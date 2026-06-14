import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

/// EyeTrackerCanvas: Widget interaktif pemandu senam mata dinamis (HCI & Gamifikasi).
class EyeTrackerCanvas extends StatefulWidget {
  final String actionType;
  const EyeTrackerCanvas({super.key, required this.actionType});

  @override
  State<EyeTrackerCanvas> createState() => _EyeTrackerCanvasState();
}

class _EyeTrackerCanvasState extends State<EyeTrackerCanvas> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark, width: 2.2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryDark,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: TrackerPainter(
              progress: _controller.value,
              actionType: widget.actionType,
            ),
          );
        },
      ),
    );
  }
}

class TrackerPainter extends CustomPainter {
  final double progress;
  final String actionType;

  TrackerPainter({required this.progress, required this.actionType});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = AppColors.primaryDark.withAlpha(35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final paintBall = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final paintBallBorder = Paint()
      ..color = AppColors.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    double x = size.width / 2;
    double y = size.height / 2;
    const double radius = 12.0;

    if (actionType == 'SIDE_TO_SIDE') {
      // Jalur Horizontal
      final double startX = 40.0;
      final double endX = size.width - 40.0;
      canvas.drawLine(Offset(startX, y), Offset(endX, y), paintLine);

      // Interpolasi bolak-balik menggunakan gelombang kosinus
      final double factor = (math.cos(progress * 2 * math.pi) + 1) / 2;
      x = startX + factor * (endX - startX);
    } else if (actionType == 'ROTATE') {
      // Jalur Lingkaran
      final double radiusOrbit = size.height / 2.8;
      canvas.drawCircle(Offset(x, y), radiusOrbit, paintLine);

      // Koordinat Orbit Melingkar
      final double angle = progress * 2 * math.pi;
      x = size.width / 2 + math.cos(angle) * radiusOrbit;
      y = size.height / 2 + math.sin(angle) * radiusOrbit;
    } else if (actionType == 'FOCUS_FAR') {
      // Jalur Kedalaman (Garis Perspektif Menyilang)
      canvas.drawLine(Offset(50, size.height - 30), Offset(size.width - 50, 30), paintLine);
      canvas.drawLine(Offset(50, 30), Offset(size.width - 50, size.height - 30), paintLine);

      // Bola membesar mengecil seirama gelombang kosinus
      final double scaleFactor = (math.cos(progress * 2 * math.pi) + 1) / 2;
      final double dynamicRadius = 4.0 + scaleFactor * 16.0;
      
      canvas.drawCircle(Offset(x, y), dynamicRadius, paintBall);
      canvas.drawCircle(Offset(x, y), dynamicRadius, paintBallBorder);
      return;
    } else {
      // BLINK Mode: Efek Pulse Gelombang di Tengah
      final double pulse = radius + (math.sin(progress * 2 * math.pi) * 4);
      canvas.drawCircle(Offset(x, y), pulse, paintBall);
      canvas.drawCircle(Offset(x, y), pulse, paintBallBorder);
      return;
    }

    // Gambar Bola Utama & Garis Batasnya
    canvas.drawCircle(Offset(x, y), radius, paintBall);
    canvas.drawCircle(Offset(x, y), radius, paintBallBorder);
  }

  @override
  bool shouldRepaint(covariant TrackerPainter oldDelegate) => true;
}
