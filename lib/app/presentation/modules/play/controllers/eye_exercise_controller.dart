import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:hive/hive.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/modules/quests/controllers/quests_controller.dart' as visionsafe_quests;

class EyeExerciseController extends GetxController {
  final _rewardService = Get.find<RewardService>();
  final currentStep = 0.obs;
  final timeLeft = 10.obs;
  final isRunning = false.obs;
  Timer? _timer;

  @visibleForTesting
  Duration tickDuration = const Duration(seconds: 1);

  final List<Map<String, String>> steps = [
    {
      'title': 'Kedipkan Mata',
      'instruction': 'Kedipkan matamu dengan cepat selama 10 detik.',
      'action': 'BLINK',
    },
    {
      'title': 'Lirik Kiri & Kanan',
      'instruction': 'Gerakkan bola matamu ke kiri dan ke kanan perlahan.',
      'action': 'SIDE_TO_SIDE',
    },
    {
      'title': 'Putar Bola Mata',
      'instruction': 'Putar bola matamu searah jarum jam dengan santai.',
      'action': 'ROTATE',
    },
    {
      'title': 'Fokus Jauh',
      'instruction': 'Lihat benda yang jauh selama beberapa detik.',
      'action': 'FOCUS_FAR',
    },
  ];

  void startExercise() {
    currentStep.value = 0;
    isRunning.value = true;
    _startTimer();
  }

  void _startTimer() {
    timeLeft.value = 10;
    _timer?.cancel();
    _timer = Timer.periodic(tickDuration, (timer) {
      tick();
    });
  }

  void tick() {
    if (timeLeft.value > 0) {
      timeLeft.value--;
    } else {
      _nextStep();
    }
  }

  void _nextStep() {
    if (currentStep.value < steps.length - 1) {
      currentStep.value++;
      _startTimer();
    } else {
      _finishExercise();
    }
  }

  void _finishExercise() async {
    _timer?.cancel();
    isRunning.value = false;

    // Logika Progress Hadiah (Matkul: Gamifikasi)
    final box = await Hive.openBox('exercise_stats');
    int count = (box.get('completed_count') ?? 0) + 1;
    await box.put('completed_count', count);
    
    if (count >= 5) {
      await _rewardService.unlockSticker('s4');
    }
    
    await _rewardService.addXp(50); // Tambahan XP untuk gamifikasi
    
    // Trigger Gamifikasi Quest Harian
    try {
      final questsCtrl = Get.find<visionsafe_quests.QuestsController>();
      questsCtrl.markExerciseCompleted();
    } catch (_) {}

    if (Get.currentRoute == '/eye-exercise') {
      Get.back();
    }
    VToast.show(
      "Hebat!",
      "Kamu telah menyelesaikan senam mata. Matamu sekarang lebih segar!",
      state: VizoState.happy,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
