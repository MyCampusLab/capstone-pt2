import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_toast.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

class PushNotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final _logger = Logger();

  Future<PushNotificationService> init() async {
    try {
      // 1. Request permissions for iOS and Android 13+
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _logger.i('User granted permission for Push Notifications');
      } else {
        _logger.w('User declined or has not accepted Push Notification permission');
      }

      // 2. Get the FCM Token
      String? token = await _fcm.getToken();
      _logger.i('FCM Token: $token');
      // Token ini dapat disimpan ke database Supabase untuk routing spesifik

      // 3. Handle messages when the app is in the foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _logger.i('Foreground Message Received: ${message.notification?.title}');
        
        if (message.notification != null) {
          VToast.show(
            message.notification!.title ?? 'Peringatan Sistem', 
            message.notification!.body ?? '', 
            state: VizoState.worried,
          );
        }
      });

      // 4. Handle notification clicks when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _logger.i('Notification Clicked: ${message.data}');
      });

    } catch (e) {
      _logger.e('Failed to initialize Push Notifications: $e');
    }

    return this;
  }
}
