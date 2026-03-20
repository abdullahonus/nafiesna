import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../product/navigation/app_router.dart';
import '../model/surah_list_data.dart';

// Kuran sekme renklerini ve tasarımını diğer sekmelerden tamamen izole ediyoruz.
// Kendi krem temalı renk paleti
const _kBackground = Color(0xFFF4EFE4);
const _kSurface = Color(0xFFEDE7D6);
const _kText = Color(0xFF2B1E0E);
const _kTextLight = Color(0xFF8B7355);
const _kAccent = Color(0xFFB8860B); // Koyu altın

// Karo renkleri (resimdeki gibi mat tonlar)
const _colorGreen = Color(0xFF5C7A5C);
const _colorBurgundy = Color(0xFF8B4A4A);
const _colorBrown = Color(0xFF7A6040);
const _colorSlate = Color(0xFF4A6B7A);

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
    return Theme(
      // Kuran sekmesine özel aydınlık tema
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: _kBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: _kSurface,
          foregroundColor: _kText,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _kText,
            letterSpacing: 0.5,
          ),
        ),
        dividerColor: _kTextLight.withValues(alpha: 0.3),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Kur\'ân-ı Kerîm',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _kText,
            ),
          ),
          centerTitle: true,
          backgroundColor: _kSurface,
          elevation: 0.5,
          shadowColor: _kTextLight.withValues(alpha: 0.3),
          bottom: _selectedTab > 0
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(38),
                  child: _buildBackButton(),
                )
              : null,
        ),
        backgroundColor: _kBackground,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      color: _kSurface,
      width: double.infinity,
      child: TextButton.icon(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 14,
          color: _kAccent,
        ),
        label: const Text(
          'Ana Sayfa',
          style: TextStyle(color: _kAccent, fontSize: 13),
        ),
        onPressed: () => setState(() => _selectedTab = 0),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedTab) {
      case 1:
        return const _SurahListBody();
      case 2:
        return const _JuzListBody();
      case 3:
        return const _SayfaListBody();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Stack(
      children: [
        // Soluk arka plan ikonu
        Positioned.fill(
          child: Opacity(
            opacity: 0.06,
            child: Center(
              child: Image.asset(
                'assets/icon/appicon.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // İçerik
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
          child: Column(
            children: [
              // Bismillah başlığı
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _kSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _kAccent.withValues(alpha: 0.4)),
                ),
                child: const Column(
                  children: [
                    Text(
                      'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: _kText,
                        height: 1.8,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'bismillâhirrahmânirrahîm',
                      style: TextStyle(
                        fontSize: 12,
                        color: _kTextLight,
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
                    color: _colorGreen,
                    icon: Icons.menu_book_rounded,
                    label: 'Kur\'an-ı Kerîm',
                    subtitle: 'Mushaf Okuma',
                    onTap: () =>
                        context.router.push(MushafPageRoute(pageNumber: 1)),
                  ),
                  _QuranTile(
                    color: _colorBurgundy,
                    icon: Icons.format_list_bulleted_rounded,
                    label: 'Sûreler',
                    subtitle: '114 Sure',
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                  _QuranTile(
                    color: _colorBrown,
                    icon: Icons.collections_bookmark_rounded,
                    label: 'Cüzler',
                    subtitle: '30 Cüz',
                    onTap: () => setState(() => _selectedTab = 2),
                  ),
                  _QuranTile(
                    color: _colorSlate,
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
                      child: Divider(color: _kAccent.withValues(alpha: 0.4)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '✦ ✦ ✦',
                        style: TextStyle(
                          color: _kAccent.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: _kAccent.withValues(alpha: 0.4)),
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
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
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
    // SurahListTab'ı krem teması içinde sarıyoruz
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: _kBackground,
        colorScheme: const ColorScheme.light(primary: _kAccent),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: _kText,
          displayColor: _kText,
        ),
      ),
      child: _WrappedSurahList(key: _surahListKey),
    );
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
    // Import inline list from surah_list_data
    final filtered = _getFiltered();
    return Column(
      children: [
        // Segment kontrol
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          height: 36,
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _kAccent.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              _tab('Kur\'ân', 0),
              _tab('Alfabetik', 1),
              _tab('Nüzul Sırası', 2),
            ],
          ),
        ),
        // Arama
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: const TextStyle(color: _kText),
            decoration: InputDecoration(
              hintText: 'Sure Adı Ara...',
              hintStyle: const TextStyle(color: _kTextLight),
              prefixIcon: const Icon(Icons.search, color: _kTextLight),
              filled: true,
              fillColor: _kSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _kAccent.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _kAccent.withValues(alpha: 0.3)),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            itemCount: filtered.length,
            separatorBuilder: (_, __) =>
                Divider(color: _kAccent.withValues(alpha: 0.2), height: 1),
            itemBuilder: (context, index) {
              final s = filtered[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 2),
                leading: _islamicStar(s.id),
                title: Text(
                  s.turkishName,
                  style: const TextStyle(
                    color: _kText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${s.englishName.toUpperCase()}  •  ${s.ayahsCount} Ayet',
                  style: const TextStyle(color: _kTextLight, fontSize: 11),
                ),
                trailing: Text(
                  s.arabicName,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    color: _kText,
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

  Widget _tab(String title, int idx) {
    final selected = _selectedIndex == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = idx),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? _kAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : _kTextLight,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _islamicStar(int n) {
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
                  color: _kAccent.withValues(alpha: 0.7),
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
                color: _kAccent.withValues(alpha: 0.7),
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Text(
            '$n',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: _kAccent,
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

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: _kSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: _kAccent.withValues(alpha: 0.25)),
          ),
          child: ExpansionTile(
            iconColor: _kAccent,
            collapsedIconColor: _kTextLight,
            title: Row(
              children: [
                _islamicStar(juzNo),
                const SizedBox(width: 10),
                Text(
                  '$juzNo. Cüz',
                  style: const TextStyle(
                    color: _kText,
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
                  color: _kAccent.withValues(alpha: 0.5),
                ),
                title: Text(
                  'Sayfa $pageNo',
                  style: const TextStyle(color: _kText, fontSize: 14),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: _kTextLight,
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

  Widget _islamicStar(int n) {
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
                  color: _kAccent.withValues(alpha: 0.7),
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
                color: _kAccent.withValues(alpha: 0.7),
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Text(
            '$n',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: _kAccent,
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
              color: _kSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kAccent.withValues(alpha: 0.3)),
            ),
            alignment: Alignment.center,
            child: Text(
              '$pageNo',
              style: const TextStyle(
                color: _kText,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        );
      },
    );
  }
}
