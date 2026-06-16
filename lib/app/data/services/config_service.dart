import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/vision_service_provider.dart';

class ConfigService extends GetxService {
  late Box _settingsBox;
  static const String _thresholdKey = 'violation_threshold';
  static const String _serviceEnabledKey = 'service_enabled';
  static const String _isFirstRunKey = 'is_first_run_v1';
  static const String _pendingSyncKey = 'settings_pending_sync';
  static const String _parentPinKey = 'parent_pin_v1';
  static const String _lastSyncTimeKey = 'last_sync_time_v1';
  static const String _faceDataPolicyKey = 'face_data_policy_accepted';
  static const double _defaultThreshold = 30.0;

  // Streams reaktif yang terikat langsung ke Hive untuk stabilitas data
  final threshold = _defaultThreshold.obs;
  final isServiceEnabled = false.obs;
  final isSyncing = false.obs;

  bool get isFirstRun => _settingsBox.get(_isFirstRunKey, defaultValue: true);

  Future<ConfigService> init() async {
    _settingsBox = await Hive.openBox('settings');
    
    // Sinkronisasi awal dari disk ke memori
    threshold.value = _settingsBox.get(_thresholdKey, defaultValue: _defaultThreshold);
    isServiceEnabled.value = _settingsBox.get(_serviceEnabledKey, defaultValue: false);
    
    // Listener otomatis untuk menjamin persistensi (Reactive Persistence)
    ever(threshold, (val) {
      _settingsBox.put(_thresholdKey, val);
      _settingsBox.put(_pendingSyncKey, true); // Mark as dirty
      pushSettings(); // Attempt auto-sync
    });
    ever(isServiceEnabled, (val) => _settingsBox.put(_serviceEnabledKey, val));
    
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
