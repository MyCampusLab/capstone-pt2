import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_card.dart';

/// Komponen Tile Pengaturan modular untuk menjaga kebersihan kode SettingsView.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconBgColor;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.iconBgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onTap != null) {
          HapticFeedback.lightImpact();
          onTap!();
        }
      },
      child: VCard(
        padding: 12,
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 16),
            _buildContent(),
            if (trailing != null) ...[
              trailing!,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconBgColor ?? AppColors.primary.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodyBold),
          Text(subtitle, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
