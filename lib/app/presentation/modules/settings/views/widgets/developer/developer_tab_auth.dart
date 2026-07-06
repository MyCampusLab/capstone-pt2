import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class DeveloperTabAuth extends StatelessWidget {
  const DeveloperTabAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final token = session?.accessToken ?? "Tidak ada sesi aktif (Gunakan Mode Dummy).";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_rounded, size: 32, color: AppColors.primaryDark),
              const SizedBox(width: 12),
              Expanded(
                child: Text("OTENTIKASI KEAMANAN (JWT)", style: AppTextStyles.heading2),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Otentikasi Kriptografi Aktif. Sesi pengguna dienkripsi dengan standar keamanan tinggi untuk melindungi privasi data rekam medis. Neobrutalism UI mendominasi panel ini untuk memberi nuansa Enterprise-grade.",
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryDark, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.primaryDark,
                  offset: Offset(4, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ACCESS TOKEN (JWT)", style: AppTextStyles.heading2.copyWith(fontSize: 16)),
                    VButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: token));
                        VToast.show("Disalin", "JWT Token berhasil disalin!", state: VizoState.happy);
                      },
                      label: "COPY",
                      icon: Icons.copy_rounded,
                      color: AppColors.primary,
                      width: 110,
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    token,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: AppColors.charcoal,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
