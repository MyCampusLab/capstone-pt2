import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/models/sticker_model.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class QuestsController extends GetxController {
  final _rewardService = Get.find<RewardService>();
  final _telemetryService = Get.find<TelemetryService>();

  final specialQuest = {
    'id': 'sq1',
    'title': 'Senam Mata Hero',
    'subtitle': 'Lakukan relaksasi mata sekarang',
    'status': 'active',
    'icon': Icons.visibility_rounded,
  }.obs;

  // Real-time metrics untuk tracking quest
  final sessionBlinks = 0.obs;
  final sessionFocusMinutes = 0.0.obs;

  // Quest dinamis yang terhitung otomatis
  final quests = <Map<String, dynamic>>[].obs;
  final heroes = <StickerModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initQuests();
    _loadHeroes();
    _listenToLiveTelemetry();
  }

  void _initQuests() {
    quests.assignAll([
      {
        'id': 'q1',
        'title': 'Blink Marathon',
        'subtitle': 'Blink 50 times in this session',
        'target': 50,
        'icon': Icons.remove_red_eye_rounded,
      },
      {
        'id': 'q2',
        'title': 'Focus Legend',
        'subtitle': '10 Minutes of safe distance',
        'target': 10,
        'icon': Icons.bolt_rounded,
      },
    ]);
  }

  void _listenToLiveTelemetry() {
    // Monitor kedipan mata untuk quest Blink Marathon
    ever(_telemetryService.blinkCount, (_) {
      sessionBlinks.value++;
      _checkQuestProgress();
    });

    // Monitor durasi fokus harian
    interval(_telemetryService.currentDistance, (_) {
      if (!_telemetryService.isViolation.value && _telemetryService.currentDistance.value > 0) {
        sessionFocusMinutes.value += (1 / 60); // 1 detik = 1/60 menit
        _checkQuestProgress();
      }
    }, time: const Duration(seconds: 1));
  }

  double getQuestProgress(String id) {
    // Touch reactive variables to register dependency for Obx stability
    sessionBlinks.value;
    sessionFocusMinutes.value;

    if (id == 'q1') return (sessionBlinks.value / 50).clamp(0.0, 1.0);
    if (id == 'q2') return (sessionFocusMinutes.value / 10).clamp(0.0, 1.0);
    return 0.0;
  }

  void _checkQuestProgress() {
    if (sessionBlinks.value == 50) {
      VToast.show("Quest Complete!", "You've finished Blink Marathon!", state: VizoState.happy);
    }
    if (sessionFocusMinutes.value >= 10.0 && sessionFocusMinutes.value < 10.1) {
      VToast.show("Master of Focus!", "10 minutes safely guarded.", state: VizoState.focused);
    }
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
    
    VToast.show(
      "Quest Tracking", 
      "Vizo is now monitoring your progress!",
      state: VizoState.happy,
    );
  }
}
