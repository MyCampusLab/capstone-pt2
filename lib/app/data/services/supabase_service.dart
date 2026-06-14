import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../models/telemetry_model.dart';
import 'observability_service.dart';

enum SyncResult { success, transientError, permanentError }

/// Layanan untuk mengelola komunikasi dengan Supabase REST API.
/// Sesuai Standar Enterprise: Mendukung operasional CRUD secara asinkron ke Cloud.
class SupabaseService extends GetxService {
  final _supabase = Supabase.instance.client;
  final _logger = Logger();
  late final ObservabilityService _observability = Get.find<ObservabilityService>();

  /// Mengirim data telemetri secara batch ke server Supabase (Cloud).
  /// Menggunakan upsert untuk menjamin idempotensi (telemetry idempotency).
  Future<SyncResult> sendTelemetryBatch(List<TelemetryModel> models) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        _observability.log(
          severity: LogSeverity.warn,
          category: 'SUPABASE_SYNC',
          message: 'Web Service: Gagal mengirim data karena user belum login.',
        );
        return SyncResult.permanentError;
      }

      if (models.isEmpty) return SyncResult.success;

      final dataToInsert = models.map((model) => {
        'id': model.id,
        'user_id': user.id,
        'distance': model.distance,
        'is_violation': model.isViolation,
        'is_blinking': model.isBlinking,
        'created_at': model.timestamp.toIso8601String(),
      }).toList();

      // Upsert berdasarkan primary key 'id' agar idempotent
      await _supabase.from('telemetry').upsert(dataToInsert);

      _observability.log(
        severity: LogSeverity.info,
        category: 'SUPABASE_SYNC',
        message: 'Sinkronisasi Cloud: ${models.length} data telemetri berhasil diunggah.',
      );
      return SyncResult.success;
    } catch (e, stack) {
      _observability.log(
        severity: LogSeverity.error,
        category: 'SUPABASE_SYNC_FAILED',
        message: 'Kesalahan Web Service: Gagal sinkronisasi batch ke Cloud.',
        error: e,
        stackTrace: stack,
      );
      return _parseException(e);
    }
  }

  SyncResult _parseException(Object e) {
    if (e is PostgrestException) {
      if (e.code != null) {
        final code = e.code!;
        if (code.startsWith('22') || code.startsWith('23') || code.startsWith('42')) {
          return SyncResult.permanentError;
        }
      }
    }
    return SyncResult.transientError;
  }


  /// Mengambil profil user aktif dari tabel 'profiles'.
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      
      return data;
    } catch (e) {
      _logger.e('Kesalahan Profil: Gagal mengambil data profil -> $e');
      return null;
    }
  }

  /// Mendengarkan perubahan data profil secara real-time.
  Stream<Map<String, dynamic>> watchUserProfile() {
    final user = _supabase.auth.currentUser;
    if (user == null) return const Stream.empty();

    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', user.id)
        .where((event) => event.isNotEmpty)
        .map((event) => event.first);
  }

  /// Mengambil daftar seluruh stiker/hero yang tersedia.
  Future<List<Map<String, dynamic>>> getStickers() async {
    try {
      final data = await _supabase.from('stickers').select();
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      _logger.e('Kesalahan Stiker: Gagal mengambil master data stiker -> $e');
      return [];
    }
  }

  /// Mengambil daftar stiker yang sudah dibuka oleh user.
  Future<List<String>> getUnlockedStickerIds() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final data = await _supabase
          .from('user_stickers')
          .select('sticker_id')
          .eq('user_id', user.id);
      
      return (data as List).map((item) => item['sticker_id'] as String).toList();
    } catch (e) {
      _logger.e('Kesalahan User Stiker: Gagal mengambil data koleksi user -> $e');
      return [];
    }
  }

  /// Mengambil data Leaderboard (Top 10 Global).
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .order('xp', ascending: false)
          .limit(10);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      _logger.e('Kesalahan Leaderboard: Gagal mengambil data top global -> $e');
      return [];
    }
  }

  /// Mengirim data telemetri tunggal (Fallback).
  Future<bool> sendTelemetry(TelemetryModel model) async {
    final result = await sendTelemetryBatch([model]);
    return result == SyncResult.success;
  }

  /// Mengecek status koneksi ke Supabase secara real-time.
  Future<bool> checkConnection() async {
    try {
      // Melakukan query ringan (ping) ke sistem auth
      await _supabase.from('telemetry').select('id').limit(1);
      return true;
    } catch (e) {
      _logger.e('Koneksi Supabase Terputus: $e');
      return false;
    }
  }

  /// Mengambil data telemetri dalam jumlah besar untuk keperluan analitik (Heatmap).
  Future<List<Map<String, dynamic>>> getAnalyticsData({int limit = 1000}) async {
    try {
      final data = await _supabase
          .from('telemetry')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      _logger.e('Kesalahan Analitik: Gagal mengambil data Big Data dari Cloud.');
      return [];
    }
  }
}
