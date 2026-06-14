import 'package:get/get.dart';
import '../models/telemetry_model.dart';
import '../services/telemetry_service.dart';

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
  /// Logika: Tiap log mewakili SAMPLING_RATE_MS (misal 1.5 detik).
  double calculateViolationMinutesToday() {
    final now = DateTime.now();
    final logs = getLocalLogs().where((log) => 
      log.isViolation && 
      log.timestamp.day == now.day &&
      log.timestamp.month == now.month &&
      log.timestamp.year == now.year
    );

    // Asumsi tiap log = 1.0 detik (sesuai SAMPLING_RATE_MS baru di Native)
    return (logs.length * 1.0) / 60;
  }

  /// Menghitung total durasi monitoring aktif hari ini (Menit).
  double calculateTotalMonitoringMinutesToday() {
    final now = DateTime.now();
    final logs = getLocalLogs().where((log) => 
      log.timestamp.day == now.day &&
      log.timestamp.month == now.month &&
      log.timestamp.year == now.year
    );
    return (logs.length * 1.0) / 60;
  }

  /// Menghitung total kedipan terdeteksi hari ini.
  int calculateBlinkCountToday() {
    final now = DateTime.now();
    return getLocalLogs().where((log) => 
      log.isBlinking && 
      log.timestamp.day == now.day &&
      log.timestamp.month == now.month &&
      log.timestamp.year == now.year
    ).length;
  }

  /// Menghitung skor kesehatan mata harian (Skala 10 - 100).
  double calculateEyeHealthScore() {
    double score = 100.0;
    final now = DateTime.now();
    final todayLogs = getLocalLogs().where((log) => 
      log.timestamp.day == now.day &&
      log.timestamp.month == now.month &&
      log.timestamp.year == now.year
    );

    if (todayLogs.isEmpty) return 100.0;

    // 1. Potongan berdasarkan durasi pelanggaran (10 poin per menit pelanggaran)
    final violationMins = calculateViolationMinutesToday();
    score -= violationMins * 10.0;

    // 2. Potongan berdasarkan rata-rata jarak yang terlalu dekat (di bawah 35cm)
    double totalDistance = 0.0;
    int validLogsCount = 0;
    for (var log in todayLogs) {
      if (log.distance > 0) {
        totalDistance += log.distance;
        validLogsCount++;
      }
    }
    if (validLogsCount > 0) {
      final avgDistance = totalDistance / validLogsCount;
      if (avgDistance < 35.0) {
        score -= (35.0 - avgDistance) * 2.0; // Potong 2 poin per cm di bawah 35cm
      }
    }

    // 3. Potongan berdasarkan frekuensi menyipitkan mata (squinting)
    final squintCount = todayLogs.where((log) => log.isSquinting).length;
    score -= squintCount * 0.2; // Potong 0.2 poin per log menyipit

    return score.clamp(10.0, 100.0);
  }

  /// Menghitung rata-rata jarak mata hari ini (cm).
  double calculateAverageDistanceToday() {
    final now = DateTime.now();
    final logs = getLocalLogs().where((log) => 
      log.distance > 0 &&
      log.timestamp.day == now.day &&
      log.timestamp.month == now.month &&
      log.timestamp.year == now.year
    );
    if (logs.isEmpty) return 0.0;
    final totalDistance = logs.fold<double>(0.0, (sum, log) => sum + log.distance);
    return totalDistance / logs.length;
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
