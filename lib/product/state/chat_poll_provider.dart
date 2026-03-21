import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının anketlere verdiği oyları cihazda tutar (Spam engeli).
/// Format: `Map<String, String>` -> `messageId: optionIndex`
class ChatPollNotifier extends StateNotifier<Map<String, String>> {
  ChatPollNotifier() : super(const <String, String>{}) {
    _init();
  }

  static const String _key = 'user_chat_poll_votes';

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList(_key);
    if (saved != null) {
      final Map<String, String> map = {};
      for (final item in saved) {
        final parts = item.split('::');
        if (parts.length == 2) {
          map[parts[0]] = parts[1];
        }
      }
      state = map;
    }
  }

  String? getVotedOption(String messageId) {
    return state[messageId];
  }

  Future<void> setVote(String messageId, String optionIndex) async {
    final Map<String, String> newState = Map<String, String>.from(state);
    newState[messageId] = optionIndex;
    
    state = newState;
    
    final prefs = await SharedPreferences.getInstance();
    final List<String> saveList = newState.entries.map((e) => '${e.key}::${e.value}').toList();
    await prefs.setStringList(_key, saveList);
  }
}

final chatPollProvider = StateNotifierProvider<ChatPollNotifier, Map<String, String>>(
  (ref) => ChatPollNotifier(),
);
