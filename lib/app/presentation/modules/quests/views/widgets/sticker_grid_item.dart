import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/models/sticker_model.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

/// Item grid stiker versi Compact (Zero-Scroll Edition).
/// Audit Visual: Menggunakan Expanded/Flexible untuk mencegah RenderFlex overflow.
class StickerGridItem extends StatelessWidget {
  final StickerModel? sticker;
  final VoidCallback? onTap;

  const StickerGridItem({super.key, this.sticker, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isLocked = sticker == null || !sticker!.isUnlocked;
    final Color badgeColor = isLocked 
        ? Colors.grey.shade200 
        : VizoMascot.getStateColor(sticker!.id == 's2' ? VizoState.focused : VizoState.happy);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isLocked ? Colors.grey.shade100 : badgeColor.withAlpha(40),
              shape: BoxShape.circle,
              border: Border.all(
                color: isLocked ? Colors.black12 : AppColors.primaryDark,
                width: isLocked ? 1.5 : 2.5,
              ),
              boxShadow: isLocked ? null : [
                BoxShadow(
                  color: AppColors.primaryDark.withAlpha(120),
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                isLocked ? Icons.lock_rounded : Icons.workspace_premium_rounded,
                color: isLocked ? Colors.grey : AppColors.primaryDark,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isLocked ? "???" : sticker!.title.split(" ").first,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              fontSize: 9, 
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
