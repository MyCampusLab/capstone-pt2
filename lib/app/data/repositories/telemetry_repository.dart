import 'package:get/get.dart';
import '../models/telemetry_model.dart';
import '../services/telemetry_service.dart';
import '../services/config_service.dart';

/// Repository untuk akses data telemetri.
/// Memisahkan logika UI dari sumber data (Hive).
/// Matkul: Big Data & Software Architecture (Clean)
class TelemetryRepository {
  final TelemetryService _service = Get.find<TelemetryService>();

  /// Mengambil semua log telemetri yang belum disinkronkan.
  List<TelemetryModel> getLocalLogs() {
    return _service.getAllLocalLogs();
  }

  /// Menghitung total durasi pelanggaran hari ini (Menit).
  /// Logika: Mengambil data persisten dari ConfigService karena SQLite log sering di-flush ke Cloud.
  double calculateViolationMinutesToday() {
    if (Get.isRegistered<ConfigService>()) {
      return Get.find<ConfigService>().violationSecondsToday / 60.0;
    }
    return 0.0;
  }

  /// Menghitung total durasi monitoring aktif hari ini (Menit).
  double calculateTotalMonitoringMinutesToday() {
    if (Get.isRegistered<ConfigService>()) {
      return Get.find<ConfigService>().monitoringSecondsToday / 60.0;
    }
    return 0.0;
  }

  /// Menghitung total kedipan terdeteksi hari ini.
  int calculateBlinkCountToday() {
    if (Get.isRegistered<ConfigService>()) {
      return Get.find<ConfigService>().blinkCountToday;
    }
    return 0;
  }

  /// Menghitung skor kesehatan mata harian (Skala 10 - 100).
  double calculateEyeHealthScore() {
    double score = 100.0;
    if (!Get.isRegistered<ConfigService>()) return score;
    
    final config = Get.find<ConfigService>();
    final violationMins = config.violationSecondsToday / 60.0;
    final avgDistance = config.averageDistanceToday;
    final squintCount = config.squintCountToday;
    final hasLogs = config.monitoringSecondsToday > 0;

    if (!hasLogs) return 100.0;

    // 1. Potongan berdasarkan durasi pelanggaran (10 poin per menit pelanggaran)
    score -= violationMins * 10.0;

    // 2. Potongan berdasarkan rata-rata jarak yang terlalu dekat (di bawah 35cm)
    if (avgDistance > 0 && avgDistance < 35.0) {
      score -= (35.0 - avgDistance) * 2.0; // Potong 2 poin per cm di bawah 35cm
    }

    // 3. Potongan berdasarkan frekuensi menyipitkan mata (squinting)
    score -= squintCount * 0.2; // Potong 0.2 poin per log menyipit

    return score.clamp(10.0, 100.0);
  }

  /// Menghitung rata-rata jarak mata hari ini (cm).
  double calculateAverageDistanceToday() {
    if (Get.isRegistered<ConfigService>()) {
      return Get.find<ConfigService>().averageDistanceToday;
    }
    return 0.0;
  }

  /// Menganalisis tingkat ketegangan/kelelahan otot mata berdasarkan squinting ratio.
  String calculateEyeStrainLevelToday() {
    final now = DateTime.now();
    final logs = getLocalLogs().where((log) => 
      log.timestamp.day == now.day &&
      log.timestamp.month == now.month &&
      log.timestamp.year == now.year
    );
    if (logs.isEmpty) return "AMAN";
    final squintCount = logs.where((log) => log.isSquinting).length;
    final ratio = squintCount / logs.length;
    if (ratio > 0.3) return "TINGGI";
    if (ratio > 0.1) return "SEDANG";
    return "RENDAH";
  }
}
