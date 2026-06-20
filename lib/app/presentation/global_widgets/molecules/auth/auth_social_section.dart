import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

/// Seksi tombol media sosial (Google, Apple, Facebook) dengan animasi tactile press premium.
class AuthSocialSection extends StatefulWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback? onAppleTap;
  final VoidCallback? onFacebookTap;

  const AuthSocialSection({
    super.key,
    required this.onGoogleTap,
    this.onAppleTap,
    this.onFacebookTap,
  });

  @override
  State<AuthSocialSection> createState() => _AuthSocialSectionState();
}

class _AuthSocialSectionState extends State<AuthSocialSection> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    HapticFeedback.lightImpact();
    widget.onGoogleTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(
              _isPressed ? 3.0 : 0.0,
              _isPressed ? 3.0 : 0.0,
              0.0,
            ),
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryDark, width: 3),
              boxShadow: _isPressed
                  ? []
                  : const [
                      BoxShadow(
                        color: AppColors.primaryDark,
                        offset: Offset(4, 4),
                      ),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata_rounded, size: 28, color: AppColors.primaryDark),
                ),
                const SizedBox(width: 12),
                Text(
                  "Sign in with Google",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
