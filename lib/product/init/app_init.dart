import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../navigation/app_router.dart';
import '../utility/injection/injection.dart';

const String kLiveStreamUrlKey = 'last_live_stream_url';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final String? url = message.data['url'] as String?;
  if (url != null && url.isNotEmpty) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(kLiveStreamUrlKey, url);
  }
  debugPrint('FCM background message: ${message.messageId}');
}

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
  'live_stream_channel',
  'Canlı Yayın Bildirimleri',
  description: 'NafiEsna canlı yayın bildirimleri',
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('hu'),
);

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

    await _initLocalNotifications();

    // unawaited bırakıyoruz — FCM setup arka planda çalışsın, uygulama bloklanmasın
    _setupFirebaseMessaging().catchError((Object e) {
      debugPrint('FCM: setup hatası — $e');
    });
  }

  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  static Future<void> _onNotificationTap(NotificationResponse response) async {
    final String? url = response.payload;
    if (url == null || url.isEmpty) return;

    final Uri uri = Uri.parse(url);
    try {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      }
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Notification tap URL açılamadı — $e');
    }
  }

  static Future<void> _setupFirebaseMessaging() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // İzin iste — hata durumunda sessizce devam et
    try {
      final NotificationSettings settings = await messaging.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // iOS'ta APNS token geç gelebilir; hata yönetimli fire-and-forget
        _subscribeToTopicWhenReady(messaging).catchError((Object e) {
          debugPrint('FCM: topic subscribe hatası — $e');
        });

        if (kDebugMode) {
          // getToken() iOS'ta APNS token hazır değilse fırlatır → catchError zorunlu
          messaging
              .getToken()
              .then((String? token) {
                debugPrint('FCM Token: $token');
              })
              .catchError((Object e) {
                debugPrint('FCM: getToken hatası (simülatörde beklenen) — $e');
              });
        }
      }
    } catch (e) {
      debugPrint('FCM: requestPermission hatası — $e');
    }

    // Ön plan bildirim ayarları
    try {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      debugPrint('FCM: foreground options hatası — $e');
    }

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleFcmTap);

    // Uygulama kapalıyken gelen mesaj — APNS hatası fırlatabileceğinden guard et
    messaging
        .getInitialMessage()
        .then((RemoteMessage? message) {
          if (message != null) _handleFcmTap(message);
        })
        .catchError((Object e) {
          debugPrint('FCM: getInitialMessage hatası — $e');
        });
  }

  static Future<void> _saveLiveUrl(RemoteMessage message) async {
    final String? url = message.data['url'] as String?;
    if (url == null || url.isEmpty) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(kLiveStreamUrlKey, url);
    debugPrint('FCM: live stream URL saved — $url');
  }

  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    await _saveLiveUrl(message);

    final RemoteNotification? notification = message.notification;
    if (notification == null) return;

    final String? url = message.data['url'] as String?;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('hu'),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'hu.mp3',
        ),
      ),
      payload: url,
    );
  }

  static Future<void> _handleFcmTap(RemoteMessage message) async {
    await _saveLiveUrl(message);
    final String? url = message.data['url'] as String?;
    if (url == null || url.isEmpty) return;

    final Uri uri = Uri.parse(url);
    try {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      }
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('FCM: URL açılamadı — $e');
    }
  }

  static Future<void> _subscribeToTopicWhenReady(
    FirebaseMessaging messaging,
  ) async {
    if (Platform.isAndroid) {
      await messaging.subscribeToTopic('live_stream');
      debugPrint('FCM: live_stream topic\'a abone olundu (Android)');
      return;
    }

    // iOS: APNS token cihaza gelmeden subscribe yapılamaz.
    // Simülatörde APNS hiç gelmez; max 5 deneme × 4 saniye = 20 saniye.
    const int maxAttempts = 5;
    const Duration retryDelay = Duration(seconds: 4);

    for (int i = 0; i < maxAttempts; i++) {
      try {
        final String? apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null && apnsToken.isNotEmpty) {
          await messaging.subscribeToTopic('live_stream');
          debugPrint('FCM: live_stream topic\'a abone olundu (iOS)');
          return;
        }
        // Token null → henüz hazır değil, bekle
        debugPrint('FCM: APNS token henüz yok (deneme ${i + 1}/$maxAttempts)');
      } on FirebaseException catch (e) {
        // [apns-token-not-set] beklenen hata — sessizce devam et
        debugPrint(
          'FCM: APNS token hazır değil (deneme ${i + 1}/$maxAttempts) — ${e.code}',
        );
      } catch (e) {
        debugPrint('FCM: beklenmedik hata (deneme ${i + 1}) — $e');
      }

      if (i < maxAttempts - 1) {
        await Future<void>.delayed(retryDelay);
      }
    }

    debugPrint('FCM: APNS token alınamadı — topic subscribe yapılamadı.');
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
