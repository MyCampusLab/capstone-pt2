import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/presentation/modules/auth/views/register_view.dart';
import 'package:visionsafe/app/presentation/modules/auth/controllers/auth_controller.dart';
import 'package:visionsafe/app/data/repositories/auth_repository.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

import '../unit/auth_test.mocks.dart';

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return Future.value(MockHttpClientRequest());
  }
}

class MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() {
    return Future.value(MockHttpClientResponse());
  }
}

class MockHttpClientResponse extends Mock implements HttpClientResponse {
  @override
  int get statusCode => 200;
  
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  
  @override
  int get contentLength => 1;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    // 1x1 transparent PNG pixel
    final bytes = [
      137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1, 
      0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 10, 73, 68, 65, 84, 
      120, 156, 99, 0, 1, 0, 0, 5, 0, 1, 13, 10, 45, 180, 0, 0, 0, 0, 73, 69, 
      78, 68, 174, 66, 96, 130
    ];
    return Stream<List<int>>.fromIterable([bytes]).listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthController controller;

  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    controller = AuthControllerWithMock(mockAuthRepository);
    Get.put<AuthController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidget() {
    return const GetMaterialApp(
      home: RegisterView(),
    );
  }

  testWidgets('RegisterView should have all required input fields and button', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    
    await tester.pumpWidget(createWidget());
    await tester.pump();

    expect(find.byKey(const Key('reg_name_input')), findsOneWidget);
    expect(find.byKey(const Key('reg_email_input')), findsOneWidget);
    expect(find.byKey(const Key('reg_password_input')), findsOneWidget);
    expect(find.byKey(const Key('reg_confirm_password_input')), findsOneWidget);
    expect(find.widgetWithText(VButton, "CREATE ACCOUNT"), findsOneWidget);
  });

  testWidgets('Tapping CREATE ACCOUNT calls controller register', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidget());
    await tester.pump();

    await tester.enterText(find.byKey(const Key('reg_name_input')), 'Test User');
    await tester.enterText(find.byKey(const Key('reg_email_input')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('reg_password_input')), 'password123');
    await tester.enterText(find.byKey(const Key('reg_confirm_password_input')), 'password123');
    
    await tester.tap(find.byType(Checkbox));
    await tester.ensureVisible(find.widgetWithText(VButton, "CREATE ACCOUNT"));

    final mockResponse = AuthResponse(user: User(
      id: 'id',
      appMetadata: {},
      userMetadata: {},
      aud: 'aud',
      createdAt: DateTime.now().toIso8601String(),
    ));
    when(mockAuthRepository.register(any, any, name: anyNamed('name')))
        .thenAnswer((_) async => mockResponse);

    await tester.tap(find.widgetWithText(VButton, "CREATE ACCOUNT"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    verify(mockAuthRepository.register('test@example.com', 'password123', name: 'Test User')).called(1);
    
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('Tapping CREATE ACCOUNT with mismatched passwords shows validation toast', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidget());
    await tester.pump();

    await tester.enterText(find.byKey(const Key('reg_name_input')), 'Test User');
    await tester.enterText(find.byKey(const Key('reg_email_input')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('reg_password_input')), 'password123');
    await tester.enterText(find.byKey(const Key('reg_confirm_password_input')), 'different123');

    await tester.tap(find.byType(Checkbox));
    await tester.ensureVisible(find.widgetWithText(VButton, "CREATE ACCOUNT"));
    await tester.tap(find.widgetWithText(VButton, "CREATE ACCOUNT"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify repository was never called
    verifyNever(mockAuthRepository.register(any, any, name: anyNamed('name')));

    // Verify mismatch error message is shown in Toast
    expect(find.text("PASSWORD BERBEDA"), findsOneWidget);
    expect(find.text("Konfirmasi password tidak cocok."), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('Tapping CREATE ACCOUNT with already registered email shows failure toast', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidget());
    await tester.pump();

    await tester.enterText(find.byKey(const Key('reg_name_input')), 'Test User');
    await tester.enterText(find.byKey(const Key('reg_email_input')), 'registered@example.com');
    await tester.enterText(find.byKey(const Key('reg_password_input')), 'password123');
    await tester.enterText(find.byKey(const Key('reg_confirm_password_input')), 'password123');

    // Mock register throw user already registered
    when(mockAuthRepository.register(any, any, name: anyNamed('name')))
        .thenThrow(AuthException('User already registered'));

    await tester.tap(find.byType(Checkbox));
    await tester.ensureVisible(find.widgetWithText(VButton, "CREATE ACCOUNT"));
    await tester.tap(find.widgetWithText(VButton, "CREATE ACCOUNT"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify repository call
    verify(mockAuthRepository.register('registered@example.com', 'password123', name: 'Test User')).called(1);

    // Verify mapped error message is shown in Toast
    expect(find.text("GAGAL DAFTAR"), findsOneWidget);
    expect(find.text("Email sudah terdaftar. Gunakan email lain ya Hero!"), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('RegisterView handles responsiveness on small screen sizes without overflow', (WidgetTester tester) async {
    // Set a very small physical size (iPhone SE style: 320x568)
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidget());
    await tester.pump();

    // Verify VizoMascot renders with smaller size (100 px)
    final mascotFinder = find.byType(VizoMascot);
    expect(mascotFinder, findsOneWidget);
    
    final VizoMascot mascotWidget = tester.widget(mascotFinder);
    expect(mascotWidget.size, 100);

    // Verify there are no layout overflows
    expect(tester.takeException(), isNull);
  });
}

class AuthControllerWithMock extends AuthController {
  final AuthRepository mockRepo;
  AuthControllerWithMock(this.mockRepo);

  @override
  AuthRepository get authRepository => mockRepo;
}
