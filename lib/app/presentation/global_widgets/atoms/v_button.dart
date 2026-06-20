import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';

/// VButton: AAA Quality Neobrutalist Button.
/// Featuring tactile spring animations, high-contrast states, and accessibility compliance.
class VButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final bool enabled;
  final bool isOutline;

  const VButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = AppColors.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.enabled = true,
    this.isOutline = false,
  });

  @override
  State<VButton> createState() => _VButtonState();
}

class _VButtonState extends State<VButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  bool get _isActive => widget.enabled && !widget.isLoading && widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: AppDesign.fast,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isActive) {
      setState(() => _isPressed = true);
      _scaleController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isActive) {
      setState(() => _isPressed = false);
      _scaleController.reverse();
      HapticFeedback.mediumImpact();
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (_isActive) {
      setState(() => _isPressed = false);
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = widget.isOutline ? Colors.white : widget.color;
    final Color buttonColor = _isActive ? baseColor : AppColors.grey.withAlpha(50);
    
    final Color contentColor = !_isActive
        ? AppColors.grey
        : widget.isOutline 
            ? (widget.color == Colors.white ? AppColors.primaryDark : widget.color)
            : (buttonColor == AppColors.primary || 
               buttonColor == AppColors.success || 
               buttonColor == AppColors.warning || 
               buttonColor == Colors.white)
                ? AppColors.primaryDark
                : Colors.white;

    return Semantics(
      button: true,
      enabled: _isActive,
      label: widget.label,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: AppDesign.fast,
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(
              _isPressed ? 2.0 : 0.0, 
              _isPressed ? 2.0 : 0.0, 
              0.0,
            ),
            height: 62, 
            width: widget.width ?? double.infinity,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(AppDesign.radiusM),
              border: Border.all(color: AppColors.primaryDark, width: AppDesign.borderWidth),
              boxShadow: _isPressed || !_isActive
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.primaryDark,
                        offset: const Offset(AppDesign.shadowOffsetSmall, AppDesign.shadowOffsetSmall),
                      )
                    ],
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: contentColor, 
                        strokeWidth: 3,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: contentColor, size: 24),
                          const SizedBox(width: AppDesign.space12),
                        ],
                        Text(
                          widget.label.toUpperCase(),
                          style: AppTextStyles.bodyBold.copyWith(
                            color: contentColor,
                            letterSpacing: 1.5,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
