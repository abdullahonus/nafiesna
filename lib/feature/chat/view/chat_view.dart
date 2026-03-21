import 'dart:io' show Platform;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/app_init.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/state/chat_poll_provider.dart';
import '../../../product/state/chat_reaction_provider.dart';
import '../../../product/widget/common/username_badge.dart';
import '../../../service/broadcast_chat_service.dart';
import '../model/chat_message.dart';

// ── Provider ─────────────────────────────────────────────────────────────────

final _chatMessagesProvider = StreamProvider.autoDispose<List<ChatMessage>>(
  (_) => BroadcastChatService.instance.messagesStream(),
);

// ── ChatView ─────────────────────────────────────────────────────────────────

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    isChatScreenActive = true;
  }

  @override
  void dispose() {
    isChatScreenActive = false;
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final String text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _controller.clear();
    try {
      await BroadcastChatService.instance.sendMessage(text);
      _scrollToBottom();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mesaj gönderilemedi.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _showCreatePollDialog() {
    final qCtrl = TextEditingController();
    final List<TextEditingController> opts = [
      TextEditingController(),
      TextEditingController(),
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Anket Oluştur'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: qCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Anket Sorusu',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ...List.generate(opts.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: TextField(
                      controller: opts[index],
                      decoration: InputDecoration(
                        labelText: 'Seçenek ${index + 1}',
                        border: const OutlineInputBorder(),
                        suffixIcon: opts.length > 2
                            ? IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setStateDialog(() => opts.removeAt(index));
                                },
                              )
                            : null,
                      ),
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () =>
                      setStateDialog(() => opts.add(TextEditingController())),
                  icon: const Icon(Icons.add),
                  label: const Text('Seçenek Ekle'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final String q = qCtrl.text.trim();
                final List<String> finalOpts = opts
                    .map((e) => e.text.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                if (q.isNotEmpty && finalOpts.length >= 2) {
                  BroadcastChatService.instance.sendPoll(q, finalOpts);
                  Navigator.pop(ctx);
                  _scrollToBottom();
                }
              },
              child: const Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(_chatMessagesProvider);
    final bool canSend = BroadcastChatService.instance.canSend;

    ref.listen(_chatMessagesProvider, (_, next) {
      if (next.hasValue) _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _InfoBanner(canSend: canSend),
          Expanded(
            child: messagesAsync.when(
              data: (List<ChatMessage> messages) {
                if (messages.isEmpty) {
                  return _buildEmpty(context);
                }
                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (_, int i) =>
                      _MessageBubble(message: messages[i]),
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(color: context.colors.accent),
              ),
              error: (_, __) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: context.colors.error,
                      size: 48,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Sohbet yüklenemedi.',
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (canSend)
            _InputBar(
              controller: _controller,
              onSend: _send,
              sending: _sending,
              onPoll: _showCreatePollDialog,
            ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.colors.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.success,
              boxShadow: [
                BoxShadow(
                  color: context.colors.success.withValues(alpha: 0.5),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Sohbet Odası',
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: const [
        UsernameBadge(),
        SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: context.colors.textSecondary.withValues(alpha: 0.3),
            size: 72,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Henüz mesaj yok.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'İlk mesajı bekliyoruz…',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bilgi bandı ───────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.canSend});
  final bool canSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs + 2,
      ),
      color: context.colors.accent.withValues(alpha: 0.07),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            canSend ? Icons.edit_rounded : Icons.visibility_rounded,
            size: 13,
            color: context.colors.accent,
          ),
          const SizedBox(width: 6),
          Text(
            canSend ? 'Mesaj gönderebilirsiniz' : 'Yalnızca okuyabilirsiniz',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mesaj balonu ─────────────────────────────────────────────────────────────

class _MessageBubble extends ConsumerWidget {
  const _MessageBubble({required this.message});
  final ChatMessage message;

  void _showMessageOptionsBottomSheet(BuildContext context, WidgetRef ref) {
    final bool isSultan = BroadcastChatService.instance.canSend;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── WhatsApp Stili Hızlı Emojiler ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...['❤️', '👍', '😂', '😮', '😢', '🙏'].map((emoji) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                          _tryReact(context, ref, emoji);
                        },
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      );
                    }),
                    // (+) Button → Emoji Picker
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        _showEmojiPicker(context, ref);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colors.background,
                        ),
                        child: Icon(
                          Icons.add,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (isSultan) ...[
                Divider(height: 1, color: context.colors.border),
                if (message.pollQuestion == null) // Anketler düzenlenemez
                  ListTile(
                    leading: Icon(
                      Icons.edit_rounded,
                      color: context.colors.primary,
                    ),
                    title: const Text('Düzenle'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showEditDialog(context);
                    },
                  ),
                ListTile(
                  leading: Icon(
                    Icons.delete_rounded,
                    color: context.colors.error,
                  ),
                  title: Text(
                    'Sil',
                    style: TextStyle(color: context.colors.error),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    BroadcastChatService.instance.deleteMessage(message.id);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Reaksiyon eklemeye çalış — zaten bu mesaja react atılmışsa SnackBar göster.
  void _tryReact(BuildContext context, WidgetRef ref, String emoji) async {
    final notifier = ref.read(chatReactionProvider.notifier);
    final bool success = await notifier.toggleReaction(message.id, emoji);
    if (!success) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bu mesaja zaten tepki verdiniz.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }
    // Başarılı — Firestore'a da yansıt
    final bool isAdding = ref
        .read(chatReactionProvider)
        .contains('${message.id}_$emoji');
    BroadcastChatService.instance.toggleReaction(message.id, emoji, isAdding);
  }

  void _showEmojiPicker(BuildContext context, WidgetRef ref) {
    // Zaten bu mesaja react atıldıysa uyar
    if (ref
        .read(chatReactionProvider.notifier)
        .hasReactedToMessage(message.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu mesaja zaten tepki verdiniz.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        height: 350,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            Navigator.pop(ctx);
            _tryReact(context, ref, emoji.emoji);
          },
          config: Config(
            height: 350,
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
            ),
            categoryViewConfig: const CategoryViewConfig(),
            bottomActionBarConfig: const BottomActionBarConfig(enabled: false),
            searchViewConfig: const SearchViewConfig(),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final ctrl = TextEditingController(text: message.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mesajı Düzenle'),
        content: TextField(
          controller: ctrl,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                BroadcastChatService.instance.editMessage(
                  message.id,
                  ctrl.text,
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Widget _buildPoll(BuildContext context, WidgetRef ref) {
    final totalVotes = message.pollVotes?.values.fold(0, (a, b) => a + b) ?? 0;
    final String? myVote = ref.watch(chatPollProvider)[message.id];

    return Container(
      margin: const EdgeInsets.only(left: 40),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 ${message.pollQuestion!}',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (message.pollOptions != null)
            ...List.generate(message.pollOptions!.length, (index) {
              final option = message.pollOptions![index];
              final String idxStr = index.toString();
              final int count = message.pollVotes?[idxStr] ?? 0;
              final double ratio = totalVotes == 0 ? 0 : count / totalVotes;
              final bool isSelected = myVote == idxStr;

              return GestureDetector(
                onTap: () {
                  if (myVote == null) {
                    ref
                        .read(chatPollProvider.notifier)
                        .setVote(message.id, idxStr);
                    BroadcastChatService.instance.votePoll(
                      message.id,
                      idxStr,
                      true,
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.border,
                    ),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: ratio,
                        child: Container(
                          height: 40,
                          color: isSelected
                              ? context.colors.primary.withValues(alpha: 0.2)
                              : context.colors.primary.withValues(alpha: 0.05),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                option,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (totalVotes > 0)
                              Text(
                                '$count oy',
                                style: context.textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          Text(
            '$totalVotes Toplam Oy',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String timeStr = DateFormat(
      'HH:mm',
      'tr_TR',
    ).format(message.createdAt);
    final String dateStr = DateFormat(
      'd MMMM',
      'tr_TR',
    ).format(message.createdAt);

    // Yalnızca 0'dan büyük reaksiyonları al
    final activeReactions = message.reactions.entries
        .where((e) => e.value > 0)
        .toList();

    return GestureDetector(
      onLongPress: () => _showMessageOptionsBottomSheet(context, ref),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gönderen satırı
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [context.colors.primary, context.colors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'sultan',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  '$dateStr · $timeStr',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Mesaj İçeriği (Anket veya Metin) & Reaksiyonların overlapı
            Stack(
              clipBehavior: Clip.none,
              children: [
                // İçerik Kapsayıcısı
                Container(
                  margin: EdgeInsets.only(
                    bottom: activeReactions.isNotEmpty ? 12 : 0,
                  ),
                  child: message.pollQuestion != null
                      ? _buildPoll(context, ref)
                      : Container(
                          margin: const EdgeInsets.only(left: 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm + 2,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            border: Border.all(
                              color: context.colors.border.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            message.text,
                            style: context.textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ),
                ),

                // Overlap (WhatsApp Tipi) Reaksiyon Çubuğu
                if (activeReactions.isNotEmpty)
                  Positioned(
                    bottom: -2,
                    left: 44,
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: activeReactions.map((e) {
                        return _ReactionChip(
                          messageId: message.id,
                          emoji: e.key,
                          count: e.value,
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reaksiyon Butonu ─────────────────────────────────────────────────────────

class _ReactionChip extends ConsumerWidget {
  const _ReactionChip({
    required this.messageId,
    required this.emoji,
    required this.count,
  });
  final String messageId;
  final String emoji;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (count == 0) return const SizedBox.shrink(); // Ek koruma

    final reactedSet = ref.watch(chatReactionProvider);
    final String key = '${messageId}_$emoji';
    final bool isSelected = reactedSet.contains(key);

    return GestureDetector(
      onTap: () async {
        final bool isAdding = !isSelected;
        final bool success = await ref
            .read(chatReactionProvider.notifier)
            .toggleReaction(messageId, emoji);
        if (!success) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bu mesaja zaten tepki verdiniz.'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
          }
          return;
        }
        BroadcastChatService.instance.toggleReaction(
          messageId,
          emoji,
          isAdding,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary.withValues(alpha: 0.15)
              : context.colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? context.colors.primary.withValues(alpha: 0.5)
                : context.colors.border.withValues(alpha: 0.4),
            width: 0.8,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: context.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? context.colors.primary
                    : context.colors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _ReactionAddBtn kaldırıldı çünkü long-press'e taşındı.

// ── Yazma alanı (sadece sultan'a görünür) ─────────────────────────────────────

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.sending,
    required this.onPoll,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool sending;
  final VoidCallback onPoll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm + MediaQuery.of(context).padding.bottom * 0.5,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(
          top: BorderSide(color: context.colors.border.withValues(alpha: 0.6)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.poll_outlined, color: context.colors.primary),
            onPressed: onPoll,
            tooltip: 'Anket Oluştur',
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: context.textTheme.bodyMedium,
              maxLines: 4,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Mesaj yaz…',
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textHint,
                ),
                filled: true,
                fillColor: context.colors.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: context.colors.border,
                    width: 0.6,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: context.colors.accent,
                    width: 1.2,
                  ),
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Gönder butonu
          GestureDetector(
            onTap: sending ? null : onSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.primary,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: sending
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
