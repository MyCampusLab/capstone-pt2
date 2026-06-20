import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';
import '../../controllers/stats_controller.dart';

/// Card untuk membandingkan waktu penggunaan layar dan waktu istirahat mata.
/// Proteksi: Anti-NaN & Anti-Infinity untuk stabilitas progres bar.
class ScreenTimeVsRestCard extends StatelessWidget {
  final StatsController controller;
  const ScreenTimeVsRestCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return VCard(
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("WAKTU LAYAR VS ISTIRAHAT", style: AppTextStyles.bodyBold),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetric(
                  label: "Layar",
                  value: controller.screenTimeHours.value.toStringAsFixed(1),
                  unit: "JAM",
                  color: AppColors.primary,
                  icon: Icons.smartphone_rounded,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.charcoal.withAlpha(30)),
              Expanded(
                child: _buildMetric(
                  label: "Istirahat",
                  value: controller.restTimeHours.value.toStringAsFixed(1),
                  unit: "JAM",
                  color: AppColors.success,
                  icon: Icons.bedtime_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressIndicator(),
        ],
      )),
    );
  }

  Widget _buildMetric({
    required String label,
    required String value,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: AppTextStyles.heading1.copyWith(fontSize: 20, color: color)),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(unit, style: AppTextStyles.caption.copyWith(fontSize: 8, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    // SQA Fix: Hindari pembagian nol yang menyebabkan NaN/Infinity
    double screenTime = controller.screenTimeHours.value;
    double restTime = controller.restTimeHours.value;
    double total = screenTime + restTime;
    
    // Jika total nol, ratio harus 0.0 (Bukan NaN)
    double ratio = total > 0 ? (restTime / total) : 0.0;
    
    // Pastikan ratio berada di rentang 0.0 - 1.0 agar LinearProgressIndicator tidak crash
    ratio = ratio.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: AppColors.primary.withAlpha(50),
            color: AppColors.success,
            minHeight: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          ratio > 0.2 ? "BAGUS! Istirahatmu cukup." : "AWAS! Kamu kurang istirahat mata.",
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
            color: ratio > 0.2 ? AppColors.success : AppColors.danger,
          ),
        ),
      ],
    );
  }
}
