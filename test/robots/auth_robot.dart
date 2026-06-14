import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

/// AuthRobot: Advanced testing helper for VisionSafe Auth Flow.
/// Follows 'The Architect' standards for clean, robust, and readable tests.
class AuthRobot {
  AuthRobot(this.$);
  final PatrolIntegrationTester $;

  // --- Locators ---
  Finder get emailInput => $(#login_email_input);
  Finder get passwordInput => $(#login_password_input);
  Finder get loginButton => $(Text("LET'S GO!"));
  Finder get googleSignInButton => $(Text("Sign in with Google"));
  Finder get joinLink => $(Text("Join the quest!"));

  Finder get regNameInput => $(#reg_name_input);
  Finder get regEmailInput => $(#reg_email_input);
  Finder get regPasswordInput => $(#reg_password_input);
  Finder get regConfirmPasswordInput => $(#reg_confirm_password_input);
  Finder get createAccountButton => $(Text("CREATE ACCOUNT"));
  Finder get backToLoginLink => $(Text("Back to Quest!"));

  // --- Actions ---

  Future<void> login(String email, String password) async {
    await $.enterText(emailInput, email);
    await $.enterText(passwordInput, password);
    await $.tap(loginButton);
    await $.pumpAndSettle();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    await $.enterText(regNameInput, name);
    await $.enterText(regEmailInput, email);
    await $.enterText(regPasswordInput, password);
    await $.enterText(regConfirmPasswordInput, confirmPassword);
    await $.tap(createAccountButton);
    await $.pumpAndSettle();
  }

  Future<void> tapGoogleSignIn() async {
    await $.tap(googleSignInButton);
    await $.pumpAndSettle();
  }

  Future<void> goToRegister() async {
    await $.tap(joinLink);
    await $.pumpAndSettle();
  }

  Future<void> goBackToLogin() async {
    await $.tap(backToLoginLink);
    await $.pumpAndSettle();
  }

  /// Handles the native Google account selection.
  /// Note: [accountName] should match the text displayed in the native sheet.
  Future<void> selectNativeGoogleAccount(String accountName) async {
    // In Patrol 4.5.0+, use platformAutomator.mobile
    await $.platformAutomator.mobile.tap(Selector(text: accountName));
    await $.pumpAndSettle();
  }

  Future<void> grantPermissionsIfVisible() async {
    if (await $.platformAutomator.mobile.isPermissionDialogVisible()) {
      await $.platformAutomator.mobile.grantPermissionWhenInUse();
    }
  }

  // --- Assertions ---

  Future<void> assertOnLoginPage() async {
    expect(emailInput, findsOneWidget);
    expect(loginButton, findsOneWidget);
  }

  Future<void> assertOnRegisterPage() async {
    expect(regEmailInput, findsOneWidget);
    expect(createAccountButton, findsOneWidget);
  }

  Future<void> assertLoggedIn() async {
    // Verify we are on the Home screen (MainWrapper)
    expect($(Text('RINGKASAN HARI INI')), findsOneWidget);
  }

  Future<void> assertToastVisible(String message) async {
    expect($(message), findsOneWidget);
  }

  Future<void> assertValidationError(String errorText) async {
    expect($(errorText), findsOneWidget);
  }
}
