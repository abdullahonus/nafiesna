import 'package:cloud_firestore/cloud_firestore.dart';

/// Broadcast chat mesaj modeli.
/// Sadece `sultan@nafiesna.com` oluşturabilir.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.senderEmail,
    required this.createdAt,
    this.reactions = const {},
    this.pollQuestion,
    this.pollOptions,
    this.pollVotes,
  });

  final String id;
  final String text;
  final String senderEmail;
  final DateTime createdAt;
  final Map<String, int> reactions;
  
  // -- Anket (Poll) --
  final String? pollQuestion;
  final List<String>? pollOptions;
  final Map<String, int>? pollVotes; // index str -> count

  factory ChatMessage.fromDoc(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    // Reactions
    final Map<String, int> parsedReactions = {};
    if (data['reactions'] is Map) {
      final Map<dynamic, dynamic> rData = data['reactions'] as Map;
      rData.forEach((dynamic k, dynamic v) {
        if (k is String && (v is int || v is double)) {
          parsedReactions[k] = (v as num).toInt();
        }
      });
    }

    // Poll Votes
    final Map<String, int> parsedVotes = {};
    if (data['pollVotes'] is Map) {
      final Map<dynamic, dynamic> vData = data['pollVotes'] as Map;
      vData.forEach((dynamic k, dynamic v) {
        if (k is String && (v is int || v is double)) {
          parsedVotes[k] = (v as num).toInt();
        }
      });
    }

    return ChatMessage(
      id: doc.id,
      text: data['text'] as String? ?? '',
      senderEmail: data['senderEmail'] as String? ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reactions: parsedReactions,
      pollQuestion: data['pollQuestion'] as String?,
      pollOptions: (data['pollOptions'] as List<dynamic>?)
          ?.map((dynamic e) => e.toString())
          .toList(),
      pollVotes: parsedVotes.isEmpty ? null : parsedVotes,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'text': text,
      'senderEmail': senderEmail,
      'createdAt': FieldValue.serverTimestamp(),
      'reactions': reactions,
    };

    if (pollQuestion != null) {
      map['pollQuestion'] = pollQuestion;
      map['pollOptions'] = pollOptions;
      map['pollVotes'] = pollVotes ?? const <String, int>{};
    }

    return map;
  }
}
