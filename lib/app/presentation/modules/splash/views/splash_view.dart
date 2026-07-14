import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_immersive_background.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller secara manual karena tidak lewat binding route (initial route)
    if (!Get.isRegistered<SplashController>()) {
      Get.put(SplashController());
    }

    return VImmersiveBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'vizo_mascot',
                        child: const VizoMascot(
                          size: 240, 
                          state: VizoState.happy,
                          isBlinking: true,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "VISIONSAFE",
                        style: AppTextStyles.heading1.copyWith(
                          fontSize: 32,
                          color: AppColors.primaryDark,
                          letterSpacing: 4 + (2 * value),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Your Cyber Health Guardian",
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 14,
                          color: AppColors.primaryDark.withValues(alpha: (150 * value).toInt() / 255.0),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
