import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/splash/views/splash_view.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';

// Mock AuthService using Dart's implicit interface and noSuchMethod
class MockAuthService extends GetxService implements AuthService {
  @override
  final isLoggedIn = false.obs;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mock ConfigService
class MockConfigService extends GetxService implements ConfigService {
  @override
  bool get isFirstRun => true;

  @override
  final threshold = 30.0.obs;
  
  @override
  final isServiceEnabled = false.obs;
  
  @override
  final isSyncing = false.obs;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() {
    Get.reset();
  });

  testWidgets('SplashView displays mascot and app name', (WidgetTester tester) async {
    // Inject Mocks
    Get.put<AuthService>(MockAuthService());
    Get.put<ConfigService>(MockConfigService());

    await tester.pumpWidget(GetMaterialApp(
      home: const SplashView(),
      getPages: [
        GetPage(name: '/onboarding', page: () => const Scaffold(body: Text('Onboarding'))),
        GetPage(name: '/home', page: () => const Scaffold(body: Text('Home'))),
      ],
    ));

    // Check Mascot
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('VISIONSAFE'), findsOneWidget);
    
    // Check Subtitle
    expect(find.text('Your Cyber Health Guardian'), findsOneWidget);
    
    await tester.pump(const Duration(seconds: 4));
  });
}
