import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

/// VAppHeader: World-Class Solid Header for VisionSafe.
/// Prevents content overlap and provides clear status feedback.
class VAppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showStatus;
  final List<Widget>? actions;

  const VAppHeader({
    super.key, 
    required this.title,
    this.showStatus = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          title.toUpperCase(), 
          style: AppTextStyles.heading2.copyWith(
            letterSpacing: 3, 
            color: AppColors.primaryDark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          )
        ),
      ),
      centerTitle: true, // Centered title for ultimate symmetry
      backgroundColor: Colors.transparent, 
      elevation: 0,
      actions: actions,
      automaticallyImplyLeading: true, // Allow default back buttons on sub-pages
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

