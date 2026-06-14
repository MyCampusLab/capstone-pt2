import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'widgets/animated_robot_mascot.dart';

/// VizoMascot: "The Neobrutalism Robotic Cat Buddy"
/// High-end interactive mascot with dynamic emotional states and eye tracking.
enum VizoState { 
  idle, worried, intervention, sleeping, exercise, surprised,
  happy, sad, focused, tired 
}

class VizoMascot extends StatelessWidget {
  final double size;
  final VizoState state;
  final VoidCallback? onTap;
  final Offset lookAt;
  final bool isBlinking;

  const VizoMascot({
    super.key, 
    this.size = 180, 
    this.state = VizoState.idle,
    this.onTap,
    this.lookAt = Offset.zero,
    this.isBlinking = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedRobotMascot(
        size: size, 
        state: state, 
        lookAt: lookAt,
        isBlinking: isBlinking,
      ),
    );
  }

  static Color getStateColor(VizoState state) {
    switch (state) {
      case VizoState.worried: 
      case VizoState.sad: 
        return const Color(0xFFFFB067); // Warning Orange
      case VizoState.intervention: 
        return const Color(0xFFFF6B6B); // Danger Red
      case VizoState.exercise: 
      case VizoState.focused: 
        return const Color(0xFF00FF88); // Success Neon Green
      case VizoState.surprised: 
        return AppColors.secondary; // Tech Purple
      case VizoState.tired:
      case VizoState.sleeping: 
        return const Color(0xFF6C5CE7); // Deep Purple
      case VizoState.happy:
      default: 
        return const Color(0xFF00D2FF); // Cyber Cyan
    }
  }

  /// Memetakan string dari database ke enum VizoState.
  static VizoState fromMascotState(String? state) {
    switch (state?.toLowerCase()) {
      case 'happy': return VizoState.happy;
      case 'sad': return VizoState.sad;
      case 'focused': return VizoState.focused;
      case 'tired': return VizoState.tired;
      case 'worried': return VizoState.worried;
      case 'intervention': return VizoState.intervention;
      default: return VizoState.idle;
    }
  }
}
