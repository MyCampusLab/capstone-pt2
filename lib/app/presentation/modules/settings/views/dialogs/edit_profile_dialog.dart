import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class EditProfileDialog extends StatefulWidget {
  final AuthService authService;

  const EditProfileDialog({super.key, required this.authService});

  static void show(AuthService authService) {
    VDialog.show(
      title: "Edit Profil",
      content: EditProfileDialog(authService: authService),
      hideButtons: true,
    );
  }

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nameCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(
      text: widget.authService.currentUser.value?.userMetadata?['full_name'] ?? "",
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final newName = _nameCtrl.text.trim();
    if (newName.isEmpty) {
      VToast.show("Gagal", "Nama tidak boleh kosong!", state: VizoState.worried);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await widget.authService.updateProfile(fullName: newName);
      Get.back(); // close dialog
      VToast.show("Sukses", "Profil berhasil diperbarui!", state: VizoState.happy);
    } catch (e) {
      VToast.show("Gagal", "Gagal memperbarui profil: $e", state: VizoState.intervention);
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
        Semantics(
          label: 'katalon_input_nama',
          textField: true,
          child: TextField(
            controller: _nameCtrl,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              labelText: "Nama Lengkap",
              labelStyle: AppTextStyles.caption.copyWith(color: AppColors.primaryDark),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 3),
              ),
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
            Semantics(
              label: 'katalon_btn_simpan_profil',
              button: true,
              child: VButton(
                onPressed: _submit,
                isLoading: _isLoading,
                label: "SIMPAN",
                color: AppColors.primary,
                width: 120,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
