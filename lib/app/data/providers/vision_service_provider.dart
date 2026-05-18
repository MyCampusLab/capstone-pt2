import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:visionsafe/app/data/models/telemetry_model.dart';

class VisionServiceProvider extends GetxService {
  static const _channel = MethodChannel('com.irsyad.visionsafe/service');
  static const _eventChannel = EventChannel('com.irsyad.visionsafe/telemetry');
  final _logger = Logger();

  Stream<TelemetryModel> get telemetryStream {
    return _eventChannel.receiveBroadcastStream().map((dynamic event) {
      if (event is Map) {
        return TelemetryModel.fromMap(event.cast<String, dynamic>());
      }
      throw PlatformException(code: 'INVALID_DATA', message: 'Expected Map from native');
    }).handleError((Object error) {
      _logger.e('Native Telemetry Stream Error: $error');
    });
  }

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
}
