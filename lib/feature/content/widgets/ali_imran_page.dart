import 'package:flutter/material.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';

// ── Veri Modeli ────────────────────────────────────────────────────────────

class _AliImranItem {
  const _AliImranItem({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

const List<_AliImranItem> _items = [
  _AliImranItem(
    title: 'Âl-i İmrân 18–27',
    description:
        'Allah şahitlik etti ki O\'ndan başka ilah yoktur; '
        'melekler ve ilim sahipleri de (buna şahitlik etti). '
        'O, adaleti ayakta tutar. O\'ndan başka ilah yoktur. '
        'O, Azîz\'dir, Hakîm\'dir. — 18. Âyet meali',
    icon: Icons.menu_book_rounded,
  ),
  _AliImranItem(
    title: 'Ne Zaman Okunur?',
    description:
        'Yatsı namazından sonra Âl-i İmrân sûresinin 18–27. âyetleri okunur.',
    icon: Icons.nightlight_round,
  ),
  _AliImranItem(
    title: 'Sıratı müstakim üzere olur',
    description: 'Doğru yol üzere olma fazileti.',
    icon: Icons.route_rounded,
  ),
  _AliImranItem(
    title: 'İmansız ölmez',
    description: 'İman ile ahirete göç etme fazileti.',
    icon: Icons.favorite_rounded,
  ),
  _AliImranItem(
    title: 'Rızık sıkıntısı çekmez',
    description: 'Geçim konusunda genişlik ve bereket.',
    icon: Icons.currency_lira_rounded,
  ),
  _AliImranItem(
    title: 'Bulunduğu toplulukta itibar görür',
    description: 'Toplum içinde saygı ve değer görme fazileti.',
    icon: Icons.groups_rounded,
  ),
];

// ── Sayfa ───────────────────────────────────────────────────────────────────

class AliImranPage extends StatefulWidget {
  const AliImranPage({super.key});

  @override
  State<AliImranPage> createState() => _AliImranPageState();
}

class _AliImranPageState extends State<AliImranPage> {
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

  List<_AliImranItem> get _filtered {
    final q = _query.trim();
    if (q.isEmpty) return _items;
    final nq = _normalize(q);
    return _items.where((item) {
      final searchable =
          _normalize('${item.title} ${item.description}');
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
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          title: Text(
            'Âl-i İmrân 18–27',
            style:
                AppTextStyles.headlineSmall.copyWith(color: AppColors.accent),
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
            _ResultCounter(
              total: _items.length,
              shown: filtered.length,
              isFiltered: _query.isNotEmpty,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: filtered.isEmpty
                    ? _EmptyState(
                        query: _query,
                        key: const ValueKey('empty'),
                      )
                    : ListView.builder(
                        key: const ValueKey('list'),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg,
                          AppSpacing.xl,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _ItemCard(
                            item: filtered[i],
                            searchQuery: _query,
                          ),
                        ),
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Başlık veya açıklama ara…',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
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

// ── Result Counter ─────────────────────────────────────────────────────────

class _ResultCounter extends StatelessWidget {
  const _ResultCounter({
    required this.total,
    required this.shown,
    required this.isFiltered,
  });

  final int total;
  final int shown;
  final bool isFiltered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 4),
      child: Row(
        children: [
          Text(
            isFiltered ? '$shown sonuç (toplam $total)' : '$total madde',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textDisabled,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Item Card (expandable, Islamic Info tarzı) ──────────────────────────────

class _ItemCard extends StatefulWidget {
  const _ItemCard({
    required this.item,
    required this.searchQuery,
  });

  final _AliImranItem item;
  final String searchQuery;

  @override
  State<_ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<_ItemCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          color: AppColors.surface,
          border: Border.all(
            color: _expanded
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.border,
            width: _expanded ? 0.8 : 0.5,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 6,
              bottom: 6,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 3,
                margin: const EdgeInsets.only(left: 1),
                decoration: BoxDecoration(
                  color: _expanded
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 12,
                top: 12,
                bottom: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                          color: AppColors.primary.withValues(alpha: 0.12),
                        ),
                        child: Icon(
                          widget.item.icon,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _HighlightText(
                          text: widget.item.title,
                          query: widget.searchQuery,
                          style: AppTextStyles.headlineSmall,
                          highlightColor: AppColors.primary,
                        ),
                      ),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _expanded
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: _expanded
                        ? Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(
                                  color: AppColors.divider,
                                  thickness: 0.5,
                                  height: AppSpacing.md,
                                ),
                                _HighlightText(
                                  text: widget.item.description,
                                  query: widget.searchQuery,
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(height: 1.65),
                                  highlightColor: AppColors.primary,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Arama vurgulaması ──────────────────────────────────────────────────────

class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.text,
    required this.query,
    required this.style,
    required this.highlightColor,
  });

  final String text;
  final String query;
  final TextStyle style;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) return Text(text, style: style);

    final q = query.toLowerCase().trim();
    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lower.indexOf(q, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + q.length),
        style: TextStyle(
          backgroundColor: highlightColor.withValues(alpha: 0.25),
          color: highlightColor,
          fontWeight: FontWeight.w600,
        ),
      ));
      start = idx + q.length;
    }

    return RichText(
      text: TextSpan(style: style, children: spans),
    );
  }
}

// ── Boş durum ──────────────────────────────────────────────────────────────

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
            const Icon(
              Icons.search_off_rounded,
              size: 52,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '"$query" için sonuç bulunamadı',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Farklı bir kelime deneyin.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
