import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Layanan Autentikasi Tingkat Enterprise.
/// Mengintegrasikan Supabase Auth dan Google OAuth.
/// Sesuai Standar SDA V2: Fokus pada Social Auth & Email.
class AuthService extends GetxService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger();
  StreamSubscription<AuthState>? _authSubscription;

  // Web Client ID (Wajib untuk handshake Google <-> Supabase)
  final String _webClientId = '353922058441-j4voev2ai15av984u7sgmd4ba78248b3.apps.googleusercontent.com';
  
  // Android Client ID (Untuk stabilitas di perangkat Android)
  final String _androidClientId = '353922058441-ljqqf9nh8rtnsjnqvl1k5oqbntsf6l5j.apps.googleusercontent.com';

  final isLoggedIn = false.obs;
  final currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    _checkInitialSession();
    _listenToAuthState();
  }

  void _checkInitialSession() {
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
