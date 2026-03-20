import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../product/navigation/app_router.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../model/surah_list_data.dart';

@RoutePage()
class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0; // 0=ana, 1=sureler, 2=cuzler, 3=sayfalar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    final isDark = context.isDark;

    // Karo renkleri — temaya göre değişir
    final colorGreen = isDark ? const Color(0xFF3B523B) : const Color(0xFF5C7A5C);
    final colorBurgundy = isDark ? const Color(0xFF5A3030) : const Color(0xFF8B4A4A);
    final colorBrown = isDark ? const Color(0xFF52402A) : const Color(0xFF7A6040);
    final colorSlate = isDark ? const Color(0xFF2E444D) : const Color(0xFF4A6B7A);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kur\'ân-ı Kerîm',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: c.onBackground,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: c.surface,
        elevation: 0.5,
        shadowColor: c.textSecondary.withValues(alpha: 0.3),
        bottom: _selectedTab > 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(38),
                child: _buildBackButton(c),
              )
            : null,
      ),
      backgroundColor: c.background,
      body: SafeArea(
        child: _buildBody(c, colorGreen, colorBurgundy, colorBrown, colorSlate),
      ),
    );
  }

  Widget _buildBackButton(AppThemeColors c) {
    return Container(
      color: c.surface,
      width: double.infinity,
      child: TextButton.icon(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          size: 14,
          color: c.accent,
        ),
        label: Text(
          'Ana Sayfa',
          style: TextStyle(color: c.accent, fontSize: 13),
        ),
        onPressed: () => setState(() => _selectedTab = 0),
      ),
    );
  }

  Widget _buildBody(
    AppThemeColors c,
    Color colorGreen,
    Color colorBurgundy,
    Color colorBrown,
    Color colorSlate,
  ) {
    Widget content;
    switch (_selectedTab) {
      case 1:
        content = const _SurahListBody();
        break;
      case 2:
        content = const _JuzListBody();
        break;
      case 3:
        content = const _SayfaListBody();
        break;
      default:
        content = _buildHomePage(c, colorGreen, colorBurgundy, colorBrown, colorSlate);
    }

    return Stack(
      children: [
        // Soluk arka plan ikonu - Tüm sayfayı kaplar
        Positioned.fill(
          child: Opacity(
            opacity: 0.04, // Göz yormaması için çok düşük opaklık
            child: Image.asset('assets/icon/appicon.png', fit: BoxFit.cover),
          ),
        ),
        // Ana içerik
        content,
      ],
    );
  }

  Widget _buildHomePage(
    AppThemeColors c,
    Color colorGreen,
    Color colorBurgundy,
    Color colorBrown,
    Color colorSlate,
  ) {
    return Stack(
      children: [
        // İçerik
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
          child: Column(
            children: [
              // Bismillah başlığı
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: c.accent.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Text(
                      'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: c.onBackground,
                        height: 1.8,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'bismillâhirrahmânirrahîm',
                      style: TextStyle(
                        fontSize: 12,
                        color: c.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2×2 karo grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
                children: [
                  _QuranTile(
                    color: colorGreen,
                    icon: Icons.menu_book_rounded,
                    label: 'Kur\'an-ı Kerîm',
                    subtitle: 'Mushaf Okuma',
                    onTap: () =>
                        context.router.push(MushafPageRoute(pageNumber: 1)),
                  ),
                  _QuranTile(
                    color: colorBurgundy,
                    icon: Icons.format_list_bulleted_rounded,
                    label: 'Sûreler',
                    subtitle: '114 Sure',
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                  _QuranTile(
                    color: colorBrown,
                    icon: Icons.collections_bookmark_rounded,
                    label: 'Cüzler',
                    subtitle: '30 Cüz',
                    onTap: () => setState(() => _selectedTab = 2),
                  ),
                  _QuranTile(
                    color: colorSlate,
                    icon: Icons.article_outlined,
                    label: 'Sayfalar',
                    subtitle: '604 Sayfa',
                    onTap: () => setState(() => _selectedTab = 3),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Alt dekorasyon — ince çizgi ve yazı
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppColors.accent.withValues(alpha: 0.4)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '✦ ✦ ✦',
                        style: TextStyle(
                          color: c.accent.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: AppColors.accent.withValues(alpha: 0.4)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Karo Widget ──────────────────────────────────────────────────────────────
class _QuranTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _QuranTile({
    required this.color,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Soluk köşe dekorasyon
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                icon,
                size: 90,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            // İçerik
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 36, color: Colors.white),
                  const Spacer(),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12,
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
}

// ── Sure Listesi (krem temalı) ───────────────────────────────────────────────
class _SurahListBody extends StatelessWidget {
  final _surahListKey = const ValueKey('surahList');

  const _SurahListBody();

  @override
  Widget build(BuildContext context) {
    return _WrappedSurahList(key: _surahListKey);
  }
}

class _WrappedSurahList extends StatefulWidget {
  const _WrappedSurahList({super.key});

  @override
  State<_WrappedSurahList> createState() => _WrappedSurahListState();
}

class _WrappedSurahListState extends State<_WrappedSurahList> {
  int _selectedIndex = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _getFiltered();
    return Column(
      children: [
        // Segment kontrol
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          height: 36,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.colors.accent.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              _tab('Kur\'ân', 0, context),
              _tab('Alfabetik', 1, context),
              _tab('Nüzul Sırası', 2, context),
            ],
          ),
        ),
        // Arama
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: TextStyle(color: context.colors.onBackground),
            decoration: InputDecoration(
              hintText: 'Sure Adı Ara...',
              hintStyle: TextStyle(color: context.colors.textSecondary),
              prefixIcon: Icon(Icons.search, color: context.colors.textSecondary),
              filled: true,
              fillColor: context.colors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.colors.accent.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.colors.accent.withValues(alpha: 0.3)),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final s = filtered[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.colors.accent.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.accent.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: _islamicStar(s.id, context),
                  title: Text(
                    s.turkishName,
                    style: TextStyle(
                      color: context.colors.onBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '${s.englishName.toUpperCase()}  •  ${s.ayahsCount} Ayet',
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 11),
                  ),
                  trailing: Text(
                    s.arabicName,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 22,
                      color: context.colors.onBackground,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () => context.router.push(
                    SurahDetailRoute(
                      surahId: s.id,
                      surahName: s.turkishName,
                      arabicName: s.arabicName,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<SurahMetadata> _getFiltered() {
    List<SurahMetadata> filtered = surahList.where((s) {
      return s.turkishName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.arabicName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.englishName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_selectedIndex == 1) {
      filtered.sort((a, b) => a.turkishName.compareTo(b.turkishName));
    } else if (_selectedIndex == 2) {
      filtered.sort((a, b) {
        if (a.revelationType == b.revelationType) return a.id.compareTo(b.id);
        return a.revelationType == 'Meccan' ? -1 : 1;
      });
    } else {
      filtered.sort((a, b) => a.id.compareTo(b.id));
    }
    return filtered;
  }

  Widget _tab(String title, int idx, BuildContext context) {
    final selected = _selectedIndex == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = idx),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? context.colors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : context.colors.textSecondary,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _islamicStar(int n, BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 3.14159 / 4,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.colors.accent.withValues(alpha: 0.7),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(
                color: context.colors.accent.withValues(alpha: 0.7),
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Text(
            '$n',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: context.colors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cüz Listesi (krem temalı) ────────────────────────────────────────────────
class _JuzListBody extends StatelessWidget {
  const _JuzListBody();

  @override
  Widget build(BuildContext context) {
    // 30 cüz
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: 30,
      itemBuilder: (context, index) {
        final juzNo = index + 1;
        final startPage = juzNo == 1 ? 1 : (juzNo - 1) * 20 + 2;
        final endPage = juzNo == 30 ? 604 : (juzNo * 20 + 1);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.colors.accent.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: context.colors.accent.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ExpansionTile(
            iconColor: context.colors.accent,
            collapsedIconColor: context.colors.accent,
            title: Row(
              children: [
                _islamicStar(juzNo, context),
                const SizedBox(width: 10),
                Text(
                  '$juzNo. Cüz',
                  style: TextStyle(
                    color: context.colors.onBackground,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            children: List.generate((endPage - startPage) + 1, (pi) {
              final pageNo = startPage + pi;
              if (pageNo > 604) return const SizedBox.shrink();
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 56, right: 16),
                dense: true,
                leading: Icon(
                  Icons.star_half_rounded,
                  size: 18,
                  color: context.colors.accent.withValues(alpha: 0.5),
                ),
                title: Text(
                  'Sayfa $pageNo',
                  style: TextStyle(color: context.colors.onBackground, fontSize: 14),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: context.colors.textSecondary,
                ),
                onTap: () =>
                    context.router.push(MushafPageRoute(pageNumber: pageNo)),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _islamicStar(int n, BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 3.14159 / 4,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.colors.accent.withValues(alpha: 0.7),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              border: Border.all(
                color: context.colors.accent.withValues(alpha: 0.7),
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Text(
            '$n',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: context.colors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sayfa Seçici (krem temalı) ───────────────────────────────────────────────
class _SayfaListBody extends StatelessWidget {
  const _SayfaListBody();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.1,
      ),
      itemCount: 604,
      itemBuilder: (context, index) {
        final pageNo = index + 1;
        return GestureDetector(
          onTap: () => context.router.push(MushafPageRoute(pageNumber: pageNo)),
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.colors.accent.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: context.colors.accent.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$pageNo',
              style: TextStyle(
                color: context.colors.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}