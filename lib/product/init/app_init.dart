import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../utility/injection/injection.dart';
import '../navigation/app_router.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM background message: ${message.messageId}');
}

class AppInit {
  AppInit._();

  static Future<void> make() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await initializeDateFormatting('tr_TR');

    await configureDependencies();

    getIt.registerSingleton<AppRouter>(AppRouter());

    await _requestLocationPermission();

    _setupFirebaseMessaging();
  }

  static void _setupFirebaseMessaging() {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.requestPermission().then((NotificationSettings settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        _subscribeToTopicWhenReady(messaging);

        if (kDebugMode) {
          messaging.getToken().then((String? token) {
            debugPrint('FCM Token: $token');
          });
        }
      }
    });

    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM foreground: ${message.notification?.title}');
    });
  }

  static Future<void> _subscribeToTopicWhenReady(
    FirebaseMessaging messaging,
  ) async {
    for (int i = 0; i < 10; i++) {
      try {
        final String? apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) {
          await messaging.subscribeToTopic('live_stream');
          debugPrint('FCM: subscribed to live_stream topic');
          return;
        }
      } catch (e) {
        debugPrint('FCM: APNS token not ready yet (attempt ${i + 1})');
      }
      await Future<void>.delayed(const Duration(seconds: 3));
    }
    debugPrint('FCM: Could not subscribe — APNS token not available');
  }

  static Future<void> _requestLocationPermission() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }
}
