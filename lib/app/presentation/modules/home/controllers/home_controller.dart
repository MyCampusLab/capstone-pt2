import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/services/auth_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/repositories/telemetry_repository.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/data/repositories/profile_repository.dart';
import 'package:visionsafe/app/data/models/profile_model.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_dialog.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final _logger = Logger();
  final _serviceProvider = Get.find<VisionServiceProvider>();
  final telemetryService = Get.find<TelemetryService>();
  final _configService = Get.find<ConfigService>();
  final _repository = TelemetryRepository();
  final _profileRepo = Get.find<ProfileRepository>();

  final isLoading = false.obs;
  final isBackendConnected = false.obs;
  final dailyViolationMinutes = 0.0.obs;
  final pendingSyncCount = 0.obs;
  
  final userProfile = Rxn<ProfileModel>();
  DateTime? _lastHapticTime;

  // Real-time getters linked to TelemetryRepository
  double get eyeHealthScore => _repository.calculateEyeHealthScore();
  double get activeMonitoringMinutes => _repository.calculateTotalMonitoringMinutesToday();
  int get blinkCountToday => _repository.calculateBlinkCountToday();
  double get averageDistanceToday => _repository.calculateAverageDistanceToday();
  String get eyeStrainLevelToday => _repository.calculateEyeStrainLevelToday();

  bool get isServiceRunning => _configService.isServiceEnabled.value;
  double get currentDistance => telemetryService.currentDistance.value;
  bool get isViolation => telemetryService.isViolation.value;

  // AI INTELLIGENCE: Mengambil keputusan state maskot secara cerdas (Cloud + Local Context)
  VizoState get dynamicMascotState {
    // 1. Prioritas Utama: Kondisi darurat saat ini
    if (isViolation) return VizoState.intervention;
    if (currentDistance > 0 && currentDistance < _configService.threshold.value + 5.0) return VizoState.worried;

    // 2. Kondisi Berdasarkan Akumulasi Data Harian (Local Intelligence)
    if (dailyViolationMinutes.value > 10.0) return VizoState.sad; // Terlalu banyak pelanggaran
    if (dailyViolationMinutes.value > 5.0) return VizoState.focused; // Perlu istirahat sebentar

    // 3. Fallback ke state dari Profile Cloud
    if (userProfile.value != null) {
      return VizoState.values.firstWhere(
        (e) => e.name == userProfile.value!.mascotState,
        orElse: () => VizoState.happy,
      );
    }

    // 4. Default state
    return isServiceRunning ? VizoState.happy : VizoState.sleeping;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialPermissions();
    _startConnectivityPolling();
    _startSyncMonitoring();
    _listenToProfile();

    ever(telemetryService.currentDistance, _handleUxFeedback);
    ever(telemetryService.isViolation, (_) => _updateStats());
  }

  void _startSyncMonitoring() {
    _updatePendingSync();
    Timer.periodic(const Duration(seconds: 10), (_) => _updatePendingSync());
  }

  void _updatePendingSync() {
    pendingSyncCount.value = telemetryService.getAllLocalLogs().length;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // CATATAN ARSITEKTUR: Layanan VisionSafe tetap aktif di background (Foreground Service)
    // agar tetap bisa melindungi mata user saat membuka aplikasi lain (YouTube, TikTok, dll).
    // Layanan hanya mati jika user menekan Toggle secara manual atau via Notifikasi.
    _logger.t("Lifecycle State Changed: $state");
  }

  StreamSubscription? _profileSubscription;

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _profileSubscription?.cancel();
    super.onClose();
  }

  void _listenToProfile() {
    final authService = Get.find<AuthService>();
    ever(authService.isLoggedIn, (bool loggedIn) {
      _profileSubscription?.cancel();
      if (loggedIn) {
        _profileSubscription = _profileRepo.watchMyProfile().listen(
          (profile) => userProfile.value = profile,
          onError: (e) => _logger.e("Gagal memantau profil: $e"),
        );
      } else {
        userProfile.value = null;
      }
    });

    if (authService.isLoggedIn.value) {
      _profileSubscription = _profileRepo.watchMyProfile().listen(
        (profile) => userProfile.value = profile,
        onError: (e) => _logger.e("Gagal memantau profil awal: $e"),
      );
    }
  }

  void _startConnectivityPolling() {
    _checkConnection();
    Timer.periodic(const Duration(seconds: 30), (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('supabase.co').timeout(const Duration(seconds: 5));
      isBackendConnected.value = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      isBackendConnected.value = false;
    }
  }

  void _handleUxFeedback(double distance) {
    final threshold = _configService.threshold.value;
    final now = DateTime.now();
    if (distance < threshold + 2.0 && distance >= threshold) {
      if (_lastHapticTime == null || now.difference(_lastHapticTime!).inSeconds >= 5) {
        HapticFeedback.lightImpact();
        _lastHapticTime = now;
      }
    }
  }

  void _updateStats() {
    dailyViolationMinutes.value = _repository.calculateViolationMinutesToday();
  }

  Future<void> addXp(int amount) async {
    final profile = userProfile.value;
    if (profile == null) return;

    final currentXp = profile.xp;
    final newXp = currentXp + amount;
    
    int newLevel = profile.level;
    while (newXp >= (newLevel + 1) * 100) {
      newLevel++;
    }

    final updatedProfile = profile.copyWith(
      xp: newXp,
      level: newLevel,
      lastActiveAt: DateTime.now(),
    );

    // Update UI immediately (Reactive GetX state)
    userProfile.value = updatedProfile;

    // Show LEVEL UP toast if level increased!
    if (newLevel > profile.level) {
      HapticFeedback.vibrate();
      VToast.show(
        "LEVEL UP!", 
        "Selamat! Kamu naik ke Level $newLevel!", 
        state: VizoState.happy
      );
    }

    // Persist to Hive cache and synchronize to Supabase
    await _profileRepo.updateProfile(updatedProfile);
  }

  void goToCalibration() => Get.toNamed(Routes.calibration);

  Future<void> _checkInitialPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> toggleService() async {
    final previousState = _configService.isServiceEnabled.value;
    
    // Optimistic state transition
    _configService.toggleService(!previousState);
    HapticFeedback.mediumImpact();
    
    try {
      if (previousState) {
        await _serviceProvider.stopService();
        VToast.show("VisionSafe", "Layanan Penjaga Mata Dinonaktifkan.", state: VizoState.sleeping);
      } else {
        if (!await Permission.camera.isGranted && !(await Permission.camera.request().isGranted)) {
          _configService.toggleService(previousState);
          _showPermissionError("Kamera");
          return;
        }
        if (!await Permission.systemAlertWindow.isGranted && !(await Permission.systemAlertWindow.request().isGranted)) {
          _configService.toggleService(previousState);
          _showPermissionError("Tampilkan di Atas Aplikasi Lain");
          return;
        }
        if (!await Permission.notification.isGranted) {
          await Permission.notification.request();
        }
        await _serviceProvider.startService();
        VToast.show("VisionSafe", "Layanan Penjaga Mata Aktif!", state: VizoState.happy);
      }
    } catch (e) {
      _configService.toggleService(previousState);
      VToast.show("Ups!", "Terjadi kesalahan: ${e.toString()}", state: VizoState.intervention);
    }
  }

  void _showPermissionError(String permissionName) {
    VDialog.show(
      title: "Izin Dibutuhkan",
      message: "VisionSafe butuh izin $permissionName agar bisa berfungsi melindungi mata Anda.",
      confirmLabel: "PENGATURAN",
      onConfirm: () {
        openAppSettings();
      },
      cancelLabel: "NANTI",
    );
  }
}
