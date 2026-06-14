import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../models/sticker_model.dart';
import 'supabase_service.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/data/repositories/profile_repository.dart';

/// Layanan untuk mengelola sistem reward dan koleksi stiker.
/// Sinkronisasi Cloud: Menggunakan Supabase sebagai Source of Truth.
class RewardService extends GetxService {
  final _logger = Logger();
  final _supabaseService = Get.find<SupabaseService>();
  
  sb.SupabaseClient get _supabase => sb.Supabase.instance.client;
  
  late Box<StickerModel> _stickerBox;
  
  @visibleForTesting
  set stickerBox(Box<StickerModel> box) => _stickerBox = box;

  @visibleForTesting
  Box<StickerModel> get stickerBox => _stickerBox;

  final unlockedStickers = <StickerModel>[].obs;

  StreamSubscription<List<Map<String, dynamic>>>? _realtimeSubscription;
  StreamSubscription<sb.AuthState>? _authSubscription;

  String? _currentActiveUserId;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  Future<RewardService> init() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(StickerModelAdapter());
    }

    _stickerBox = await Hive.openBox<StickerModel>('vizo_stickers');
    if (_stickerBox.isEmpty) {
      await _stickerBox.put('s1', StickerModel(id: 's1', title: 'Robo Vizo', description: 'Vizo dalam jubah tempur robotik.', isUnlocked: true));
      await _stickerBox.put('s2', StickerModel(id: 's2', title: 'Cyber Blink', description: 'Vizo ahli kedip berkecepatan tinggi.', isUnlocked: false));
      await _stickerBox.put('s3', StickerModel(id: 's3', title: 'Guardian Vizo', description: 'Vizo sang penjaga jarak legendaris.', isUnlocked: false));
      await _stickerBox.put('s4', StickerModel(id: 's4', title: 'Zenith Master Vizo', description: 'Vizo sang pahlawan senam mata interaktif.', isUnlocked: false));
    } else if (!_stickerBox.containsKey('s4')) {
      await _stickerBox.put('s4', StickerModel(id: 's4', title: 'Zenith Master Vizo', description: 'Vizo sang pahlawan senam mata interaktif.', isUnlocked: false));
    }
    
    // Listen Auth State untuk bind/unbind realtime listener secara dinamis
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      _onUserChanged(data.session?.user);
    });

    // Inisialisasi awal jika sudah login saat startup
    final currentUser = _supabase.auth.currentUser;
    if (currentUser != null) {
      _onUserChanged(currentUser);
    }

    return this;
  }

  void _onUserChanged(sb.User? user) {
    if (user?.id == _currentActiveUserId) return;
    _currentActiveUserId = user?.id;

    if (user != null) {
      _syncMasterStickers();
      _loadUnlockedStickersFromCache();
      _listenToRealtimeRewards(user.id);
    } else {
      _cancelRealtimeRewards();
      unlockedStickers.clear();
    }
  }

  /// Sinkronisasi Master Data Stiker dari Supabase ke Hive.
  Future<void> _syncMasterStickers() async {
    try {
      final cloudStickers = await _supabaseService.getStickers();
      final unlockedIds = await _supabaseService.getUnlockedStickerIds();

      if (cloudStickers.isEmpty) return;

      for (var data in cloudStickers) {
        final id = data['id'];
        final isUnlocked = unlockedIds.contains(id);
        
        final sticker = StickerModel(
          id: id,
          title: data['title'],
          description: data['description'],
          isUnlocked: isUnlocked,
          unlockedAt: isUnlocked ? DateTime.now() : null,
        );
        await _stickerBox.put(id, sticker);
      }
      _logger.i('Reward Service: Sinkronisasi Master Stiker Berhasil.');
    } catch (e) {
      _logger.w('Reward Service: Gagal sinkronisasi cloud, menggunakan cache lokal. $e');
    }
  }

  void _loadUnlockedStickersFromCache() {
    unlockedStickers.value = _stickerBox.values.where((s) => s.isUnlocked).toList();
  }

  /// Mendengarkan trigger unlock otomatis dari Database (PostgreSQL Trigger).
  void _listenToRealtimeRewards(String userId) {
    _cancelRealtimeRewards();

    try {
      _realtimeSubscription = _supabase
          .from('user_stickers')
          .stream(primaryKey: ['user_id', 'sticker_id'])
          .eq('user_id', userId)
          .listen((event) {
            _reconnectAttempts = 0; // Reset on successful message
            for (var record in event) {
              final stickerId = record['sticker_id'];
              _handleServerSideUnlock(stickerId);
            }
          }, onError: (error) {
            final errStr = error.toString();
            if (errStr.contains('SocketException') || errStr.contains('Failed host lookup')) {
               _logger.w('Reward Service Stream: Menunggu jaringan...');
            } else {
               _logger.w('Reward Service Stream Error: $error');
            }
            _handleStreamReconnect(userId, error);
          });
    } catch (e) {
      _logger.w('Reward Service Stream exception: $e');
      _handleStreamReconnect(userId, e);
    }
  }

  void _handleStreamReconnect(String userId, dynamic error) {
    _reconnectTimer?.cancel();
    if (_reconnectAttempts > 5) {
      _logger.e('Reward Service: Maksimum percobaan rekoneksi terlampaui. Menunggu status auth berikutnya.');
      return;
    }
    _reconnectAttempts++;
    final backoffSeconds = _reconnectAttempts * 5;
    _logger.i('Reward Service: Mencoba menghubungkan kembali dalam $backoffSeconds detik...');
    _reconnectTimer = Timer(Duration(seconds: backoffSeconds), () async {
      try {
        final session = _supabase.auth.currentSession;
        if (session != null && session.isExpired) {
          _logger.i('Reward Service: Menyegarkan sesi Supabase sebelum menyambung kembali...');
          await _supabase.auth.refreshSession();
        }
      } catch (e) {
        _logger.w('Reward Service: Gagal menyegarkan sesi: $e');
      }
      _listenToRealtimeRewards(userId);
    });
  }

  void _cancelRealtimeRewards() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _cancelRealtimeRewards();
    super.onClose();
  }

  Future<void> _handleServerSideUnlock(String id) async {
    final sticker = _stickerBox.get(id);
    if (sticker != null && !sticker.isUnlocked) {
      final updated = StickerModel(
        id: sticker.id,
        title: sticker.title,
        description: sticker.description,
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await _stickerBox.put(id, updated);
      _loadUnlockedStickersFromCache();
      
      VToast.show(
        "Koleksi Baru Terdeteksi!",
        "Hero baru bergabung: ${updated.title}",
        state: VizoState.happy,
        duration: const Duration(seconds: 4),
      );
      _logger.i('Reward Realtime Unlocked: ${updated.title}');
    }
  }

  /// Membuka stiker secara manual (misal setelah menyelesaikan kalibrasi atau exercise).
  Future<void> unlockSticker(String id) async {
    try {
      final sticker = _stickerBox.get(id);
      if (sticker == null || sticker.isUnlocked) return;

      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase.from('user_stickers').insert({
          'user_id': user.id,
          'sticker_id': id,
        });
      }

      // Update cache lokal
      final updated = StickerModel(
        id: sticker.id,
        title: sticker.title,
        description: sticker.description,
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await _stickerBox.put(id, updated);
      _loadUnlockedStickersFromCache();

      VToast.show(
        "Koleksi Baru Terbuka!",
        "Hero baru berhasil dibuka: ${updated.title}",
        state: VizoState.happy,
        duration: const Duration(seconds: 4),
      );
      _logger.i('Reward Manually Unlocked: ${updated.title}');
    } catch (e) {
      _logger.e('Gagal unlock stiker secara manual: $e');
    }
  }

  List<StickerModel> getAllStickers() => _stickerBox.values.toList();

  int getStickerPrice(String id) {
    switch (id) {
      case 's1': return 0;
      case 's2': return 250;
      case 's3': return 500;
      default: return 150;
    }
  }

  Future<bool> buySticker(String id) async {
    final sticker = _stickerBox.get(id);
    if (sticker == null) {
      VToast.show("Ups!", "Stiker tidak ditemukan.", state: VizoState.worried);
      return false;
    }
    if (sticker.isUnlocked) {
      VToast.show("Sudah Dimiliki", "Kamu sudah membuka stiker ini!", state: VizoState.happy);
      return false;
    }

    final price = getStickerPrice(id);
    final homeController = Get.find<HomeController>();
    final profile = homeController.userProfile.value;
    if (profile == null) {
      VToast.show("Ups!", "Harap masuk atau sinkronisasi profil terlebih dahulu.", state: VizoState.worried);
      return false;
    }

    if (profile.xp < price) {
      VToast.show(
        "XP Kurang!",
        "Kamu butuh $price XP untuk membeli ${sticker.title}.",
        state: VizoState.worried,
      );
      return false;
    }

    try {
      // Deduct XP and update profile
      final updatedProfile = profile.copyWith(
        xp: profile.xp - price,
        lastActiveAt: DateTime.now(),
      );
      homeController.userProfile.value = updatedProfile;
      await Get.find<ProfileRepository>().updateProfile(updatedProfile);

      // Unlock on Supabase if online
      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase.from('user_stickers').insert({
          'user_id': user.id,
          'sticker_id': id,
        });
      }

      // Update cache lokal
      final updated = StickerModel(
        id: sticker.id,
        title: sticker.title,
        description: sticker.description,
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await _stickerBox.put(id, updated);
      _loadUnlockedStickersFromCache();

      VToast.show(
        "Pembelian Sukses!",
        "Hero ${updated.title} berhasil dibeli dan dibuka!",
        state: VizoState.happy,
      );
      
      _logger.i('Reward purchased: ${updated.title}');
      return true;
    } catch (e) {
      _logger.e('Gagal melakukan pembelian stiker: $e');
      VToast.show("Pembelian Gagal", "Terjadi kesalahan koneksi database.", state: VizoState.intervention);
      return false;
    }
  }
}
