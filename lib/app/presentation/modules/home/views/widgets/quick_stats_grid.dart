import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';

/// QuickStatsGrid: Local module widget matching the global rich stats grid for seamless redundancy and clean UX.
class QuickStatsGrid extends GetView<HomeController> {
  const QuickStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Akses variabel reaktif untuk memicu rebuild otomatis saat data masuk
      final _ = controller.telemetryService.currentDistance.value;
      final violationMins = controller.dailyViolationMinutes.value;
      
      final healthScore = controller.eyeHealthScore.toInt();
      final Color scoreColor = healthScore >= 85 
          ? Colors.green 
          : (healthScore >= 60 ? Colors.orange : Colors.red);

      // Card 1 (Skor Mata) Metadata
      String healthStatus;
      Color healthStatusBg;
      Color healthStatusText;
      if (healthScore >= 85) {
        healthStatus = "PRIMA";
        healthStatusBg = Colors.green.withAlpha(35);
        healthStatusText = Colors.green[800]!;
      } else if (healthScore >= 65) {
        healthStatus = "BAIK";
        healthStatusBg = Colors.blue.withAlpha(35);
        healthStatusText = Colors.blue[800]!;
      } else if (healthScore >= 45) {
        healthStatus = "LELAH";
        healthStatusBg = Colors.orange.withAlpha(35);
        healthStatusText = Colors.orange[800]!;
      } else {
        healthStatus = "KRITIS";
        healthStatusBg = Colors.red.withAlpha(35);
        healthStatusText = Colors.red[800]!;
      }

      // Card 2 (Pelanggaran) Metadata
      final String violationValue = violationMins < 1.0 
          ? "${(violationMins * 60).toInt()}" 
          : violationMins.toStringAsFixed(1);
      final String violationUnit = violationMins < 1.0 ? "DTK" : "MNT";

      String violationStatus;
      Color violationStatusBg;
      Color violationStatusText;
      if (violationMins <= 0.1) {
        violationStatus = "AMAN";
        violationStatusBg = Colors.green.withAlpha(35);
        violationStatusText = Colors.green[800]!;
      } else if (violationMins < 2.0) {
        violationStatus = "AWARE";
        violationStatusBg = Colors.orange.withAlpha(35);
        violationStatusText = Colors.orange[800]!;
      } else {
        violationStatus = "BAHAYA";
        violationStatusBg = Colors.red.withAlpha(35);
        violationStatusText = Colors.red[800]!;
      }

      final double avgDistance = controller.averageDistanceToday;
      final String avgDistanceStr = avgDistance > 0 ? "${avgDistance.toInt()} CM" : "-";

      final activeMins = controller.activeMonitoringMinutes;
      final blinkCount = controller.blinkCountToday;

      return GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: AppDesign.spaceM,
        mainAxisSpacing: AppDesign.spaceM,
        childAspectRatio: 1.1, // Elegant landscape-oriented card ratio
        children: [
          // Card 1: Eye Health Index
          _buildStatItem(
            label: "SKOR MATA",
            value: "$healthScore",
            unit: "PTS",
            icon: Icons.health_and_safety_rounded,
            color: scoreColor,
            progressValue: healthScore / 100.0,
            progressBarColor: scoreColor,
            statusText: healthStatus,
            statusBgColor: healthStatusBg,
            statusTextColor: healthStatusText,
            subtitleText: "Aktif: ${_formatDuration(activeMins)} • $blinkCount Kedip",
          ),
          // Card 2: Posture & Warnings
          _buildStatItem(
            label: "PELANGGARAN",
            value: violationValue,
            unit: violationUnit,
            icon: Icons.warning_amber_rounded,
            color: violationMins > 0 ? Colors.red : Colors.green,
            progressValue: (violationMins / 5.0).clamp(0.01, 1.0),
            progressBarColor: violationMins > 0 ? Colors.red : Colors.green,
            statusText: violationStatus,
            statusBgColor: violationStatusBg,
            statusTextColor: violationStatusText,
            subtitleText: "Jarak: $avgDistanceStr • Strain: ${controller.eyeStrainLevelToday}",
          ),
        ],
      );
    });
  }

  String _formatDuration(double minutes) {
    if (minutes <= 0) return "0s";
    if (minutes < 1.0) {
      return "${(minutes * 60).toInt()}s";
    }
    if (minutes < 60.0) {
      return "${minutes.toStringAsFixed(0)}m";
    }
    final hours = minutes / 60.0;
    return "${hours.toStringAsFixed(1)}h";
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required double progressValue,
    required Color progressBarColor,
    required String statusText,
    required Color statusBgColor,
    required Color statusTextColor,
    required String subtitleText,
  }) {
    return VCard(
      padding: 12.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Row: Label & Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label, 
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w900, 
                  fontSize: 9.0, 
                  color: AppColors.primaryDark.withAlpha(180),
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          
          // Value & Badge Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value, 
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 28, 
                  height: 1.0, 
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w900,
                )
              ),
              const SizedBox(width: 2),
              Text(
                unit, 
                style: AppTextStyles.caption.copyWith(
                  fontSize: 9.0, 
                  fontWeight: FontWeight.w900, 
                  color: AppColors.grey
                )
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.primaryDark, width: 1.2),
                ),
                child: Text(
                  statusText,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w900,
                    color: statusTextColor,
                    height: 1.0,
                  ),
                ),
              ),
            ],
          ),
          
          // Sleek progress bar
          Container(
            height: 5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withAlpha(15),
              borderRadius: BorderRadius.circular(2.5),
              border: Border.all(color: AppColors.primaryDark, width: 1.2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressValue.clamp(0.01, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: progressBarColor,
                  borderRadius: BorderRadius.circular(1.2),
                ),
              ),
            ),
          ),
          
          // Subtitle Text (Single Elegant Line)
          Text(
            subtitleText, 
            style: AppTextStyles.caption.copyWith(
              fontSize: 8.5, 
              fontWeight: FontWeight.w800, 
              color: AppColors.primaryDark.withAlpha(140),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
