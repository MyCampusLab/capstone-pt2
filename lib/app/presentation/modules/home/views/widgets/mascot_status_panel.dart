import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';

class MascotStatusPanel extends StatelessWidget {
  final HomeController controller;

  const MascotStatusPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.userProfile.value;
      final level = profile?.level ?? 1;
      final xp = profile?.xp ?? 0;

      final currentLevelBaseXp = (level - 1) * 100;
      final nextLevelXp = level * 100;
      final progress = (xp - currentLevelBaseXp) / (nextLevelXp - currentLevelBaseXp);
      final clampedProgress = progress.clamp(0.0, 1.0);

      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _showLevelDetails(level, xp.toInt(), nextLevelXp);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryDark, width: 3),
            boxShadow: const [
              BoxShadow(
                color: AppColors.primaryDark,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              // Left Side: Circular Progress surrounding Level
              _buildCircularLevelProgress(level, clampedProgress),
              
              const SizedBox(width: 16),
              
              // Right Side: Bold Role Title, XP, and Clean Connection Status Pill
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Pahlawan Penjaga Mata",
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // High-End XP Progress Bar Line
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: clampedProgress,
                              backgroundColor: AppColors.primaryDark.withAlpha(20),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$xp / $nextLevelXp XP",
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryDark,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (controller.telemetryService.isPowerSaveActive.value)
                          _buildPowerSaveBadge(),
                        if (controller.telemetryService.isLowLight.value)
                          _buildLowLightBadge(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCircularLevelProgress(int level, double clampedProgress) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: clampedProgress),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.elasticOut,
      builder: (context, animValue, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background empty track circle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withAlpha(20),
                border: Border.all(color: AppColors.primaryDark.withAlpha(40), width: 1.5),
              ),
            ),
            // Animated Progress Track Circle (Purple Violet)
            SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                value: animValue,
                strokeWidth: 5.5,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
            ),
            // Center text (LVL and Level count)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "LVL",
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark.withAlpha(140),
                    height: 1.0,
                  ),
                ),
                Text(
                  "$level",
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Cloud Sync Pill removed as requested (to avoid confusion)

  Widget _buildPowerSaveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.warning,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.battery_saver_rounded,
            size: 11,
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: 4),
          Text(
            "HEMAT BATERAI",
            style: AppTextStyles.caption.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowLightBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.danger.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.danger,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.brightness_3_rounded,
            size: 11,
            color: AppColors.danger,
          ),
          const SizedBox(width: 4),
          Text(
            "TERLALU GELAP",
            style: AppTextStyles.caption.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: AppColors.danger,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showLevelDetails(int level, int xp, int nextLevelXp) {
    final currentLevelBaseXp = (level - 1) * 100;
    final progress = (xp - currentLevelBaseXp) / (nextLevelXp - currentLevelBaseXp);
    final clampedProgress = progress.clamp(0.0, 1.0);

    VDialog.show(
      title: "PROFIL PAHLAWAN MATA",
      icon: Icons.shield_rounded,
      iconColor: AppColors.primary,
      showConfetti: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Hero(
            tag: 'vizo_thumb_dialog',
            child: VizoMascot(size: 100, state: VizoState.happy),
          ),
          const SizedBox(height: 16),
          Text(
            "LEVEL $level: HERO DEFENDER",
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2.copyWith(color: AppColors.primaryDark),
          ),
          const SizedBox(height: 4),
          Text(
            "${(nextLevelXp - xp)} XP lagi untuk naik level!",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: clampedProgress,
              minHeight: 12,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$xp XP", style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              Text("$nextLevelXp XP", style: AppTextStyles.caption.copyWith(color: AppColors.grey)),
            ],
          ),
          const SizedBox(height: 24),
          _buildMilestoneItem(Icons.task_alt_rounded, "Level Saat Ini ($level)", "Melindungi mata dengan disiplin.", isAchieved: true),
          const SizedBox(height: 12),
          _buildMilestoneItem(Icons.lock_outline_rounded, "Target Level ${level + 1}", "Terbuka setelah $nextLevelXp XP.", isAchieved: false),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem(IconData icon, String title, String desc, {bool isAchieved = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAchieved ? AppColors.success.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isAchieved ? AppColors.success : AppColors.primaryDark, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryDark,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAchieved ? AppColors.success : AppColors.primaryDark.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isAchieved ? Colors.white : AppColors.primaryDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold.copyWith(color: isAchieved ? AppColors.success : AppColors.primaryDark)),
                const SizedBox(height: 2),
                Text(desc, style: AppTextStyles.caption.copyWith(color: Colors.grey[700], height: 1.2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
