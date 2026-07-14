import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class VisionServiceProvider extends GetxService {
  static const _channel = MethodChannel('com.hn.visionsafe/service');
  final _logger = Logger();

  Future<void> startService() async {
    try {
      final result = await _channel.invokeMethod('startService');
      _logger.i('Native Service: $result');
    } on PlatformException catch (e) {
      _logger.e('Failed to start service: ${e.message}');
    }
  }

  Future<void> stopService() async {
    try {
      final result = await _channel.invokeMethod('stopService');
      _logger.i('Native Service: $result');
    } on PlatformException catch (e) {
      _logger.e('Failed to stop service: ${e.message}');
    }
  }

  Future<bool> checkOverlayPermission() async {
    try {
      return await _channel.invokeMethod('checkOverlayPermission') ?? false;
    } on PlatformException catch (e) {
      _logger.e('Failed to check overlay permission: ${e.message}');
      return false;
    }
  }

  Future<void> requestOverlayPermission() async {
    try {
      await _channel.invokeMethod('requestOverlayPermission');
    } on PlatformException catch (e) {
      _logger.e('Failed to request overlay permission: ${e.message}');
    }
  }

  Future<bool> checkBatteryOptimization() async {
    try {
      return await _channel.invokeMethod('checkBatteryOptimization') ?? false;
    } on PlatformException catch (e) {
      _logger.e('Failed to check battery optimization: ${e.message}');
      return false;
    }
  }

  Future<void> requestIgnoreBatteryOptimization() async {
    try {
      await _channel.invokeMethod('requestIgnoreBatteryOptimization');
    } on PlatformException catch (e) {
      _logger.e('Failed to request ignore battery optimization: ${e.message}');
    }
  }

  Future<void> requestAutoStartPermission() async {
    try {
      await _channel.invokeMethod('requestAutoStartPermission');
    } on PlatformException catch (e) {
      _logger.e('Failed to request auto start permission: ${e.message}');
    }
  }

  Future<bool> checkAccessibilityPermission() async {
    try {
      return await _channel.invokeMethod('checkAccessibilityPermission') ?? false;
    } on PlatformException catch (e) {
      _logger.e('Failed to check accessibility permission: ${e.message}');
      return false;
    }
  }

  Future<void> requestAccessibilityPermission() async {
    try {
      await _channel.invokeMethod('requestAccessibilityPermission');
    } on PlatformException catch (e) {
      _logger.e('Failed to request accessibility permission: ${e.message}');
    }
  }

  Future<bool> isServiceRunning() async {
    try {
      final result = await _channel.invokeMethod<bool>('isServiceRunning');
      return result ?? false;
    } on PlatformException catch (e) {
      _logger.e('Failed to check service state: ${e.message}');
      return false;
    }
  }

  Future<void> updateThreshold(double threshold) async {
    try {
      await _channel.invokeMethod('updateThreshold', {'threshold': threshold});
      _logger.i('Threshold updated to: $threshold');
    } on PlatformException catch (e) {
      _logger.e('Failed to update threshold: ${e.message}');
    }
  }

  Future<void> setCalibrationMultiplier(double multiplier) async {
    try {
      await _channel.invokeMethod('setCalibrationMultiplier', {'multiplier': multiplier});
      _logger.i('Calibration multiplier updated to: $multiplier');
    } on PlatformException catch (e) {
      _logger.e('Failed to update calibration multiplier: ${e.message}');
    }
  }

  Future<void> updateSamplingRate(int samplingRateMs) async {
    try {
      await _channel.invokeMethod('updateSamplingRate', {'samplingRate': samplingRateMs});
      _logger.i('Sampling rate updated to: $samplingRateMs ms');
    } on PlatformException catch (e) {
      _logger.e('Failed to update sampling rate: ${e.message}');
    }
  }

  Future<void> updateGpuDelegation(bool isEnabled) async {
    try {
      await _channel.invokeMethod('updateGpuDelegation', {'isEnabled': isEnabled});
      _logger.i('GPU Delegation updated to: $isEnabled');
    } on PlatformException catch (e) {
      _logger.e('Failed to update GPU delegation: ${e.message}');
    }
  }
}
