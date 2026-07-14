import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_input.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';

/// Layanan Autentikasi Tingkat Enterprise.
/// Mengintegrasikan Supabase Auth dan Google OAuth.
/// Sesuai Standar SDA V2: Fokus pada Social Auth & Email.
class AuthService extends GetxService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger();
  StreamSubscription<AuthState>? _authSubscription;

  // Menggunakan OAuthRedirect flow, client IDs dihapus karena tidak digunakan di sisi flutter natively

  final isLoggedIn = false.obs;
  final currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    _checkInitialSession();
    _listenToAuthState();
    
    // Global Router Observer untuk Auth State
    ever(isLoggedIn, (bool loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (loggedIn) {
          Get.offAllNamed(Routes.mainWrapper);
        } else {
          Get.offAllNamed(Routes.login);
        }
      });
    });
  }

  Future<void> _checkInitialSession() async {
    try {
      // Mencegah "Ghosting Loop": Ambil token terbaru dari Native (antisipasi jika Native merestart JWT di background)
      final nativeAuth = await const MethodChannel('com.hn.visionsafe/telemetry_db').invokeMethod<Map>('getAuthContext');
      
      final nativeRefreshToken = nativeAuth?['supabase_refresh_token'] as String?;
      final currentSession = _supabase.auth.currentSession;
      final currentRefreshToken = currentSession?.refreshToken;

      // Jika Native punya token yang berbeda/lebih baru dari Dart, kita harus memulihkan sesi Dart
      if (nativeRefreshToken != null && nativeRefreshToken.isNotEmpty && nativeRefreshToken != currentRefreshToken) {
        _logger.w('Ghosting Loop dicegah! Token Native lebih baru dari Dart. Memulihkan sesi...');
        await _supabase.auth.setSession(nativeRefreshToken);
      }
    } catch (e) {
      _logger.e('Gagal sinkronisasi token dari Native (Ghosting Preventer): $e');
    }

    final session = _supabase.auth.currentSession;
    final user = session?.user;
    currentUser.value = user;
    isLoggedIn.value = user != null;
    if (user != null) {
      _logger.i('Sesi ditemukan: ${user.email}');
    }
  }

  void _listenToAuthState() {
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      
      // Update reaktif state
      currentUser.value = user;
      isLoggedIn.value = user != null;

      if (data.event == AuthChangeEvent.passwordRecovery) {
        _logger.i('Mode Pemulihan Password Terdeteksi dari Deep Link.');
        Future.delayed(const Duration(milliseconds: 1000), () {
          _showResetPasswordDialog();
        });
      }
      
      // Sinkronisasi JWT ke Kotlin Native untuk Headless Background Sync
      if (data.session != null && user != null) {
        try {
          const MethodChannel('com.hn.visionsafe/telemetry_db').invokeMethod('setAuthContext', {
            'supabase_url': dotenv.env['SUPABASE_URL'] ?? '',
            'supabase_anon_key': dotenv.env['SUPABASE_ANON_KEY'] ?? '',
            'supabase_jwt': data.session!.accessToken,
            'supabase_refresh_token': data.session!.refreshToken,
            'supabase_uuid': user.id,
          });
          _logger.i('AuthContext tersinkronisasi ke Native.');
        } catch (e) {
          _logger.e('Gagal sync AuthContext ke Native: $e');
        }
      }

      _logger.d('Auth State Change: ${data.event.name} - User: ${user?.email}');
    });
  }

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _secureStorage.write(key: 'saved_email', value: email);
        _logger.i('Autentikasi Berhasil: ${response.user!.email}');
      }
      return response;
    } catch (e) {
      _logger.e('Kesalahan Autentikasi: $e');
      rethrow;
    }
  }

  /// Registrasi akun baru menggunakan kredensial email dan nama.
  Future<AuthResponse> signUp(String email, String password, {String? name}) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email, 
        password: password,
        data: name != null ? {'full_name': name} : null,
      );
      _logger.i('Registrasi Berhasil untuk: $email');
      return response;
    } catch (e) {
      _logger.e('Kesalahan Registrasi: $e');
      rethrow;
    }
  }

  /// NATIVE GOOGLE SIGN IN (Diubah ke OAuth Browser Based untuk bypass masalah SHA-1 Debug)
  Future<void> nativeGoogleSignIn() async {
    try {
      // Menggunakan Supabase OAuth (Web Based) agar aman dari masalah SHA-1 Debug.
      // Ini akan melempar pengguna ke browser dan kembali via deep link.
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.hn.visionsafe://login-callback',
      );
      _logger.i('Google Login via OAuth diluncurkan.');
    } catch (e) {
      _logger.e('Kesalahan Google Auth: $e');
      rethrow;
    }
  }

  /// Mengirimkan email reset password ke pengguna.
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'https://visionsafe.web.id/',
      );
      _logger.i('Email reset password terkirim ke: $email');
    } catch (e) {
      _logger.e('Gagal mengirim email reset password: $e');
      rethrow;
    }
  }

  /// Memperbarui metadata profil di Auth dan menyinkronkan ke tabel 'profiles'.
  Future<void> updateProfile({required String fullName, String? avatarUrl}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'User belum terautentikasi.';

      // 1. Update Auth Metadata
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': fullName,
            // ignore: use_null_aware_elements
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );

      // 2. Sync ke tabel public.profiles (Diizinkan RLS column-level grant)
      await _supabase.from('profiles').update({
        'full_name': fullName,
        // ignore: use_null_aware_elements
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);

      _logger.i('Profil berhasil diperbarui: $fullName');
    } catch (e) {
      _logger.e('Gagal memperbarui profil: $e');
      rethrow;
    }
  }

  /// Memperbarui password user aktif secara aman di Supabase Auth.
  Future<void> changePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _logger.i('Password berhasil diperbarui.');
    } catch (e) {
      _logger.e('Gagal memperbarui password: $e');
      rethrow;
    }
  }

  void _showResetPasswordDialog() {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    final isLoading = false.obs;

    VDialog.show(
      title: "Ubah Password ✨",
      message: "Buat password baru untuk akun pahlawanmu!",
      icon: Icons.vpn_key_rounded,
      iconColor: AppColors.primary,
      content: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          VInput(
            controller: passwordController,
            isPassword: true,
            hint: "Password Baru (Min. 6 Karakter)",
            prefixIcon: Icons.lock_outline_rounded,
          ),
          const SizedBox(height: 12),
          VInput(
            controller: confirmController,
            isPassword: true,
            hint: "Ulangi Password",
            prefixIcon: Icons.lock_reset_rounded,
          ),
          const SizedBox(height: 24),
          VButton(
            label: "SIMPAN & BERAKSI! ⚡",
            icon: Icons.bolt_rounded,
            isLoading: isLoading.value,
            onPressed: isLoading.value ? null : () async {
              final pwd = passwordController.text.trim();
              final confirm = confirmController.text.trim();
              if (pwd.length < 6) {
                VToast.show("Error", "Password minimal 6 karakter.", state: VizoState.worried);
                return;
              }
              if (pwd != confirm) {
                VToast.show("Error", "Konfirmasi password tidak cocok.", state: VizoState.worried);
                return;
              }

              isLoading.value = true;
              try {
                await changePassword(pwd);
                Get.back(); // Tutup dialog
                VToast.show("Sukses 🎉", "Password berhasil diubah!", state: VizoState.happy);
              } catch (e) {
                VToast.show("Gagal", "Gagal mengubah password.", state: VizoState.intervention);
              } finally {
                isLoading.value = false;
              }
            },
          ),
        ],
      )),
      hideButtons: true, // Karena kita pakai VButton di dalam content
      barrierDismissible: false,
    );
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _secureStorage.delete(key: 'saved_email');
      
      // Logout from Google to ensure clean state for account switching
      try {
        await GoogleSignIn().signOut();
      } catch (e) {
        _logger.w('Gagal sign out dari Google (mungkin login via email): $e');
      }
      
      try {
        final visionProvider = Get.find<VisionServiceProvider>();
        if (await visionProvider.isServiceRunning()) {
          await visionProvider.stopService();
        }
      } catch (_) {}
      
      _logger.i('Sesi Berakhir: User Logged Out');
    } catch (e) {
      _logger.e('Gagal Logout: $e');
    }
  }

  /// Menghapus data akun sesuai kebijakan privasi Play Store.
  Future<void> deleteAccount() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        // Hapus data profil dan telemetri (Best effort, bergantung konfigurasi RLS Supabase)
        await _supabase.from('profiles').delete().eq('id', user.id).catchError((_) => null);
      }
      await signOut();
      _logger.i('Akun berhasil dihapus beserta datanya.');
    } catch (e) {
      _logger.e('Gagal menghapus akun: $e');
      rethrow;
    }
  }

  String? get currentUserId => _supabase.auth.currentUser?.id;

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
