import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'widgets/settings_tile.dart';
import 'widgets/settings_section.dart';
import 'dialogs/edit_profile_dialog.dart';
import 'dialogs/change_password_dialog.dart';
import 'dialogs/distance_setter_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_app_header.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'dialogs/about_app_dialog.dart';
import 'dialogs/how_to_use_dialog.dart';
import 'dialogs/feedback_dialog.dart';
import 'developer_dashboard_view.dart';
import 'package:visionsafe/app/presentation/modules/home/views/dialogs/discipline_mode_sheet.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';

/// View Pengaturan Utama (Elite Professional Version).
/// File length strictly < 200 lines.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  void _showAutoStartDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            const Icon(Icons.rocket_launch_rounded, color: AppColors.warning, size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text("Izin Mulai Otomatis", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryDark)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Untuk Apa Izin Ini?",
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 4),
            const Text(
              "Izin Mulai Otomatis (AutoStart) berfungsi agar aplikasi VisionSafe dapat menyala secara mandiri di latar belakang ketika HP baru saja dihidupkan ulang atau dibersihkan.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            const Text(
              "Apa Keuntungannya?",
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 4),
            const Text(
              "Mata anak Anda akan terus diawasi dan dilindungi 24/7 tanpa harus repot membuka aplikasi ini secara manual setiap saat. Anda jadi lebih tenang!",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            const Text(
              "Cara Menyalakannya:",
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 4),
            const Text(
              "1. Tekan tombol 'Buka Pengaturan'.\n2. Anda akan diarahkan ke layar pengaturan.\n3. Cari aplikasi 'VisionSafe'.\n4. Centang atau aktifkan tuas 'Mulai Otomatis' (AutoStart).",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.back();
              final provider = Get.find<VisionServiceProvider>();
              provider.requestAutoStartPermission();
            },
            child: const Text("Buka Pengaturan", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleDisciplineModeToggle(ConfigService config, [bool? val]) async {
    final newValue = val ?? !config.isDisciplineModeEnabled.value;
    if (newValue) {
      // Trying to enable
      final provider = Get.find<VisionServiceProvider>();
      final isAccessibilityEnabled = await provider.checkAccessibilityPermission();
      if (!isAccessibilityEnabled) {
         // Show DisciplineModeSheet
         DisciplineModeSheet.show(
           onProceed: () async {
             await provider.requestAccessibilityPermission();
           },
           onCancel: () {},
         );
      } else {
         config.toggleDisciplineMode(true);
         VToast.show("Mode Disiplin", "Berhasil Diaktifkan!", state: VizoState.happy);
      }
    } else {
      // Trying to disable
      config.toggleDisciplineMode(false);
      VToast.show("Mode Disiplin", "Telah Dinonaktifkan.", state: VizoState.sleeping);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = Get.find<ConfigService>();
    final auth = Get.find<AuthService>();

    return BaseScreenTemplate(
      appBar: const VAppHeader(title: 'PENGATURAN'),
      bottomPadding: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SettingsSection(title: "PROFIL & KEAMANAN"),
          Semantics(
            label: 'katalon_settings_edit_profile',
            button: true,
            child: Obx(() => SettingsTile(
              icon: Icons.person_outline_rounded,
              title: "Edit Profil",
              subtitle: auth.currentUser.value?.email ?? "User Hero",
              onTap: () => EditProfileDialog.show(auth),
              trailing: const Icon(Icons.chevron_right, color: AppColors.primaryDark),
            )),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            icon: Icons.lock_reset_rounded,
            title: "Ganti Password",
            subtitle: "Perbarui kunci keamanan akunmu.",
            onTap: () => ChangePasswordDialog.show(auth),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 24),

          const SettingsSection(title: "TARGET KESEHATAN"),
          Obx(() => SettingsTile(
            icon: Icons.straighten_rounded,
            title: "Batas Jarak Aman",
            subtitle: "Saat ini: ${config.threshold.value.toInt()} CM",
            onTap: () => DistanceSetterDialog.show(config),
            trailing: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
          )),
          const SizedBox(height: 24),
          
          const SettingsSection(title: "FITUR SOSIAL"),
          SettingsTile(
            icon: Icons.hub_rounded,
            title: "Family Squad",
            subtitle: "Buat grup atau pantau jarak mata keluargamu.",
            onTap: () => Get.toNamed(Routes.family),
            iconBgColor: AppColors.secondary.withAlpha(20),
            iconColor: AppColors.secondary,
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 24),
          
          const SettingsSection(title: "PERIZINAN SISTEM"),
          Obx(() => SettingsTile(
            icon: Icons.security_rounded,
            title: "Mode Disiplin",
            subtitle: config.isDisciplineModeEnabled.value ? "Aktif - Layar akan dikunci saat melanggar." : "Nonaktif - Hanya notifikasi peringatan ringan.",
            onTap: () => _handleDisciplineModeToggle(config),
            iconBgColor: config.isDisciplineModeEnabled.value ? Colors.green.withAlpha(30) : Colors.grey.withAlpha(20),
            iconColor: config.isDisciplineModeEnabled.value ? Colors.green : Colors.grey,
            trailing: Switch(
              value: config.isDisciplineModeEnabled.value,
              onChanged: (val) => _handleDisciplineModeToggle(config, val),
              activeTrackColor: AppColors.primaryDark,
            ),
          )),
          const SizedBox(height: 12),
          SettingsTile(
            icon: Icons.rocket_launch_rounded,
            title: "Mulai Otomatis (AutoStart)",
            subtitle: "Wajib diaktifkan agar perlindungan mata berjalan 24/7.",
            onTap: _showAutoStartDialog,
            iconBgColor: AppColors.warning.withAlpha(20),
            iconColor: AppColors.warning,
            trailing: const Icon(Icons.settings_suggest_rounded, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 24),
          
          const SettingsSection(title: "AI EDGE COMPUTING (DEV)"),
          Obx(() => SettingsTile(
            icon: Icons.memory_rounded,
            title: "Hardware Acceleration",
            subtitle: config.isGpuDelegationEnabled.value ? "Aktif - Menggunakan GPU/NNAPI (Performa Tinggi)" : "Nonaktif - Menggunakan CPU (Hemat Baterai)",
            onTap: () {
              config.toggleGpuDelegation(!config.isGpuDelegationEnabled.value);
              VToast.show("Edge Computing", config.isGpuDelegationEnabled.value ? "GPU/NNAPI Delegation Aktif" : "Mode CPU Aktif", state: VizoState.focused);
            },
            iconBgColor: config.isGpuDelegationEnabled.value ? AppColors.secondary.withAlpha(30) : AppColors.primary.withAlpha(20),
            iconColor: config.isGpuDelegationEnabled.value ? AppColors.secondary : AppColors.primary,
            trailing: Switch(
              value: config.isGpuDelegationEnabled.value,
              onChanged: (val) {
                config.toggleGpuDelegation(val);
                VToast.show("Edge Computing", val ? "GPU/NNAPI Delegation Aktif" : "Mode CPU Aktif", state: VizoState.focused);
              },
              activeTrackColor: AppColors.secondary,
            ),
          )),
          const SizedBox(height: 24),

          const SettingsSection(title: "SISTEM & AKUN"),
          SettingsTile(
            icon: Icons.logout_rounded,
            title: "Keluar Akun",
            subtitle: "Selesaikan sesi dan keluar dari Cloud.",
            iconBgColor: AppColors.danger.withAlpha(30),
            iconColor: AppColors.danger,
            onTap: () => _handleLogout(auth),
            trailing: const Icon(Icons.exit_to_app_rounded, color: AppColors.danger),
          ),
          const SizedBox(height: 12),
          Semantics(
            label: 'katalon_settings_delete_account',
            button: true,
            child: SettingsTile(
              icon: Icons.delete_forever_rounded,
              title: "Hapus Akun & Data",
              subtitle: "Hapus permanen akun dan seluruh riwayat telemetri (Syarat Play Store).",
              iconBgColor: AppColors.danger.withAlpha(20),
              iconColor: Colors.red[900]!,
              onTap: () => _handleDeleteAccount(auth),
              trailing: Icon(Icons.warning_amber_rounded, color: Colors.red[900]),
            ),
          ),
          const SizedBox(height: 24),

          const SettingsSection(title: "DUKUNGAN PENGGUNA"),
          SettingsTile(
            icon: Icons.feedback_outlined,
            title: "Kritik & Saran",
            subtitle: "Bantu kami menjadi lebih baik.",
            onTap: () => FeedbackDialog.show(),
            trailing: const Icon(Icons.open_in_new_rounded, size: 20, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 24),

          const SettingsSection(title: "INFORMASI APLIKASI"),
          SettingsTile(
            icon: Icons.info_outline_rounded,
            title: "Tentang Aplikasi",
            subtitle: "Visi, misi, dan informasi pengembang.",
            onTap: () => AboutAppDialog.show(),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            icon: Icons.menu_book_rounded,
            title: "Cara Penggunaan",
            subtitle: "Panduan untuk perlindungan optimal.",
            onTap: () => HowToUseDialog.show(),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 12),
          SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: "Kebijakan Privasi",
            subtitle: "Aturan perlindungan data dan kamera.",
            onTap: () async {
              final url = Uri.parse('https://visionsafe.web.id/privacy.html');
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                Get.snackbar("Gagal", "Tidak dapat membuka tautan privasi", backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
            trailing: const Icon(Icons.open_in_new_rounded, size: 20, color: AppColors.primaryDark),
          ),
          const SizedBox(height: 24),

          const SizedBox(height: 16),
          _buildVersionInfo(),
        ],
      ),
    );
  }


  void _handleLogout(AuthService auth) {
    Get.dialog(
      AlertDialog(
        title: const Text("Konfirmasi Keluar"),
        content: const Text("Apakah kamu yakin ingin mengakhiri sesi ini?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("BATAL")),
          TextButton(
            onPressed: () async {
              await auth.signOut();
              Get.offAllNamed(Routes.login);
            },
            child: const Text("KELUAR", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleDeleteAccount(AuthService auth) {
    Get.dialog(
      AlertDialog(
        title: const Text("Hapus Permanen Akun?"),
        content: const Text(
          "Tindakan ini tidak bisa dibatalkan. Semua data profil dan histori kesehatan mata akan dihapus permanen.",
        ),
        actions: [
          Semantics(
            label: 'katalon_btn_batal_hapus',
            button: true,
            child: TextButton(onPressed: () => Get.back(), child: const Text("BATAL")),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Tutup dialog konfirmasi
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );
              try {
                await auth.deleteAccount();
                Get.offAllNamed(Routes.login);
              } catch (e) {
                Get.back(); // Tutup loading
                Get.snackbar("Error", "Gagal menghapus akun: $e");
              }
            },
            child: const Text("HAPUS DATA", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeveloperLogin() {
    final TextEditingController passwordController = TextEditingController();
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.primaryDark, width: 4)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.admin_panel_settings_rounded, color: AppColors.danger, size: 32),
                  const SizedBox(width: 12),
                  Text("AREA TERLARANG", style: AppTextStyles.heading2.copyWith(color: AppColors.danger)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Konsol ini hanya diperuntukkan bagi Pemilik Aplikasi (Owner) dan Pengembang. Terdapat pengaturan sensitif yang dapat memengaruhi keseluruhan sistem Cloud.",
                style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: AppTextStyles.heading2.copyWith(letterSpacing: 8, fontSize: 24, color: AppColors.primaryDark),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "••••••",
                  hintStyle: AppTextStyles.heading2.copyWith(letterSpacing: 8, fontSize: 24, color: AppColors.grey.withAlpha(100)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryDark, width: 2)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryDark, width: 2)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.secondary, width: 3)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: Text("BATAL", style: AppTextStyles.bodyBold.copyWith(color: AppColors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VButton(
                      label: "OTORISASI",
                      color: AppColors.danger,
                      onPressed: () {
                        final expectedPin = dotenv.env['DEV_PIN'] ?? '180305';
                        if (passwordController.text == expectedPin) {
                          Get.back();
                          Get.to(() => const DeveloperDashboardView(), transition: Transition.cupertinoDialog);
                        } else {
                          Get.back();
                          VToast.show("Akses Ditolak", "PIN Otorisasi Tidak Valid!", state: VizoState.sad);
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildVersionInfo() {
    int tapCount = 0;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        tapCount++;
        if (tapCount >= 5) {
          tapCount = 0;
          _showDeveloperLogin();
        }
      },
      child: const Center(
        child: Column(
          children: [
            Text("VisionSafe v1.0.0 Elite", style: TextStyle(color: Color(0xFF757575), fontSize: 12, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text("Powered by SDA Framework V2", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
