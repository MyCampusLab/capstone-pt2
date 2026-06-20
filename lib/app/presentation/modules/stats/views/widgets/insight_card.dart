import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import '../../controllers/stats_controller.dart';

class InsightCard extends StatelessWidget {
  final StatsController controller;
  const InsightCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final score = controller.healthScore.value;
      final distance = controller.averageDistance.value.toStringAsFixed(1);
      
      String insightTitle = "Analisis AI Vizo";
      String insightMessage = "";
      IconData icon = Icons.psychology_rounded;
      Color color = AppColors.primary;

      if (score >= 90) {
        insightMessage = "Luar biasa! Penggunaan gadget sangat aman hari ini. Jarak mata rata-rata terjaga di $distance cm.";
        icon = Icons.verified_rounded;
        color = AppColors.success;
      } else if (score >= 60) {
        insightMessage = "Cukup baik, namun ada beberapa momen jarak terlalu dekat. Pastikan istirahat sesuai aturan 20-20-20.";
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
      } else {
        insightMessage = "Peringatan Tinggi! Terlalu banyak pelanggaran jarak dekat hari ini. Segera kurangi waktu layar anak.";
        icon = Icons.gpp_bad_rounded;
        color = AppColors.danger;
      }

      return VCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                shape: BoxShape.circle,
                border: Border.all(color: color.withAlpha(80), width: 1.5),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insightTitle,
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.primaryDark,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insightMessage,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryDark.withAlpha(200),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
