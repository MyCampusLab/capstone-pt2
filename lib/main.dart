import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/bindings/global_binding.dart';
import 'app/core/utils/error_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Konfigurasi Edge-to-Edge Status Bar Transparan
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  // 0. Crash Reporting Preparation (Phase 5)
  FlutterError.onError = (FlutterErrorDetails details) {
    // Silence repetitive network noise in logs
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
    url: 'https://tkfxqlpmccnpzefywkef.supabase.co',
    anonKey: 'sb_publishable_CA0kVCgcofJgmibNNW6-9w_osXCd4Cx', 
    debug: false, // Turn off excessive Supabase logging
  );

  // 2. Inisialisasi Hive (Pondasi Local Storage)
  await Hive.initFlutter();

  // 3. Menjalankan Aplikasi dengan GlobalBinding
  runApp(
    GetMaterialApp(
      title: "VisionSafe",
      initialRoute: AppPages.initial,
      initialBinding: GlobalBinding(),
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
