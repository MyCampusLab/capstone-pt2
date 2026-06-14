import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/data/models/profile_model.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

// Gunakan subclass sederhana untuk mock GetxController tanpa harus implementasi seluruh interface mixin
class MockHomeController extends GetxController implements HomeController {
  @override
  final isBackendConnected = true.obs;
  @override
  final isLoading = false.obs;
  @override
  final dailyViolationMinutes = 0.0.obs;
  @override
  final pendingSyncCount = 0.obs;
  @override
  final userProfile = Rxn<ProfileModel>();
  
  @override
  bool get isServiceRunning => true;
  @override
  double get currentDistance => 45.0;
  @override
  bool get isViolation => false;
  @override
  VizoState get dynamicMascotState => VizoState.happy;

  @override
  void goToCalibration() {}
  @override
  Future<void> toggleService() async {}
  
  // Implementasi dummy untuk GetxController/WidgetsBindingObserver
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}
  
  @override
  get telemetryService => throw UnimplementedError();

  // Mematikan error missing implementation untuk method yang tidak kita test
  @override
  void noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('VAppHeader should display title in Uppercase', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: VAppHeader(title: 'Test Title', showStatus: false),
        ),
      ),
    );

    expect(find.text('TEST TITLE'), findsOneWidget);
  });

  testWidgets('VAppHeader should render custom actions when provided', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: VAppHeader(
            title: 'Home',
            actions: [
              Text('ACTION_TEXT'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('ACTION_TEXT'), findsOneWidget);
  });
}
