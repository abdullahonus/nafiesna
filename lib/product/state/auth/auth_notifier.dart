import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> loginAsGuest() async {
    state = state.copyWith(isLoading: true, errorMessage: null, userId: null);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authKey, UserRole.guest.name);
    state = state.copyWith(role: UserRole.guest, isLoading: false);
  }

  Future<void> loginAsAuthorized(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null, userId: null);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authKey, UserRole.authorized.name);
      state = state.copyWith(
        role: UserRole.authorized,
        isLoading: false,
        userId: _auth.currentUser?.uid,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Giriş yapılamadı.';
      if (e.code == 'user-not-found') {
        message = 'Kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        message = 'Hatalı şifre.';
      } else if (e.code == 'invalid-email') {
        message = 'Geçersiz e-posta.';
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
    await _auth.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
    state = state.copyWith(
      role: UserRole.unauthenticated,
      isLoading: false,
      userId: null,
    );
  }
}
