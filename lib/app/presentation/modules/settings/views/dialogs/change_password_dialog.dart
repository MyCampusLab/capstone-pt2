import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class ChangePasswordDialog extends StatefulWidget {
  final AuthService authService;

  const ChangePasswordDialog({super.key, required this.authService});

  static void show(AuthService authService) {
    VDialog.show(
      title: "Ganti Password",
      content: ChangePasswordDialog(authService: authService),
      hideButtons: true,
    );
  }

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final newPass = _passCtrl.text.trim();
    if (newPass.length < 6) {
      VToast.show("Gagal", "Password minimal 6 karakter!", state: VizoState.worried);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await widget.authService.changePassword(newPass);
      Get.back();
      VToast.show("Sukses", "Password berhasil diubah!", state: VizoState.happy);
    } catch (e) {
      VToast.show("Gagal", "Gagal mengganti password: $e", state: VizoState.intervention);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _passCtrl,
          obscureText: true,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            labelText: "Password Baru",
            labelStyle: AppTextStyles.caption.copyWith(color: AppColors.primaryDark),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 3),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _isLoading ? null : () => Get.back(),
              child: Text("BATAL", style: AppTextStyles.bodyBold.copyWith(color: AppColors.grey)),
            ),
            const SizedBox(width: 12),
            VButton(
              onPressed: _submit,
              isLoading: _isLoading,
              label: "GANTI",
              color: AppColors.primary,
              width: 120,
            ),
          ],
        ),
      ],
    );
  }
}
