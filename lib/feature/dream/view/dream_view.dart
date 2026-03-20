import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/service/dream_pdf_service.dart';
import '../../../product/state/auth/auth_provider.dart';
import '../../../product/state/auth/model/user_role.dart';
import '../../../product/widget/common/watermark_overlay.dart';
import '../../../service/dream_journal_service.dart';

// ── Providers ────────────────────────────────────────────────────────────────
final _dreamServiceProvider = Provider((ref) {
  final authState = ref.watch(authProvider);
  final prefix =
      authState.role == UserRole.authorized && authState.userId != null
      ? 'auth_${authState.userId}'
      : 'guest';
  return DreamJournalService(prefix);
});

final _dreamsProvider = FutureProvider.autoDispose<List<DreamEntry>>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final service = ref.watch(_dreamServiceProvider);
  if (authState.role == UserRole.authorized && authState.userId != null) {
    return service.syncFromFirestore();
  }
  return service.getAll();
});

// ── Ana Sayfa ────────────────────────────────────────────────────────────────
@RoutePage()
class DreamView extends ConsumerWidget {
  const DreamView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dreamsAsync = ref.watch(_dreamsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 60,
                floating: true,
                snap: true,
                elevation: 0,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: AppSpacing.md),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.nights_stay_rounded,
                        color: context.colors.accent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rüya Defterim',
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: context.colors.accent,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: dreamsAsync.when(
                    data: (List<DreamEntry> dreams) => dreams.isEmpty
                        ? _buildEmpty(context, ref)
                        : _buildDreamList(context, ref, dreams),
                    loading: () => Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: context.colors.accent,
                        ),
                      ),
                    ),
                    error: (_, __) => Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(
                        child: Text(
                          'Rüyalar yüklenirken hata oluştu.',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const WatermarkOverlay(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context, ref),
        backgroundColor: context.colors.accent,
        child: Icon(
          Icons.add_rounded,
          color: context.colors.onPrimary,
          size: 26,
        ),
      ),
    );
  }

  // ── Boş durum ──────────────────────────────────────────────────────────────
  Widget _buildEmpty(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 120,
              height: 120,
              child: CustomPaint(
                painter: _CrescentStarsPainter(color: context.colors.accent),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Henüz bir rüya yazmadınız',
              style: context.textTheme.headlineMedium?.copyWith(
                color: context.colors.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Gördüğünüz rüyaları kaydederek\nhuzurlu bir günlük tutmaya başlayın.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  // ── Liste Görünümü ───────────────────────────────────────────────────────
  Widget _buildDreamList(
    BuildContext context,
    WidgetRef ref,
    List<DreamEntry> dreams,
  ) {
    // Tarihe göre yeniden eskiye sırala
    final sortedDreams = List<DreamEntry>.from(dreams)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: sortedDreams.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final dream = sortedDreams[index];
        return _DreamCard(
          dream: dream,
          onTap: () => _openEditor(context, ref, existingDream: dream),
          onDelete: () => _confirmDelete(context, ref, dream),
        );
      },
    );
  }

  // ── Yardımcılar ──────────────────────────────────────────────────────────
  void _openEditor(
    BuildContext context,
    WidgetRef ref, {
    DreamEntry? existingDream,
  }) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DreamEditor(existingDream: existingDream),
    ).then((value) {
      if (value == true) {
        ref.invalidate(_dreamsProvider);
      }
    });
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, DreamEntry dream) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rüyayı Sil'),
        content: const Text(
          'Bu rüya kaydını silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final service = ref.read(_dreamServiceProvider);
              await service.delete(dream.id);
              ref.invalidate(_dreamsProvider);
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colors.error,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

// ── Rüya Kartı ──────────────────────────────────────────────────────────────
class _DreamCard extends StatelessWidget {
  final DreamEntry dream;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DreamCard({
    required this.dream,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: BorderSide(color: context.colors.border.withValues(alpha: 0.8)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dream.title,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                DateFormat(
                  'dd MMMM yyyy, EEEE',
                  'tr_TR',
                ).format(dream.createdAt),
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                dream.content,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.onBackground,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _CircleActionButton(
                    onPressed: () => DreamPdfService.generateAndShare(dream),
                    icon: Icons.share_rounded,
                    color: context.colors.accent,
                    label: 'Paylaş',
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _CircleActionButton(
                    onPressed: onDelete,
                    icon: Icons.delete_outline_rounded,
                    color: context.colors.error,
                    label: 'Sil',
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Devamını oku...',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ### 2. Sharing & Action UI Refinement
// - **Distinct Buttons**: Redesigned the "Share as PDF" and "Delete" buttons in `_DreamCard`.
// - **Aesthetics**: Replaced simple icons with **Circle Action Buttons** featuring standard **Share Icons** and subtle background colors (Gold/Accent for Share, Red/Error for Delete), making them much more intuitive and premium.
// - **Naming**: Exported files are automatically named after the dream title for easy organization.
class _CircleActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;
  final String? label;

  const _CircleActionButton({
    required this.onPressed,
    required this.icon,
    required this.color,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: color.withValues(alpha: 0.1),
              shape: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(icon, size: 20, color: color),
              ),
            ),
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(
                label!,
                style: context.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Rüya Editörü ─────────────────────────────────────────────────────────────
class _DreamEditor extends ConsumerStatefulWidget {
  final DreamEntry? existingDream;

  const _DreamEditor({this.existingDream});

  @override
  ConsumerState<_DreamEditor> createState() => _DreamEditorState();
}

class _DreamEditorState extends ConsumerState<_DreamEditor> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _saving = false;
  bool get _isEditing => widget.existingDream != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingDream?.title);
    _contentController = TextEditingController(
      text: widget.existingDream?.content,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isEditing
                    ? Icons.edit_note_rounded
                    : Icons.auto_stories_rounded,
                color: context.colors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                _isEditing ? 'Rüyayı Düzenle' : 'Yeni Rüya Yaz',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: context.colors.accent,
                ),
              ),
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          actions: [
            if (_isEditing)
              _CircleActionButton(
                onPressed: () =>
                    DreamPdfService.generateAndShare(widget.existingDream!),
                icon: Icons.share_rounded,
                color: context.colors.accent,
                label: 'Paylaş',
              ),
            const SizedBox(width: AppSpacing.md),
            TextButton(
              onPressed: _saving ? null : _save,
              style: TextButton.styleFrom(
                backgroundColor: context.colors.accent.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _saving
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: context.colors.accent,
                      ),
                    )
                  : Text(
                      'Kaydet',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colors.accent,
                      ),
                    ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              bottom: 30,
              right: -10,
              child: Opacity(
                opacity: 0.03,
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: CustomPaint(
                    painter: _CrescentStarsPainter(
                      color: context.colors.accent,
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(
                        color: context.colors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          style: context.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Rüya Başlığı',
                            hintStyle: context.textTheme.headlineMedium
                                ?.copyWith(color: context.colors.textHint),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.lg,
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        Divider(
                          color: context.colors.border.withValues(alpha: 0.3),
                          height: 1,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextField(
                          controller: _contentController,
                          style: context.textTheme.bodyLarge?.copyWith(
                            height: 1.8,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Rüyanı anlatın...',
                            hintStyle: context.textTheme.bodyLarge?.copyWith(
                              color: context.colors.textHint,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                            ),
                          ),
                          maxLines: null,
                          minLines: 14,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (_isEditing)
                    Text(
                      'Son düzenleme: ${DateFormat('dd MMM yyyy, HH:mm', 'tr_TR').format(widget.existingDream!.updatedAt)}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.textSecondary.withValues(
                          alpha: 0.5,
                        ),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
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
      final authState = ref.read(authProvider);
      final prefix =
          authState.role == UserRole.authorized && authState.userId != null
          ? 'auth_${authState.userId}'
          : 'guest';
      final service = DreamJournalService(prefix);

      if (_isEditing) {
        await service.update(widget.existingDream!.id, title, content);
      } else {
        await service.insert(title, content);
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e, st) {
      debugPrint('DreamEditor save error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kayıt hatası: $e'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            backgroundColor: context.colors.error.withValues(alpha: 0.9),
          ),
        );
        setState(() => _saving = false);
      }
    }
  }
}

// ── Painter ──────────────────────────────────────────────────────────────────
class _CrescentStarsPainter extends CustomPainter {
  final Color color;
  _CrescentStarsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Hilal
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.7, size.height * 0.2)
        ..arcToPoint(
          Offset(size.width * 0.7, size.height * 0.8),
          radius: Radius.circular(size.width * 0.4),
          clockwise: false,
        )
        ..arcToPoint(
          Offset(size.width * 0.7, size.height * 0.2),
          radius: Radius.circular(size.width * 0.32),
        ),
      paint,
    );

    // Yıldızlar
    final random = Random(42);
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.2 + random.nextDouble() * 0.4);
      final y = size.height * (0.2 + random.nextDouble() * 0.6);
      final s = 2.0 + random.nextDouble() * 3.0;
      canvas.drawCircle(Offset(x, y), s, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
