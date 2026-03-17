import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../utility/injection/injection.dart';
import '../navigation/app_router.dart';

class AppInit {
  AppInit._();

  static Future<void> make() async {
    WidgetsFlutterBinding.ensureInitialized();

    await initializeDateFormatting('tr_TR');

    await configureDependencies();

    getIt.registerSingleton<AppRouter>(AppRouter());
  }
}
