import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';

/// CompactActionButton: Unified Premium Control Button for VisionSafe.
/// Merged start control and protection status into a single tactile, high-contrast neobrutalist power-toggle button.
class CompactActionButton extends StatelessWidget {
  const CompactActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final bool isRunning = controller.isServiceRunning;
      final Color btnBgColor = isRunning ? AppColors.danger : AppColors.success;
      final Color contentColor = isRunning ? Colors.white : AppColors.primaryDark;

      return GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          controller.toggleService();
        },
        child: AnimatedOpacity(
          duration: AppDesign.medium,
          opacity: isRunning ? 0.75 : 1.0,
          child: AnimatedContainer(
            duration: AppDesign.medium,
          curve: AppDesign.springCurve,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: btnBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryDark, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark,
                offset: isRunning ? const Offset(2, 2) : const Offset(4, 4),
              )
            ],
          ),
          child: Row(
            children: [
              // 1. Icon Container with Pulsing / Glowing indicator when running
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isRunning ? Colors.white.withAlpha(60) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryDark, width: 2),
                ),
                child: Icon(
                  isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  size: 24,
                  color: isRunning ? Colors.white : AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 16),
              
              // 2. Text column (Title & Subtitle)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isRunning ? "HENTIKAN PROTEKSI" : "MULAI PROTEKSI",
                      style: AppTextStyles.bodyBold.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: contentColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isRunning
                          ? "Vizo sedang aktif memantau matamu."
                          : "Ketuk untuk mengaktifkan radar mata.",
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: contentColor.withAlpha(isRunning ? 200 : 160),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 3. Right Chevron Indicator
              Icon(
                Icons.chevron_right_rounded,
                color: contentColor,
                size: 24,
              ),
            ],
          ),
        ),
        ),
      );
    });
  }
}
