import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

/// Flying XP item holding rendering coordinates and uniqueness.
class _FlyingXpItem {
  final int id;
  final String text;
  final Offset offset;

  _FlyingXpItem({
    required this.id,
    required this.text,
    required this.offset,
  });
}

/// Floating animative XP indicator that rises, scales with bounce, and fades.
class _FlyingXpWidget extends StatefulWidget {
  final String text;
  final Offset startOffset;
  final VoidCallback onComplete;

  const _FlyingXpWidget({
    required this.text,
    required this.startOffset,
    required this.onComplete,
    super.key,
  });

  @override
  State<_FlyingXpWidget> createState() => _FlyingXpWidgetState();
}

class _FlyingXpWidgetState extends State<_FlyingXpWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _opacity;
  late Animation<double> _translateY;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    _translateY = Tween<double>(begin: 0.0, end: -95.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    _scale = Tween<double>(begin: 0.5, end: 1.25).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.elasticOut,
      ),
    );

    _animController.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        // Center the pop-up above Vizo's head dynamically
        return Positioned(
          top: 35 + widget.startOffset.dy + _translateY.value,
          left: 80 + widget.startOffset.dx,
          child: Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryDark, width: 2.5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.primaryDark,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          widget.text,
          style: AppTextStyles.bodyBold.copyWith(
            color: AppColors.primaryDark,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

/// LiveVizoRadar: Premium interactive assistant with dynamic status visual feedback.
class LiveVizoRadar extends StatefulWidget {
  const LiveVizoRadar({super.key});

  @override
  State<LiveVizoRadar> createState() => _LiveVizoRadarState();
}

class _LiveVizoRadarState extends State<LiveVizoRadar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final controller = Get.find<HomeController>();
  
  // Interactive gamified states
  VizoState? _interactiveState;
  final List<_FlyingXpItem> _xpItems = [];
  int _itemCounter = 0;

  void _handleTap() {
    HapticFeedback.heavyImpact();
    
    // Switch to a random energetic/happy state
    final randomStates = [VizoState.happy, VizoState.surprised, VizoState.focused, VizoState.exercise];
    final selectedState = (randomStates..shuffle()).first;
    
    setState(() {
      _interactiveState = selectedState;
    });

    // Generate floating text "+5 XP!" pop-up above mascot
    final randomDx = (DateTime.now().millisecond % 50) - 25.0; // Random offset between -25 and +25
    final randomDy = (DateTime.now().millisecond % 20) - 10.0; // Random offset between -10 and +10
    final itemId = _itemCounter++;
    
    setState(() {
      _xpItems.add(_FlyingXpItem(
        id: itemId,
        text: "+5 XP!",
        offset: Offset(randomDx, randomDy),
      ));
    });

    // Add XP instantly in reward service (Throttled/Capped in RewardService if implemented)
    // FIX: Hapus penambahan XP tak terbatas dari sisi UI untuk mencegah spam tapping.
    // Animasi visual tetap berjalan untuk interaksi, tapi XP tidak bertambah sembarangan.
    // Get.find<RewardService>().addXp(5);

    // Reset mascot state back to normal after a short delay (1.5 seconds)
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && _interactiveState == selectedState) {
        setState(() => _interactiveState = null);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final distance = controller.telemetryService.currentDistance.value;
      final isViolation = controller.telemetryService.isViolation.value;
      final accentColor = isViolation ? AppColors.danger : AppColors.primary;
      
      return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          // AAA Dynamics: Combined Pulse, Scale, and Float Y
          final double pulseValue = _pulseController.value;
          double scale = 1.0 + (pulseValue * 0.04);
          if (isViolation) scale = 1.0 + (pulseValue * 0.12); // Urgent alert scale
          
          final double floatY = -8 * pulseValue;

          return Transform.translate(
            offset: Offset(0, floatY),
            child: Transform.scale(
              scale: scale,
              child: Container(
                height: 240,
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                  border: Border.all(
                    color: accentColor, 
                    width: isViolation ? 8 : 6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.15 + (pulseValue * 0.1)),
                      blurRadius: 32,
                      spreadRadius: 8 * pulseValue,
                    ),
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.8),
                      offset: const Offset(8, 8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Subtle Background Glow
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                    
                    _buildMascot(isViolation),
                    
                    // High-End Status Badge
                    Positioned(
                      bottom: 20,
                      child: _buildStatusBadge(distance, isViolation),
                    ),

                    // Floating XP dynamic widgets
                    ..._xpItems.map((item) => _FlyingXpWidget(
                      key: ValueKey(item.id),
                      text: item.text,
                      startOffset: item.offset,
                      onComplete: () {
                        if (mounted) {
                          setState(() {
                            _xpItems.removeWhere((x) => x.id == item.id);
                          });
                        }
                      },
                    )),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildStatusBadge(double distance, bool isViolation) {
    return AnimatedContainer(
      duration: AppDesign.medium,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isViolation ? AppColors.danger : AppColors.success,
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(3, 3))],
      ),
      child: Text(
        distance > 0 ? "${distance.toInt()} CM" : "SCANNING...",
        style: AppTextStyles.bodyBold.copyWith(
          color: isViolation ? Colors.white : AppColors.primaryDark, 
          fontSize: 20, 
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildMascot(bool isViolation) {
    final bool isSquinting = controller.telemetryService.isSquinting.value;
    final bool isUserBlinking = controller.telemetryService.isBlinking.value;
    
    VizoState mascotState = isViolation ? VizoState.worried : VizoState.idle;
    if (isSquinting && !isViolation) {
      mascotState = VizoState.tired;
    }
    
    if (_interactiveState != null) {
      mascotState = _interactiveState!;
    }

    final String movement = controller.telemetryService.eyeMovement.value;
    Offset lookOffset = Offset.zero;
    if (movement == 'left') {
      lookOffset = const Offset(-1.0, 0.0);
    } else if (movement == 'right') {
      lookOffset = const Offset(1.0, 0.0);
    } else if (movement == 'up') {
      lookOffset = const Offset(0.0, -1.0);
    } else if (movement == 'down') {
      lookOffset = const Offset(0.0, 1.0);
    }

    return VizoMascot(
      size: 140,
      state: mascotState,
      onTap: _handleTap,
      lookAt: lookOffset,
      isBlinking: isUserBlinking,
    );
  }
}
