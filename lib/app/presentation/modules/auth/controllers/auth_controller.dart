import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/data/repositories/auth_repository.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';


/// Controller untuk manajemen state dan logika UI Autentikasi.
class AuthController extends GetxController {
  @protected
  AuthRepository get authRepository => Get.find<AuthRepository>();
  
  final isLoading = false.obs;
  final agreedToTerms = false.obs;
  
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  // Mascot reaktif: status dan arah tatapan mata
  final loginMascotState = VizoState.idle.obs;
  final registerMascotState = VizoState.happy.obs;
  
  final loginLookAt = Offset.zero.obs;
  final registerLookAt = Offset.zero.obs;

  late FocusNode loginEmailFocus;
  late FocusNode loginPasswordFocus;
  late FocusNode regNameFocus;
  late FocusNode regEmailFocus;
  late FocusNode regPasswordFocus;
  late FocusNode regConfirmPasswordFocus;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _initializeFocusNodes();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void _initializeFocusNodes() {
    loginEmailFocus = FocusNode();
    loginPasswordFocus = FocusNode();
    regNameFocus = FocusNode();
    regEmailFocus = FocusNode();
    regPasswordFocus = FocusNode();
    regConfirmPasswordFocus = FocusNode();

    // Listener fokus halaman Login
    loginEmailFocus.addListener(() {
      if (_isDisposed) return;
      if (loginEmailFocus.hasFocus) {
        loginMascotState.value = VizoState.focused;
        loginLookAt.value = const Offset(0.0, 0.4); // Melirik ke kolom email
      } else {
        _resetLoginMascot();
      }
    });

    loginPasswordFocus.addListener(() {
      if (_isDisposed) return;
      if (loginPasswordFocus.hasFocus) {
        loginMascotState.value = VizoState.sleeping; // Tutup mata (tidak mengintip sandi)
        loginLookAt.value = Offset.zero;
      } else {
        _resetLoginMascot();
      }
    });

    // Listener fokus halaman Register
    regNameFocus.addListener(() {
      if (_isDisposed) return;
      if (regNameFocus.hasFocus) {
        registerMascotState.value = VizoState.focused;
        registerLookAt.value = const Offset(-0.2, 0.3);
      } else {
        _resetRegisterMascot();
      }
    });

    regEmailFocus.addListener(() {
      if (_isDisposed) return;
      if (regEmailFocus.hasFocus) {
        registerMascotState.value = VizoState.focused;
        registerLookAt.value = const Offset(0.0, 0.4);
      } else {
        _resetRegisterMascot();
      }
    });

    regPasswordFocus.addListener(() {
      if (_isDisposed) return;
      if (regPasswordFocus.hasFocus) {
        registerMascotState.value = VizoState.sleeping; // Tutup mata
        registerLookAt.value = Offset.zero;
      } else {
        _resetRegisterMascot();
      }
    });

    regConfirmPasswordFocus.addListener(() {
      if (_isDisposed) return;
      if (regConfirmPasswordFocus.hasFocus) {
        registerMascotState.value = VizoState.sleeping; // Tutup mata
        registerLookAt.value = Offset.zero;
      } else {
        _resetRegisterMascot();
      }
    });
  }

  void _resetLoginMascot() {
    if (_isDisposed) return;
    if (!loginEmailFocus.hasFocus && !loginPasswordFocus.hasFocus) {
      loginMascotState.value = VizoState.idle;
      loginLookAt.value = Offset.zero;
    }
  }

  void _resetRegisterMascot() {
    if (_isDisposed) return;
    if (!regNameFocus.hasFocus && !regEmailFocus.hasFocus && 
        !regPasswordFocus.hasFocus && !regConfirmPasswordFocus.hasFocus) {
      registerMascotState.value = VizoState.happy;
      registerLookAt.value = Offset.zero;
    }
  }

  /// Mengeksekusi login standar melalui email dan password.
  Future<void> login() async {
    if (!_validateLoginInput()) return;

    isLoading.value = true;
    try {
      await authRepository.login(emailController.text.trim(), passwordController.text.trim());
      VToast.show("Welcome Back!", "Good to see you again, Hero!", state: VizoState.happy);
      // Routing di-handle 100% oleh AuthService (SDA Standard)
    } on AuthException catch (e) {
      String errorMsg = "Email atau password salah.";
      if (e.message.toLowerCase().contains("invalid login credentials")) {
        errorMsg = "Email atau password salah, cek lagi ya!";
      } else if (e.message.toLowerCase().contains("email not confirmed")) {
        errorMsg = "Email kamu belum dikonfirmasi. Cek inbox ya!";
      } else if (e.message.toLowerCase().contains("network")) {
        errorMsg = "Koneksi bermasalah. Cek internetmu ya!";
      }
      VToast.show("Gagal Masuk", errorMsg, state: VizoState.intervention);
    } catch (e) {
      VToast.show("Kesalahan Login", "Terjadi kesalahan tak terduga.", state: VizoState.worried);
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  /// Mengeksekusi pendaftaran akun baru (Register Manual).
  Future<void> register() async {
    if (!_validateRegisterInput()) return;

    isLoading.value = true;
    try {
      final response = await authRepository.register(
        emailController.text.trim(), 
        passwordController.text.trim(),
        name: nameController.text.trim(),
      );
      
      if (response.session != null) {
        // Auto-login success (email confirmation might be disabled)
        VToast.show("Welcome Hero!", "Registration successful. Start your quest!", state: VizoState.happy);
        // Routing di-handle 100% oleh AuthService (SDA Standard)
      } else {
        // Confirmation required, kirim args untuk polling background
        if (!_isDisposed) {
          Get.offAllNamed(
            Routes.waitingVerification,
            arguments: {
              'email': emailController.text.trim(),
              'password': passwordController.text.trim(),
            },
          );
        }
      }
    } on AuthException catch (e) {
      String errorMsg = "Gagal Daftar. Silakan coba lagi.";
      if (e.message.toLowerCase().contains("already registered")) {
        errorMsg = "Email sudah terdaftar. Gunakan email lain ya Hero!";
      } else if (e.message.toLowerCase().contains("network")) {
        errorMsg = "Koneksi bermasalah. Cek internetmu ya!";
      }
      VToast.show("Gagal Daftar", errorMsg, state: VizoState.intervention);
    } catch (e) {
      VToast.show("Gagal Daftar", "Terjadi kesalahan tak terduga.", state: VizoState.intervention);
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    if (isLoading.value) return; // Cegah double trigger
    
    isLoading.value = true;
    try {
      // Membuka browser untuk OAuth.
      // Tidak perlu push route di sini, akan ditangani oleh listener isLoggedIn di AuthService
      // saat browser meredirect kembali ke aplikasi.
      await authRepository.loginWithGoogle();
    } catch (e) {
      VToast.show("Kesalahan Google Auth", "Gagal masuk dengan Google.", state: VizoState.worried);
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  /// Menampilkan dialog lupa password dan memproses pengiriman email.
  void showForgotPasswordDialog() {
    final resetEmailController = TextEditingController(text: emailController.text.trim());
    Get.defaultDialog(
      title: "Lupa Password?",
      titlePadding: const EdgeInsets.only(top: 24),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        children: [
          const Text(
            "Masukkan email kamu yang terdaftar. Kami akan mengirimkan tautan untuk mengatur ulang password.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: resetEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "hero@example.com",
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
        ],
      ),
      confirm: VButton(
        onPressed: () async {
          final email = resetEmailController.text.trim();
          if (!_isValidEmail(email)) {
            Get.snackbar("Email Salah", "Format email tidak valid!", backgroundColor: Colors.red, colorText: Colors.white);
            return;
          }
          Get.back(); // Tutup dialog
          await _sendPasswordReset(email);
        },
        label: "Kirim Tautan",
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Batal"),
      ),
    );
  }

  Future<void> _sendPasswordReset(String email) async {
    isLoading.value = true;
    try {
      await authRepository.resetPassword(email);
      VToast.show(
        "Email Terkirim!", 
        "Cek inbox atau folder spam kamu untuk tautan reset password.", 
        state: VizoState.happy
      );
    } on AuthException catch (e) {
      VToast.show("Gagal", e.message, state: VizoState.intervention);
    } catch (e) {
      VToast.show("Error", "Gagal mengirim email reset.", state: VizoState.worried);
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  void clearFields() {
    if (_isDisposed) return;
    try {
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    } catch (_) {}
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool _validateLoginInput() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      VToast.show("Input Tidak Valid", "Mohon isi email dan password.", state: VizoState.worried);
      return false;
    }
    if (!_isValidEmail(email)) {
      VToast.show("Email Salah", "Format email tidak valid, Hero!", state: VizoState.sad);
      return false;
    }
    return true;
  }

  bool _validateRegisterInput() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      VToast.show("Input Kosong", "Semua kolom wajib diisi.", state: VizoState.worried);
      return false;
    }
    if (!agreedToTerms.value) {
      VToast.show("Persetujuan Privasi", "Kamu harus menyetujui Kebijakan Privasi (COPPA) untuk melanjutkan.", state: VizoState.intervention);
      return false;
    }
    if (!_isValidEmail(email)) {
      VToast.show("Email Salah", "Gunakan format email yang benar ya!", state: VizoState.sad);
      return false;
    }
    if (password != confirm) {
      VToast.show("Password Berbeda", "Konfirmasi password tidak cocok.", state: VizoState.sad);
      return false;
    }
    if (password.length < 6) {
      VToast.show("Password Lemah", "Minimal 6 karakter ya Hero!", state: VizoState.worried);
      return false;
    }
    return true;
  }

  bool _isDisposed = false;

  @override
  void onClose() {
    _isDisposed = true;
    
    // Memberikan jeda sebelum menghancurkan Controller & FocusNode
    // Ini mencegah error "used after being disposed" saat animasi transisi halaman belum selesai.
    Future.delayed(const Duration(milliseconds: 600), () {
      try {
        nameController.dispose();
        emailController.dispose();
        passwordController.dispose();
        confirmPasswordController.dispose();

        loginEmailFocus.dispose();
        loginPasswordFocus.dispose();
        regNameFocus.dispose();
        regEmailFocus.dispose();
        regPasswordFocus.dispose();
        regConfirmPasswordFocus.dispose();
      } catch (_) {}
    });

    super.onClose();
  }

}
