import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import '../controllers/calibration_controller.dart';
import 'widgets/scan_target_overlay.dart';

/// View Kalibrasi Wajah Versi Pro dengan Live Camera Feed.
class CalibrationView extends GetView<CalibrationController> {
  const CalibrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Background Camera Preview (Pondasi AI)
          _buildCameraPreview(),
          
          // 2. UI Overlay (Glassmorphism & Gradient)
          _buildUiOverlay(),
          
          // 2b. Retro Scanning Bounding Box Frame (Interactive Visual Target)
          Obx(() => ScanTargetOverlay(distance: controller.currentDistance.value)),
          
          // 3. Distance Meter & Info
          _buildDistanceMeter(),
          
          // 4. Action Controls
          _buildControls(),

          // 5. Back Button
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryDark),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.primaryDark, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return GetBuilder<CalibrationController>(
      builder: (controller) {
        if (controller.cameraController == null || !controller.cameraController!.value.isInitialized) {
          return Container(color: AppColors.background);
        }
        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.cameraController!.value.previewSize!.height,
              height: controller.cameraController!.value.previewSize!.width,
              child: CameraPreview(controller.cameraController!),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUiOverlay() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.background.withAlpha(120),
            AppColors.background,
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceMeter() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            final double distance = controller.currentDistance.value;
            final bool isDetected = distance > 0;
            return Column(
              children: [
                // Vizo Mascot Reaktif
                VizoMascot(
                  size: 180,
                  state: distance < 30 ? VizoState.worried : VizoState.idle,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: distance >= 30 
                          ? AppColors.primaryDark 
                          : (isDetected ? Colors.orange : AppColors.danger), 
                      width: 4
                    ),
                    boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(6, 6))],
                  ),
                  child: Text(
                    isDetected ? "${distance.toInt()} CM" : "MENCARI WAJAH...",
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primaryDark, 
                      fontSize: 36
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  distance >= 30 
                    ? "JARAK SUDAH IDEAL!" 
                    : (isDetected ? "TERLALU DEKAT! MUNDUR SEDIKIT" : "POSISIKAN WAJAH DI DEPAN KAMERA"),
                  style: AppTextStyles.bodyBold.copyWith(
                    color: distance >= 30 ? Colors.green.shade700 : AppColors.primaryDark,
                    fontSize: 12,
                    letterSpacing: 1.2
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 60,
      left: 40,
      right: 40,
      child: Column(
        children: [
          Obx(() {
            final bool isTooClose = controller.currentDistance.value < 30;
            return VButton(
              label: "KUNCI JARAK AMAN",
              icon: Icons.lock_outline_rounded,
              isLoading: controller.isSaving.value,
              onPressed: isTooClose ? null : () => controller.saveCalibration(),
            );
          }),
          const SizedBox(height: 20),
          Text(
            "Minimal jarak aman adalah 30 CM.",
            style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark.withAlpha(180)),
          ),
        ],
      ),
    );
  }
}
