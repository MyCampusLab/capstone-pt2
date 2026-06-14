import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

/// ScanTargetOverlay: Overlap bidik wajah interaktif bertema Neobrutalisme Komik Retro.
class ScanTargetOverlay extends StatefulWidget {
  final double distance;
  const ScanTargetOverlay({super.key, required this.distance});

  @override
  State<ScanTargetOverlay> createState() => _ScanTargetOverlayState();
}

class _ScanTargetOverlayState extends State<ScanTargetOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double dist = widget.distance;
    final bool isDetected = dist > 0;
    
    // Warna adaptif status kalibrasi
    final Color statusColor = dist >= 30 
        ? Colors.green.shade600 
        : (isDetected ? Colors.orange : AppColors.danger);

    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Retro Corner Brackets (Neobrutalism Style dengan Offset Shadow)
            _buildCorner(top: 0, left: 0, rotateQuadrant: 0, color: statusColor),
            _buildCorner(top: 0, right: 0, rotateQuadrant: 1, color: statusColor),
            _buildCorner(bottom: 0, right: 0, rotateQuadrant: 2, color: statusColor),
            _buildCorner(bottom: 0, left: 0, rotateQuadrant: 3, color: statusColor),
            
            // Bar Pemindai Bergerak (Continuous Animated Scan Bar)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  top: 15 + (_controller.value * 216),
                  left: 15,
                  right: 15,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryDark, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withAlpha(100),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required int rotateQuadrant,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: RotatedBox(
        quarterTurns: rotateQuadrant,
        child: SizedBox(
          width: 36,
          height: 32,
          child: CustomPaint(
            painter: _CornerPainter(color: color),
          ),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final paintShadow = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final path = Path()
      ..moveTo(size.width, 3)
      ..lineTo(3, 3)
      ..lineTo(3, size.height);

    // Bayangan Datar Neobrutalisme
    canvas.drawPath(path.shift(const Offset(3.5, 3.5)), paintShadow);
    // Batas Foreground Utama
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
