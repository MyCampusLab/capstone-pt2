import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_news_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class VEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final VizoState mascotState;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool useNewsMascot;

  const VEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.mascotState = VizoState.sleeping,
    this.actionLabel,
    this.onActionPressed,
    this.useNewsMascot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusM),
        border: Border.all(color: AppColors.primaryDark, width: AppDesign.borderWidth),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryDark,
            offset: Offset(AppDesign.shadowOffset, AppDesign.shadowOffset),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          useNewsMascot 
              ? VizoNewsMascot(size: 110, state: mascotState) 
              : VizoMascot(size: 110, state: mascotState),
          const SizedBox(height: AppDesign.spaceM),
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.primaryDark,
              fontSize: 16,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppDesign.spaceS),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.grey,
              height: 1.4,
            ),
          ),
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(height: AppDesign.spaceL),
            VButton(
              label: actionLabel!,
              onPressed: onActionPressed!,
              color: AppColors.primary,
            ),
          ],
        ],
      ),
    );
  }
}
