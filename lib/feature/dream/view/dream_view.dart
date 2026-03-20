import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/state/auth/auth_provider.dart';
import '../../../product/state/auth/model/user_role.dart';
import '../../../service/dream_journal_service.dart';

// ── Providers ────────────────────────────────────────────────────────────────
final _dreamServiceProvider = Provider((ref) {
  final authState = ref.watch(authProvider);
  final prefix = authState.role == UserRole.authorized && authState.userId != null
      ? 'auth_${authState.userId}'
      : 'guest';
  return DreamJournalService(prefix);
});

final _dreamsProvider = FutureProvider.autoDispose<List<DreamEntry>>((ref) async {
  final authState = ref.watch(authProvider);
  final service = ref.watch(_dreamServiceProvider);
  // Sadece authorized + uid varsa Firestore sync yap.
  // Aksi halde (logout sonrası dahil) sadece local veriyi döndür.
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
      body: CustomScrollView(
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
                  const Icon(
                    Icons.nights_stay_rounded,
                    color: AppColors.accent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Rüya Defterim',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.accent,
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: dreamsAsync.when(
                data: (List<DreamEntry> dreams) => dreams.isEmpty
                    ? _buildEmpty(context, ref)
                    : _buildDreamList(context, ref, dreams),
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                ),
                error: (_, __) => Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                    child: Text(
                      'Rüyalar yüklenirken hata oluştu.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context, ref),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add_rounded, color: Colors.black, size: 26),
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
              child: CustomPaint(painter: _CrescentStarsPainter()),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Henüz bir rüya yazmadınız',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Rüyalarınızı kaydedin,\nyıldızların altında saklansın.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton.icon(
              onPressed: () => _openEditor(context, ref),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('İlk Rüyanı Yaz'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Rüya listesi ───────────────────────────────────────────────────────────
  Widget _buildDreamList(
    BuildContext context,
    WidgetRef ref,
    List<DreamEntry> dreams,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('${dreams.length} Rüya', style: AppTextStyles.headlineSmall),
            ],
          ),
        ),
        ...dreams.map(
          (DreamEntry dream) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _DreamCard(
              dream: dream,
              onTap: () => _openEditor(context, ref, existingDream: dream),
              onDelete: () => _deleteDream(context, ref, dream),
            ),
          ),
        ),
        const SizedBox(height: 80),
      ],
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: Row(
          children: [
            Icon(
              Icons.nights_stay_rounded,
              color: AppColors.accent.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Rüyayı Sil', style: AppTextStyles.headlineSmall),
          ],
        ),
        content: const Text(
          'Bu rüya kalıcı olarak silinecek.\nEmin misiniz?',
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

// ═══════════════════════════════════════════════════════════════════════════════
// Rüya Kartı
// ═══════════════════════════════════════════════════════════════════════════════
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
    final String dateStr = DateFormat(
      'dd MMM yyyy, HH:mm',
      'tr_TR',
    ).format(dream.createdAt);
    final bool wasEdited =
        dream.updatedAt.difference(dream.createdAt).inMinutes > 1;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          color: AppColors.surface,
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.12),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -6,
              right: -6,
              child: Opacity(
                opacity: 0.04,
                child: Icon(
                  Icons.nights_stay_rounded,
                  color: AppColors.accent,
                  size: 64,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.nights_stay_rounded,
                        color: AppColors.accent.withValues(alpha: 0.6),
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          dream.title,
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.accent,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildPopupMenu(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    dream.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onBackground.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateStr,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                        ),
                      ),
                      if (wasEdited) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm,
                            ),
                            color: AppColors.surfaceVariant,
                          ),
                          child: Text(
                            'düzenlendi',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 9,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.6,
                              ),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: AppColors.textSecondary.withValues(alpha: 0.5),
        size: 18,
      ),
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      padding: EdgeInsets.zero,
      onSelected: (String value) {
        if (value == 'delete') onDelete();
        if (value == 'edit') onTap();
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_rounded, color: AppColors.accent, size: 16),
              SizedBox(width: AppSpacing.sm),
              Text('Düzenle', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Sil',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Rüya Editörü
// ═══════════════════════════════════════════════════════════════════════════════
class _DreamEditorPage extends ConsumerStatefulWidget {
  const _DreamEditorPage({this.existingDream});

  final DreamEntry? existingDream;

  @override
  ConsumerState<_DreamEditorPage> createState() => _DreamEditorPageState();
}

class _DreamEditorPageState extends ConsumerState<_DreamEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _saving = false;

  bool get _isEditing => widget.existingDream != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingDream?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.existingDream?.content ?? '',
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.nights_stay_rounded,
              color: AppColors.accent.withValues(alpha: 0.7),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              _isEditing ? 'Rüyayı Düzenle' : 'Yeni Rüya',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.accent,
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
                child: CustomPaint(painter: _CrescentStarsPainter()),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    color: AppColors.surface,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      width: 0.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.accent,
                        ),
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
                      Divider(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        height: 1,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _contentController,
                        style: AppTextStyles.bodyLarge.copyWith(height: 1.8),
                        decoration: InputDecoration(
                          hintText: 'Rüyanızı anlatın...',
                          hintStyle: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textHint,
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
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ],
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
      final prefix = authState.role == UserRole.authorized && authState.userId != null
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
            backgroundColor: AppColors.error.withValues(alpha: 0.9),
          ),
        );
        setState(() => _saving = false);
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Hilal ve yıldızlar (boş durum + editör dekorasyon)
// ═══════════════════════════════════════════════════════════════════════════════
class _CrescentStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    final Paint moonPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final Paint erasePaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;

    final double moonR = size.width * 0.28;
    canvas.drawCircle(Offset(cx, cy), moonR, moonPaint);
    canvas.drawCircle(
      Offset(cx + moonR * 0.45, cy - moonR * 0.15),
      moonR * 0.8,
      erasePaint,
    );

    final Paint starPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    const List<List<double>> stars = [
      [0.72, 0.22, 3.0],
      [0.78, 0.38, 2.0],
      [0.65, 0.15, 2.5],
      [0.85, 0.28, 1.8],
      [0.55, 0.30, 1.5],
    ];

    for (final List<double> s in stars) {
      _drawStar(
        canvas,
        Offset(size.width * s[0], size.height * s[1]),
        s[2],
        starPaint,
      );
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final Path path = Path();
    for (int i = 0; i < 5; i++) {
      final double outerAngle = (i * 72 - 90) * pi / 180;
      final double innerAngle = ((i * 72) + 36 - 90) * pi / 180;

      final double ox = center.dx + cos(outerAngle) * radius;
      final double oy = center.dy + sin(outerAngle) * radius;
      final double ix = center.dx + cos(innerAngle) * radius * 0.4;
      final double iy = center.dy + sin(innerAngle) * radius * 0.4;

      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
