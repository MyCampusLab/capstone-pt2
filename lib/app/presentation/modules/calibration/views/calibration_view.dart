import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calibration_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class CalibrationView extends GetView<CalibrationController> {
  const CalibrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark mode enterprise
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Header
              const Text(
                "ADAPTASI SENSOR",
                style: TextStyle(
                  color: Color(0xFF00D2FF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Kalibrasi Jarak Mata",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Pegang HP Anda sejauh rentangan tangan (±40cm) agar sistem bisa mempelajari karakteristik wajah Anda.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Animasi Kalibrasi
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF00D2FF).withValues(alpha: 0.3), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D2FF).withValues(alpha: 0.1),
                        blurRadius: 50,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Lottie Animation Scan (fallback ke icon jika lottie tidak ada)
                      const Icon(Icons.face_retouching_natural, size: 120, color: Color(0xFF00D2FF)),
                      
                      // Progress Indicator melingkar
                      Obx(() => controller.isCalibrating.value 
                        ? SizedBox(
                            width: 250,
                            height: 250,
                            child: CircularProgressIndicator(
                              value: controller.progress.value,
                              strokeWidth: 8,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00D2FF)),
                            ),
                          )
                        : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Status Real-time
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    const Text(
                      "STATUS SENSOR",
                      style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.currentRawDistance.value > 0 
                        ? "Wajah Terdeteksi" 
                        : "Wajah Belum Terlihat",
                      style: TextStyle(
                        color: controller.currentRawDistance.value > 0 ? const Color(0xFF00FF87) : const Color(0xFFFF6B6B),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
              
              const Spacer(),
              
              // Action Buttons
              Obx(() => controller.isCalibrating.value
                  ? const Center(
                      child: Text(
                        "Menganalisis wajah...",
                        style: TextStyle(color: Color(0xFF00D2FF), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        VButton(
                          onPressed: controller.startCalibration,
                          label: "MULAI KALIBRASI",
                          color: const Color(0xFF00D2FF),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: controller.cancelCalibration,
                          child: const Text(
                            "BATAL",
                            style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
