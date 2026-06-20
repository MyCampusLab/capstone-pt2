import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class HomeDialogHelper {
  static Future<bool> showPermissionExplanation({
    required String title,
    required String explanation,
    required String benefit,
    required IconData icon,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            Icon(icon, color: AppColors.warning, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryDark)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Untuk Apa Izin Ini?", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 4),
            Text(explanation, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            const Text("Apa Keuntungannya?", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 4),
            Text(benefit, style: const TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Tolak", style: TextStyle(color: Colors.grey)),
          ),
          VButton(
            onPressed: () => Get.back(result: true),
            label: "Mengerti & Izinkan",
            color: AppColors.primaryDark,
          ),
        ],
      ),
    );
    return result ?? false;
  }
  static Future<bool> showAccessibilityTutorial() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.background,
        title: const Row(
          children: [
            Icon(Icons.touch_app_rounded, color: AppColors.primary, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text("Cara Mengaktifkan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryDark)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ikuti 3 langkah mudah ini:", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 12),
            _buildTutorialStep("1", "Pilih 'Aplikasi yang Diunduh' (Downloaded Apps) atau 'Layanan Terinstal'."),
            const SizedBox(height: 8),
            _buildTutorialStep("2", "Cari dan pilih 'VisionSafe' dari daftar."),
            const SizedBox(height: 8),
            _buildTutorialStep("3", "Nyalakan saklar (Toggle) untuk memberikan aksesibilitas."),
            const SizedBox(height: 16),
            const Text("Catatan: Android akan menampilkan peringatan privasi standar. Jangan khawatir, kami sama sekali tidak merekam layar Anda.", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          VButton(
            onPressed: () => Get.back(result: true),
            label: "Buka Pengaturan",
            color: AppColors.primaryDark,
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Widget _buildTutorialStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Text(number, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Padding(padding: const EdgeInsets.only(top: 4), child: Text(text, style: const TextStyle(fontSize: 14)))),
      ],
    );
  }

  static void showInterventionDialog({required VoidCallback onStartExercise}) {
    Get.defaultDialog(
      title: "Mata Kamu Lelah!",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      content: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Sistem mendeteksi kamu menggunakan HP terlalu dekat selama lebih dari 5 menit hari ini. Ayo lakukan Senam Mata sekarang untuk mencegah mata minus!",
          textAlign: TextAlign.center,
        ),
      ),
      barrierDismissible: false, // TIDAK BISA DITUTUP KECUALI KLIK TOMBOL
      confirm: VButton(
        onPressed: onStartExercise,
        icon: Icons.sports_gymnastics_rounded,
        label: "MULAI SENAM",
        color: Colors.red,
      ),
    );
  }

  static void showProminentDisclosure({required VoidCallback onAgree}) {
    VDialog.show(
      title: "KEBIJAKAN PRIVASI KAMERA & DATA WAJAH",
      icon: Icons.privacy_tip_rounded,
      iconColor: AppColors.primaryDark,
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "VisionSafe membutuhkan akses ke Kamera Depan untuk mendeteksi jarak mata Anda ke layar menggunakan teknologi pemindaian wajah (Face Tracking).",
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            "PENTING:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "• Pemrosesan gambar dilakukan 100% LOKAL di perangkat Anda.\n"
            "• TIDAK ADA foto, video, atau data biometrik wajah yang disimpan.\n"
            "• TIDAK ADA gambar yang dikirim ke server/cloud kami.\n"
            "• Kami hanya memproses data angka jarak (cm) untuk melindungi penglihatan Anda.",
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
      confirmLabel: "SAYA SETUJU",
      onConfirm: onAgree,
      cancelLabel: "TOLAK",
    );
  }

  static void showOverlayPermissionDialog({
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    VDialog.show(
      title: "Izin Tampil di Layar",
      icon: Icons.layers_rounded,
      iconColor: AppColors.primary,
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Untuk melindungimu, Vizo perlu memunculkan efek blur peringatan di atas aplikasi lain (seperti saat kamu main game atau nonton YouTube).",
            style: TextStyle(fontSize: 14, height: 1.4),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            "Mohon izinkan VisionSafe di menu pengaturan yang akan terbuka.",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      confirmLabel: "MENGERTI",
      onConfirm: onConfirm,
      cancelLabel: "NANTI",
    );
  }

  // Battery Optimization Dialog removed as requested.

  static void showPinDialog({
    required String title,
    required String message,
    required bool isSetup,
    String? correctPin,
    required Function(String) onConfirm,
  }) {
    final pinController = TextEditingController();
    Get.defaultDialog(
      title: title,
      titlePadding: const EdgeInsets.only(top: 24),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "****",
              counterText: "",
            ),
          ),
        ],
      ),
      confirm: VButton(
        onPressed: () => onConfirm(pinController.text),
        label: "Lanjut",
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Batal"),
      ),
    );
  }

  static void showPermissionError(String permissionName) {
    VDialog.show(
      title: "Izin Dibutuhkan",
      message: "VisionSafe butuh izin $permissionName agar bisa berfungsi melindungi mata Anda.",
      confirmLabel: "PENGATURAN",
      onConfirm: () {
        openAppSettings();
      },
      cancelLabel: "NANTI",
    );
  }
}
