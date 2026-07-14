import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/vision_service_provider.dart';

class ConfigService extends GetxService {
  late Box _settingsBox;
  static const String _thresholdKey = 'violation_threshold';
  static const String _serviceEnabledKey = 'service_enabled';
  static const String _disciplineEnabledKey = 'discipline_mode_v1';
  static const String _gpuDelegationKey = 'gpu_delegation_v1';
  static const String _isFirstRunKey = 'is_first_run_v1';
  static const String _pendingSyncKey = 'settings_pending_sync';
  static const String _parentPinKey = 'parent_pin_v1';
  static const String _lastSyncTimeKey = 'last_sync_time_v1';
  static const String _faceDataPolicyKey = 'face_data_policy_accepted';
  static const String _hardwareCalibratedKey = 'hardware_calibrated';
  static const String _lastEyeExerciseDateKey = 'last_eye_exercise_date_v1';
  static const String _violationDateKey = 'violation_date_v1';
  static const String _violationSecondsKey = 'violation_seconds_v1';
  
  // Daily Aggregations (Because local SQLite is ephemeral)
  static const String _monitoringSecondsKey = 'monitoring_seconds_today';
  static const String _blinkCountKey = 'blink_count_today';
  static const String _squintCountKey = 'squint_count_today';
  static const String _sumDistanceKey = 'sum_distance_today';
  static const String _countDistanceKey = 'count_distance_today';

  static const double _defaultThreshold = 30.0;

  // Streams reaktif yang terikat langsung ke Hive untuk stabilitas data
  final threshold = _defaultThreshold.obs;
  final isServiceEnabled = false.obs;
  final isDisciplineModeEnabled = false.obs;
  final isGpuDelegationEnabled = false.obs;
  final isSyncing = false.obs;

  bool get isFirstRun => _settingsBox.get(_isFirstRunKey, defaultValue: true);

  Future<ConfigService> init() async {
    _settingsBox = await Hive.openBox('settings');
    
    // Sinkronisasi awal dari disk ke memori
    threshold.value = _settingsBox.get(_thresholdKey, defaultValue: _defaultThreshold);
    isServiceEnabled.value = _settingsBox.get(_serviceEnabledKey, defaultValue: false);
    isDisciplineModeEnabled.value = _settingsBox.get(_disciplineEnabledKey, defaultValue: false);
    isGpuDelegationEnabled.value = _settingsBox.get(_gpuDelegationKey, defaultValue: false);
    
    // Listener otomatis untuk menjamin persistensi (Reactive Persistence)
    ever(threshold, (val) {
      _settingsBox.put(_thresholdKey, val);
      _settingsBox.put(_pendingSyncKey, true); // Mark as dirty
      pushSettings(); // Attempt auto-sync
      // PENTING: Update native service agar sinkron
      try {
        Get.find<VisionServiceProvider>().updateThreshold(val);
      } catch (e) {
        // Abaikan jika provider belum siap
      }
    });
    ever(isServiceEnabled, (val) => _settingsBox.put(_serviceEnabledKey, val));
    ever(isDisciplineModeEnabled, (val) => _settingsBox.put(_disciplineEnabledKey, val));
    ever(isGpuDelegationEnabled, (val) {
      _settingsBox.put(_gpuDelegationKey, val);
      // PENTING: Update native service
      try {
        Get.find<VisionServiceProvider>().updateGpuDelegation(val);
      } catch (_) {}
    });
    
    // Listen for Auth State changes to pull remote settings
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      if (user != null) {
        pullSettings();
        pushSettings(); // In case there are pending local changes
      }
    });

    // If already logged in, pull settings immediately and sync any pending changes
    if (Supabase.instance.client.auth.currentUser != null) {
      pullSettings();
      pushSettings();
    }
    
    return this;
  }

  // Method pembantu dengan performa tinggi
  void toggleService(bool value) => isServiceEnabled.value = value;
  void toggleDisciplineMode(bool isEnabled) {
    isDisciplineModeEnabled.value = isEnabled;
  }
  
  void toggleGpuDelegation(bool isEnabled) {
    isGpuDelegationEnabled.value = isEnabled;
  }
  void completeOnboarding() {
    _settingsBox.put(_isFirstRunKey, false);
  }

  void updateThreshold(double value) {
    threshold.value = value;
  }

  String? get parentPin => _settingsBox.get(_parentPinKey);
  
  Future<void> setParentPin(String pin) async {
    await _settingsBox.put(_parentPinKey, pin);
  }

  String? get lastEyeExerciseDate => _settingsBox.get(_lastEyeExerciseDateKey);
  Future<void> setLastEyeExerciseDate(String dateStr) async {
    await _settingsBox.put(_lastEyeExerciseDateKey, dateStr);
  }

  // Melacak total pelanggaran harian secara luring (Local Persistent)
  int get violationSecondsToday {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    if (_settingsBox.get(_violationDateKey) != todayStr) {
      return 0; // Reset jika beda hari
    }
    return _settingsBox.get(_violationSecondsKey, defaultValue: 0);
  }

  Future<void> addViolationSeconds(int seconds) async {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    int current = 0;
    if (_settingsBox.get(_violationDateKey) == todayStr) {
      current = _settingsBox.get(_violationSecondsKey, defaultValue: 0);
    } else {
      await _settingsBox.put(_violationDateKey, todayStr);
    }
    await _settingsBox.put(_violationSecondsKey, current + seconds);
  }

  // Melacak total waktu layar (Monitoring) hari ini
  int get monitoringSecondsToday {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    if (_settingsBox.get(_violationDateKey) != todayStr) return 0;
    return _settingsBox.get(_monitoringSecondsKey, defaultValue: 0);
  }

  // Melacak total kedipan hari ini
  int get blinkCountToday {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    if (_settingsBox.get(_violationDateKey) != todayStr) return 0;
    return _settingsBox.get(_blinkCountKey, defaultValue: 0);
  }

  // Melacak total kedipan hari ini
  int get squintCountToday {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    if (_settingsBox.get(_violationDateKey) != todayStr) return 0;
    return _settingsBox.get(_squintCountKey, defaultValue: 0);
  }

  // Rata-rata jarak hari ini
  double get averageDistanceToday {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    if (_settingsBox.get(_violationDateKey) != todayStr) return 0.0;
    
    final sum = _settingsBox.get(_sumDistanceKey, defaultValue: 0.0);
    final count = _settingsBox.get(_countDistanceKey, defaultValue: 0);
    if (count == 0) return 0.0;
    return sum / count;
  }

  // Record Telemetry Event (Called by TelemetryService)
  Future<void> recordTelemetryEvent(double distance, bool isBlinking, bool isSquinting, double durationSeconds) async {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    if (_settingsBox.get(_violationDateKey) != todayStr) {
      await _settingsBox.put(_violationDateKey, todayStr);
      await _settingsBox.put(_violationSecondsKey, 0);
      await _settingsBox.put(_monitoringSecondsKey, 0);
      await _settingsBox.put(_blinkCountKey, 0);
      await _settingsBox.put(_squintCountKey, 0);
      await _settingsBox.put(_sumDistanceKey, 0.0);
      await _settingsBox.put(_countDistanceKey, 0);
    }
    
    // Accumulate
    final currentMon = _settingsBox.get(_monitoringSecondsKey, defaultValue: 0);
    await _settingsBox.put(_monitoringSecondsKey, currentMon + durationSeconds.round());

    if (isBlinking) {
      final currentBlink = _settingsBox.get(_blinkCountKey, defaultValue: 0);
      await _settingsBox.put(_blinkCountKey, currentBlink + 1);
    }

    if (isSquinting) {
      final currentSquint = _settingsBox.get(_squintCountKey, defaultValue: 0);
      await _settingsBox.put(_squintCountKey, currentSquint + 1);
    }

    if (distance > 0) {
      final sum = _settingsBox.get(_sumDistanceKey, defaultValue: 0.0);
      final count = _settingsBox.get(_countDistanceKey, defaultValue: 0);
      await _settingsBox.put(_sumDistanceKey, sum + distance);
      await _settingsBox.put(_countDistanceKey, count + 1);
    }
  }

  DateTime? get lastCloudSyncTime {
    final ms = _settingsBox.get(_lastSyncTimeKey);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  Future<void> updateLastCloudSyncTime() async {
    await _settingsBox.put(_lastSyncTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  bool get hasAcceptedFaceDataPolicy => _settingsBox.get(_faceDataPolicyKey, defaultValue: false);

  Future<void> setHasAcceptedFaceDataPolicy() async {
    await _settingsBox.put(_faceDataPolicyKey, true);
  }

  bool get hasCalibratedHardware => _settingsBox.get(_hardwareCalibratedKey, defaultValue: false);

  Future<void> setHasCalibratedHardware() async {
    await _settingsBox.put(_hardwareCalibratedKey, true);
  }

  /// Menarik setting terbaru dari Supabase Cloud ke HP.
  Future<void> pullSettings() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('user_settings')
          .select('safe_distance')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response != null && response['safe_distance'] != null) {
        final double cloudThreshold = (response['safe_distance'] as num).toDouble();
        
        // Hanya update jika berbeda dengan lokal dan tidak ada pending sync local yang belum terkirim
        final hasPendingSync = _settingsBox.get(_pendingSyncKey, defaultValue: false);
        if (threshold.value != cloudThreshold && !hasPendingSync) {
          threshold.value = cloudThreshold;
          
          if (Get.isRegistered<VisionServiceProvider>()) {
            try {
              final visionProvider = Get.find<VisionServiceProvider>();
              // ignore: unawaited_futures
              visionProvider.updateThreshold(cloudThreshold);
            } catch (_) {}
          }
        }
      }
    } catch (e) {
      // Gagal menarik data, tetap gunakan cache lokal
    }
  }

  /// Mengirim setting lokal ke Supabase Cloud.
  Future<void> pushSettings() async {
    final hasPendingSync = _settingsBox.get(_pendingSyncKey, defaultValue: false);
    if (!hasPendingSync || isSyncing.value) return;

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    isSyncing.value = true;
    try {
      await supabase.from('user_settings').upsert({
        'user_id': user.id,
        'safe_distance': threshold.value,
        'updated_at': DateTime.now().toIso8601String(),
      });
      // Berhasil sync, hapus flag dirty
      await _settingsBox.put(_pendingSyncKey, false);
    } catch (e) {
      // Gagal sync, flag dirty tetap true sehingga akan dicoba lagi di startup/login
    } finally {
      isSyncing.value = false;
    }
  }
}
