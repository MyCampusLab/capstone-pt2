import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/data/models/sticker_model.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class HeroShowcaseDialog extends StatelessWidget {
  final StickerModel sticker;
  final bool isPurchase;
  final int? price;
  final VoidCallback onConfirm;

  const HeroShowcaseDialog({
    super.key,
    required this.sticker,
    this.isPurchase = false,
    this.price,
    required this.onConfirm,
  });

  static void show({
    required StickerModel sticker,
    bool isPurchase = false,
    int? price,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      HeroShowcaseDialog(
        sticker: sticker,
        isPurchase: isPurchase,
        price: price,
        onConfirm: onConfirm,
      ),
      barrierDismissible: true,
      barrierColor: Colors.black87,
    );
  }

  IconData _getIconForSticker(String id) {
    if (id == 's1') return Icons.shield_rounded;
    if (id == 's2') return Icons.stars_rounded;
    if (id == 's3') return Icons.medical_services_rounded;
    if (id == 's4') return Icons.auto_awesome_rounded;
    if (id == 's5') return Icons.eco_rounded;
    if (id == 's6') return Icons.speed_rounded;
    if (id == 's7') return Icons.light_mode_rounded;
    if (id == 's8') return Icons.diamond_rounded;
    return Icons.star_rounded;
  }

  Color _getColorForSticker(String id) {
    if (id == 's1') return const Color(0xFF3B82F6); // Blue
    if (id == 's2') return const Color(0xFF8B5CF6); // Purple
    if (id == 's3') return const Color(0xFFEF4444); // Red
    if (id == 's4') return const Color(0xFFF59E0B); // Amber
    if (id == 's5') return const Color(0xFF10B981); // Green
    if (id == 's6') return const Color(0xFF06B6D4); // Cyan
    if (id == 's7') return const Color(0xFFF97316); // Orange
    if (id == 's8') return const Color(0xFF6366F1); // Indigo
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: sticker.isEquipped ? AppColors.warning : AppColors.primaryDark,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: (sticker.isEquipped ? AppColors.warning : AppColors.primaryDark).withValues(alpha: 0.3),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gacha Ray Effect Background
            Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 10),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * 2 * 3.14159,
                      child: Icon(Icons.settings_suggest_rounded, size: 220, color: _getColorForSticker(sticker.id).withValues(alpha: 0.1)),
                    );
                  },
                ),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: _getColorForSticker(sticker.id).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: _getColorForSticker(sticker.id), width: 8),
                    boxShadow: [
                      BoxShadow(
                        color: _getColorForSticker(sticker.id).withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ]
                  ),
                  child: Center(
                    child: Icon(
                      _getIconForSticker(sticker.id),
                      size: 64,
                      color: _getColorForSticker(sticker.id),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Text(
              sticker.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              sticker.description,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryDark.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Buff Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: sticker.isEquipped ? AppColors.warning.withValues(alpha: 0.15) : AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sticker.isEquipped ? AppColors.warning.withValues(alpha: 0.5) : AppColors.secondary.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        sticker.isEquipped ? Icons.electric_bolt_rounded : Icons.auto_awesome_rounded,
                        color: sticker.isEquipped ? AppColors.warning : AppColors.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        sticker.isEquipped ? "BUFF AKTIF" : "BUFF PASIF",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: sticker.isEquipped ? AppColors.warning : AppColors.secondary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sticker.buffDescription,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Buttons
            if (sticker.isEquipped)
              SizedBox(
                width: double.infinity,
                child: VButton(
                  onPressed: () => Get.back(),
                  label: "TUTUP",
                  color: AppColors.primaryDark,
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        "BATAL",
                        style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: VButton(
                      onPressed: () {
                        Get.back();
                        onConfirm();
                      },
                      label: isPurchase ? "$price XP" : "GUNAKAN",
                      icon: isPurchase ? Icons.star_rounded : null,
                      color: isPurchase ? AppColors.secondary : AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
