import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/family_service.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'dart:async';

class FamilyController extends GetxController {
  final _familyService = Get.find<FamilyService>();
  final _authService = Get.find<AuthService>();

  final myGroups = <Map<String, dynamic>>[].obs;
  final groupMembers = <String, List<Map<String, dynamic>>>{}.obs;
  final isLoading = false.obs;

  bool _isDisposed = false;
  Timer? _realtimeTimer;

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
    // Sinkronisasi realtime setiap 3 detik untuk Family Squad
    _realtimeTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_isDisposed) fetchGroups(silent: true);
    });
  }

  @override
  void onClose() {
    _isDisposed = true;
    _realtimeTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchGroups({bool silent = false}) async {
    if (!silent) isLoading.value = true;
    final groups = await _familyService.getMyGroups();
    myGroups.assignAll(groups);
    
    // Fetch members for each group
    for (var group in groups) {
      final members = await _familyService.getGroupMembers(group['id']);
      // SORT FOR LEADERBOARD: Highest XP first
      members.sort((a, b) {
        final xpA = (a['profiles']?['xp'] ?? 0) as int;
        final xpB = (b['profiles']?['xp'] ?? 0) as int;
        return xpB.compareTo(xpA);
      });
      groupMembers[group['id']] = members;
    }
    
    
    if (!_isDisposed) isLoading.value = false;
  }

  Future<void> createGroup(String name) async {
    if (name.trim().isEmpty) return;
    isLoading.value = true;
    final result = await _familyService.createGroup(name);
    if (result != null) {
      Get.back(); // close dialog
      Get.snackbar('Sukses', 'Grup berhasil dibuat! Bagikan Invite Code: ${result['invite_code']}');
      await fetchGroups();
    } else {
      Get.snackbar('Gagal', 'Terjadi kesalahan saat membuat grup.');
    }
    if (!_isDisposed) isLoading.value = false;
  }

  Future<void> joinGroup(String inviteCode) async {
    if (inviteCode.trim().isEmpty) return;
    isLoading.value = true;
    final success = await _familyService.joinGroup(inviteCode);
    if (success) {
      Get.back(); // close dialog
      Get.snackbar('Sukses', 'Berhasil bergabung ke dalam grup!');
      await fetchGroups();
    } else {
      Get.snackbar('Gagal', 'Invite code tidak valid atau Anda sudah bergabung.');
    }
    if (!_isDisposed) isLoading.value = false;
  }

  String get currentUserId => _authService.currentUser.value?.id ?? '';
}
