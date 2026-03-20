import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';
import 'auth_guard.dart';

final authGuardProvider = Provider((ref) => AuthGuard(ref));

final appRouterProvider = Provider((ref) {
  final authGuard = ref.watch(authGuardProvider);
  return AppRouter(authGuard: authGuard);
});
