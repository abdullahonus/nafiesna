import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/content_notifier.dart';
import '../../../service/islamic_calendar_service.dart';

final _calendarServiceProvider = Provider(
  (ref) => IslamicCalendarService(),
);

final contentProvider = StateNotifierProvider<ContentNotifier, ContentState>(
  (ref) => ContentNotifier(ref.read(_calendarServiceProvider)),
);
