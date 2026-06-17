import 'dart:async';
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
  StreamSubscription? _analyticsSubscription;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  @override
  void onClose() {
    _analyticsSubscription?.cancel();
    super.onClose();
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
      // Dengarkan perubahan secara real-time dari Supabase (WebSockets)
      _analyticsSubscription?.cancel();
      _analyticsSubscription = _supabaseService.watchAnalyticsData(limit: 1000).listen(
        (cloudData) {
          // Setiap kali ada data baru dari database (anak terdeteksi), 
          // Stream ini akan otomatis terpanggil.
          
          // MENGGABUNGKAN DATA: Cloud + Local Hive
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
        },
        onError: (error) {
          Get.log('Error Stream Analytics: $error');
          _resetToEmptyState();
        },
      );
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
    int totalHeartbeats = 0;
    double sumDistance = 0.0;
    int distanceCount = 0;
    
    final now = DateTime.now();
    final Map<int, List<bool>> weeklyMap = {for (var i = 0; i < 7; i++) i: []};
    
    for (var log in logs) {
      try {
        final createdAtStr = log['created_at']?.toString();
        if (createdAtStr == null) continue;
        
        final createdAt = DateTime.parse(createdAtStr).toLocal();
        final isViolation = log['is_violation'] as bool? ?? false;
        
        // --- WEEKLY CHART LOGIC (7 Hari Terakhir) ---
        final differenceInDays = now.difference(createdAt).inDays;
        if (differenceInDays >= 0 && differenceInDays < 7) {
            // Index 6 adalah hari ini (now), Index 0 adalah 6 hari yang lalu.
            final index = 6 - differenceInDays;
            weeklyMap[index]?.add(isViolation);
        }
        
        // --- TODAY FILTER (Super Penting untuk Ringkasan Hari Ini) ---
        if (createdAt.year != now.year || createdAt.month != now.month || createdAt.day != now.day) {
            continue;
        }
        
        if (isViolation) {
            totalViolations++;
        } else {
            totalHeartbeats++;
        }
        
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
      // RUMUS BARU (Smart Event-Driven Architecture):
      // Heartbeat mewakili 60 detik aktivitas aman.
      // Violation mewakili 15 detik aktivitas bahaya.
      final int totalScreenTimeSeconds = (totalHeartbeats * 60) + (totalViolations * 15);
      
      // Menghitung persentase waktu bahaya dari total waktu
      final int totalViolationSeconds = totalViolations * 15;
      final double timeBasedViolationRate = totalScreenTimeSeconds > 0 
          ? (totalViolationSeconds / totalScreenTimeSeconds) 
          : 0.0;
          
      final double rawScore = 100 - (timeBasedViolationRate * 100);
      healthScore.value = rawScore.isNaN || rawScore.isInfinite 
          ? 100 
          : rawScore.clamp(0, 100).toInt();
      
      final double rawScreenTime = totalScreenTimeSeconds / 3600;
      screenTimeHours.value = rawScreenTime.isNaN || rawScreenTime.isInfinite ? 0.0 : rawScreenTime;
      
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
    
    // --- POPULATE WEEKLY CHART ---
    final List<double> newWeekly = List.filled(7, 0.0);
    for (var i = 0; i < 7; i++) {
      final dailyList = weeklyMap[i]!;
      if (dailyList.isNotEmpty) {
        final double rate = dailyList.where((v) => v).length / dailyList.length;
        newWeekly[i] = rate.isNaN || rate.isInfinite ? 0.0 : rate;
      }
    }
    weeklyData.value = newWeekly;
  }
}
