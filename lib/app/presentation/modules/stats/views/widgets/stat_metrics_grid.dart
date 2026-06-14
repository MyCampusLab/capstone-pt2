import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/stats/controllers/stats_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class StatMetricsGrid extends GetView<StatsController> {
  const StatMetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                "DURASI AKTIF",
                controller.screenTimeHours.value.toStringAsFixed(1),
                "JAM",
                Icons.timer_rounded,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricItem(
                "RATA JARAK",
                controller.averageDistance.value.toStringAsFixed(0),
                "CM",
                Icons.straighten_rounded,
                AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                "PELANGGARAN",
                "${controller.totalViolationsCount.value}",
                "KALI",
                Icons.warning_amber_rounded,
                AppColors.danger,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricItem(
                "ISTIRAHAT",
                (controller.restTimeHours.value * 60).toStringAsFixed(0),
                "MENIT",
                Icons.bedtime_rounded,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    ));
  }

  Widget _buildMetricItem(String label, String value, String unit, IconData icon, Color color) {
    return VCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w900, fontSize: 10, color: AppColors.charcoal.withAlpha(150))),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTextStyles.heading1.copyWith(fontSize: 28, height: 1, color: AppColors.charcoal)),
              const SizedBox(width: 4),
              Text(unit, style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
