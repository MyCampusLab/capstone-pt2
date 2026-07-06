import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class FeedbackDialog extends StatelessWidget {
  const FeedbackDialog({super.key});

  static void show() {
    final TextEditingController feedbackController = TextEditingController();
    
    VDialog.show(
      title: "Kritik & Saran",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Masukan Anda akan dikirim langsung ke database kami untuk perbaikan sistem.",
            style: AppTextStyles.caption.copyWith(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Tulis masalah atau saran Anda di sini...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryDark),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
      confirmLabel: "KIRIM FEEDBACK",
      icon: Icons.feedback_rounded,
      iconColor: AppColors.primary,
      onConfirm: () async {
        if (feedbackController.text.trim().isEmpty) {
          VToast.show("Gagal", "Feedback tidak boleh kosong!", state: VizoState.sad);
          return;
        }

        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
        
        try {
          final user = Supabase.instance.client.auth.currentUser;
          await Supabase.instance.client.from('user_feedbacks').insert({
            'user_id': user?.id,
            'email': user?.email ?? 'Anonymous',
            'message': feedbackController.text,
            'status': 'Pending'
          });
          
          Get.back(); // close loading
          Get.back(); // close dialog
          VToast.show("Terima Kasih", "Feedback aktual berhasil dikirim ke Supabase!", state: VizoState.happy);
        } catch (e) {
          Get.back(); // close loading
          VToast.show("Gagal", "Pastikan tabel user_feedbacks sudah dibuat di Supabase.\nError: $e", state: VizoState.sad);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); 
  }
}

