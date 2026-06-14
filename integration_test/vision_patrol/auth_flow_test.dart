import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:visionsafe/main.dart' as app;

void main() {
  patrolTest(
    'VisionPatrol: Comprehensive Auth & Security Journey',
    ($) async {
      // 1. Launch the App
      app.main();
      await $.pumpAndSettle();

      // --- LOGIKA ONBOARDING ---
      if ($(Text('Welcome Hero')).exists) {
        await $.tap($(Text('NEXT')));
        await $.pumpAndSettle();
        await $.tap($(Text('NEXT')));
        await $.pumpAndSettle();
        await $.tap($(Text('START QUEST')));
        await $.pumpAndSettle();
      }

      // --- LOGIN FLOW ---
      await $.enterText($(#login_email_input), 'hero@visionsafe.id');
      await $.enterText($(#login_password_input), 'HeroSafe123!');
      
      await $.tap($(Text("LET'S GO!")));
      await $.pumpAndSettle();

      // --- GOOGLE LOGIN ---
      await $.tap($(Icons.g_mobiledata)); 
      
      if (await $.platformAutomator.mobile.isPermissionDialogVisible()) {
        await $.platformAutomator.mobile.grantPermissionWhenInUse();
      }
      
      // --- REGISTER FLOW ---
      await $.tap($(Text("Join the quest!")));
      await $.pumpAndSettle();

      await $.enterText($(#reg_name_input), 'Master Irsyad');
      await $.enterText($(#reg_email_input), 'master@visionsafe.id');
      await $.enterText($(#reg_password_input), 'SupremeHero2026!');
      await $.enterText($(#reg_confirm_password_input), 'SupremeHero2026!');

      await $.tap($(Text("CREATE ACCOUNT")));
      await $.pumpAndSettle();

      // --- VERIFIKASI ---
      expect($(Text('RINGKASAN HARI INI')), findsOneWidget);
    },
  );
}
