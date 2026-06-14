import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'package:get/get.dart';

/// Repository untuk mengelola akses data autentikasi.
/// Menjembatani antara UI/Controller dengan Data Source (AuthService/Supabase).
class AuthRepository extends GetxService {
  AuthService get _authService => Get.find<AuthService>();

  /// Melakukan login ke sistem.
  Future<AuthResponse> login(String email, String password) async {
    return await _authService.signIn(email, password);
  }

  /// Melakukan pendaftaran akun baru.
  Future<AuthResponse> register(String email, String password, {String? name}) async {
    return await _authService.signUp(email, password, name: name);
  }

  /// Melakukan login menggunakan Google.
  Future<void> loginWithGoogle() async {
    await _authService.nativeGoogleSignIn();
  }

  /// Mengambil data user yang sedang login.
  User? get currentUser => _authService.currentUser.value;

  /// Mengecek apakah user sudah terautentikasi.
  bool get isAuthenticated => _authService.isLoggedIn.value;

  /// Melakukan logout.
  Future<void> logout() async {
    await _authService.signOut();
  }
}
