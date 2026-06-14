import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

enum LogSeverity { info, warn, error, critical }

class ObservabilityService extends GetxService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 80,
      colors: true,
      printEmojis: false,
    ),
  );

  final RxList<String> inMemoryLogs = <String>[].obs;

  void log({
    required LogSeverity severity,
    required String category,
    required String message,
    String? userId,
    Map<String, dynamic>? payload,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Simpan log ke buffer memori untuk ditampilkan di UI log interaktif
    final timeStr = DateTime.now().toLocal().toString().substring(11, 19);
    final textLog = '[$timeStr] [${severity.name.toUpperCase()}] [$category] $message';
    inMemoryLogs.insert(0, textLog);
    if (inMemoryLogs.length > 150) {
      inMemoryLogs.removeLast();
    }

    final structuredPayload = {
      'timestamp': DateTime.now().toIso8601String(),
      'severity': severity.name.toUpperCase(),
      'category': category,
      'message': message,
      // ignore: use_null_aware_elements
      if (userId != null) 'user_id': userId,
      // ignore: use_null_aware_elements
      if (payload != null) 'payload': payload,
      // ignore: use_null_aware_elements
      if (error != null) 'error': error.toString(),
    };

    final formattedMessage = json.encode(structuredPayload);
    
    // Output JSON directly to stdout/console for log aggregators in production
    if (!kDebugMode) {
      debugPrint(formattedMessage);
    }

    switch (severity) {
      case LogSeverity.info:
        if (kDebugMode) _logger.i('[$category] $message', error: error);
        break;
      case LogSeverity.warn:
        _logger.w('[$category] $message', error: error);
        break;
      case LogSeverity.error:
        _logger.e('[$category] $message', error: error, stackTrace: stackTrace);
        break;
      case LogSeverity.critical:
        _logger.f('[$category] CRITICAL: $message', error: error, stackTrace: stackTrace);
        break;
    }
  }

  // Performance monitoring tracer
  Future<T> trace<T>({
    required String operationName,
    required Future<T> Function() operation,
    Map<String, dynamic>? additionalPayload,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();
      log(
        severity: LogSeverity.info,
        category: 'PERFORMANCE',
        message: 'Operation $operationName completed in ${stopwatch.elapsedMilliseconds}ms',
        payload: {
          'duration_ms': stopwatch.elapsedMilliseconds,
          if (additionalPayload != null) ...additionalPayload,
        },
      );
      return result;
    } catch (e, stack) {
      stopwatch.stop();
      log(
        severity: LogSeverity.error,
        category: 'PERFORMANCE_FAILED',
        message: 'Operation $operationName failed after ${stopwatch.elapsedMilliseconds}ms: $e',
        payload: {
          'duration_ms': stopwatch.elapsedMilliseconds,
          if (additionalPayload != null) ...additionalPayload,
        },
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}
