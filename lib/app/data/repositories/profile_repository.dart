import 'dart:async';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/profile_model.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  Box? _profileBox;

  Future<void> _initBox() async {
    if (_profileBox == null || !_profileBox!.isOpen) {
      _profileBox = await Hive.openBox('profile_cache');
    }
  }

  Future<ProfileModel?> getMyProfile() async {
    await _initBox();
    final user = Supabase.instance.client.auth.currentUser;
    final cachedData = user != null ? _profileBox?.get(user.id) : null;
    ProfileModel? localProfile;
    if (cachedData != null) {
      try {
        localProfile = ProfileModel.fromMap(Map<String, dynamic>.from(cachedData));
      } catch (_) {}
    }

    try {
      final data = await _supabaseService.getUserProfile();
      if (data != null) {
        final profile = ProfileModel.fromMap(data);
        if (user != null) {
          await _profileBox?.put(user.id, profile.toMap());
        }
        return profile;
      }
    } catch (_) {}

    // Fallback to local cache or dynamic dummy
    if (localProfile != null) return localProfile;
    if (user != null) {
      final dummy = ProfileModel(
        id: user.id,
        fullName: user.email?.split('@').first ?? 'PAHLAWAN',
        lastActiveAt: DateTime.now(),
      );
      await _profileBox?.put(user.id, dummy.toMap());
      return dummy;
    }
    return null;
  }

  Stream<ProfileModel> watchMyProfile() {
    final controller = StreamController<ProfileModel>();
    final user = Supabase.instance.client.auth.currentUser;

    // Send cached first
    if (user != null) {
      _initBox().then((_) {
        if (controller.isClosed) return;
        final cachedData = _profileBox?.get(user.id);
        if (cachedData != null) {
          try {
            controller.add(ProfileModel.fromMap(Map<String, dynamic>.from(cachedData)));
          } catch (_) {}
        } else {
          controller.add(ProfileModel(
            id: user.id, 
            fullName: user.email?.split('@').first ?? 'PAHLAWAN', 
            lastActiveAt: DateTime.now()
          ));
        }
      });
    }

    // Now try to listen to Supabase real-time stream
    StreamSubscription? sub;
    try {
      sub = _supabaseService.watchUserProfile().listen(
        (data) async {
          try {
            final profile = ProfileModel.fromMap(data);
            if (user != null) {
              await _initBox();
              await _profileBox?.put(user.id, profile.toMap());
            }
            if (!controller.isClosed) {
              controller.add(profile);
            }
          } catch (_) {}
        },
        onError: (e) {
          // Suppress error and keep using cached data
        },
      );
    } catch (_) {}

    controller.onCancel = () {
      sub?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  Future<List<ProfileModel>> getLeaderboard() async {
    try {
      final data = await _supabaseService.getLeaderboard();
      if (data.isEmpty) throw Exception("Leaderboard empty");
      return data.map((item) => ProfileModel.fromMap(item)).toList();
    } catch (_) {
      // Offline / table missing leaderboard fallback
      return [
        ProfileModel(id: 'l1', fullName: 'Fizo Master', xp: 5200, level: 7, lastActiveAt: DateTime.now()),
        ProfileModel(id: 'l2', fullName: 'Safety Ranger', xp: 4100, level: 5, lastActiveAt: DateTime.now()),
        ProfileModel(id: 'l3', fullName: 'Blink Expert', xp: 3200, level: 4, lastActiveAt: DateTime.now()),
      ];
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await _initBox();
    await _profileBox?.put(profile.id, profile.toMap());

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null && user.id == profile.id) {
        await Supabase.instance.client
            .from('profiles')
            .update(profile.toMap())
            .eq('id', profile.id);
      }
    } catch (_) {}
  }
}
