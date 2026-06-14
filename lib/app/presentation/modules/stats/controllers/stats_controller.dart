import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/data/services/supabase_service.dart';
import 'package:visionsafe/app/data/models/sticker_model.dart';
import 'package:visionsafe/app/data/repositories/profile_repository.dart';
import 'package:visionsafe/app/data/models/profile_model.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';

/// StatsController: Logika pengelolaan data statistik dan analitik cloud.
class StatsController extends GetxController {
  final _rewardService = Get.find<RewardService>();
  final _supabaseService = Get.find<SupabaseService>();
  final _profileRepo = Get.find<ProfileRepository>();

  final healthScore = 100.obs;
  final weeklyData = <double>[0, 0, 0, 0, 0, 0, 0].obs;
  final screenTimeHours = 0.0.obs;
  final restTimeHours = 0.0.obs;
  final totalViolationsCount = 0.obs;
  final averageDistance = 38.0.obs;

  final hourlyViolations = List<double>.filled(24, 0.0).obs;
  final stickers = <StickerModel>[].obs;
  final leaderboard = <ProfileModel>[].obs;
  final isLoading = false.obs;
  final telemetryService = Get.find<TelemetryService>();

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    _loadStickers();
    await Future.wait([
      fetchCloudAnalytics(),
      fetchLeaderboard(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchLeaderboard() async {
    try {
      final data = await _profileRepo.getLeaderboard();
      leaderboard.assignAll(data);
    } catch (e) {
      Get.log("Gagal fetch leaderboard: $e");
    }
  }

  void _loadStickers() {
    stickers.value = _rewardService.getAllStickers();
  }

  Future<void> fetchCloudAnalytics() async {
    try {
      // Mengambil data cloud (Limit ditingkatkan ke 1000 untuk cakupan lebih luas)
      final cloudData = await _supabaseService.getAnalyticsData(limit: 1000);
      
      // MENGGABUNGKAN DATA: Cloud + Local Hive (Data yang belum tersinkron)
      final localLogs = telemetryService.getAllLocalLogs();
      final List<Map<String, dynamic>> combinedLogs = List.from(cloudData);
      
      for (var log in localLogs) {
        combinedLogs.add({
          'created_at': log.timestamp.toIso8601String(),
          'is_violation': log.isViolation,
          'distance': log.distance,
        });
      }

      if (combinedLogs.isNotEmpty) {
        _processHeatmapData(combinedLogs);
      } else {
        _resetToEmptyState();
      }
    } catch (e) {
      _resetToEmptyState();
    }
  }

  void _resetToEmptyState() {
    healthScore.value = 100;
    screenTimeHours.value = 0.0;
    restTimeHours.value = 0.0;
    totalViolationsCount.value = 0;
    averageDistance.value = 38.0;
    hourlyViolations.value = List.filled(24, 0.0);
  }

  void _processHeatmapData(List<Map<String, dynamic>> logs) {
    if (logs.isEmpty) return;

    final Map<int, List<bool>> hourlyMap = {};
    for (var i = 0; i < 24; i++) {
      hourlyMap[i] = [];
    }

    int totalViolations = 0;
    double sumDistance = 0.0;
    int distanceCount = 0;
    
    for (var log in logs) {
      try {
        final createdAtStr = log['created_at']?.toString();
        if (createdAtStr == null) continue;
        
        // Pastikan konversi ke Local Time untuk Heatmap yang akurat bagi user
        final createdAt = DateTime.parse(createdAtStr).toLocal();
        final isViolation = log['is_violation'] as bool? ?? false;
        
        if (isViolation) totalViolations++;
        
        final distVal = log['distance'];
        if (distVal != null) {
          final double dist = (distVal as num).toDouble();
          if (dist > 0) {
            sumDistance += dist;
            distanceCount++;
          }
        }
        
        final hour = createdAt.hour;
        hourlyMap[hour]?.add(isViolation);
      } catch (e) {
        continue;
      }
    }

    totalViolationsCount.value = totalViolations;
    averageDistance.value = distanceCount > 0 ? (sumDistance / distanceCount) : 38.0;

    final int logCount = logs.length;
    if (logCount > 0) {
      final double violationRate = totalViolations / logCount;
      final double rawScore = 100 - (violationRate * 100);
      healthScore.value = rawScore.isNaN || rawScore.isInfinite 
          ? 100 
          : rawScore.clamp(0, 100).toInt();
      
      // RUMUS DUNIA NYATA: 1 Log = 1 Detik (Sesuai Native Sampling Rate terbaru)
      final double rawScreenTime = logCount / 3600;
      screenTimeHours.value = rawScreenTime.isNaN || rawScreenTime.isInfinite ? 0.0 : rawScreenTime;
      
      // Rasio Istirahat Ideal: 20% dari total screen time (Standar Medis 20-20-20)
      restTimeHours.value = screenTimeHours.value * 0.2;
    }

    final List<double> newIntensity = List.filled(24, 0.0);
    for (var i = 0; i < 24; i++) {
      final logList = hourlyMap[i]!;
      if (logList.isNotEmpty) {
        final double rawIntensity = logList.where((v) => v).length / logList.length;
        newIntensity[i] = rawIntensity.isNaN || rawIntensity.isInfinite ? 0.0 : rawIntensity;
      }
    }
    
    hourlyViolations.value = newIntensity;
  }
}
