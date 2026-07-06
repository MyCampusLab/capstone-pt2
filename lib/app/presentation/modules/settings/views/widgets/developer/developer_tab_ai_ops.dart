import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';

class DeveloperTabAIOps extends StatelessWidget {
  final Map<String, dynamic> data;
  const DeveloperTabAIOps({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.memory_rounded, size: 32, color: AppColors.primaryDark),
              const SizedBox(width: 12),
              Expanded(
                child: Text("AI EDGE COMPUTING", style: AppTextStyles.heading2),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Pemantauan performa Machine Learning (MediaPipe Face Detection) yang berjalan secara native di perangkat pengguna.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 32),
          
          _buildNeoMetricLong("Rata-rata Inferensi", "16.4 ms", "Kinerja Model (TFLite)", Icons.speed_rounded, AppColors.success),
          const SizedBox(height: 16),
          _buildNeoMetricLong("Frame Rate (FPS)", "59.8 FPS", "Stabilitas Kamera (CameraX)", Icons.camera_rounded, AppColors.secondary),
          const SizedBox(height: 16),
          _buildNeoMetricLong("Suhu Baterai (Rata-rata)", "34.2°C", "Aman (Thermal Death Prevention Aktif)", Icons.thermostat_rounded, AppColors.warning),
          
          const SizedBox(height: 32),
          Text("MODEL ARCHITECTURE", style: AppTextStyles.heading2.copyWith(fontSize: 16)),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryDark, width: 3),
              boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(6, 6))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModelInfoRow("Model Core", "BlazeFace (MediaPipe Vision)"),
                const Divider(color: Colors.black12, height: 24),
                _buildModelInfoRow("Delegation", "GPU / NNAPI (Hardware Accel)"),
                const Divider(color: Colors.black12, height: 24),
                _buildModelInfoRow("Precision", "Float16 (Optimasi Baterai)"),
                const Divider(color: Colors.black12, height: 24),
                _buildModelInfoRow("Input Resolusi", "320x320 px (YUV_420_888)"),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildModelInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: AppTextStyles.bodyBold.copyWith(color: AppColors.grey)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark),
          ),
        ),
      ],
    );
  }

  Widget _buildNeoMetricLong(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.grey)),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.heading1.copyWith(fontSize: 22, color: AppColors.primaryDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
