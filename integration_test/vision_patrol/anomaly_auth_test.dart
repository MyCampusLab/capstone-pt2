import 'dart:math';
import 'package:flutter/material.dart';
import 'package:patrol/patrol.dart';
import 'package:visionsafe/main.dart' as app;
import '../../test/robots/auth_robot.dart';
import '../../test/robots/home_robot.dart';
import '../../test/robots/settings_robot.dart';

void main() {
  final String uniqueId = Random().nextInt(10000).toString();
  final String testEmail = 'anomaly_$uniqueId@visionsafe.id';
  const String testPassword = 'AnomalyPassword123!';
  const String testName = 'Anomaly Tester';

  patrolTest(
    'Anomaly Auth: Repeated Login/Logout and Edge Cases',
    ($) async {
      final authRobot = AuthRobot($);
      final homeRobot = HomeRobot($);
      final settingsRobot = SettingsRobot($);

      // 1. Launch App
      app.main();
      await $.pumpAndSettle();

      // Skip onboarding if it exists
      if ($(Text('NEXT')).exists) {
        await $(Text('NEXT')).tap();
        await $.pumpAndSettle();
        await $(Text('NEXT')).tap();
        await $.pumpAndSettle();
        await $(Text('START QUEST')).tap();
        await $.pumpAndSettle();
      }

      // --- SECTION 1: CREATE ACCOUNT ---
      debugPrint('Anomaly Test: Creating Account...');
      await authRobot.goToRegister();
      await authRobot.register(
        name: testName,
        email: testEmail,
        password: testPassword,
        confirmPassword: testPassword,
      );
      await authRobot.assertOnLoginPage();

      // --- SECTION 2: LOGIN -> LOGOUT -> LOGIN RAPIDLY ---
      debugPrint('Anomaly Test: Rapid Login & Logout...');
      
      // First Login
      await authRobot.login(testEmail, testPassword);
      await authRobot.assertLoggedIn();
      
      // Go to settings and logout
      // Depending on app structure, we might need to change tab. 
      // Let's tap the settings icon which should be on the home screen or bottom nav.
      try {
        await homeRobot.goToSettings();
      } catch (e) {
        // Fallback if settings icon not visible, try tapping by text if it's a bottom nav
        await $(Text('Pengaturan')).tap();
        await $.pumpAndSettle();
      }
      
      await settingsRobot.tapLogout();
      await authRobot.assertOnLoginPage();

      // Immediate Second Login
      await authRobot.login(testEmail, testPassword);
      await authRobot.assertLoggedIn();

      // Immediate Second Logout
      try {
        await homeRobot.goToSettings();
      } catch (e) {
        await $(Text('Pengaturan')).tap();
        await $.pumpAndSettle();
      }
      await settingsRobot.tapLogout();
      await authRobot.assertOnLoginPage();

      // --- SECTION 3: MULTIPLE FAILED LOGINS ---
      debugPrint('Anomaly Test: Multiple Failed Logins...');
      for (int i = 0; i < 3; i++) {
        await authRobot.login(testEmail, 'WrongPassword$i!');
        await authRobot.assertValidationError('Email atau password salah'); // Adjust text as per app's actual error message if needed
        // The error might be a toast or a snackbar. Pump enough for it to disappear if needed.
        await $.pump(const Duration(seconds: 3)); 
      }

      // --- SECTION 4: FINAL SUCCESSFUL LOGIN ---
      debugPrint('Anomaly Test: Final Successful Login after failures...');
      await authRobot.login(testEmail, testPassword);
      await authRobot.assertLoggedIn();

    },
  );
}
