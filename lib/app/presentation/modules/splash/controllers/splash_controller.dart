import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/services/news_service.dart';
import 'package:visionsafe/app/routes/app_pages.dart';

class SplashController extends GetxController {
  AuthService get _authService => Get.find<AuthService>();
  ConfigService get _configService => Get.find<ConfigService>();

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Memberikan waktu minimum bagi animasi Splash untuk terlihat (2 detik)
    // Dan memberikan waktu bagi async dependencies di GlobalBinding untuk selesai
    await Future.delayed(const Duration(seconds: 2));

    // Menunggu hingga semua layanan asinkron selesai diinisialisasi
    int retries = 0;
    while (!_areServicesReady() && retries < 50) { // Max 5 detik tambahan
      await Future.delayed(const Duration(milliseconds: 100));
      retries++;
    }

    try {
      // Pastikan session auth sudah terinisialisasi
      if (_authService.isLoggedIn.value) {
        Get.offAllNamed(Routes.mainWrapper);
      } else {
        // Cek apakah ini pertama kali user buka aplikasi
        if (_configService.isFirstRun) {
          Get.offAllNamed(Routes.onboarding);
        } else {
          Get.offAllNamed(Routes.login);
        }
      }
    } catch (e) {
      // Jika masih gagal (misal async service lama banget), tunggu sebentar lagi
      await Future.delayed(const Duration(seconds: 1));
      _navigateToNext();
    }
  }

  bool _areServicesReady() {
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return Get.isRegistered<ConfigService>();
      }
    } catch (_) {}

    return Get.isRegistered<ConfigService>() &&
           Get.isRegistered<RewardService>() &&
           Get.isRegistered<TelemetryService>() &&
           Get.isRegistered<NewsService>();
  }
}
