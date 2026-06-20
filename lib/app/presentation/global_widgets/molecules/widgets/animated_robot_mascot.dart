import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class AnimatedRobotMascot extends StatefulWidget {
  final double size;
  final VizoState state;
  final Offset lookAt;
  final bool isBlinking;

  const AnimatedRobotMascot({
    super.key,
    required this.size,
    required this.state,
    required this.lookAt,
    this.isBlinking = false,
  });

  @override
  State<AnimatedRobotMascot> createState() => _AnimatedRobotMascotState();
}

class _AnimatedRobotMascotState extends State<AnimatedRobotMascot> with TickerProviderStateMixin {
  late AnimationController _floatController;
  bool _isNaturalBlinking = false;
  Timer? _naturalBlinkTimer;
  Timer? _blinkDurationTimer;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _startNaturalBlinking();
  }

  void _startNaturalBlinking() {
    _naturalBlinkTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() => _isNaturalBlinking = true);
        _blinkDurationTimer?.cancel();
        _blinkDurationTimer = Timer(const Duration(milliseconds: 160), () {
          if (mounted) {
            setState(() => _isNaturalBlinking = false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _naturalBlinkTimer?.cancel();
    _blinkDurationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = VizoMascot.getStateColor(widget.state);

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final double floatY = -12 * _floatController.value;

        return Transform.translate(
          offset: Offset(0, floatY),
          child: _buildRobotFace(baseColor),
        );
      },
    );
  }

  Widget _buildRobotFace(Color color) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.85,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Robotic Cat Ears
          Positioned(top: -widget.size * 0.18, left: widget.size * 0.08, child: _buildRoboticCatEar(color, isLeft: true)),
          Positioned(top: -widget.size * 0.18, right: widget.size * 0.08, child: _buildRoboticCatEar(color, isLeft: false)),
        
        // Main Head
        Container(
          width: widget.size,
          height: widget.size * 0.85,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withAlpha(200)],
            ),
            borderRadius: BorderRadius.circular(48), 
            border: Border.all(color: const Color(0xFF1A1A1A), width: 5),
            boxShadow: const [
              BoxShadow(color: Color(0xFF1A1A1A), offset: Offset(10, 10)),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Detail Panel Line
              Positioned(
                top: 15,
                child: Container(
                  width: widget.size * 0.4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(100),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Screen (Face Display Panel)
              Positioned(
                top: widget.size * 0.15,
                child: Container(
                  width: widget.size * 0.75,
                  height: widget.size * 0.45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF1A1A1A), width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withAlpha(50),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildEyes(),
                      _buildCatSnoutMouth(),
                    ],
                  ),
                ),
              ),
              
              // Whiskers
              Positioned(left: widget.size * 0.02, top: widget.size * 0.35, child: _buildWhiskers(isLeft: true)),
              Positioned(right: widget.size * 0.02, top: widget.size * 0.35, child: _buildWhiskers(isLeft: false)),
              
              // Screws / Power Core Indicators
              Positioned(
                bottom: widget.size * 0.08,
                child: Row(
                  children: [
                    _buildTechScrew(color),
                    SizedBox(width: widget.size * 0.3),
                    _buildTechScrew(color),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildRoboticCatEar(Color color, {required bool isLeft}) {
    return Transform.rotate(
      angle: isLeft ? -0.1 : 0.1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: widget.size * 0.3,
            height: widget.size * 0.35,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              border: Border.all(color: const Color(0xFF1A1A1A), width: 5),
            ),
          ),
          Positioned(
            top: 8,
            child: Container(
              width: widget.size * 0.12,
              height: widget.size * 0.18,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A).withAlpha(120),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Container(
                  width: 4,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(150),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiskers({required bool isLeft}) {
    return Column(
      children: [
        _buildSingleWhisker(angle: isLeft ? -0.2 : 0.2),
        const SizedBox(height: 5),
        _buildSingleWhisker(angle: 0),
        const SizedBox(height: 5),
        _buildSingleWhisker(angle: isLeft ? 0.2 : -0.2),
      ],
    );
  }

  Widget _buildSingleWhisker({required double angle}) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: widget.size * 0.15,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildEyes() {
    bool isSleeping = widget.state == VizoState.sleeping || widget.state == VizoState.tired || widget.isBlinking || _isNaturalBlinking;
    bool isWorried = widget.state == VizoState.worried || widget.state == VizoState.intervention || widget.state == VizoState.sad;
    bool isSurprised = widget.state == VizoState.surprised;
    bool isHappy = widget.state == VizoState.happy;

    return Positioned(
      top: widget.size * 0.1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSingleEye(isClosed: isSleeping, isWorried: isWorried, isSurprised: isSurprised, isHappy: isHappy),
          SizedBox(width: widget.size * 0.15),
          _buildSingleEye(isClosed: isSleeping, isWorried: isWorried, isSurprised: isSurprised, isHappy: isHappy),
        ],
      ),
    );
  }

  Widget _buildSingleEye({required bool isClosed, required bool isWorried, bool isSurprised = false, bool isHappy = false}) {
    if (isWorried) {
      return Container(
        width: widget.size * 0.12,
        height: widget.size * 0.12,
        decoration: const BoxDecoration(color: Color(0xFF1A1A1A), shape: BoxShape.circle),
        child: Icon(Icons.close_rounded, color: Colors.white, size: widget.size * 0.08),
      );
    }
    if (isHappy) {
      return Icon(Icons.favorite_rounded, color: const Color(0xFF1A1A1A), size: widget.size * 0.15);
    }
    
    final double eyeWidth = isSurprised ? widget.size * 0.16 : widget.size * 0.12;
    final double eyeHeight = isClosed ? widget.size * 0.03 : (isSurprised ? widget.size * 0.16 : widget.size * 0.12);
    
    if (isClosed) {
      return Container(
        width: eyeWidth,
        height: eyeHeight,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }

    // Kalkulasi pergeseran pupil dinamis dengan transisi interpolasi halus
    final double pupilMaxShiftX = eyeWidth * 0.22;
    final double pupilMaxShiftY = eyeHeight * 0.22;

    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: Offset.zero, end: widget.lookAt),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      builder: (context, animatedLookAt, child) {
        final double dx = animatedLookAt.dx.clamp(-1.0, 1.0) * pupilMaxShiftX;
        final double dy = animatedLookAt.dy.clamp(-1.0, 1.0) * pupilMaxShiftY;

        return Container(
          width: eyeWidth,
          height: eyeHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            shape: isSurprised ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isSurprised ? null : BorderRadius.circular(widget.size * 0.06),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pupil Bercahaya (Glow Pupil)
              Transform.translate(
                offset: Offset(dx, dy),
                child: Container(
                  width: eyeWidth * 0.5,
                  height: eyeHeight * 0.5,
                  decoration: BoxDecoration(
                    color: VizoMascot.getStateColor(widget.state),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: VizoMascot.getStateColor(widget.state).withAlpha(150),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
              ),
              // Kilatan Cahaya Mata (Reflection/Glint)
              Transform.translate(
                offset: Offset(dx - eyeWidth * 0.1, dy - eyeHeight * 0.1),
                child: Container(
                  width: eyeWidth * 0.15,
                  height: eyeHeight * 0.15,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCatSnoutMouth() {
    IconData mouthIcon = Icons.keyboard_arrow_up_rounded; 
    bool flip = true;
    
    if (widget.state == VizoState.worried || widget.state == VizoState.intervention || widget.state == VizoState.sad) {
      mouthIcon = Icons.keyboard_arrow_down_rounded;
      flip = false;
    } else if (widget.state == VizoState.sleeping || widget.state == VizoState.tired) {
      mouthIcon = Icons.horizontal_rule_rounded;
      flip = false;
    } else if (widget.state == VizoState.surprised) {
      mouthIcon = Icons.circle;
      flip = false;
    } else if (widget.state == VizoState.happy) {
      mouthIcon = Icons.keyboard_double_arrow_up_rounded;
      flip = false;
    }

    return Positioned(
      bottom: widget.size * 0.08,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.rotate(
            angle: flip ? 3.14159 : 0, 
            child: Icon(
              mouthIcon, 
              color: const Color(0xFF1A1A1A), 
              size: widget.state == VizoState.surprised ? widget.size * 0.08 : widget.size * 0.12
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechScrew(Color color) {
    return Container(
      width: widget.size * 0.1,
      height: widget.size * 0.1,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(100), width: 1),
      ),
      child: Center(
        child: Container(
          width: widget.size * 0.04,
          height: widget.size * 0.04,
          decoration: BoxDecoration(
            color: color.withAlpha(200),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color, blurRadius: 4, spreadRadius: 1),
            ],
          ),
        ),
      ),
    );
  }
}
