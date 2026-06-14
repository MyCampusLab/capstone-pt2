import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class CalibrationController extends GetxController {
  final telemetryService = Get.find<TelemetryService>();
  final _configService = Get.find<ConfigService>();
  final _visionProvider = Get.find<VisionServiceProvider>();
  final _rewardService = Get.find<RewardService>();
  final _supabase = Supabase.instance.client;
  final _logger = Logger();

  final currentDistance = 0.0.obs;
  final isSaving = false.obs;
  
  CameraController? cameraController;
  
  // Haptic feedback state tracker to avoid continuous vibrations
  String _lastHapticState = 'idle';

  @override
  void onInit() {
    super.onInit();
    _initCamera();
    _startCalibrationEngine();
    
    ever(telemetryService.currentDistance, (double distance) {
      currentDistance.value = distance;
      
      // Trigger tactile haptic feedback on state changes
      if (distance >= 30.0) {
        if (_lastHapticState != 'ideal') {
          HapticFeedback.lightImpact();
          _lastHapticState = 'ideal';
        }
      } else if (distance > 0.0 && distance < 30.0) {
        if (_lastHapticState != 'tooClose') {
          HapticFeedback.vibrate();
          _lastHapticState = 'tooClose';
        }
      } else {
        _lastHapticState = 'idle';
      }
    });
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
      
      final ctrl = CameraController(frontCamera, ResolutionPreset.medium, enableAudio: false);
      cameraController = ctrl;
      await ctrl.initialize();
      if (isClosed) {
        await ctrl.dispose();
        return;
      }
      update(); // Refresh UI only if active
    } catch (e) {
      _logger.e("Gagal inisialisasi kamera preview: $e");
    }
  }

  Future<void> _startCalibrationEngine() async {
    final isRunning = await _visionProvider.isServiceRunning();
    if (!isRunning && !isClosed) {
      await _visionProvider.startService();
    }
  }

  /// Menyimpan hasil kalibrasi ke Lokal (Hive) dan Cloud (Supabase).
  Future<void> saveCalibration() async {
    if (currentDistance.value < 30.0) {
      VToast.show("Aduh!", "Jarak minimal 30 cm ya Hero!", state: VizoState.worried);
      return;
    }

    if (isSaving.value) return;
    isSaving.value = true;
    try {
      final double newThreshold = currentDistance.value;

      // 1. Simpan ke Hive (Offline First)
      _configService.updateThreshold(newThreshold);
      
      // 2. Simpan ke Supabase (Cloud Sync)
      final user = _supabase.auth.currentUser;
      if (user != null) {
        await _supabase.from('user_settings').upsert({
          'user_id': user.id,
          'safe_distance': newThreshold,
          'updated_at': DateTime.now().toIso8601String(),
        });
        _logger.i("Cloud Sync: Jarak aman berhasil disimpan di Supabase.");
      }

      // 3. Update Native Service
      await _visionProvider.updateThreshold(newThreshold);
      
      // Unlock achievement: Calibration Master
      await _rewardService.unlockSticker('s3');

      if (!isClosed) Get.back();
      VToast.show(
        "Berhasil!",
        "Jarak aman matamu sekarang: ${newThreshold.toInt()} cm.",
        state: VizoState.happy,
      );
    } catch (e) {
      _logger.e("Gagal sinkronisasi kalibrasi: $e");
      VToast.show("Error", "Gagal menyimpan ke cloud, tapi tetap tersimpan di HP.", state: VizoState.intervention);
    } finally {
      if (!isClosed) isSaving.value = false;
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
