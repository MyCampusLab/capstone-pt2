import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

class DistanceSetterDialog extends StatefulWidget {
  final ConfigService config;

  const DistanceSetterDialog({super.key, required this.config});

  static void show(ConfigService config) {
    VDialog.show(
      title: "Target Jarak",
      content: DistanceSetterDialog(config: config),
      hideButtons: true,
    );
  }

  @override
  State<DistanceSetterDialog> createState() => _DistanceSetterDialogState();
}

class _DistanceSetterDialogState extends State<DistanceSetterDialog> {
  late final TextEditingController _distCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _distCtrl = TextEditingController(text: widget.config.threshold.value.toInt().toString());
  }

  @override
  void dispose() {
    _distCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final double? val = double.tryParse(_distCtrl.text);
    if (val == null || val < 30.0) {
      VToast.show("Gagal", "Jarak harus minimal 30 cm!", state: VizoState.worried);
      return;
    }

    setState(() => _isLoading = true);

    try {
      widget.config.updateThreshold(val);

      // 1. Sync ke Native Service
      try {
        final visionProvider = Get.find<VisionServiceProvider>();
        await visionProvider.updateThreshold(val);
      } catch (_) {}

      // 2. Sync ke Supabase Cloud
      try {
        final supabase = Supabase.instance.client;
        final user = supabase.auth.currentUser;
        if (user != null) {
          await supabase.from('user_settings').upsert({
            'user_id': user.id,
            'safe_distance': val,
            'updated_at': DateTime.now().toIso8601String(),
          });
        }
      } catch (_) {}

      Get.back();
      VToast.show("Berhasil", "Batas jarak aman diupdate ke ${val.toInt()} cm.", state: VizoState.happy);
    } catch (e) {
      VToast.show("Gagal", "Terjadi kesalahan: $e", state: VizoState.intervention);
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
          controller: _distCtrl,
          keyboardType: TextInputType.number,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            labelText: "Jarak (CM)",
            suffixText: "cm",
            helperText: "Minimal 30 cm untuk perlindungan mata.",
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
              label: "SIMPAN",
              color: AppColors.primary,
              width: 120,
            ),
          ],
        ),
      ],
    );
  }
}
