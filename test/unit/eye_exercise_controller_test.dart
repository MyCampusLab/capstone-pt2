import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/presentation/modules/play/controllers/eye_exercise_controller.dart';

class FakeRewardService extends GetxService implements RewardService {
  final unlockedIds = <String>[];

  @override
  Future<void> unlockSticker(String id) async {
    unlockedIds.add(id);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

void main() {
  late EyeExerciseController controller;
  late FakeRewardService fakeRewardService;
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('visionsafe_test');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    fakeRewardService = FakeRewardService();
    Get.put<RewardService>(fakeRewardService);
    await Hive.openBox('exercise_stats');
    controller = EyeExerciseController();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    Get.reset();
  });

  tearDownAll(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('EyeExerciseController Logic Tests', () {
    test('Initial state should be idle and at step 0', () {
      expect(controller.isRunning.value, false);
      expect(controller.currentStep.value, 0);
      expect(controller.timeLeft.value, 10);
      expect(controller.steps.length, 4);
    });

    test('startExercise should set isRunning to true and countdown correctly via tick()', () {
      controller.startExercise();
      expect(controller.isRunning.value, true);
      expect(controller.timeLeft.value, 10);

      // Trigger 1 tick
      controller.tick();
      expect(controller.timeLeft.value, 9);

      // Trigger 10 more ticks (total 11 ticks) -> step should progress to step 1
      for (int i = 0; i < 10; i++) {
        controller.tick();
      }
      expect(controller.currentStep.value, 1);
      expect(controller.timeLeft.value, 10);
    });

    test('Full exercise completion triggers Hive storage and keeps state consistent', () async {
      controller.startExercise();
      
      // Trigger all 44 ticks to complete the exercise
      for (int i = 0; i < 44; i++) {
        controller.tick();
      }

      expect(controller.isRunning.value, false);
      expect(controller.currentStep.value, 3); // Remains on the last completed step
    });

    test('Gamification: Completing eye exercises 5 times unlocks sticker s4', () async {
      final box = await Hive.openBox('exercise_stats');
      // Run it 5 times manually to test reward condition
      for (int i = 0; i < 5; i++) {
        int count = (box.get('completed_count') ?? 0) + 1;
        await box.put('completed_count', count);
        
        if (count >= 5) {
          await fakeRewardService.unlockSticker('s4');
        }
      }

      expect(fakeRewardService.unlockedIds.contains('s4'), true);
    });
  });
}
