import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/modules/home/controllers/home_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

/// LiveVizoRadar: Organism interaktif untuk memantau status jarak mata secara real-time.
/// Dilengkapi dengan Eye-Tracking (Mata mengikuti sentuhan).
class LiveVizoRadar extends StatefulWidget {
  const LiveVizoRadar({super.key});

  @override
  State<LiveVizoRadar> createState() => _LiveVizoRadarState();
}

class _LiveVizoRadarState extends State<LiveVizoRadar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final controller = Get.find<HomeController>();
  
  bool _isSurprised = false;
  Offset _lookAtOffset = Offset.zero;

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

  void _handleTap() {
    if (_isSurprised) return;
    
    HapticFeedback.heavyImpact();
    setState(() => _isSurprised = true);
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _isSurprised = false);
    });
  }

  void _handleHover(PointerEvent event) {
    // Hitung offset relatif terhadap pusat radar
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final center = renderBox.size.center(Offset.zero);
    final localPosition = renderBox.globalToLocal(event.position);
    
    setState(() {
      _lookAtOffset = Offset(
        (localPosition.dx - center.dx) / 10,
        (localPosition.dy - center.dy) / 10,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _handleHover,
      child: Listener(
        onPointerMove: _handleHover,
        child: Obx(() {
          final distance = controller.telemetryService.currentDistance.value;
          final isViolation = controller.telemetryService.isViolation.value;
          
          return AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              double scale = 1.0 + (_pulseController.value * 0.05);
              if (isViolation) scale = 1.0 + (_pulseController.value * 0.15);
              
              double floatY = 10 * _pulseController.value;

              return Transform.translate(
                offset: Offset(0, floatY),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    height: 260,
                    width: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                      border: Border.all(
                        color: isViolation ? AppColors.danger : AppColors.primary, 
                        width: 8
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isViolation ? AppColors.danger : AppColors.primary).withAlpha(100),
                          blurRadius: 20,
                          spreadRadius: 5 * _pulseController.value,
                        ),
                        const BoxShadow(color: AppColors.primaryDark, offset: Offset(8, 8)),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildMascot(isViolation),
                        Positioned(
                          bottom: 24,
                          child: _buildDistanceIndicator(distance, isViolation),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildDistanceIndicator(double distance, bool isViolation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isViolation ? AppColors.danger : AppColors.success,
        borderRadius: BorderRadius.circular(AppDesign.radiusM),
        border: Border.all(color: AppColors.primaryDark, width: 4),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4))],
      ),
      child: Text(
        distance > 0 ? "${distance.toInt()} CM" : "SCANNING...",
        style: AppTextStyles.bodyBold.copyWith(
          color: isViolation ? Colors.white : AppColors.primaryDark, 
          fontSize: 22, 
          letterSpacing: 1.5
        ),
      ),
    );
  }

  Widget _buildMascot(bool isViolation) {
    return Obx(() {
      VizoState mascotState = controller.dynamicMascotState;

      // Animasi kejutan tetap diutamakan untuk interaksi tap
      if (_isSurprised) {
        mascotState = VizoState.surprised;
      }

      return VizoMascot(
        size: 150,
        state: mascotState,
        onTap: _handleTap,
        lookAt: _lookAtOffset,
      );
    });
  }
}
