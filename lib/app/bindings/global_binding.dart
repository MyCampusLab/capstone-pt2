import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/sync_service.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/data/services/supabase_service.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/data/repositories/auth_repository.dart';
import 'package:visionsafe/app/data/services/news_service.dart';
import 'package:visionsafe/app/data/repositories/profile_repository.dart';
import 'package:visionsafe/app/data/services/observability_service.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // 0. Observability (Logging & Monitoring)
    Get.put(ObservabilityService(), permanent: true);

    // 1. Critical Base Services
    Get.put(SupabaseService(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(AuthRepository(), permanent: true);
    Get.put(ProfileRepository(), permanent: true);
    Get.put(SyncService(), permanent: true);

    // 2. Async Services (Awaited for stability)
    Get.putAsync(() async => await ConfigService().init(), permanent: true);
    Get.putAsync(() async => await RewardService().init(), permanent: true);
    Get.putAsync(() async => await TelemetryService().init(), permanent: true);
    Get.putAsync(() async => await NewsService().init(), permanent: true);
  }
}
