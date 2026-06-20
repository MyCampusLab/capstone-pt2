import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/main_wrapper/controllers/main_wrapper_controller.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_design.dart';

/// VBottomNav: AAA Quality Floating Glass-Neobrutalist Navigation.
/// Featuring fluid active indicators, elastic interactions, and high-end depth.
class VBottomNav extends GetView<MainWrapperController> {
  const VBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppDesign.spaceL,
      left: AppDesign.spaceL,
      right: AppDesign.spaceL,
      child: SafeArea(
        top: false,
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesign.radiusFull),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.12),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 16,
                spreadRadius: -4,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDesign.radiusFull),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDesign.space12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7), 
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6), 
                    width: 1.5,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double totalWidth = constraints.maxWidth;
                    final double itemWidth = totalWidth / 4;
                    
                    return Stack(
                      children: [
                        // Fluid Active Indicator
                        Obx(() {
                          final double leftOffset = controller.currentIndex.value * itemWidth;
                          
                          return AnimatedPositioned(
                            duration: const Duration(milliseconds: 400),
                            curve: AppDesign.elasticCurve,
                            left: leftOffset,
                            top: 10,
                            bottom: 10,
                            width: itemWidth,
                            child: Center(
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDark,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        
                        // Interaction Layer
                        Row(
                          children: [
                            _buildNavItem(0, Icons.face_rounded, "BUDDY"),
                            _buildNavItem(1, Icons.auto_graph_rounded, "STATS"),
                            _buildNavItem(2, Icons.military_tech_rounded, "QUESTS"),
                            _buildNavItem(3, Icons.settings_rounded, "SETTINGS"),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return Expanded(
      child: Obx(() {
        final bool isSelected = controller.currentIndex.value == index;
        
        return Semantics(
          label: 'katalon_nav_${label.toLowerCase()}',
          button: true,
          child: GestureDetector(
            onTap: () {
              if (!isSelected) {
                HapticFeedback.mediumImpact();
                controller.changePage(index);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.0 : 0.9,
                  duration: AppDesign.medium,
                  curve: AppDesign.springCurve,
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : AppColors.primaryDark.withValues(alpha: 0.45),
                    size: 26,
                  ),
                ),
                if (!isSelected)
                  const SizedBox(height: 4),
                if (!isSelected)
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark.withValues(alpha: 0.45),
                      letterSpacing: 0.5,
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
