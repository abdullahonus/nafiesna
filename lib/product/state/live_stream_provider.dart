import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../init/app_init.dart';

/// Global ValueNotifier for reacting to Live Stream URL changes
final ValueNotifier<String?> liveStreamUrlNotifier = ValueNotifier<String?>(null);

/// Loads the initial URL from SharedPreferences
Future<void> loadInitialLiveStreamUrl() async {
  final prefs = await SharedPreferences.getInstance();
  liveStreamUrlNotifier.value = prefs.getString(kLiveStreamUrlKey);
}

/// Updates the URL both in SharedPreferences and the ValueNotifier
Future<void> updateLiveStreamUrl(String url) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(kLiveStreamUrlKey, url);
  liveStreamUrlNotifier.value = url;
}
