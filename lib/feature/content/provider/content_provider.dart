import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/content_notifier.dart';

final contentProvider = StateNotifierProvider<ContentNotifier, ContentState>(
  (ref) => ContentNotifier(),
);
