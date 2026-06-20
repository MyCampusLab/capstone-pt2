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
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import '../views/dialogs/home_dialog_helper.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';

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
  Timer? _tamperWatchdog;
  Timer? _snoozeTimer;

  // Real-time getters linked to TelemetryRepository
  double get eyeHealthScore => _repository.calculateEyeHealthScore();
  double get activeMonitoringMinutes => _repository.calculateTotalMonitoringMinutesToday();
  int get blinkCountToday => _repository.calculateBlinkCountToday();
  double get averageDistanceToday => _repository.calculateAverageDistanceToday();
  String get eyeStrainLevelToday => _repository.calculateEyeStrainLevelToday();

  bool get isServiceRunning => _configService.isServiceEnabled.value;
  double get currentDistance => telemetryService.currentDistance.value;
  bool get isViolation => telemetryService.isViolation.value;

  // Analisis Celah & Heartbeat (Refined for Local UI)
  String get connectionStatusText {
    return isServiceRunning ? "Sistem Aktif" : "Perlindungan Mati";
  }

  Color get connectionStatusColor {
    return isServiceRunning ? AppColors.success : AppColors.danger;
  }

  // Internet & Sync Status
  String get cloudSyncStatusText {
    if (!isBackendConnected.value) return "Offline (Data Lokal)";
    if (pendingSyncCount.value > 0) return "Menyinkronkan ($pendingSyncCount)";
    return "Tersinkronisasi";
  }

  Color get cloudSyncStatusColor {
    if (!isBackendConnected.value) return Colors.orange;
    if (pendingSyncCount.value > 0) return Colors.blue;
    return AppColors.success;
  }

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
    _startAntiTamperWatchdog();
    _listenToProfile();

    ever(telemetryService.currentDistance, _handleUxFeedback);
    ever(telemetryService.isViolation, (_) => _updateStats());
  }

  void _startSyncMonitoring() {
    _updatePendingSync();
    Timer.periodic(const Duration(seconds: 10), (_) => _updatePendingSync());
  }

  void _startAntiTamperWatchdog() {
    _tamperWatchdog = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_configService.isDisciplineModeEnabled.value) {
        final isAccessibilityEnabled = await _serviceProvider.checkAccessibilityPermission();
        if (!isAccessibilityEnabled) {
          _logger.w("ANTI-TAMPER: Aksesibilitas dimatikan paksa di luar aplikasi!");
          _configService.toggleDisciplineMode(false); // Matikan toggle sementara di UI
          
          VDialog.show(
            title: "Peringatan Keamanan!",
            message: "Izin Aksesibilitas (Mode Disiplin) telah dimatikan secara paksa dari pengaturan HP (Kemungkinan Anak Curang!). Ini merupakan pelanggaran kritis.",
            icon: Icons.gpp_bad_rounded,
            iconColor: Colors.red,
            confirmLabel: "BUKA PENGATURAN",
            onConfirm: () {
               Get.back();
            }
          );
        }
      }
    });
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
    _tamperWatchdog?.cancel();
    _snoozeTimer?.cancel();
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

  void goToCalibration() => Get.toNamed(Routes.calibration);

  Future<void> _checkInitialPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> toggleService() async {
    final previousState = _configService.isServiceEnabled.value;
    
    if (previousState) {
      // PROSES MATIKAN/JEDA: Jangan biarkan user lupa menyalakan!
      _showSnoozeOptions();
    } else {
      // PROSES NYALAKAN: Langsung gas, optimis.
      _snoozeTimer?.cancel(); // Batalkan snooze jika dinyalakan manual

      _configService.toggleService(true);
      HapticFeedback.mediumImpact();
      
      if (!_configService.hasAcceptedFaceDataPolicy) {
        _configService.toggleService(false);
        _showProminentDisclosure();
        return;
      }

      await _executeStartService();
    }
  }

  void _showProminentDisclosure() {
    VDialog.show(
      title: "KEBIJAKAN PRIVASI KAMERA & DATA WAJAH",
      icon: Icons.privacy_tip_rounded,
      iconColor: AppColors.primaryDark,
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "VisionSafe membutuhkan akses ke Kamera Depan untuk mendeteksi jarak mata Anda ke layar menggunakan teknologi pemindaian wajah (Face Tracking).",
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            "PENTING:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "• Pemantauan berjalan konstan di LATAR BELAKANG (Foreground Service) meskipun aplikasi ditutup.\n"
            "• Pemrosesan gambar dilakukan 100% LOKAL di perangkat Anda.\n"
            "• TIDAK ADA foto, video, atau data biometrik yang disimpan.\n"
            "• TIDAK ADA gambar yang dikirim ke server/internet kami.\n"
            "• Kami murni hanya mengonversi jarak menjadi angka (cm).",
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
      confirmLabel: "SAYA SETUJU",
      onConfirm: () async {
        Get.back();
        await _configService.setHasAcceptedFaceDataPolicy();
        _configService.toggleService(true);
        await _executeStartService();
      },
      cancelLabel: "TOLAK",
    );
  }

  Future<void> _executeStartService() async {
    try {
      // 1. KAMERA
      if (!await Permission.camera.isGranted) {
        final proceed = await HomeDialogHelper.showPermissionExplanation(
          title: "Izin Kamera Depan",
          explanation: "Kami membutuhkan akses Kamera Depan untuk mendeteksi jarak wajah secara lokal. Tidak ada video yang direkam atau dikirim ke internet.",
          benefit: "VisionSafe bisa mengukur dengan akurat kapan mata Anda terlalu dekat dengan layar.",
          icon: Icons.camera_alt_rounded,
        );
        if (!proceed || !(await Permission.camera.request().isGranted)) {
          _configService.toggleService(false);
          _showPermissionError("Kamera");
          return;
        }
      }

      // 2. TAMPIL DI ATAS APLIKASI LAIN (OVERLAY)
      if (!await Permission.systemAlertWindow.isGranted) {
        final proceed = await HomeDialogHelper.showPermissionExplanation(
          title: "Izin Tampil di Layar",
          explanation: "Izin ini (Overlay / System Alert Window) memungkinkan kami menampilkan efek peringatan di atas aplikasi lain yang sedang Anda buka.",
          benefit: "Anda akan tetap mendapat peringatan jarak aman meskipun sedang bermain game atau menonton video.",
          icon: Icons.layers_rounded,
        );
        if (!proceed || !(await Permission.systemAlertWindow.request().isGranted)) {
          _configService.toggleService(false);
          _showPermissionError("Tampilkan di Atas Aplikasi Lain");
          return;
        }
      }

      // 3. NOTIFIKASI
      if (!await Permission.notification.isGranted) {
        final proceed = await HomeDialogHelper.showPermissionExplanation(
          title: "Izin Notifikasi",
          explanation: "Agar aplikasi dapat mengirim peringatan sistem dan notifikasi teguran (Nudge) dari anggota keluarga Anda secara real-time.",
          benefit: "Anda tidak akan melewatkan pesan penting atau jadwal istirahat mata Anda.",
          icon: Icons.notifications_active_rounded,
        );
        if (proceed) {
          await Permission.notification.request();
        }
      }
      
      // 4. BATTERY OPTIMIZATION (Untuk Mode Disiplin / Latar Belakang)
      if (!await Permission.ignoreBatteryOptimizations.isGranted) {
        final proceed = await HomeDialogHelper.showPermissionExplanation(
          title: "Izin Latar Belakang",
          explanation: "Sistem Android terkadang mematikan aplikasi secara sepihak untuk menghemat baterai.",
          benefit: "Penting agar AI VisionSafe terus melindungi mata anak Anda tanpa terputus secara tiba-tiba.",
          icon: Icons.battery_charging_full_rounded,
        );
        if (proceed) {
          await Permission.ignoreBatteryOptimizations.request();
        }
      }

      await _serviceProvider.startService();
      await _serviceProvider.updateThreshold(_configService.threshold.value);
      VToast.show("VisionSafe", "Layanan Penjaga Mata Aktif!", state: VizoState.happy);
    } catch (e) {
      _configService.toggleService(false);
      VToast.show("Ups!", "Terjadi kesalahan: ${e.toString()}", state: VizoState.intervention);
    }
  }

  void _showSnoozeOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jeda Proteksi?", style: AppTextStyles.heading2.copyWith(color: AppColors.primaryDark)),
            const SizedBox(height: 8),
            Text("Pilih durasi jeda agar Vizo bisa otomatis menyala kembali nanti.", style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.timer_rounded, color: AppColors.secondary),
              title: const Text("Jeda 30 Menit"),
              subtitle: const Text("Cocok untuk ujian / membaca fokus."),
              onTap: () {
                Get.back();
                _snoozeService(30);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.movie_filter_rounded, color: AppColors.secondary),
              title: const Text("Jeda 2 Jam"),
              subtitle: const Text("Cocok saat menonton film panjang."),
              onTap: () {
                Get.back();
                _snoozeService(120);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.power_settings_new_rounded, color: Colors.red),
              title: const Text("Matikan Sepenuhnya", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              subtitle: const Text("Membutuhkan PIN Orang Tua."),
              onTap: () {
                Get.back();
                _promptHardStop();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _snoozeService(int minutes) {
    _executeStopService();
    VToast.show("Proteksi Dijeda", "Vizo akan tidur selama $minutes menit.", state: VizoState.sleeping);
    _snoozeTimer?.cancel();
    _snoozeTimer = Timer(Duration(minutes: minutes), () {
      if (!_configService.isServiceEnabled.value) {
        _configService.toggleService(true);
        _executeStartService();
      }
    });
  }

  void _promptHardStop() {
    final currentPin = _configService.parentPin;
    if (currentPin == null) {
      _showPinDialog(
        title: "Buat PIN Orang Tua",
        message: "Buat 4-digit PIN agar perlindungan tidak bisa dimatikan sembarangan.",
        isSetup: true,
      );
    } else {
      _showPinDialog(
        title: "Masukkan PIN",
        message: "Masukkan 4-digit PIN Orang Tua untuk mematikan perlindungan.",
        isSetup: false,
        correctPin: currentPin,
      );
    }
  }

  void _showPinDialog({
    required String title,
    required String message,
    required bool isSetup,
    String? correctPin,
  }) {
    final pinController = TextEditingController();
    Get.defaultDialog(
      title: title,
      titlePadding: const EdgeInsets.only(top: 24),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "****",
              counterText: "",
            ),
          ),
        ],
      ),
      confirm: VButton(
        onPressed: () async {
          final input = pinController.text;
          if (input.length != 4) {
            Get.snackbar("Error", "PIN harus 4 digit!");
            return;
          }

          if (isSetup) {
            await _configService.setParentPin(input);
            Get.back();
            // Lanjut proses stop setelah setup
            _executeStopService();
          } else {
            if (input == correctPin) {
              Get.back();
              _executeStopService();
            } else {
              Get.snackbar("Akses Ditolak", "PIN Salah!", backgroundColor: Colors.red, colorText: Colors.white);
            }
          }
        },
        label: "Lanjut",
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Batal"),
      ),
    );
  }

  Future<void> _executeStopService() async {
    _configService.toggleService(false);
    HapticFeedback.mediumImpact();
    try {
      await _serviceProvider.stopService();
      VToast.show("VisionSafe", "Layanan Penjaga Mata Dinonaktifkan.", state: VizoState.sleeping);
    } catch (e) {
      _configService.toggleService(true);
      VToast.show("Ups!", "Gagal mematikan: ${e.toString()}", state: VizoState.intervention);
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
