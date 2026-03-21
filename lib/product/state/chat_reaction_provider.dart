import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının chat mesajlarına attığı reaksiyonları cihazda tutar (Spam engeli).
/// Format: `Set<String>` -> `"messageId_emoji"`
///
/// **Kısıtlama:** Bir kullanıcı bir mesaja yalnızca 1 kez reaksiyon atabilir.
/// Farklı emoji olsa bile aynı mesaja ikinci reaksiyon engellenir.
class ChatReactionNotifier extends StateNotifier<Set<String>> {
  ChatReactionNotifier() : super(const <String>{}) {
    _init();
  }

  static const String _key = 'user_chat_reactions';

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? saved = prefs.getStringList(_key);
    if (saved != null) {
      state = saved.toSet();
    }
  }

  bool hasReacted(String messageId, String emoji) {
    return state.contains('${messageId}_$emoji');
  }

  /// Bu mesaja herhangi bir emoji ile react atılmış mı?
  bool hasReactedToMessage(String messageId) {
    final prefix = '${messageId}_';
    return state.any((s) => s.startsWith(prefix));
  }

  /// Reaksiyon toggle. Eğer zaten bu mesaja başka bir emoji ile react atılmışsa
  /// yeni emoji eklenmez ve `false` döner. Kendi eski reaksiyonunu geri çekmek serbesttir.
  Future<bool> toggleReaction(String messageId, String emoji) async {
    final String item = '${messageId}_$emoji';
    final Set<String> newState = Set<String>.from(state);

    if (newState.contains(item)) {
      // Geri çekme — her zaman izin ver
      newState.remove(item);
    } else {
      // Yeni ekleme — aynı mesaja daha önce react atılmış mı kontrol et
      final prefix = '${messageId}_';
      if (newState.any((s) => s.startsWith(prefix))) {
        return false; // Zaten başka bir emoji ile react atılmış
      }
      newState.add(item);
    }

    state = newState;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, newState.toList());
    return true;
  }
}

final chatReactionProvider =
    StateNotifierProvider<ChatReactionNotifier, Set<String>>(
      (ref) => ChatReactionNotifier(),
    );
