import 'package:auto_route/auto_route.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product/init/app_init.dart';
import 'product/init/theme/app_theme.dart';
import 'product/navigation/app_router_provider.dart';
import 'product/state/auth/auth_provider.dart';

void main() async {
  await AppInit.make();
  runApp(
    const ProviderScope(
      child: NafiesnaApp(),
    ),
  );
}

class NafiesnaApp extends ConsumerWidget {
  const NafiesnaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'NafieSna',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router.config(
        reevaluateListenable: ReevaluateListenable.stream(
          ref.watch(authProvider.notifier).stream,
        ),
        navigatorObservers: () => [
          if (kDebugMode) ChuckerFlutter.navigatorObserver,
        ],
      ),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.noScaling,
        ),
        child: child!,
      ),
    );
  }
}
