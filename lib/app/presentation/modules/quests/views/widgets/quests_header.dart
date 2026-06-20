import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import '../../controllers/quests_controller.dart';

class QuestsHeader extends StatelessWidget {
  const QuestsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(6, 6))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withAlpha(60), shape: BoxShape.circle),
            child: const Icon(Icons.stars_rounded, color: AppColors.warning, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("QUEST MAP", style: AppTextStyles.heading2.copyWith(color: Colors.white, fontSize: 20)),
                Text("Selesaikan misi untuk stiker eksklusif!", 
                  style: AppTextStyles.caption.copyWith(color: Colors.white.withAlpha(180), fontSize: 11)),
              ],
            ),
          ),
          Obx(() {
            final controller = Get.find<QuestsController>();
            final streak = controller.streakCount.value;
            String multiplier = "1x XP";
            if (streak >= 7) {
              multiplier = "2x XP";
            } else if (streak >= 3) {
              multiplier = "1.5x XP";
            }
            
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text("$streak HARI", style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  Text("Buff: $multiplier", style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
