import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/models/sticker_model.dart';

/// Item grid stiker versi Compact (Zero-Scroll Edition).
/// Audit Visual: Menggunakan Expanded/Flexible untuk mencegah RenderFlex overflow.
class StickerGridItem extends StatelessWidget {
  final StickerModel? sticker;
  final VoidCallback? onTap;

  const StickerGridItem({super.key, this.sticker, this.onTap});

  IconData _getIconForSticker(String? id) {
    if (id == null) return Icons.help_outline_rounded;
    if (id == 's1') return Icons.shield_rounded; // Guardian
    if (id == 's2') return Icons.stars_rounded; // Captain
    if (id == 's3') return Icons.medical_services_rounded; // Medic
    if (id == 's4') return Icons.auto_awesome_rounded; // Zenith Master
    if (id == 's5') return Icons.eco_rounded; // Forest Ninja
    if (id == 's6') return Icons.speed_rounded; // Quantum
    if (id == 's7') return Icons.light_mode_rounded; // Solar Flare
    if (id == 's8') return Icons.diamond_rounded; // Cosmic Overlord
    return Icons.star_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocked = sticker == null || !sticker!.isUnlocked;
    final bool isEquipped = sticker != null && !isLocked && sticker!.isEquipped;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isLocked ? Colors.grey.shade200 : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLocked ? Colors.grey.shade400 : (isEquipped ? AppColors.warning : AppColors.primaryDark),
                    width: isLocked ? 2.0 : 3.0,
                  ),
                  boxShadow: isLocked ? null : [
                    BoxShadow(
                      color: isEquipped ? AppColors.warning : AppColors.primaryDark,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getIconForSticker(sticker?.id),
                    size: 24,
                    color: isLocked ? Colors.grey.shade400 : (isEquipped ? AppColors.warning : AppColors.primaryDark),
                  ),
                ),
              ),
              if (isEquipped)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 12),
                  ),
                ),
            ],
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
