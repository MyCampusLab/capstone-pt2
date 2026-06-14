import 'dart:math';
import 'package:flutter/material.dart';
import 'package:patrol/patrol.dart';
import 'package:visionsafe/main.dart' as app;
import '../../test/robots/auth_robot.dart';

void main() {
  final String uniqueId = Random().nextInt(10000).toString();
  final String testEmail = 'hero_$uniqueId@visionsafe.id';
  const String testPassword = 'SupremeHero123!';
  const String testName = 'Master Irsyad';

  patrolTest(
    'Auth Master: The Ultimate Authentication Lifecycle Test',
    ($) async {
      final robot = AuthRobot($);

      // 1. Launch App & Handle Onboarding
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

      // --- SECTION 1: VALIDATION ERRORS ---
      debugPrint('Testing Validation Errors...');
      await robot.goToRegister();
      
      // Test 1: Mismatch Password
      await robot.register(
        name: testName,
        email: testEmail,
        password: testPassword,
        confirmPassword: 'WrongPassword123',
      );
      await robot.assertValidationError('Konfirmasi password tidak cocok');

      // Test 2: Invalid Email
      await robot.register(
        name: testName,
        email: 'invalid-email',
        password: testPassword,
        confirmPassword: testPassword,
      );
      await robot.assertValidationError('format email yang benar');
      
      await robot.goBackToLogin();

      // --- SECTION 2: REGISTRATION (PERFECT FLOW) ---
      debugPrint('Testing Perfect Registration Flow...');
      await robot.goToRegister();
      await robot.register(
        name: testName,
        email: testEmail,
        password: testPassword,
        confirmPassword: testPassword,
      );
      
      // Verification: Should go back to login with success message
      await robot.assertOnLoginPage();
      await robot.assertToastVisible('Akun Hero kamu berhasil dibuat');

      // --- SECTION 3: LOGIN (EMAIL/PASSWORD) ---
      debugPrint('Testing Standard Login Flow...');
      await robot.login(testEmail, testPassword);
      await robot.assertLoggedIn();
    },
  );
}
