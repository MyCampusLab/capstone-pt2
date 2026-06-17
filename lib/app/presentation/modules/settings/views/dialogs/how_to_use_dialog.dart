import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';

class HowToUseDialog extends StatelessWidget {
  const HowToUseDialog({super.key});

  static void show() {
    VDialog.show(
      title: "Cara Penggunaan",
      content: const HowToUseDialog(),
      confirmLabel: "MENGERTI",
      icon: Icons.menu_book_rounded,
      iconColor: AppColors.primary,
      onConfirm: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStep(
          "1",
          "Nyalakan Pelindung",
          "Ketuk tombol bulat berlogo mata (Vizo) di halaman utama untuk mengaktifkan AI Camera di latar belakang.",
        ),
        const SizedBox(height: 12),
        _buildStep(
          "2",
          "Bermain HP Seperti Biasa",
          "Buka aplikasi lain (YouTube, TikTok, dll). VisionSafe akan terus memantau jarak mata dari layar secara diam-diam.",
        ),
        const SizedBox(height: 12),
        _buildStep(
          "3",
          "Respons Peringatan",
          "Jika jarak terlalu dekat, layar akan tertutup sebagian oleh Vizo. Jauhkan HP ke jarak aman (default: 30cm) agar layar kembali normal.",
        ),
        const SizedBox(height: 12),
        _buildStep(
          "4",
          "Pantau Statistik",
          "Lihat grafik di menu Statistik untuk mengetahui pola kebiasaan anak. Gunakan informasi ini untuk memberikan edukasi lebih lanjut.",
        ),
      ],
    );
  }

  Widget _buildStep(String number, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryDark, width: 1.5),
          ),
          child: Text(number, style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark, fontSize: 14)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark, fontSize: 13)),
              const SizedBox(height: 2),
              Text(desc, style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark.withAlpha(180), height: 1.3, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
