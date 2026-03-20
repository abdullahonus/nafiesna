import 'package:auto_route/auto_route.dart';
import '../state/auth/auth_provider.dart';
import '../state/auth/model/user_role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard(this.ref);
  final Ref ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final role = ref.read(authProvider).role;
    final isAuthenticated = role != UserRole.unauthenticated;

    if (isAuthenticated) {
      resolver.next(true);
    } else {
      // router.root → ensures we always operate on the root-level stack,
      // not the nested tab router.
      router.root.replaceAll([const LoginRoute()]);
    }
  }
}
