import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

class HomeRobot {
  HomeRobot(this.$);
  final PatrolIntegrationTester $;

  Future<void> verifyOnHome() async {
    expect($(Text('RINGKASAN HARI INI')), findsOneWidget);
  }

  Future<void> goToSettings() async {
    await $.tap($(Icons.settings_outlined));
    await $.pumpAndSettle();
  }
}
