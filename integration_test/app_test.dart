import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';
import 'package:visionsafe/main.dart' as app;
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/presentation/modules/main_wrapper/controllers/main_wrapper_controller.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> settleRoute(WidgetTester tester) async {
    for (int i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  testWidgets(
    'Screenshot Automation: Cycle through all views',
    (WidgetTester tester) async {
      try {
        app.main();
        await tester.pump(const Duration(seconds: 2));


        // 1. Splash Screen
        debugPrint("TAKE_SCREENSHOT: 01_splash");
        await tester.pump(const Duration(seconds: 3));

        // 2. Onboarding Screen
        Get.offAllNamed(Routes.onboarding);
        await settleRoute(tester);
        debugPrint("TAKE_SCREENSHOT: 02_onboarding");
        await tester.pump(const Duration(seconds: 2));

        // 3. Login Screen
        Get.offAllNamed(Routes.login);
        await settleRoute(tester);
        debugPrint("TAKE_SCREENSHOT: 03_login");
        await tester.pump(const Duration(seconds: 2));

        // 4. Register Screen
        Get.offAllNamed(Routes.register);
        await settleRoute(tester);
        debugPrint("TAKE_SCREENSHOT: 04_register");
        await tester.pump(const Duration(seconds: 2));

        // 5. Main Wrapper (Buddy / Home)
        Get.offAllNamed(Routes.mainWrapper);
        await settleRoute(tester);
        debugPrint("TAKE_SCREENSHOT: 05_home");
        await tester.pump(const Duration(seconds: 2));

        // 6. Main Wrapper (Stats Tab)
        try {
          final mainWrapperCtrl = Get.find<MainWrapperController>();
          mainWrapperCtrl.changePage(1);
          await settleRoute(tester);
          debugPrint("TAKE_SCREENSHOT: 06_stats");
          await tester.pump(const Duration(seconds: 2));
        } catch (e) {
          debugPrint("Error switching to stats tab: $e");
        }

        // 7. Main Wrapper (Quests Tab)
        try {
          final mainWrapperCtrl = Get.find<MainWrapperController>();
          mainWrapperCtrl.changePage(2);
          await settleRoute(tester);
          debugPrint("TAKE_SCREENSHOT: 07_quests");
          await tester.pump(const Duration(seconds: 2));
        } catch (e) {
          debugPrint("Error switching to quests tab: $e");
        }

        // 8. Main Wrapper (Settings Tab)
        try {
          final mainWrapperCtrl = Get.find<MainWrapperController>();
          mainWrapperCtrl.changePage(3);
          await settleRoute(tester);
          debugPrint("TAKE_SCREENSHOT: 08_settings");
          await tester.pump(const Duration(seconds: 2));
        } catch (e) {
          debugPrint("Error switching to settings tab: $e");
        }

        // 9. Calibration Screen
        Get.offAllNamed(Routes.calibration);
        await settleRoute(tester);
        debugPrint("TAKE_SCREENSHOT: 09_calibration");
        await tester.pump(const Duration(seconds: 2));

        // 10. Eye Exercise Screen
        Get.offAllNamed(Routes.eyeExercise);
        await settleRoute(tester);
        debugPrint("TAKE_SCREENSHOT: 10_eye_exercise");
        await tester.pump(const Duration(seconds: 2));

        // 11. News Screen
        Get.offAllNamed(Routes.news);
        await settleRoute(tester);
        debugPrint("TAKE_SCREENSHOT: 11_news_list");
        await tester.pump(const Duration(seconds: 2));


        debugPrint("TAKE_SCREENSHOT_DONE");
      } catch (e, stack) {
        debugPrint("TEST ERROR: $e");
        debugPrint(stack.toString());
        rethrow;
      }
    },
  );
}
