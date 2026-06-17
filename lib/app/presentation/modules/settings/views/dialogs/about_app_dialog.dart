import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';

class AboutAppDialog extends StatelessWidget {
  const AboutAppDialog({super.key});

  static void show() {
    VDialog.show(
      title: "Tentang VisionSafe",
      content: const AboutAppDialog(),
      confirmLabel: "TUTUP",
      icon: Icons.info_outline_rounded,
      iconColor: AppColors.secondary,
      onConfirm: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSection(
          "VISI & MISI",
          "VisionSafe diciptakan untuk membebaskan generasi muda dari ancaman Astenopia dan Miopia akibat paparan layar berlebih. Kami menggunakan teknologi kecerdasan buatan untuk mengawal kesehatan mata secara proaktif dan menyenangkan.",
        ),
        const SizedBox(height: 16),
        _buildSection(
          "PENGEMBANG",
          "Aplikasi ini adalah hasil riset mutakhir yang dirancang khusus dengan arsitektur Enterprise, memanfaatkan AI Edge Computing untuk deteksi wajah tanpa kompromi privasi.",
        ),
        const SizedBox(height: 16),
        _buildSection(
          "VERSI",
          "VisionSafe v1.0.0 Elite Edition\nPowered by SDA Framework V2",
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 13, height: 1.4, color: AppColors.primaryDark.withAlpha(200)),
        ),
      ],
    );
  }
}
