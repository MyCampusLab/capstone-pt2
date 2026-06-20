import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';

class NotificationTipsDialog {
  static void show() {
    VDialog.show(
      title: "PUSAT EDUKASI VIZO",
      icon: Icons.lightbulb_outline_rounded,
      iconColor: AppColors.secondary,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTipItem(
            Icons.tips_and_updates_rounded, 
            "ATURAN 20-20-20", 
            "Setiap 20 menit menatap layar HP, istirahatkan mata dengan melihat benda berjarak 6 meter (20 kaki) selama 20 detik.",
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            Icons.wb_sunny_rounded, 
            "CAHAYA SEHAT", 
            "Hindari bermain HP di ruangan gelap gulita. Pastikan ruangan memiliki pencahayaan cukup agar mata anak tidak tegang.",
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            Icons.sports_esports_rounded, 
            "MISI SPESIAL VIZO", 
            "Mainkan menu 'Latihan' senam mata seru bersama Vizo untuk meregangkan otot penglihatan dan dapatkan bonus +50 XP!",
          ),
        ],
      ),
    );
  }

  static Widget _buildTipItem(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryDark,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(20),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryDark, width: 1.5),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 12, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.primaryDark.withAlpha(180), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
