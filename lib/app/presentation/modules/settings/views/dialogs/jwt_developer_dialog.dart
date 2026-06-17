import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class JwtDeveloperDialog extends StatelessWidget {
  const JwtDeveloperDialog({super.key});

  static void show() {
    VDialog.show(
      title: "Security Token (JWT)",
      content: const JwtDeveloperDialog(),
      confirmLabel: "TUTUP",
      icon: Icons.security_rounded,
      iconColor: AppColors.primaryDark,
      onConfirm: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final token = session?.accessToken ?? "Tidak ada sesi aktif.";

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Data rahasia ini digunakan untuk memverifikasi keamanan (Role-Level Security) ke dosen Anda menggunakan jwt.io.",
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark.withAlpha(150), fontSize: 11),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Text(
            token,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: Colors.black87,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: token));
            VToast.show("Tersalin", "Token JWT disalin ke clipboard!", state: VizoState.happy);
          },
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: const Text("SALIN TOKEN JWT"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
