import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/models/sticker_model.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

import 'package:visionsafe/app/data/services/config_service.dart';

class QuestsController extends GetxController {
  final _rewardService = Get.find<RewardService>();
  final _telemetryService = Get.find<TelemetryService>();
  final _configService = Get.find<ConfigService>();

  final specialQuest = {
    'id': 'sq1',
    'title': 'Relaksasi Total',
    'subtitle': 'Selesaikan Senam Mata 3D Vizo',
    'status': 'active',
    'type': 'action',
    'icon': Icons.self_improvement_rounded,
  }.obs;

  // Real-time metrics untuk tracking quest
  final eyeExerciseCompleted = 0.obs;
  
  Timer? _questTimer;

  // Quest dinamis yang terhitung otomatis
  final quests = <Map<String, dynamic>>[].obs;
  final heroes = <StickerModel>[].obs;
  final isLoading = false.obs;
  
  Box? _questBox;
  final streakCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initQuestsStorage();
  }
  
  Future<void> _initQuestsStorage() async {
    _questBox = await Hive.openBox('vizo_quests');
    _calculateStreak();
    _initQuests();
    _loadHeroes();
    _listenToLiveTelemetry();
  }
  
  void _calculateStreak() {
    final lastLogin = _questBox?.get('last_login_date');
    final currentStreak = _questBox?.get('streak_count', defaultValue: 1) as int;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    
    if (lastLogin != today) {
      if (lastLogin != null) {
        final lastDate = DateTime.parse(lastLogin);
        final difference = DateTime.now().difference(lastDate).inDays;
        if (difference == 1) {
          _questBox?.put('streak_count', currentStreak + 1);
        } else {
          _questBox?.put('streak_count', 1);
        }
      } else {
        _questBox?.put('streak_count', 1);
      }
      _questBox?.put('last_login_date', today);
    }
    streakCount.value = _questBox?.get('streak_count', defaultValue: 1) as int;
  }

  @override
  void onClose() {
    _questTimer?.cancel();
    super.onClose();
  }

  void _initQuests() {
    quests.assignAll([
      {
        'id': 'q1',
        'title': 'Mata Baja',
        'subtitle': 'Jaga jarak aman 30 Menit sesi ini',
        'target': 30,
        'icon': Icons.shield_rounded,
      },
      {
        'id': 'q2',
        'title': 'Detoks Mini',
        'subtitle': 'Istirahat layar 15 Menit',
        'target': 15,
        'icon': Icons.battery_charging_full_rounded,
      },
      {
        'id': 'q3',
        'title': 'Fokus Jangka Panjang',
        'subtitle': 'Jaga jarak aman akumulasi 1 Jam',
        'target': 60,
        'icon': Icons.star_rounded,
      },
      {
        'id': 'q4',
        'title': 'Kedipan Sempurna',
        'subtitle': 'Cegah Mata Kering (Blink 10x)',
        'target': 10,
        'icon': Icons.remove_red_eye_rounded,
      },
    ]);
  }

  void _listenToLiveTelemetry() {
    // Monitor durasi harian yang nyata melalui sinkronisasi ConfigService
    _questTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkQuestProgress();
    });
  }

  double getQuestProgress(String id) {
    // Reactive touch
    eyeExerciseCompleted.value;

    final safeMinutes = _configService.monitoringSecondsToday / 60.0;
    final blinks = _telemetryService.blinkCount.value;

    if (id == 'sq1') return eyeExerciseCompleted.value > 0 ? 1.0 : 0.0;
    if (id == 'q1') return (safeMinutes / 30.0).clamp(0.0, 1.0);
    if (id == 'q2') return (safeMinutes / 15.0).clamp(0.0, 1.0); 
    if (id == 'q3') return (safeMinutes / 60.0).clamp(0.0, 1.0);
    if (id == 'q4') return (blinks / 50.0).clamp(0.0, 1.0);
    return 0.0;
  }
  
  bool isQuestClaimedToday(String id) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastClaim = _questBox?.get('claim_date_$id');
    return lastClaim == today;
  }

  void markExerciseCompleted() {
    eyeExerciseCompleted.value++;
    _checkQuestProgress();
  }

  void _checkQuestProgress() {
    bool hasUpdates = false;
    for (var i = 0; i < quests.length; i++) {
      final q = quests[i];
      final prog = getQuestProgress(q['id']);
      final isCompleted = prog >= 1.0;
      final isClaimed = isQuestClaimedToday(q['id']);
      
      // Update UI state
      if (q['isReadyToClaim'] != (isCompleted && !isClaimed)) {
        q['isReadyToClaim'] = (isCompleted && !isClaimed);
        q['isClaimed'] = isClaimed;
        hasUpdates = true;
      }
    }
    
    // Check Special Quest
    final sqProg = getQuestProgress(specialQuest['id'] as String);
    final sqClaimed = isQuestClaimedToday(specialQuest['id'] as String);
    if (specialQuest['isReadyToClaim'] != (sqProg >= 1.0 && !sqClaimed)) {
      specialQuest['isReadyToClaim'] = (sqProg >= 1.0 && !sqClaimed);
      specialQuest['isClaimed'] = sqClaimed;
      specialQuest.refresh();
    }

    if (hasUpdates) quests.refresh();
  }
  
  void claimQuestReward(String id, int baseReward) {
    if (isQuestClaimedToday(id)) {
      return;
    }
    
    // 1. Calculate XP with Streak Multiplier
    double multiplier = 1.0;
    if (streakCount.value >= 7) {
      multiplier = 2.0;
    } else if (streakCount.value >= 3) {
      multiplier = 1.5;
    }
    
    final finalXp = (baseReward * multiplier).toInt();
    
    // 2. Persist Claim
    final today = DateTime.now().toIso8601String().substring(0, 10);
    _questBox?.put('claim_date_$id', today);
    
    // 3. Grant Reward
    _rewardService.addXp(finalXp, isQuest: true);
    VToast.show("Reward Claimed!", "Kamu mendapatkan +$finalXp XP! (Streak x$multiplier)", state: VizoState.happy);
    
    // 4. Update UI
    _checkQuestProgress();
  }

  Future<void> refreshQuestData() async {
    isLoading.value = true;
    _loadHeroes();
    // Re-sync with reward service
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }

  void _loadHeroes() {
    heroes.value = _rewardService.getAllStickers();
  }

  Future<void> purchaseHero(String id) async {
    final success = await _rewardService.buySticker(id);
    if (success) {
      _loadHeroes();
    }
  }

  void startTask(String id) {
    if (id == 'sq1') {
      Get.toNamed('/eye-exercise');
      return;
    }
    
    String instructions = "Jaga jarak mata lebih dari 30cm dari layar sekarang. Vizo sedang mengawasi!";
    if (id == 'q2') {
      instructions = "Kunci layar HP kamu dan istirahatlah selama 15 menit.";
    }

    VToast.show(
      "Quest Aktif!", 
      instructions,
      state: VizoState.focused,
      duration: const Duration(seconds: 4),
    );
  }
}
