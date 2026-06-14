import 'package:flutter/material.dart';
import 'package:patrol/patrol.dart';
import 'package:visionsafe/main.dart' as app;
import '../../test/robots/auth_robot.dart';
import '../../test/robots/home_robot.dart';
import '../../test/robots/settings_robot.dart';

void main() {
  patrolTest(
    'VisionSafe: Elite Live Automation (Register -> Login -> Google)',
    ($) async {
      final auth = AuthRobot($);
      final home = HomeRobot($);
      final settings = SettingsRobot($);

      // 1. Launch App
      app.main();
      await $.pumpAndSettle();

      // 2. Handle Onboarding
      if ($(Text('Welcome Hero')).exists) {
        await $.tap($(Text('NEXT')));
        await $.pumpAndSettle();
        await $.tap($(Text('NEXT')));
        await $.pumpAndSettle();
        await $.tap($(Text('START QUEST')));
        await $.pumpAndSettle();
      }

      // --- STAGE 1: STANDARD REGISTRATION ---
      debugPrint("STAGE 1: Registering Standard Account...");
      await auth.goToRegister();
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testEmail = 'tester_$timestamp@visionsafe.id';
      
      await auth.register(
        name: 'Elite Tester',
        email: testEmail,
        password: 'HeroSafe123!',
        confirmPassword: 'HeroSafe123!',
      );
      
      await home.verifyOnHome();
      debugPrint("SUCCESS: Registered and logged in.");

      // --- STAGE 2: LOGOUT ---
      debugPrint("STAGE 2: Logging out...");
      await home.goToSettings();
      await settings.tapLogout();
      debugPrint("SUCCESS: Logged out.");

      // --- STAGE 3: STANDARD LOGIN ---
      debugPrint("STAGE 3: Logging in with registered account...");
      await auth.login(testEmail, 'HeroSafe123!');
      
      await home.verifyOnHome();
      debugPrint("SUCCESS: Logged in back.");

      // --- STAGE 4: LOGOUT AGAIN ---
      await home.goToSettings();
      await settings.tapLogout();

      // --- STAGE 5: GOOGLE SIGN-IN ---
      debugPrint("STAGE 5: Registering/Logging in with Google...");
      await auth.tapGoogleSignIn();
      await auth.selectNativeGoogleAccount('noblxomen@gmail.com');
      
      await home.verifyOnHome();
      debugPrint("SUCCESS: Google Sign-In completed.");
    },
  );
}
