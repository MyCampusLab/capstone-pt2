import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/data/repositories/auth_repository.dart';
import 'package:visionsafe/app/presentation/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'auth_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  // Inisialisasi binding Flutter untuk test yang melibatkan UI/Haptics
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    
    // Inject mock repository
    controller = AuthControllerWithMock(mockAuthRepository);
    controller.nameController = TextEditingController();
    controller.emailController = TextEditingController();
    controller.passwordController = TextEditingController();
    controller.confirmPasswordController = TextEditingController();
  });

  tearDown(() {
    controller.nameController.dispose();
    controller.emailController.dispose();
    controller.passwordController.dispose();
    controller.confirmPasswordController.dispose();
    Get.reset();
  });

  group('AuthController Validation Logic', () {
    test('isValidEmail should return true for valid emails', () async {
      controller.emailController.text = 'hero@visionsafe.id';
      controller.passwordController.text = 'password123';
      
      final mockResponse = AuthResponse(user: User(
        id: 'id',
        appMetadata: {},
        userMetadata: {},
        aud: 'aud',
        createdAt: DateTime.now().toIso8601String(),
      ));

      // Mock login agar tidak error saat dipanggil
      when(mockAuthRepository.login(any, any)).thenAnswer((_) async => mockResponse);

      await controller.login();
      verify(mockAuthRepository.login('hero@visionsafe.id', 'password123')).called(1);
    });

    test('login should handle authentication failure', () async {
      controller.emailController.text = 'hero@visionsafe.id';
      controller.passwordController.text = 'wrong-password';
      
      when(mockAuthRepository.login(any, any))
          .thenThrow(AuthException('Invalid login credentials'));

      await controller.login();
      
      expect(controller.isLoading.value, false);
      verify(mockAuthRepository.login('hero@visionsafe.id', 'wrong-password')).called(1);
    });

    test('isValidEmail should return false for invalid emails', () async {
      controller.emailController.text = 'invalid-email';
      controller.passwordController.text = 'password123';
      
      await controller.login();
      verifyNever(mockAuthRepository.login(any, any));
    });

    test('clearFields should empty all controllers', () {
      controller.nameController.text = 'Hero';
      controller.emailController.text = 'hero@test.com';
      controller.clearFields();
      
      expect(controller.nameController.text, '');
      expect(controller.emailController.text, '');
    });

    test('register should validate matching passwords', () async {
      controller.nameController.text = 'Hero';
      controller.emailController.text = 'hero@test.com';
      controller.passwordController.text = 'pass123';
      controller.confirmPasswordController.text = 'pass456'; 
      
      await controller.register();
      verifyNever(mockAuthRepository.register(any, any, name: anyNamed('name')));
    });

    test('register should call repository when input is valid', () async {
      controller.nameController.text = 'Hero';
      controller.emailController.text = 'hero@test.com';
      controller.passwordController.text = 'password123';
      controller.confirmPasswordController.text = 'password123';
      
      final mockResponse = AuthResponse(user: User(
        id: 'id',
        appMetadata: {},
        userMetadata: {},
        aud: 'aud',
        createdAt: DateTime.now().toIso8601String(),
      ));

      controller.agreedToTerms.value = true;
      
      when(mockAuthRepository.register(any, any, name: anyNamed('name')))
          .thenAnswer((_) async => mockResponse);

      await controller.register();
      
      verify(mockAuthRepository.register(
        'hero@test.com', 
        'password123', 
        name: 'Hero',
      )).called(1);
    });

    test('register should handle repository error', () async {
      controller.nameController.text = 'Hero';
      controller.emailController.text = 'hero@test.com';
      controller.passwordController.text = 'password123';
      controller.confirmPasswordController.text = 'password123';
      controller.agreedToTerms.value = true;
      
      when(mockAuthRepository.register(any, any, name: anyNamed('name')))
          .thenThrow(Exception('Registration failed'));

      await controller.register();
      
      expect(controller.isLoading.value, false);
      verify(mockAuthRepository.register(any, any, name: anyNamed('name'))).called(1);
    });

    test('register should validate empty fields', () async {
      controller.nameController.text = '';
      controller.emailController.text = '';
      controller.passwordController.text = '';
      controller.confirmPasswordController.text = '';
      
      await controller.register();
      verifyNever(mockAuthRepository.register(any, any, name: anyNamed('name')));
    });

    test('register should validate password length', () async {
      controller.nameController.text = 'Hero';
      controller.emailController.text = 'hero@test.com';
      controller.passwordController.text = '123';
      controller.confirmPasswordController.text = '123';
      
      await controller.register();
      verifyNever(mockAuthRepository.register(any, any, name: anyNamed('name')));
    });

    group('Loading State Management', () {
      test('isLoading should be true during login and false after', () async {
        controller.emailController.text = 'hero@visionsafe.id';
        controller.passwordController.text = 'password123';
        
        final loginCompleter = Completer<AuthResponse>();
        when(mockAuthRepository.login(any, any)).thenAnswer((_) => loginCompleter.future);

        final loginFuture = controller.login();
        expect(controller.isLoading.value, true);

        loginCompleter.complete(AuthResponse(user: User(
          id: 'id',
          appMetadata: {},
          userMetadata: {},
          aud: 'aud',
          createdAt: DateTime.now().toIso8601String(),
        )));
        await loginFuture;
        expect(controller.isLoading.value, false);
      });
    });
  });
}

/// Subclass for testing to inject mock repository directly
class AuthControllerWithMock extends AuthController {
  final AuthRepository mockRepo;
  AuthControllerWithMock(this.mockRepo);

  @override
  AuthRepository get authRepository => mockRepo;
}
