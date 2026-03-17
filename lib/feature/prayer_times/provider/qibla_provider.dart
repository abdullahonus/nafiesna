import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../service/location_service.dart';
import '../../../service/qibla_service.dart';
import '../notifier/qibla_notifier.dart';

final qiblaProvider = StateNotifierProvider.autoDispose<QiblaNotifier, QiblaState>(
  (ref) => QiblaNotifier(
    QiblaService(),
    LocationService(),
  ),
);
