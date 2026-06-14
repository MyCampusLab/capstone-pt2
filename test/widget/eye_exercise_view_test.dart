import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/presentation/modules/play/controllers/eye_exercise_controller.dart';
import 'package:visionsafe/app/presentation/modules/play/views/eye_exercise_view.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

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
    tempDir = await Directory.systemTemp.createTemp('visionsafe_widget_test');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    fakeRewardService = FakeRewardService();
    Get.put<RewardService>(fakeRewardService);
    await Hive.openBox('exercise_stats');
    
    controller = EyeExerciseController();
    Get.put<EyeExerciseController>(controller);
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

  testWidgets('EyeExerciseView displays idle state and starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      home: const EyeExerciseView(),
    ));

    // 1. Check initial idle states
    expect(find.text('SENAM MATA'), findsOneWidget);
    expect(find.text('SIAP MULAI?'), findsOneWidget);
    expect(find.text('Ikuti gerakan Vizo untuk mengistirahatkan matamu.'), findsOneWidget);
    expect(find.text('MULAI SEKARANG'), findsOneWidget);
    expect(find.byType(VizoMascot), findsOneWidget);

    // 2. Start Exercise
    await tester.tap(find.text('MULAI SEKARANG'));
    await tester.pump();

    // 3. Check active exercise UI elements
    expect(find.text('10 DETIK'), findsOneWidget);
    expect(find.text('KEDIPKAN MATA'), findsOneWidget);
    expect(find.text('Kedipkan matamu dengan cepat selama 10 detik.'), findsOneWidget);
    expect(find.text('LANGKAH 1 DARI 4'), findsOneWidget);

    // 4. Clean up active controller timers before the test body exits to satisfy Flutter test framework checks
    controller.onClose();
  });
}
