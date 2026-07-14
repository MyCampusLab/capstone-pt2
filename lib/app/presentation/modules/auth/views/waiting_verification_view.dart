import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class WaitingVerificationView extends StatefulWidget {
  const WaitingVerificationView({super.key});

  @override
  State<WaitingVerificationView> createState() => _WaitingVerificationViewState();
}

class _WaitingVerificationViewState extends State<WaitingVerificationView> {
  Timer? _pollingTimer;
  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    
    // Ambil kredensial dari arguments yang dikirim saat register
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _email = args['email'];
      _password = args['password'];
      
      if (_email != null && _password != null) {
        _startPolling();
      }
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: _email!,
          password: _password!,
        );
        
        if (response.session != null) {
          // Berhasil login secara background!
          // Routing di-handle 100% oleh AuthService (ever listener) untuk mencegah double-navigation
          _pollingTimer?.cancel();
        }
      } catch (e) {
        // Akan error 'Email not confirmed' selama belum di-klik, biarkan saja.
        // Interval 5 detik mencegah trigger Rate Limit (Too many requests) Supabase.
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _openEmailApp() async {
    // Metode 1: Coba buka aplikasi Gmail langsung (Android) atau Apple Mail (iOS)
    final Uri gmailUri = Uri.parse('googlegmail://');
    final Uri iosMailUri = Uri.parse('message://');
    
    try {
      if (await canLaunchUrl(gmailUri)) {
        await launchUrl(gmailUri);
      } else if (await canLaunchUrl(iosMailUri)) {
        await launchUrl(iosMailUri);
      } else {
        // Metode 2: Fallback sangat aman. Buka inbox Web Gmail. 
        // Di Android modern, link ini otomatis ditangkap oleh Aplikasi Gmail tanpa membuka compose!
        await launchUrl(
          Uri.parse('https://mail.google.com/mail/u/0/#inbox'),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Oops!", 
        "Tidak dapat membuka kotak masuk secara otomatis. Silakan buka emailmu secara manual.",
        backgroundColor: AppColors.danger.withValues(alpha: 0.1),
        colorText: AppColors.danger,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Mascot Section
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: VizoMascot(
                    size: 200,
                    state: VizoState.focused,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Title
              Text(
                "Menunggu Verifikasi... ⏳",
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.charcoal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Description
              Text(
                "Vizo sedang memantau sinyal dari email kamu.\n\nBuka email verifikasi dari HP atau Laptop kamu, dan klik link di dalamnya. Layar ini akan otomatis berpindah jika verifikasi berhasil ditekan!",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Action Buttons
              VButton(
                label: "Buka Kotak Masuk Gmail",
                icon: Icons.mark_email_unread_rounded,
                onPressed: _openEmailApp,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: () {
                  _pollingTimer?.cancel();
                  Get.offAllNamed(Routes.login);
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Kembali ke Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
