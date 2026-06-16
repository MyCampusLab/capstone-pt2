import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class WaitingVerificationView extends StatelessWidget {
  const WaitingVerificationView({super.key});

  Future<void> _openEmailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
    );
    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      Get.snackbar(
        "Oops!", 
        "Tidak dapat membuka aplikasi email secara otomatis.",
        backgroundColor: AppColors.danger.withValues(alpha: 0.1),
        colorText: AppColors.danger,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Mascot Section
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: VizoMascot(
                    size: 200,
                    state: VizoState.happy,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Title
              Text(
                "Cek Email Kamu, Hero! 📧",
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.charcoal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Description
              Text(
                "Vizo sudah mengirimkan tiket rahasia ke email kamu. Klik link di dalamnya untuk mengaktifkan kekuatan penuh VisionSafe!",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Action Buttons
              ElevatedButton.icon(
                onPressed: _openEmailApp,
                icon: const Icon(Icons.mail_outline_rounded, size: 24),
                label: const Text(
                  "Buka Aplikasi Email",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: () => Get.offAllNamed(Routes.login),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Kembali ke Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
