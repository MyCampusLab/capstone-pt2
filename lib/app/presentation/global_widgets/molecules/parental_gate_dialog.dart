import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';

class ParentalGate {
  static void show({required VoidCallback onSuccess}) {
    final random = Random();
    final num1 = random.nextInt(8) + 5; // 5 to 12
    final num2 = random.nextInt(8) + 5; // 5 to 12
    final answer = num1 * num2;
    
    final textController = TextEditingController();
    final errorText = RxnString();

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
                      color: AppColors.danger.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.security_rounded, color: AppColors.danger, size: 40),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "VERIFIKASI ORANG TUA",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.primaryDark,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Jawab pertanyaan matematika berikut untuk mematikan proteksi mata.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryDark.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                    ),
                    child: Text(
                      "$num1 x $num2 = ?",
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 28,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() => TextField(
                        controller: textController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading2,
                        decoration: InputDecoration(
                          hintText: "Jawaban",
                          errorText: errorText.value,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                      )),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.primaryDark, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            "BATAL",
                            style: AppTextStyles.bodyBold.copyWith(fontSize: 14, color: AppColors.primaryDark),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: VButton(
                          label: "VERIFIKASI",
                          color: AppColors.danger,
                          onPressed: () {
                            if (textController.text == answer.toString()) {
                              Get.back(); // Tutup dialog
                              onSuccess(); // Matikan proteksi
                            } else {
                              errorText.value = "Jawaban salah!";
                            }
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
      barrierColor: Colors.black54,
      transitionCurve: Curves.elasticOut,
    );
  }
}
