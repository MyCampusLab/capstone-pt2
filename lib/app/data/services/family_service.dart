import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:flutter/services.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class FamilyService extends GetxService {
  static const _methodChannel = MethodChannel('com.hn.visionsafe/service');
  final _supabase = Supabase.instance.client;
  final _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    // Auto-listen nudges in background
    final authService = Get.find<AuthService>();
    ever(authService.isLoggedIn, (bool loggedIn) {
      if (loggedIn) {
        _startListeningToNudges();
      } else {
        _nudgeSubscription?.cancel();
      }
    });
    
    if (authService.isLoggedIn.value) {
      _startListeningToNudges();
    }
  }

  void _startListeningToNudges() {
    listenToIncomingNudges((message, senderName) async {
      try {
        if (message == '[LOCKDOWN_COMMAND]') {
          // Trigger Native Lockdown Overlay
          await _methodChannel.invokeMethod('showLockdownOverlay', {
            'sender': senderName,
          });
          VToast.show("LOCKDOWN AKTIF", "Perangkat dikunci oleh ${senderName.toUpperCase()}", state: VizoState.intervention);
          return;
        }

        // Prioritas 1: Memicu System Overlay agar peringatan "tembus" aplikasi lain (game, youtube, dll)
        await _methodChannel.invokeMethod('showNudgeOverlay', {
          'sender': senderName,
          'message': message,
        });
        
        // Tetap munculkan Toast sebagai feedback audio/visual tambahan jika app sedang dibuka
        VToast.show("TEGURAN DARI ${senderName.toUpperCase()}!", message, state: VizoState.worried);
      } catch (e) {
        // Prioritas 2 (Fallback): Jika izin Overlay belum diberikan, gunakan Dialog Flutter biasa
        _logger.w('System Overlay Gagal, menggunakan Fallback Dialog: $e');
        
        if (Get.isDialogOpen == true) {
          VToast.show("TEGURAN DARI ${senderName.toUpperCase()}!", message, state: VizoState.worried);
          return;
        }
        
        Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFFE53E3E), // AppColors.danger
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF1E293B), width: 4), // AppColors.primaryDark
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 36),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "TEGURAN DARI ${senderName.toUpperCase()}!", 
                  style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Icon(Icons.privacy_tip_rounded, color: Colors.white, size: 80),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: VButton(
                onPressed: () {
                  Get.back();
                  VToast.show("Bagus!", "Terus jaga kesehatan matamu.", state: VizoState.happy);
                },
                label: "BAIK, SAYA AKAN PATUH",
                isOutline: true,
                color: const Color(0xFFE53E3E),
              ),
            ),
          ],
        ),
        barrierDismissible: false, // Tidak bisa ditutup dengan mengetuk luar area dialog
      );
      }
    });
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = List.generate(5, (index) => chars[random.nextInt(chars.length)]).join();
    return 'VZ-$code';
  }

  Future<Map<String, dynamic>?> createGroup(String groupName) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final inviteCode = _generateInviteCode();

      // Buat Grup
      final group = await _supabase.from('groups').insert({
        'name': groupName,
        'invite_code': inviteCode,
        'created_by': user.id,
      }).select().single();

      // Tambahkan pembuat sebagai Admin
      await _supabase.from('group_members').insert({
        'group_id': group['id'],
        'user_id': user.id,
        'role': 'admin',
      });

      return group;
    } catch (e) {
      _logger.e('Gagal membuat grup keluarga: $e');
      return null;
    }
  }

  Future<bool> joinGroup(String inviteCode) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Cari grup berdasarkan invite code
      final group = await _supabase
          .from('groups')
          .select()
          .eq('invite_code', inviteCode.toUpperCase())
          .maybeSingle();

      if (group == null) return false;

      // Gabung ke grup sebagai member
      await _supabase.from('group_members').insert({
        'group_id': group['id'],
        'user_id': user.id,
        'role': 'member',
      });

      return true;
    } catch (e) {
      _logger.e('Gagal bergabung ke grup: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getMyGroups() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      // Mengambil grup melalui tabel relasi untuk keamanan, mencegah full-table scan 
      // jika RLS groups disetel public untuk keperluan joinGroup.
      final memberships = await _supabase
          .from('group_members')
          .select('*, groups(*)')
          .eq('user_id', user.id);
          
      final List<Map<String, dynamic>> groups = [];
      for (var m in memberships) {
        if (m['groups'] != null) {
          groups.add(m['groups'] as Map<String, dynamic>);
        }
      }
      return groups;
    } catch (e) {
      _logger.e('Gagal mengambil daftar grup: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getGroupMembers(String groupId) async {
    try {
      // Ambil members + detail profilnya
      final members = await _supabase
          .from('group_members')
          .select('''
            *,
            profiles:user_id (
              id,
              full_name,
              avatar_url,
              level,
              xp
            )
          ''')
          .eq('group_id', groupId);

      return List<Map<String, dynamic>>.from(members);
    } catch (e) {
      _logger.e('Gagal mengambil anggota grup: $e');
      return [];
    }
  }

  // ==========================================
  // FITUR NUDGE (TEGURAN JARAK JAUH)
  // ==========================================

  Future<bool> sendNudge(String receiverId, String message) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('nudges').insert({
        'sender_id': user.id,
        'receiver_id': receiverId,
        'message': message,
      });

      return true;
    } catch (e) {
      _logger.e('Gagal mengirim teguran: $e');
      return false;
    }
  }

  StreamSubscription? _nudgeSubscription;

  void listenToIncomingNudges(Function(String message, String senderName) onNudgeReceived) {
    _nudgeSubscription?.cancel();
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _nudgeSubscription = _supabase
        .from('nudges')
        .stream(primaryKey: ['id'])
        .eq('receiver_id', user.id)
        .listen((event) async {
      for (var nudge in event) {
        if (nudge['is_read'] == false) { // Filter boolean dilakukan di sisi client
          // Hapus permanen dari cloud agar stream tidak membesar
          await _supabase
              .from('nudges')
              .delete()
              .eq('id', nudge['id']);

          // Ambil nama pengirim
          String senderName = "Seseorang";
          try {
            final senderProfile = await _supabase
                .from('profiles')
                .select('full_name')
                .eq('id', nudge['sender_id'])
                .single();
            senderName = senderProfile['full_name'] ?? senderName;
          } catch (_) {}

          onNudgeReceived(nudge['message'], senderName);
        }
      }
    }, onError: (e) {
      _logger.w('FamilyService Nudge Stream Error (diabaikan agar tidak crash): $e');
    });
  }

  @override
  void onClose() {
    _nudgeSubscription?.cancel();
    super.onClose();
  }
}
