import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'app/routes/app_pages.dart';
import 'app/core/utils/error_logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app/data/services/config_service.dart';
import 'app/data/services/reward_service.dart';
import 'app/data/services/telemetry_service.dart';
import 'app/data/services/news_service.dart';
import 'app/data/services/push_notification_service.dart';
import 'app/data/services/sync_service.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/supabase_service.dart';
import 'app/data/repositories/auth_repository.dart';
import 'app/data/repositories/profile_repository.dart';
import 'app/data/services/observability_service.dart';
import 'app/data/services/family_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (.env)
  await dotenv.load(fileName: ".env");

  // Firebase Init (Untuk Crashlytics - Harus configure dulu)
  try {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint("Firebase not configured yet: $e");
  }

  // Konfigurasi Edge-to-Edge Status Bar Transparan
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  // 0. Crash Reporting Preparation (Phase 5)
  FlutterError.onError ??= (FlutterErrorDetails details) {
    final exceptionStr = details.exception.toString();
      if (exceptionStr.contains('SocketException') || 
          exceptionStr.contains('AuthRetryableFetchException') ||
          exceptionStr.contains('Failed host lookup')) {
        debugPrint('Network: Connection currently unavailable.');
        return;
      }

      FlutterError.presentError(details);
      ErrorLogger.recordError(details.exception, details.stack);
    };
  
  // 1. Inisialisasi Supabase (Pondasi Backend)
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '', 
    debug: false, // Turn off excessive Supabase logging
  );

  // 2. Inisialisasi Hive (Pondasi Local Storage)
  await Hive.initFlutter();

  // 3. Inisialisasi Services (Sync & Async)
  // Sync Services
  Get.put(ObservabilityService(), permanent: true);
  Get.put(SupabaseService(), permanent: true);
  Get.put(AuthService(), permanent: true);
  Get.put(AuthRepository(), permanent: true);
  Get.put(ProfileRepository(), permanent: true);
  Get.put(SyncService(), permanent: true);
  Get.put(FamilyService(), permanent: true);

  // Async Services
  await Get.putAsync(() => ConfigService().init());
  await Get.putAsync(() => RewardService().init());
  await Get.putAsync(() => TelemetryService().init());
  await Get.putAsync(() => NewsService().init());
  Get.putAsync(() => PushNotificationService().init());

  // 4. Menjalankan Aplikasi dengan GlobalBinding
  runApp(
    GetMaterialApp(
      title: "VisionSafe",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D2FF),
          primary: const Color(0xFF00D2FF),
          secondary: const Color(0xFF9D50BB),
          surface: Colors.white,
          onSurface: const Color(0xFF1A1A1A),
        ),
        scaffoldBackgroundColor: const Color(0xFFE0EAFC),
      ),
    ),
  );
}
