import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

/// VImmersiveBackground: AAA Quality Layered Animated Background.
/// Features smooth breathing gradients, floating organic orbs, and subtle light movements.
class VImmersiveBackground extends StatefulWidget {
  final Widget child;
  final bool animated;

  const VImmersiveBackground({
    super.key,
    required this.child,
    this.animated = true,
  });

  @override
  State<VImmersiveBackground> createState() => _VImmersiveBackgroundState();
}

class _VImmersiveBackgroundState extends State<VImmersiveBackground> with TickerProviderStateMixin {
  late AnimationController _mainController;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Base Gradient
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFE0EAFC),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
            ),
          ),
        ),

        // Layer 2: Animated Floating Orbs
        if (widget.animated) ...[
          _buildFloatingOrb(
            color: AppColors.primary.withValues(alpha: 0.15),
            size: 300,
            initialOffset: const Offset(-50, -50),
            speed: 1.0,
          ),
          _buildFloatingOrb(
            color: AppColors.secondary.withValues(alpha: 0.12),
            size: 400,
            initialOffset: const Offset(150, 400),
            speed: 0.8,
          ),
          _buildFloatingOrb(
            color: Colors.white.withValues(alpha: 0.4),
            size: 250,
            initialOffset: const Offset(200, -100),
            speed: 1.2,
          ),
        ],

        // Layer 3: Glass Overlay
        Positioned.fill(
          child: Container(
            color: Colors.white.withValues(alpha: 0.02),
          ),
        ),

        // Content
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: widget.child,
        ),
      ],
    );
  }

  Widget _buildFloatingOrb({
    required Color color,
    required double size,
    required Offset initialOffset,
    required double speed,
  }) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        final double t = _mainController.value * 2 * math.pi * speed;
        final double dx = 40 * math.sin(t);
        final double dy = 40 * math.cos(t);

        return Positioned(
          left: initialOffset.dx + dx,
          top: initialOffset.dy + dy,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
          ),
        );
      },
    );
  }
}
