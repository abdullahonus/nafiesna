import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../feature/chat/model/chat_message.dart';

/// Yayın odası chat servisi.
///
/// **Yetki kuralı:** Sadece `sultan@nafiesna.com` mesaj gönderebilir.
/// Herkes (misafir dahil) okuyabilir.
///
/// Firestore yapısı:
/// ```
/// broadcast_chat/messages/{id}
///   - text: String
///   - senderEmail: String
///   - createdAt: Timestamp
/// ```
class BroadcastChatService {
  BroadcastChatService._();
  static final BroadcastChatService instance = BroadcastChatService._();

  static const String _collection = 'broadcast_chat';
  static const String _subCollection = 'messages';
  static const String _broadcasterEmail = 'sultan@nafiesna.com';
  static const int _messageLimit = 100;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ref =>
      _db.collection(_collection).doc('room').collection(_subCollection);

  /// Mesaj yazma yetkisi var mı?
  bool get canSend =>
      FirebaseAuth.instance.currentUser?.email == _broadcasterEmail;

  /// Real-time mesaj akışı — son [_messageLimit] mesaj, eskiden yeniye.
  Stream<List<ChatMessage>> messagesStream() {
    return _ref
        .orderBy('createdAt', descending: false)
        .limitToLast(_messageLimit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(ChatMessage.fromDoc)
              .toList(),
        );
  }

  /// Mesaj gönder. Sadece sultan@nafiesna.com çağırabilmeli.
  Future<void> sendMessage(String text) async {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return;
    if (!canSend) return; // UI guard — Firestore rules da bloklar

    final String? email = FirebaseAuth.instance.currentUser?.email;
    await _ref.add({
      'text': trimmed,
      'senderEmail': email,
      'createdAt': FieldValue.serverTimestamp(),
      'reactions': const <String, int>{},
    });
  }

  /// Mesaj düzenle. Sadece sultan@nafiesna.com çağırabilmeli.
  Future<void> editMessage(String messageId, String newText) async {
    final String trimmed = newText.trim();
    if (trimmed.isEmpty) return;
    if (!canSend) return;

    await _ref.doc(messageId).update({
      'text': trimmed,
    });
  }

  /// Mesaj sil. Sadece sultan@nafiesna.com çağırabilmeli.
  Future<void> deleteMessage(String messageId) async {
    if (!canSend) return;
    await _ref.doc(messageId).delete();
  }

  /// Anket gönder. Sadece sultan@nafiesna.com
  Future<void> sendPoll(String question, List<String> options) async {
    final String trimmedQ = question.trim();
    if (trimmedQ.isEmpty || options.isEmpty) return;
    if (!canSend) return;

    final String? email = FirebaseAuth.instance.currentUser?.email;
    await _ref.add({
      'text': 'Anket: $trimmedQ',
      'senderEmail': email,
      'createdAt': FieldValue.serverTimestamp(),
      'reactions': const <String, int>{},
      'pollQuestion': trimmedQ,
      'pollOptions': options,
      'pollVotes': const <String, int>{},
    });
  }

  /// Mesaja reaksiyon (emoji) sayısını artır veya azalt.
  /// Firestore'daki `reactions.EMOJI` key'ini 1 veya -1 artırır.
  Future<void> toggleReaction(String messageId, String emoji, bool isAdding) async {
    try {
      await _ref.doc(messageId).update({
        'reactions.$emoji': FieldValue.increment(isAdding ? 1 : -1),
      });
    } catch (e) {
      // Konsola sessiz hata yazarız
      // log('FCM: Reaksiyon eklenemedi — $e');
    }
  }

  /// Ankete oy ver (veya oyu geri çek).
  /// Firestore'daki `pollVotes.INDEX` key'ini 1 veya -1 artırır.
  Future<void> votePoll(String messageId, String optionIndex, bool isAdding) async {
    try {
      await _ref.doc(messageId).update({
        'pollVotes.$optionIndex': FieldValue.increment(isAdding ? 1 : -1),
      });
    } catch (e) {
      // log('FCM: Oy gönderilemedi — $e');
    }
  }
}
