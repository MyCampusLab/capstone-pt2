import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';

/// VInput: AAA Quality Textfield.
/// Featuring smooth focus transitions, premium border glow, and consistent tactile feedback.
class VInput extends StatefulWidget {
  final String? label;
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  const VInput({
    super.key,
    this.label,
    this.hint = "",
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  State<VInput> createState() => _VInputState();
}

class _VInputState extends State<VInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _isFocused = _focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(covariant VInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChange);
      _isFocused = _focusNode.hasFocus;
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppDesign.space8),
        ],
        AnimatedContainer(
          duration: AppDesign.medium,
          curve: AppDesign.smoothCurve,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.98),
            borderRadius: BorderRadius.circular(AppDesign.radiusM),
            border: Border.all(
              color: _isFocused 
                  ? AppColors.primary 
                  : AppColors.primaryDark.withValues(alpha: 0.15),
              width: _isFocused ? 2.5 : 2.0,
            ),
            boxShadow: [
              if (_isFocused)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 16.0,
                  spreadRadius: 2.0,
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  offset: const Offset(0, 2),
                  blurRadius: 4.0,
                ),
            ],
          ),
          child: Semantics(
            identifier: widget.hint,
            label: widget.hint,
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
              autofillHints: widget.autofillHints,
              textInputAction: widget.textInputAction,
              onSubmitted: widget.onSubmitted,
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.charcoal,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.grey.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? AnimatedScale(
                        scale: _isFocused ? 1.1 : 1.0,
                        duration: AppDesign.fast,
                        child: Icon(
                          widget.prefixIcon,
                          color: _isFocused ? AppColors.primary : AppColors.primaryDark.withValues(alpha: 0.6),
                          size: 22,
                        ),
                      )
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: _isFocused ? AppColors.primary : AppColors.primaryDark.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.space20,
                  vertical: AppDesign.space20,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
