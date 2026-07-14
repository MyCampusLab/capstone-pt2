import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
      await _stickerBox.put('s1', StickerModel(id: 's1', title: 'Robo Vizo', description: 'Vizo dalam jubah tempur robotik.', buffDescription: 'XP Bertambah 10% Lebih Cepat', isUnlocked: true, isEquipped: true));
      await _stickerBox.put('s2', StickerModel(id: 's2', title: 'Cyber Blink', description: 'Vizo ahli kedip berkecepatan tinggi.', buffDescription: 'Toleransi Teguran Jarak +2 Detik', isUnlocked: false));
      await _stickerBox.put('s3', StickerModel(id: 's3', title: 'Guardian Vizo', description: 'Vizo sang penjaga jarak legendaris.', buffDescription: 'Skor Kesehatan (Health Score) +5 Poin Permanen', isUnlocked: false));
      await _stickerBox.put('s4', StickerModel(id: 's4', title: 'Zenith Master Vizo', description: 'Vizo sang pahlawan senam mata interaktif.', buffDescription: 'Hadiah XP Quest Harian 2x Lipat', isUnlocked: false));
      await _stickerBox.put('s5', StickerModel(id: 's5', title: 'Forest Ninja Vizo', description: 'Ninja yang menjaga pandangan dari jarak aman hutan bambu.', buffDescription: 'Toleransi Waktu Pelanggaran +3 Detik', isUnlocked: false));
      await _stickerBox.put('s6', StickerModel(id: 's6', title: 'Quantum Vizo', description: 'Mampu menembus dimensi waktu untuk merekam histori.', buffDescription: 'Hadiah XP +20% dari Setiap Sesi Fokus', isUnlocked: false));
      await _stickerBox.put('s7', StickerModel(id: 's7', title: 'Solar Flare Vizo', description: 'Memancarkan cahaya perlindungan dari silau gadget.', buffDescription: 'Teguran Suara Diperhalus (Mode Tenang)', isUnlocked: false));
      await _stickerBox.put('s8', StickerModel(id: 's8', title: 'Cosmic Overlord', description: 'Raja Vizo dari galaksi Andromeda. Penguasa mata sempurna.', buffDescription: 'Semua Buff Aktif Sekaligus + Avatar Kosmik', isUnlocked: false));
    } else if (!_stickerBox.containsKey('s8')) {
      // Patch jika pengguna sebelumnya hanya punya 4 sticker
      await _stickerBox.put('s5', StickerModel(id: 's5', title: 'Forest Ninja Vizo', description: 'Ninja yang menjaga pandangan dari jarak aman hutan bambu.', buffDescription: 'Toleransi Waktu Pelanggaran +3 Detik', isUnlocked: false));
      await _stickerBox.put('s6', StickerModel(id: 's6', title: 'Quantum Vizo', description: 'Mampu menembus dimensi waktu untuk merekam histori.', buffDescription: 'Hadiah XP +20% dari Setiap Sesi Fokus', isUnlocked: false));
      await _stickerBox.put('s7', StickerModel(id: 's7', title: 'Solar Flare Vizo', description: 'Memancarkan cahaya perlindungan dari silau gadget.', buffDescription: 'Teguran Suara Diperhalus (Mode Tenang)', isUnlocked: false));
      await _stickerBox.put('s8', StickerModel(id: 's8', title: 'Cosmic Overlord', description: 'Raja Vizo dari galaksi Andromeda. Penguasa mata sempurna.', buffDescription: 'Semua Buff Aktif Sekaligus + Avatar Kosmik', isUnlocked: false));
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
        final existing = _stickerBox.get(id);
        
        final sticker = StickerModel(
          id: id,
          title: data['title'],
          description: data['description'],
          isUnlocked: isUnlocked,
          unlockedAt: isUnlocked ? DateTime.now() : null,
          buffDescription: existing?.buffDescription ?? '',
          isEquipped: existing?.isEquipped ?? false,
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
        try {
          await _supabase.from('user_stickers').insert({
            'user_id': user.id,
            'sticker_id': id,
          });
        } catch (e) {
          _logger.w('Gagal sinkronisasi unlock stiker $id ke Cloud (Best effort): $e');
        }
      }

      // Update cache lokal
      final updated = sticker.copyWith(
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
  
  StickerModel? getEquippedSticker() {
    try {
      return _stickerBox.values.firstWhere((element) => element.isEquipped);
    } catch (_) {
      return null;
    }
  }

  Future<void> equipSticker(String id) async {
    final target = _stickerBox.get(id);
    if (target == null || !target.isUnlocked) return;

    // Unequip all first
    for (var sticker in _stickerBox.values) {
      if (sticker.isEquipped) {
        await _stickerBox.put(sticker.id, sticker.copyWith(isEquipped: false));
      }
    }

    // Equip new
    await _stickerBox.put(id, target.copyWith(isEquipped: true));
    _loadUnlockedStickersFromCache();
    
    // Sinkronisasi Buff ke Native (Agar toleransi deteksi mata langsung bekerja di Kotlin Background Service)
    try {
      const platform = MethodChannel('com.hn.visionsafe/telemetry_db');
      await platform.invokeMethod('setEquippedSticker', {'id': id});
    } catch (e) {
      _logger.e('Gagal sinkronisasi buff sticker ke Native: $e');
    }
    
    VToast.show(
      "Hero Digunakan!",
      "Buff [${target.title}] sekarang aktif!",
      state: VizoState.focused,
    );
  }

  int getStickerPrice(String id) {
    switch (id) {
      case 's1': return 0;
      case 's2': return 250;
      case 's3': return 500;
      case 's4': return 150;
      case 's5': return 800;
      case 's6': return 1200;
      case 's7': return 2000;
      case 's8': return 5000;
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
        "XP Belum Cukup!",
        "Kumpulkan $price XP untuk membuka hero ${sticker.title}.",
        state: VizoState.worried,
      );
      return false;
    }

    try {
      // XP TIDAK DIPOTONG! (Memperbaiki bug level anjlok/fluktuatif)
      // XP berfungsi murni sebagai reputasi kumulatif.
      final updatedProfile = profile.copyWith(
        lastActiveAt: DateTime.now(),
      );
      homeController.userProfile.value = updatedProfile;
      await Get.find<ProfileRepository>().updateProfile(updatedProfile);

      // Unlock on Supabase if online
      final user = _supabase.auth.currentUser;
      if (user != null) {
        try {
          await _supabase.from('user_stickers').insert({
            'user_id': user.id,
            'sticker_id': id,
          });
        } catch (e) {
          _logger.w('Gagal sinkronisasi pembelian stiker $id ke Cloud (Best effort): $e');
        }
      }

      // Update cache lokal
      final updated = sticker.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await _stickerBox.put(id, updated);
      _loadUnlockedStickersFromCache();

      VToast.show(
        "Hero Terbuka!",
        "Hero ${updated.title} berhasil dibuka!",
        state: VizoState.happy,
      );
      
      _logger.i('Reward unlocked: ${updated.title}');
      return true;
    } catch (e) {
      _logger.e('Gagal melakukan unlock stiker: $e');
      VToast.show("Gagal Membuka", "Terjadi kesalahan koneksi database.", state: VizoState.intervention);
      return false;
    }
  }

  Future<void> addXp(int amount, {bool isQuest = false}) async {
    try {
      // 1. Terapkan Buffs dari Sticker yang Equiped
      final equipped = getEquippedSticker();
      double multiplier = 1.0;
      
      if (equipped != null) {
        if (equipped.id == 's1' || equipped.id == 's8') {
          multiplier += 0.10; // +10% XP
        }
        if (equipped.id == 's6' || equipped.id == 's8') {
          multiplier += 0.20; // +20% XP
        }
        if (isQuest && (equipped.id == 's4' || equipped.id == 's8')) {
          multiplier += 1.0; // 2x Lipat
        }
      }

      int finalAmount = (amount * multiplier).round();
      
      // 2. Mencegah eksploitasi: Batas harian XP (Cap = 2000 XP per hari)
      final todayStr = DateTime.now().toIso8601String().split('T')[0];
      final xpDateKey = 'xp_date';
      final xpAmountKey = 'xp_amount_today';
      
      final metaBox = await Hive.openBox('reward_meta');
      
      String? lastDate = metaBox.get(xpDateKey) as String?;
      int xpToday = metaBox.get(xpAmountKey, defaultValue: 0) as int;
      
      if (lastDate != todayStr) {
        lastDate = todayStr;
        xpToday = 0;
        await metaBox.put(xpDateKey, todayStr);
      }
      
      const int maxDailyXp = 2000;
      if (xpToday >= maxDailyXp) {
        _logger.w('Batas harian XP tercapai ($maxDailyXp). XP tidak bertambah.');
        return; // Hentikan penambahan XP
      }
      
      // Jika penambahan melewati batas, potong sisa XP yang boleh ditambah
      int actualAmount = finalAmount;
      if (xpToday + finalAmount > maxDailyXp) {
        actualAmount = maxDailyXp - xpToday;
      }
      
      await metaBox.put(xpAmountKey, xpToday + actualAmount);

      final profileRepo = Get.find<ProfileRepository>();
      final profile = await profileRepo.getMyProfile();
      if (profile == null) return;

      int newXp = profile.xp + actualAmount;
      
      // Rumus Level Absolut: 1 Level = 100 XP. 
      // Mencegah jumping level aneh / desync state.
      int correctLevel = (newXp ~/ 100) + 1;
      bool hasLeveledUp = correctLevel > profile.level;

      final updatedProfile = profile.copyWith(
        xp: newXp,
        level: correctLevel,
        lastActiveAt: DateTime.now(),
      );
      
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.userProfile.value = updatedProfile;
      }
      
      await profileRepo.updateProfile(updatedProfile);
      
      if (hasLeveledUp) {
        if (Get.isRegistered<HomeController>()) {
           VToast.show(
             "LEVEL UP! 🎉",
             "Selamat! Kamu telah mencapai Level $correctLevel!",
             state: VizoState.happy,
             duration: const Duration(seconds: 5),
           );
        }
        
        // Cek Pencapaian Hero (Achievement System)
        if (correctLevel >= 5 && _stickerBox.get('s2')?.isUnlocked == false) await unlockSticker('s2'); // Cyber Blink
        if (correctLevel >= 10 && _stickerBox.get('s3')?.isUnlocked == false) await unlockSticker('s3'); // Guardian Vizo
        if (correctLevel >= 15 && _stickerBox.get('s5')?.isUnlocked == false) await unlockSticker('s5'); // Forest Ninja
        if (correctLevel >= 20 && _stickerBox.get('s6')?.isUnlocked == false) await unlockSticker('s6'); // Quantum
        if (correctLevel >= 25 && _stickerBox.get('s7')?.isUnlocked == false) await unlockSticker('s7'); // Solar Flare
        if (correctLevel >= 30 && _stickerBox.get('s8')?.isUnlocked == false) await unlockSticker('s8'); // Cosmic Overlord
      }

      _logger.i('Reward Service: Berhasil menambah $actualAmount XP (Total: $newXp, Level: $correctLevel). Limit Harian: ${xpToday + actualAmount}/$maxDailyXp');
    } catch (e) {
      _logger.e('Gagal menambah XP: $e');
    }
  }
}
