import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../service/dream_journal_service.dart';

final _dreamServiceProvider = Provider((ref) => DreamJournalService());

final _dreamsProvider = FutureProvider<List<DreamEntry>>((ref) {
  return ref.read(_dreamServiceProvider).getAll();
});

class DreamJournalPage extends ConsumerWidget {
  const DreamJournalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dreamsAsync = ref.watch(_dreamsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Rüya Defterim',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.accent,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context, ref),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: dreamsAsync.when(
        data: (List<DreamEntry> dreams) => dreams.isEmpty
            ? _buildEmpty()
            : _buildList(context, ref, dreams),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (_, __) => const Center(
          child: Text('Rüyalar yüklenirken hata oluştu.', style: AppTextStyles.bodyMedium),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_stories_rounded,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
            size: 64,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Henüz rüya kaydınız yok.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Sağ alttaki + butonuyla yeni rüya ekleyin.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<DreamEntry> dreams,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: dreams.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, int index) {
        final DreamEntry dream = dreams[index];
        return _DreamCard(
          dream: dream,
          onTap: () => _openEditor(context, ref, existingDream: dream),
          onDelete: () => _deleteDream(context, ref, dream),
        );
      },
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref, {
    DreamEntry? existingDream,
  }) async {
    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => _DreamEditorPage(existingDream: existingDream),
      ),
    );

    if (saved == true) {
      ref.invalidate(_dreamsProvider);
    }
  }

  Future<void> _deleteDream(
    BuildContext context,
    WidgetRef ref,
    DreamEntry dream,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Rüyayı Sil', style: AppTextStyles.headlineSmall),
        content: const Text(
          'Bu rüya kalıcı olarak silinecek. Emin misiniz?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'İptal',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Sil',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(_dreamServiceProvider).delete(dream.id);
      ref.invalidate(_dreamsProvider);
    }
  }
}

class _DreamCard extends StatelessWidget {
  const _DreamCard({
    required this.dream,
    required this.onTap,
    required this.onDelete,
  });

  final DreamEntry dream;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final String dateStr =
        DateFormat('dd MMM yyyy, HH:mm', 'tr_TR').format(dream.createdAt);
    final bool wasEdited = dream.updatedAt.difference(dream.createdAt).inMinutes > 1;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.nightlight_round,
                  color: AppColors.accent,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    dream.title,
                    style: AppTextStyles.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  color: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              dream.content,
              style: AppTextStyles.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  dateStr,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
                if (wasEdited) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '(düzenlendi)',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DreamEditorPage extends StatefulWidget {
  const _DreamEditorPage({this.existingDream});

  final DreamEntry? existingDream;

  @override
  State<_DreamEditorPage> createState() => _DreamEditorPageState();
}

class _DreamEditorPageState extends State<_DreamEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final DreamJournalService _service = DreamJournalService();
  bool _saving = false;

  bool get _isEditing => widget.existingDream != null;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingDream?.title ?? '');
    _contentController =
        TextEditingController(text: widget.existingDream?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          _isEditing ? 'Rüyayı Düzenle' : 'Yeni Rüya',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.accent),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(false),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: AppColors.accent,
                    ),
                  )
                : Text(
                    'Kaydet',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: AppTextStyles.headlineMedium,
              decoration: InputDecoration(
                hintText: 'Rüyanın başlığı...',
                hintStyle: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            Divider(color: AppColors.border.withValues(alpha: 0.5)),
            TextField(
              controller: _contentController,
              style: AppTextStyles.bodyLarge.copyWith(height: 1.8),
              decoration: InputDecoration(
                hintText: 'Rüyanızı buraya yazın...',
                hintStyle: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                ),
              ),
              maxLines: null,
              minLines: 12,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Başlık ve içerik alanları boş bırakılamaz.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      if (_isEditing) {
        await _service.update(widget.existingDream!.id, title, content);
      } else {
        await _service.insert(title, content);
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kayıt sırasında hata oluştu.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => _saving = false);
      }
    }
  }
}
