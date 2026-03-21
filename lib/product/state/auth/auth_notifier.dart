import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart';
import 'model/user_role.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  static const String _authKey = 'user_auth_role';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? roleName = prefs.getString(_authKey);

    if (roleName != null) {
      final UserRole role = UserRole.values.firstWhere(
        (e) => e.name == roleName,
        orElse: () => UserRole.unauthenticated,
      );

      // Check if actually logged into firebase if we are authorized
      if (role == UserRole.authorized && _auth.currentUser == null) {
        state = state.copyWith(
          role: UserRole.unauthenticated,
          isLoading: false,
        );
        await prefs.remove(_authKey);
        return;
      }

      state = state.copyWith(
        role: role,
        isLoading: false,
        userId: _auth.currentUser?.uid,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Cihazın benzersiz kimliğini döndürür.
  Future<String> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo android = await deviceInfo.androidInfo;
      return android.id; // Android unique build ID
    } else if (Platform.isIOS) {
      final IosDeviceInfo ios = await deviceInfo.iosInfo;
      return ios.identifierForVendor ?? 'unknown_ios';
    }
    return 'unknown_device';
  }

  Future<void> loginAsGuest() async {
    state = state.copyWith(isLoading: true, errorMessage: null, userId: null);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authKey, UserRole.guest.name);
    state = state.copyWith(role: UserRole.guest, isLoading: false);
  }

  Future<void> loginAsAuthorized(String email, String password) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearUserId: true,
    );
    try {
      // 1. Firebase Auth ile giriş yap
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final String uid = _auth.currentUser!.uid;

      // 2. Cihaz kimliğini al
      final String deviceId = await _getDeviceId();

      // 3. Firestore'da kullanıcı kaydını kontrol et
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        // Kayıt var — deviceId eşleşiyor mu?
        final Map<String, dynamic> data =
            userDoc.data()! as Map<String, dynamic>;
        final String? existingDeviceId = data['deviceId'] as String?;

        if (existingDeviceId != null && existingDeviceId != deviceId) {
          // Farklı cihaz → erişim reddedilir
          await _auth.signOut();
          state = state.copyWith(
            isLoading: false,
            errorMessage:
                'Bu hesap başka bir cihazda aktif edilmiş. Giriş yapılamaz.',
          );
          return;
        }

        // Aynı cihaz — normal devam
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(_authKey, UserRole.authorized.name);
        state = state.copyWith(
          role: UserRole.authorized,
          isLoading: false,
          userId: uid,
        );
        await _subscribeToNotifications();
        return;
      }

      // 4. İlk giriş — Cloud Function çağır (aktivasyon + şifre değişimi)
      try {
        final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'activateAccount',
        );
        await callable.call<dynamic>({'deviceId': deviceId});
      } catch (e) {
        // Cloud Function başarısız olursa geri al
        await _auth.signOut();
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Hesap aktive edilemedi. Lütfen tekrar deneyin.',
        );
        return;
      }

      // 5. Aktivasyon başarılı — oturumu kapat ve yeni şifreyle giriş yap
      // (Cloud Function şifreyi değiştirdi, mevcut token hâlâ geçerli)
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authKey, UserRole.authorized.name);
      state = state.copyWith(
        role: UserRole.authorized,
        isLoading: false,
        userId: uid,
      );
      await _subscribeToNotifications();
    } on FirebaseAuthException catch (e) {
      String message = 'Giriş yapılamadı.';
      if (e.code == 'user-not-found') {
        message = 'Kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        message = 'Hatalı şifre.';
      } else if (e.code == 'invalid-email') {
        message = 'Geçersiz e-posta.';
      } else if (e.code == 'invalid-credential') {
        message = 'Hatalı kullanıcı adı veya şifre.';
      }
      state = state.copyWith(isLoading: false, errorMessage: message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Bir hata oluştu.',
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _unsubscribeFromNotifications();
    await _auth.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
    state = state.copyWith(
      role: UserRole.unauthenticated,
      isLoading: false,
      clearUserId: true,
      clearError: true,
    );
  }

  /// FCM topic'lerine abone ol (sadece authorized kullanıcılar).
  Future<void> _subscribeToNotifications() async {
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.subscribeToTopic('live_stream');
      await messaging.subscribeToTopic('chat_messages');
      debugPrint('FCM: Bildirim topic\'larına abone olundu.');
    } catch (e) {
      debugPrint('FCM: Topic subscribe hatası — $e');
    }
  }

  /// FCM topic aboneliklerini kaldır (logout).
  Future<void> _unsubscribeFromNotifications() async {
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.unsubscribeFromTopic('live_stream');
      await messaging.unsubscribeFromTopic('chat_messages');
      debugPrint('FCM: Bildirim topic\'larından çıkıldı.');
    } catch (e) {
      debugPrint('FCM: Topic unsubscribe hatası — $e');
    }
  }
}
