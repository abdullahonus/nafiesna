import 'package:flutter/material.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';

class AksamVirdiPage extends StatefulWidget {
  const AksamVirdiPage({super.key});

  @override
  State<AksamVirdiPage> createState() => _AksamVirdiPageState();
}

class _AksamVirdiPageState extends State<AksamVirdiPage> {
  String _query = '';
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  static String _normalize(String s) {
    return s
        .toLowerCase()
        .replaceAll('â', 'a')
        .replaceAll('î', 'i')
        .replaceAll('û', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        .replaceAll('ş', 's')
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll(RegExp(r'[\s\n]+'), ' ');
  }

  List<_VirdStep> get _filtered {
    final q = _query.trim();
    if (q.isEmpty) return _steps;
    final nq = _normalize(q);
    return _steps.where((s) {
      final searchable = _normalize(
        '${s.text} ${s.titleTr ?? ''} ${s.descTr ?? ''}',
      );
      return searchable.contains(nq);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => _query = '');
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return GestureDetector(
      onTap: _focusNode.unfocus,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.surface,
          elevation: 0,
          title: Text(
            'Akşam Namazı Virdi',
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colors.accent,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
        ),
        body: Column(
          children: [
            _SearchField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (v) => setState(() => _query = v),
              onClear: _clearSearch,
            ),
            if (_query.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Text(
                      '${filtered.length} sonuç',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colors.textDisabled,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: filtered.isEmpty
                    ? _EmptyState(query: _query, key: const ValueKey('empty'))
                    : ListView.builder(
                        key: const ValueKey('list'),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg,
                          AppSpacing.xl,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, int i) {
                          final step = filtered[i];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: switch (step.type) {
                              _StepType.divider => _DividerRow(
                                label: step.text,
                              ),
                              _StepType.note => _NoteCard(text: step.text),
                              _ => _DhikrRow(step: step),
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Search Field ───────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: context.colors.border, width: 0.5),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          style: context.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Zikir, sure veya açıklama ara…',
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textHint,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: context.colors.textSecondary,
              size: 20,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: context.colors.textSecondary,
                      size: 18,
                    ),
                    onPressed: onClear,
                    splashRadius: 16,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 52,
              color: context.colors.textDisabled,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '"$query" için sonuç bulunamadı',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Vird adımları (sırasıyla) ──────────────────────────────────────────────

enum _StepType { dhikr, surah, divider, note }

class _VirdStep {
  const _VirdStep({
    required this.type,
    required this.text,
    this.count = 0,
    this.titleTr,
    this.descTr,
  });

  final _StepType type;
  final int count;
  final String text;
  final String? titleTr; // Başlık/açıklama (arama için)
  final String? descTr;
}

const List<_VirdStep> _steps = [
  _VirdStep(
    type: _StepType.dhikr,
    count: 21,
    text: 'Eûzübillâhimineşşeytânirracîmbismillâhirrahmânirrahîm',
    titleTr: 'Euzu besmele',
  ),
  _VirdStep(
    type: _StepType.dhikr,
    count: 10,
    text: 'Hasbünallah ve ni\'mel vekîl',
    titleTr: 'Hasbunallah',
  ),
  _VirdStep(
    type: _StepType.dhikr,
    count: 3,
    text: 'Sübhânallâhi ve bihimdihî\nSübhânallâhil\'azîm',
    titleTr: 'Subhanallah',
  ),
  _VirdStep(
    type: _StepType.dhikr,
    count: 3,
    text: 'Estağfurullâhel azîm ve etûbu ileyh',
    titleTr: 'Istigfar',
  ),
  _VirdStep(
    type: _StepType.dhikr,
    count: 3,
    text: 'Lâ ilâhe illâ ente sübhâneke innî küntü minezzâlimîn',
  ),
  _VirdStep(
    type: _StepType.dhikr,
    count: 3,
    text: 'Allâhümme inneke afüvvün kerîmün\ntühibbül afve fa\'fü annî',
  ),
  _VirdStep(
    type: _StepType.dhikr,
    count: 1,
    text:
        'Eşhedü en lâ ilâhe illallah\nve eşhedü enne Muhammeden abduhü ve resûlüh',
  ),
  _VirdStep(type: _StepType.dhikr, count: 1, text: 'Lâ ilâhe illallah'),
  _VirdStep(
    type: _StepType.dhikr,
    count: 1,
    text:
        'Hasbiyallâhu lâ ilâhe illâ hü\naleyhi tevekkeltü ve hüve rabbül arşil azîm',
  ),
  _VirdStep(
    type: _StepType.dhikr,
    count: 1,
    text:
        'Bismillâhi, tevekkeltü alallâhi,\nlâ havle ve lâ kuvvete illâ billâh',
  ),

  // ── Bölüm: Avuç içine ──────────────────────────────────────────────────
  _VirdStep(
    type: _StepType.divider,
    text: 'AVUÇ İÇİNE',
    titleTr: 'avuc icinde sureler',
  ),

  _VirdStep(
    type: _StepType.surah,
    count: 1,
    text: 'Âyetel Kürsî',
    titleTr: 'Ayetel Kürsi Bakara',
  ),
  _VirdStep(
    type: _StepType.surah,
    count: 1,
    text: 'Kâfirûn Sûresi',
    titleTr: 'Kafirun',
  ),
  _VirdStep(
    type: _StepType.surah,
    count: 1,
    text: 'İhlâs Sûresi',
    titleTr: 'Ihlas',
  ),
  _VirdStep(
    type: _StepType.surah,
    count: 1,
    text: 'Felak Sûresi',
    titleTr: 'Felak',
  ),
  _VirdStep(
    type: _StepType.surah,
    count: 1,
    text: 'Nâs Sûresi',
    titleTr: 'Nas',
  ),
  _VirdStep(
    type: _StepType.surah,
    count: 1,
    text: 'Kevser Sûresi',
    titleTr: 'Kevser',
  ),

  _VirdStep(
    type: _StepType.note,
    text:
        'Avuç içine üflenildikten sonra tüm vücut mesh edilecek ve yatılacak.',
    titleTr: 'avuc mesh vucut yatilacak',
    descTr: 'Mesh edilir yatılır uyku öncesi',
  ),
];

// ── Widget'lar ─────────────────────────────────────────────────────────────

class _DhikrRow extends StatelessWidget {
  const _DhikrRow({required this.step});

  final _VirdStep step;

  bool get _isSurah => step.type == _StepType.surah;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: context.colors.surface,
        border: Border.all(
          color: _isSurah
              ? context.colors.primary.withValues(alpha: 0.25)
              : context.colors.border,
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sayı rozeti
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isSurah
                  ? context.colors.primary.withValues(alpha: 0.15)
                  : context.colors.accent.withValues(alpha: 0.12),
              border: Border.all(
                color: _isSurah
                    ? context.colors.primary.withValues(alpha: 0.35)
                    : context.colors.accent.withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: Center(
              child: Text(
                '${step.count}×',
                style: context.textTheme.labelSmall?.copyWith(
                  color: _isSurah ? context.colors.primary : context.colors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Metin
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                step.text,
                style: context.textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  fontStyle: _isSurah ? FontStyle.normal : FontStyle.italic,
                  color: context.colors.onBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerRow extends StatelessWidget {
  const _DividerRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: context.colors.primary, thickness: 0.6),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Icon(
                  Icons.pan_tool_alt_outlined,
                  size: 14,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colors.primary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Divider(color: context.colors.primary, thickness: 0.6),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: context.colors.accent.withValues(alpha: 0.07),
        border: Border.all(
          color: context.colors.accent.withValues(alpha: 0.25),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: context.colors.accent,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.accent,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}