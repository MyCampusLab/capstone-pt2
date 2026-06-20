import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/stats_controller.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';

class StickerCollection extends StatelessWidget {
  final StatsController controller;
  const StickerCollection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("KOLEKSI STIKER VIZO", style: AppTextStyles.bodyBold),
        const SizedBox(height: 16),
        Obx(() => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: controller.stickers.length,
              itemBuilder: (context, index) {
                final sticker = controller.stickers[index];
                return _buildStickerItem(sticker);
              },
            )),
      ],
    );
  }

  Widget _buildStickerItem(dynamic sticker) {
    return Tooltip(
      message: sticker.description,
      child: Opacity(
        opacity: sticker.isUnlocked ? 1.0 : 0.3,
        child: VCard(
          padding: 0,
          color: sticker.isUnlocked ? AppColors.secondary : AppColors.grey,
          child: Center(
            child: Icon(
              sticker.isUnlocked ? Icons.stars_rounded : Icons.lock_outline_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
