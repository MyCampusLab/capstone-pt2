import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as flutter_secure_storage;
import '../models/telemetry_model.dart';
import 'config_service.dart';
import 'sync_service.dart';
import 'supabase_service.dart';
import 'observability_service.dart';

/// Layanan Inti untuk orkestrasi aliran data telemetri.
class TelemetryService extends GetxService {
  static const _eventChannel = EventChannel('com.hn.visionsafe/telemetry');
  late final ObservabilityService _observability = Get.find<ObservabilityService>();
  SyncService get _syncService => Get.find<SyncService>();
  
  StreamSubscription? _telemetrySubscription;
  
  late Box _telemetryBox;
  late Box _telemetryDlqBox;
  final _batchThreshold = 12; // Sync every 1 minute (12 records * 5 seconds)
  final _maxBatchSize = 100;
  bool _isSyncing = false;

  DateTime? _lastSyncFailedTime;
  final _coolDownDuration = const Duration(seconds: 30);

  final currentDistance = 0.0.obs;
  final isViolation = false.obs;
  final isBlinking = false.obs;
  final blinkCount = 0.obs;
  final isPowerSaveActive = false.obs;
  final eyeMovement = 'center'.obs;
  final isSquinting = false.obs;

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

    _telemetryBox = await Hive.openBox(
      'telemetry_logs',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    _telemetryDlqBox = await Hive.openBox(
      'telemetry_dlq',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    _listenToNativeTelemetry();
    
    // Auto-sync data tersisa saat startup
    _triggerSync();

    return this;
  }

  void _listenToNativeTelemetry() {
    DateTime lastUiUpdateTime = DateTime.now();
    DateTime lastDbSaveTime = DateTime.now();

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
          if (model.isBlinking) blinkCount.value++;
          lastUiUpdateTime = now;
        }

        // 2. Database & Sync Throttle: 5000ms (5 seconds) to prevent Battery Drain
        // This stops the app from saving 30 frames per second to the local database!
        if (now.difference(lastDbSaveTime).inMilliseconds >= 5000) {
          _saveToLocal(model);
          lastDbSaveTime = now;
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

  void _saveToLocal(TelemetryModel model) async {
    // Prevent disk/memory leaks: limit local logs to max 5000 items
    if (_telemetryBox.length >= 5000) {
      try {
        final oldestKey = _telemetryBox.keys.first;
        await _telemetryBox.delete(oldestKey);
        _observability.log(
          severity: LogSeverity.warn,
          category: 'LOCAL_TELEMETRY_LIMIT',
          message: 'Lokal Telemetri melebihi batas 5000 data. Menghapus data tertua.',
        );
      } catch (e) {
        _observability.log(
          severity: LogSeverity.error,
          category: 'LOCAL_TELEMETRY_CLEANUP_FAILED',
          message: 'Gagal membersihkan cache telemetri lama: $e',
        );
      }
    }

    await _telemetryBox.add(model.toJson());
    
    _observability.log(
      severity: LogSeverity.info,
      category: 'LOCAL_TELEMETRY',
      message: 'Data Lokal Tersimpan: ${model.distance.toStringAsFixed(2)} cm',
    );

    if (_telemetryBox.length >= _batchThreshold && !_isSyncing) {
      _triggerSync();
    }
  }

  List<TelemetryModel> getAllLocalLogs() {
    return _telemetryBox.values
        .map((jsonStr) => TelemetryModel.fromJson(jsonStr as String))
        .toList();
  }

  TelemetryModel? getLatestData() {
    if (_telemetryBox.isEmpty) return null;
    return TelemetryModel.fromJson(_telemetryBox.values.last as String);
  }

  // Sinkronisasi data ke cloud secara efisien dengan Offline Recovery
  Future<void> _triggerSync() async {
    if (_telemetryBox.isEmpty || _isSyncing) return;

    // Cek cooldown setelah kegagalan sinkronisasi sebelumnya
    if (_lastSyncFailedTime != null) {
      final elapsed = DateTime.now().difference(_lastSyncFailedTime!);
      if (elapsed < _coolDownDuration) {
        _observability.log(
          severity: LogSeverity.info,
          category: 'TELEMETRY_SYNC_COOLDOWN',
          message: 'Sync: Dalam masa cooldown setelah gagal. Menunda sinkronisasi.',
        );
        return;
      }
    }

    _isSyncing = true;
    _observability.log(
      severity: LogSeverity.info,
      category: 'TELEMETRY_SYNC_START',
      message: 'Memulai Sinkronisasi Batch: ${_telemetryBox.length} data.',
    );

    try {
      final allKeys = _telemetryBox.keys.toList();
      final keysToProcess = allKeys.length > _maxBatchSize 
          ? allKeys.sublist(0, _maxBatchSize) 
          : allKeys;

      final List<String> rawJsons = keysToProcess.map((k) => _telemetryBox.get(k) as String).toList();

      // Offload parsing ke isolate lain agar UI tetap 120fps
      final List<TelemetryModel> batch = await compute(_parseTelemetryBatch, rawJsons);

      final result = await _syncService.syncBatch(batch);
      if (result == SyncResult.success) {
        _lastSyncFailedTime = null; // Reset cooldown
        await _telemetryBox.deleteAll(keysToProcess);
        
        if (Get.isRegistered<ConfigService>()) {
          Get.find<ConfigService>().updateLastCloudSyncTime();
        }
        
        _observability.log(
          severity: LogSeverity.info,
          category: 'TELEMETRY_SYNC_SUCCESS',
          message: 'Offline Recovery: ${batch.length} data terkirim. Sisa: ${_telemetryBox.length}',
        );

        if (_telemetryBox.length >= _batchThreshold) {
          Future.delayed(const Duration(seconds: 1), _triggerSync);
        }
      } else if (result == SyncResult.permanentError) {
        _observability.log(
          severity: LogSeverity.critical,
          category: 'TELEMETRY_SYNC_PERMANENT_ERROR',
          message: 'Kesalahan Permanen terdeteksi. Memindahkan ${batch.length} data ke DLQ.',
        );

        // Pindahkan ke Dead Letter Queue (DLQ)
        for (final key in keysToProcess) {
          final val = _telemetryBox.get(key);
          if (val != null) {
            await _telemetryDlqBox.add(val);
          }
        }
        await _telemetryBox.deleteAll(keysToProcess);
      } else {
        _lastSyncFailedTime = DateTime.now();
        _observability.log(
          severity: LogSeverity.warn,
          category: 'TELEMETRY_SYNC_TRANSIENT_FAILED',
          message: 'Offline Recovery: Koneksi bermasalah. Cooldown diaktifkan.',
        );
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
    super.onClose();
  }
}

List<TelemetryModel> _parseTelemetryBatch(List<String> rawJsons) {
  return rawJsons.map((jsonStr) => TelemetryModel.fromJson(jsonStr)).toList();
}
