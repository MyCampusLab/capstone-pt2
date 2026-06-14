import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'vizo_mascot.dart';

class VizoNewsMascot extends StatelessWidget {
  final double size;
  final VizoState state;

  const VizoNewsMascot({
    super.key, 
    this.size = 180, 
    this.state = VizoState.idle,
  });

  String _getLottieUrl() {
    switch (state) {
      case VizoState.sleeping:
      case VizoState.tired:
        return 'https://assets5.lottiefiles.com/packages/lf20_yMpiqCG50n.json'; // Sleeping/Empty robot
      case VizoState.happy:
      case VizoState.focused:
      case VizoState.exercise:
        return 'https://assets8.lottiefiles.com/packages/lf20_M9p23l.json'; // Happy/Active robot
      case VizoState.worried:
      case VizoState.sad:
      case VizoState.intervention:
        return 'https://assets2.lottiefiles.com/packages/lf20_U1vE1A.json'; // Alert/Warning robot
      default:
        return 'https://assets3.lottiefiles.com/packages/lf20_UJNc2t.json'; // Idle robot
    }
  }

  IconData _getFallbackIcon() {
    switch (state) {
      case VizoState.sleeping:
      case VizoState.tired: return Icons.nightlight_round;
      case VizoState.happy: return Icons.sentiment_very_satisfied_rounded;
      case VizoState.worried:
      case VizoState.sad: return Icons.sentiment_dissatisfied_rounded;
      case VizoState.intervention: return Icons.warning_rounded;
      case VizoState.exercise: return Icons.fitness_center_rounded;
      case VizoState.focused: return Icons.center_focus_strong_rounded;
      default: return Icons.smart_toy_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.network(
        _getLottieUrl(),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildPremiumFallback();
        },
        frameBuilder: (context, child, composition) {
          if (composition == null) return _buildPremiumFallback();
          return child;
        },
      ),
    );
  }

  Widget _buildPremiumFallback() {
    final color = VizoMascot.getStateColor(state);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: size * 0.2,
            spreadRadius: size * 0.05,
          )
        ],
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          _getFallbackIcon(),
          color: color,
          size: size * 0.5,
          shadows: [
            Shadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 10,
            )
          ],
        ),
      ),
    );
  }
}
