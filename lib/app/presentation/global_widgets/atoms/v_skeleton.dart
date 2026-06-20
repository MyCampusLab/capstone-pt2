import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

/// VSkeleton: Atom Shimmer Loading kelas Enterprise
/// Menggantikan CircularProgressIndicator konvensional dengan efek loading tulang yang mulus.
class VSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const VSkeleton({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryDark.withValues(alpha: 0.1),
      highlightColor: AppColors.primaryDark.withValues(alpha: 0.05),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.primaryDark.withValues(alpha: 0.2), width: 2),
        ),
      ),
    );
  }
}
