import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure_storage;
import '../models/telemetry_model.dart';
import 'config_service.dart';
import 'sync_service.dart';
import 'supabase_service.dart';
import 'observability_service.dart';
import 'reward_service.dart';

/// Layanan Inti untuk orkestrasi aliran data telemetri.
class TelemetryService extends GetxService {
  static const _eventChannel = EventChannel('com.hn.visionsafe/telemetry');
  static const _dbChannel = MethodChannel('com.hn.visionsafe/telemetry_db');
  
  late final ObservabilityService _observability = Get.find<ObservabilityService>();
  SyncService get _syncService => Get.find<SyncService>();
  
  StreamSubscription? _telemetrySubscription;
  Timer? _syncTimer;
  
  late Box _telemetryDlqBox;
  final _maxBatchSize = 100;
  bool _isSyncing = false;

  DateTime? _lastSyncFailedTime;
  DateTime? _lastEmergencySync;
  final _coolDownDuration = const Duration(seconds: 30);

  final currentDistance = 0.0.obs;
  final isViolation = false.obs;
  final isBlinking = false.obs;
  final blinkCount = 0.obs;
  final isPowerSaveActive = false.obs;
  final eyeMovement = 'center'.obs;
  final isSquinting = false.obs;
  final isLowLight = false.obs;

  Future<TelemetryService> init() async {
    const secureStorage = flutter_secure_storage.FlutterSecureStorage();
    
    // Mencari kunci enkripsi yang sudah ada
    String? base64Key = await secureStorage.read(key: 'hive_encryption_key');
    List<int> encryptionKey;

    if (base64Key == null) {
      // Jika belum ada, buat kunci baru (Standar AES-256)
      encryptionKey = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'hive_encryption_key',
        value: base64.encode(encryptionKey),
      );
      _observability.log(
        severity: LogSeverity.info,
        category: 'SECURITY',
        message: 'Kunci enkripsi baru berhasil dibuat dan disimpan dengan aman.',
      );
    } else {
      encryptionKey = base64.decode(base64Key);
    }

    // Kita tidak lagi menggunakan _telemetryBox (Hive) karena sudah dipindah ke SQLite Native
    // Hive hanya dipakai untuk Dead Letter Queue (DLQ) jika cloud gagal permanen
    _telemetryDlqBox = await Hive.openBox(
      'telemetry_dlq',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    _listenToNativeTelemetry();
    
    // Auto-sync data tersisa saat startup
    _startSyncTimer();
    _triggerSync();

    return this;
  }

  void _listenToNativeTelemetry() {
    DateTime lastUiUpdateTime = DateTime.now();
    DateTime? lastEventTime;

    _telemetrySubscription = _eventChannel.receiveBroadcastStream().listen((dynamic event) {
      if (event is Map) {
        // Cek sinkronisasi status service dari Native
        if (event['status'] == 'STOPPED') {
          if (Get.isRegistered<ConfigService>()) {
            Get.find<ConfigService>().toggleService(false);
          }
          return;
        }

        if (event.containsKey('isPowerSaveActive')) {
          isPowerSaveActive.value = event['isPowerSaveActive'] == true;
        }

        final model = TelemetryModel.fromMap(event);
        final now = DateTime.now();
        
        // 1. UI Update Throttle: 200ms (5 FPS) for smooth visual feedback
        if (now.difference(lastUiUpdateTime).inMilliseconds > 200) {
          currentDistance.value = model.distance;
          isViolation.value = model.isViolation;
          isBlinking.value = model.isBlinking;
          eyeMovement.value = model.eyeMovement;
          isSquinting.value = model.isSquinting;
          isLowLight.value = model.isLowLight;
          if (model.isBlinking) blinkCount.value++;
          lastUiUpdateTime = now;
        }

        // EMERGENCY WRITE-AHEAD: Segera sync ke Cloud jika terjadi pelanggaran (Throttled 10 detik)
        if (model.isViolation) {
          if (_lastEmergencySync == null || now.difference(_lastEmergencySync!).inSeconds > 10) {
            _lastEmergencySync = now;
            _triggerSync();
          }
        }

        // 2. Database Logic (Penyimpanan ke SQLite Native)
        // Akumulasi data agregat harian dengan Dynamic Delta Time
        // Penting untuk mendukung Thermal Throttling / Battery Saver (Frame rate dinamis)
        if (Get.isRegistered<ConfigService>()) {
          double deltaSeconds = 1.0;
          if (lastEventTime != null) {
            deltaSeconds = now.difference(lastEventTime!).inMilliseconds / 1000.0;
            // Cap delta at 15 seconds to prevent huge spikes if app was paused/backgrounded
            if (deltaSeconds > 15.0) deltaSeconds = 1.0; 
          }
          lastEventTime = now;

          Get.find<ConfigService>().recordTelemetryEvent(
            model.distance,
            model.isBlinking,
            model.isSquinting,
            deltaSeconds,
          );
        }
      }
    }, onError: (error) {
      _observability.log(
        severity: LogSeverity.error,
        category: 'NATIVE_TELEMETRY_STREAM',
        message: 'Kesalahan Stream Telemetri: $error',
        error: error,
      );
    });
  }

  // Timer reguler untuk mencoba sync data dari Native DB ke Cloud
  void _startSyncTimer() {
    _syncTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      _triggerSync();
    });
  }

  List<TelemetryModel> getAllLocalLogs() {
    return []; // Tidak relevan lagi karena di-handle Native
  }

  TelemetryModel? getLatestData() {
    return null; 
  }

  // Sinkronisasi data ke cloud secara efisien dengan Offline Recovery
  Future<void> _triggerSync() async {
    if (_isSyncing) return;

    // Cek cooldown setelah kegagalan sinkronisasi sebelumnya
    if (_lastSyncFailedTime != null) {
      final elapsed = DateTime.now().difference(_lastSyncFailedTime!);
      if (elapsed < _coolDownDuration) {
        return;
      }
    }

    try {
      // 1. Tarik log dari SQLite Native
      final List<dynamic>? rawLogs = await _dbChannel.invokeListMethod('getUnsyncedLogs', {'limit': _maxBatchSize});
      
      if (rawLogs == null || rawLogs.isEmpty) return;

      _isSyncing = true;
      _observability.log(
        severity: LogSeverity.info,
        category: 'TELEMETRY_SYNC_START',
        message: 'Memulai Sinkronisasi Batch Native DB: ${rawLogs.length} data.',
      );

      final List<TelemetryModel> rawBatch = [];
      final List<int> nativeIds = [];

      for (var item in rawLogs) {
        if (item is Map) {
          rawBatch.add(TelemetryModel.fromMap(item));
          nativeIds.add(item['native_id'] as int);
        }
      }

      // --- DATA AGGREGATION ALGORITHM (Smart Rollup) ---
      // Menghemat 90% bandwidth dan kapasitas Cloud Database.
      final List<TelemetryModel> aggregatedBatch = [];
      int safeCount = 0;
      double sumSafeDistance = 0.0;
      DateTime? lastSafeTime;

      for (var model in rawBatch) {
        if (model.isViolation) {
          // Flush accumulated safe data
          if (safeCount > 0) {
            aggregatedBatch.add(TelemetryModel(
              distance: sumSafeDistance / safeCount,
              isViolation: false,
              isBlinking: false,
              eyeMovement: 'center',
              isSquinting: false,
              isLowLight: false,
              timestamp: lastSafeTime ?? model.timestamp,
            ));
            safeCount = 0;
            sumSafeDistance = 0.0;
          }
          // Pelanggaran (Violation) selalu dicatat per-kejadian demi akurasi tinggi
          aggregatedBatch.add(model);
        } else {
          safeCount++;
          sumSafeDistance += model.distance;
          lastSafeTime = model.timestamp;

          // Setiap 12 event aman (sekitar 60 detik) digulung menjadi 1 Heartbeat
          if (safeCount >= 12) {
            aggregatedBatch.add(TelemetryModel(
              distance: sumSafeDistance / safeCount,
              isViolation: false,
              isBlinking: false,
              eyeMovement: 'center',
              isSquinting: false,
              isLowLight: false,
              timestamp: lastSafeTime,
            ));
            safeCount = 0;
            sumSafeDistance = 0.0;
          }
        }
      }

      // Flush sisa data aman yang belum mencapai kelipatan 12
      if (safeCount > 0) {
        aggregatedBatch.add(TelemetryModel(
          distance: sumSafeDistance / safeCount,
          isViolation: false,
          isBlinking: false,
          eyeMovement: 'center',
          isSquinting: false,
          isLowLight: false,
          timestamp: lastSafeTime ?? DateTime.now(),
        ));
      }

      _observability.log(
        severity: LogSeverity.info,
        category: 'TELEMETRY_SYNC_AGGREGATED',
        message: 'Kompresi Berhasil: ${rawBatch.length} mentah -> ${aggregatedBatch.length} ringkasan.',
      );

      // 2. Push ke Cloud
      final result = await _syncService.syncBatch(aggregatedBatch);
      
      if (result == SyncResult.success) {
        _lastSyncFailedTime = null; // Reset cooldown
        
        // HEARTBEAT / DEAD-MAN'S SWITCH PING
        await Get.find<SupabaseService>().updateUserHeartbeat();
        
        // 3. Hapus log yang sukses dari Native SQLite
        await _dbChannel.invokeMethod('deleteLogs', {'ids': nativeIds});
        
        if (Get.isRegistered<ConfigService>()) {
          Get.find<ConfigService>().updateLastCloudSyncTime();
          
          // Akumulasi Waktu Pelanggaran (The Penalty Box Logic)
          // Asumsi rata-rata event native (Kotlin) adalah 1 detik per event
          int violationCount = rawBatch.where((m) => m.isViolation).length;
          if (violationCount > 0) {
            Get.find<ConfigService>().addViolationSeconds(violationCount); // 1 count = 1 second
          }
        }
        
        // --- GAMIFIKASI LOGIC (XP DARI TELEMETRI) ---
        if (Get.isRegistered<RewardService>()) {
          // Hitung rawBatch untuk akurasi XP
          int rawSafeCount = rawBatch.where((m) => !m.isViolation).length;
          // Setiap 1 heartbeat mentah aman (setiap 5 detik) = 2 XP
          int xpGained = rawSafeCount * 2;
          if (xpGained > 0) {
            Get.find<RewardService>().addXp(xpGained);
          }
        }
        
        _observability.log(
          severity: LogSeverity.info,
          category: 'TELEMETRY_SYNC_SUCCESS',
          message: 'Offline Recovery: ${aggregatedBatch.length} data terkirim.',
        );

        if (rawLogs.length >= _maxBatchSize) {
          Future.delayed(const Duration(seconds: 1), _triggerSync);
        }
      } else if (result == SyncResult.permanentError) {
        _observability.log(
          severity: LogSeverity.critical,
          category: 'TELEMETRY_SYNC_PERMANENT_ERROR',
          message: 'Kesalahan Permanen terdeteksi. Memindahkan ${aggregatedBatch.length} data ke DLQ.',
        );

        // Pindahkan ke Dead Letter Queue (DLQ)
        for (final model in aggregatedBatch) {
          await _telemetryDlqBox.add(model.toJson());
        }
        // Tetap hapus dari Native karena sudah masuk DLQ
        await _dbChannel.invokeMethod('deleteLogs', {'ids': nativeIds});
      } else {
        _lastSyncFailedTime = DateTime.now();
      }
    } catch (e, stack) {
      _observability.log(
        severity: LogSeverity.error,
        category: 'TELEMETRY_SYNC_CRITICAL',
        message: 'Kesalahan Kritis Sinkronisasi: $e',
        error: e,
        stackTrace: stack,
      );
    } finally {
      _isSyncing = false;
    }
  }

  @override
  void onClose() {
    _telemetrySubscription?.cancel();
    _syncTimer?.cancel();
    super.onClose();
  }
}
