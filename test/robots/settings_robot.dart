import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

class SettingsRobot {
  SettingsRobot(this.$);
  final PatrolIntegrationTester $;

  Future<void> tapLogout() async {
    await $.tap($(Text("Keluar Akun")));
    await $.pumpAndSettle();
    
    // Confirm in dialog
    await $.tap($(Text("KELUAR")));
    await $.pumpAndSettle();
  }
}
