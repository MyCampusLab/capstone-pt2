import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
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

/// View Pengaturan Utama (Elite Professional Version).
/// File length strictly < 200 lines.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

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
          Obx(() => SettingsTile(
            icon: Icons.person_outline_rounded,
            title: "Edit Profil",
            subtitle: auth.currentUser.value?.email ?? "User Hero",
            onTap: () => EditProfileDialog.show(auth),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primaryDark),
          )),
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
          const SizedBox(height: 40),
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

  Widget _buildVersionInfo() {
    return const Center(
      child: Column(
        children: [
          Text("VisionSafe v1.0.0 Elite", style: TextStyle(color: Color(0xFF757575), fontSize: 12, fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text("Powered by SDA Framework V2", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 10)),
        ],
      ),
    );
  }
}
