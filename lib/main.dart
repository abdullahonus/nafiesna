import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product/init/app_init.dart';
import 'product/init/theme/app_theme.dart';
import 'product/navigation/app_router.dart';
import 'product/utility/injection/injection.dart';

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
    final router = getIt<AppRouter>();

    return MaterialApp.router(
      title: 'NafieSna',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router.config(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.noScaling,
        ),
        child: child!,
      ),
    );
  }
}
