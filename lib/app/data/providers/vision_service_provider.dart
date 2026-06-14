import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class VisionServiceProvider extends GetxService {
  static const _channel = MethodChannel('com.irsyad.visionsafe/service');
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

  Future<void> updateSamplingRate(int samplingRateMs) async {
    try {
      await _channel.invokeMethod('updateSamplingRate', {'samplingRate': samplingRateMs});
      _logger.i('Sampling rate updated to: $samplingRateMs ms');
    } on PlatformException catch (e) {
      _logger.e('Failed to update sampling rate: ${e.message}');
    }
  }
}
