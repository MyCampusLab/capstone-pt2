import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import '../atoms/v_card.dart';
import '../atoms/v_button.dart';

/// Utilitas Dialog bergaya VCard untuk konsistensi UI/UX Elite.
class VDialog {
  static void show({
    required String title,
    String? message,
    Widget? content,
    String confirmLabel = "OK!",
    String? cancelLabel,
    IconData icon = Icons.info_outline_rounded,
    Color iconColor = AppColors.primary,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Material(
            color: Colors.transparent,
            child: VCard(
              padding: 24,
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.primaryDark,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                if (message != null)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryDark.withAlpha(180),
                      height: 1.5,
                    ),
                  ),
                if (content != null) ...[
                  const SizedBox(height: 16),
                  content,
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    if (cancelLabel != null) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                            onCancel?.call();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.primaryDark, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            cancelLabel.toUpperCase(),
                            style: AppTextStyles.bodyBold.copyWith(fontSize: 14, color: AppColors.primaryDark),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: VButton(
                        label: confirmLabel,
                        onPressed: () {
                          Get.back();
                          onConfirm?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),
        ),
      ),
      barrierColor: Colors.black.withAlpha(100),
      transitionCurve: Curves.elasticOut,
    );
  }
}
