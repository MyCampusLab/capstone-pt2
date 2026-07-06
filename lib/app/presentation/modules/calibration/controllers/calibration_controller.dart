import 'dart:async';
import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/telemetry_service.dart';
import 'package:visionsafe/app/data/services/config_service.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class CalibrationController extends GetxController {
  final _telemetryService = Get.find<TelemetryService>();
  final _configService = Get.find<ConfigService>();
  final _serviceProvider = Get.find<VisionServiceProvider>();

  final isCalibrating = false.obs;
  final progress = 0.0.obs;
  final currentRawDistance = 0.0.obs;
  
  StreamSubscription? _distanceSub;

  @override
  void onInit() {
    super.onInit();
    // Listen to raw distance from telemetry stream
    _distanceSub = _telemetryService.currentDistance.stream.listen((distance) {
      if (distance > 0) {
        currentRawDistance.value = distance;
      }
    });
  }

  @override
  void onClose() {
    _distanceSub?.cancel();
    super.onClose();
  }

  void startCalibration() async {
    isCalibrating.value = true;
    progress.value = 0.0;
    
    double totalDistance = 0.0;
    int count = 0;
    
    // We will collect data for 3 seconds
    const duration = Duration(milliseconds: 3000);
    const tick = Duration(milliseconds: 100);
    int totalTicks = duration.inMilliseconds ~/ tick.inMilliseconds;
    
    for (int i = 0; i <= totalTicks; i++) {
      if (currentRawDistance.value > 0) {
        totalDistance += currentRawDistance.value;
        count++;
      }
      progress.value = i / totalTicks;
      await Future.delayed(tick);
    }
    
    isCalibrating.value = false;

    if (count == 0 || totalDistance == 0) {
      VToast.show("Gagal", "Wajah tidak terdeteksi. Pastikan pencahayaan cukup dan posisikan wajah di depan kamera.", state: VizoState.intervention);
      // Fallback
      return;
    }

    final averageRawDistance = totalDistance / count;
    // Asumsi jarak rentangan tangan adalah 40 cm
    final multiplier = 40.0 / averageRawDistance;

    await _serviceProvider.setCalibrationMultiplier(multiplier);
    await _configService.setHasCalibratedHardware();

    VToast.show("Berhasil!", "Sensor telah dikalibrasi untuk mata Anda.", state: VizoState.happy);
    
    // Kembali ke Home
    Get.back();
  }

  void cancelCalibration() {
    // Matikan service jika user batal kalibrasi pertama kali
    if (!_configService.hasCalibratedHardware) {
      _configService.toggleService(false);
      _serviceProvider.stopService();
    }
    Get.back();
  }
}
