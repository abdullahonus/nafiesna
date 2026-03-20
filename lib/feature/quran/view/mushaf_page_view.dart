import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/quran_provider.dart';
import '../model/quran_page_model.dart';
import '../model/surah_list_data.dart';

// ── Mushaf Renk Teması ───────────────────────────────────────────────────────
const _kBg = Color(0xFFFAF5E9);          // krem kağıt arka plan
const _kPaper = Color(0xFFF5EDD3);       // sayfa rengi
const _kText = Color(0xFF1A0F00);        // koyu mürekkep
const _kAccent = Color(0xFFB8860B);      // altın kenar
const _kVerseNum = Color(0xFFCC6666);    // pembe-kırmızı (resimdeki gibi)
const _kSurahHeader = Color(0xFF8B4513); // sure başlığı

@RoutePage()
class MushafPageView extends ConsumerStatefulWidget {
  final int pageNumber;

  const MushafPageView({
    super.key,
    required this.pageNumber,
  });

  @override
  ConsumerState<MushafPageView> createState() => _MushafPageViewState();
}

class _MushafPageViewState extends ConsumerState<MushafPageView> {
  late PageController _pageController;
  late int _currentPage;
  String _currentSurahName = '';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.pageNumber;
    _pageController = PageController(initialPage: widget.pageNumber - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: _kBg,
        appBarTheme: AppBarTheme(
          backgroundColor: _kPaper,
          foregroundColor: _kText,
          elevation: 0.5,
          shadowColor: _kAccent.withValues(alpha: 0.3),
          titleTextStyle: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _kText,
          ),
          iconTheme: IconThemeData(color: _kText),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Text(
                _currentSurahName.isNotEmpty ? _currentSurahName : '─',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _kSurahHeader,
                ),
              ),
              Text(
                'Sayfa $_currentPage',
                style: TextStyle(
                  fontSize: 11,
                  color: _kAccent,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          backgroundColor: _kPaper,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: _kText),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            TextButton(
              onPressed: _goToPage,
              child: Text(
                'Git',
                style: TextStyle(color: _kAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: _kBg,
        body: PageView.builder(
          controller: _pageController,
          // Arapça kitap: sağdan sola (swipe right = sonraki sayfa)
          // Ancak Flutter'da tipik UX için sola kaydır = sonraki sayfa bırakıyoruz
          onPageChanged: (index) {
            setState(() => _currentPage = index + 1);
          },
          itemCount: 604,
          itemBuilder: (context, index) {
            final pageNo = index + 1;
            return _MushafSinglePage(
              pageNumber: pageNo,
              onSurahNameChanged: (name) {
                if (pageNo == _currentPage && name != _currentSurahName) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _currentSurahName = name);
                  });
                }
              },
            );
          },
        ),

        // Alt gezinme — sayfa numarası orta + prev/next
        bottomNavigationBar: Container(
          height: 52,
          decoration: BoxDecoration(
            color: _kPaper,
            border: Border(top: BorderSide(color: _kAccent.withValues(alpha: 0.3))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Önceki sayfa (sol < )
              IconButton(
                icon: Icon(Icons.chevron_left_rounded, color: _kText),
                onPressed: _currentPage > 1
                    ? () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        )
                    : null,
              ),
              // İslami süsleme + sayfa no
              Row(
                children: [
                  Text('❖', style: TextStyle(color: _kAccent, fontSize: 14)),
                  const SizedBox(width: 8),
                  Text(
                    '$_currentPage / 604',
                    style: TextStyle(
                      color: _kText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('❖', style: TextStyle(color: _kAccent, fontSize: 14)),
                ],
              ),
              // Sonraki sayfa ( > sağ)
              IconButton(
                icon: Icon(Icons.chevron_right_rounded, color: _kText),
                onPressed: _currentPage < 604
                    ? () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToPage() {
    showDialog(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          backgroundColor: _kPaper,
          title: Text('Sayfaya Git', style: TextStyle(color: _kText, fontSize: 16)),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: TextStyle(color: _kText),
            decoration: InputDecoration(
              hintText: '1 - 604',
              hintStyle: TextStyle(color: _kAccent.withValues(alpha: 0.6)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _kAccent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _kAccent, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('İptal', style: TextStyle(color: _kText)),
            ),
            TextButton(
              onPressed: () {
                final n = int.tryParse(ctrl.text);
                if (n != null && n >= 1 && n <= 604) {
                  _pageController.jumpToPage(n - 1);
                  Navigator.pop(ctx);
                }
              },
              child: Text('Git', style: TextStyle(color: _kAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

// ── Tek Sayfa Widget ─────────────────────────────────────────────────────────
class _MushafSinglePage extends ConsumerWidget {
  final int pageNumber;
  final ValueChanged<String> onSurahNameChanged;

  const _MushafSinglePage({
    required this.pageNumber,
    required this.onSurahNameChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPage = ref.watch(pageDetailProvider(pageNumber));

    return asyncPage.when(
      data: (verses) {
        if (verses.isEmpty) {
          return _emptyPage();
        }
        // Surah adını bildir
        final surahName = verses.first.surahName
            .replaceAll('سُورَةُ', '').trim();
        onSurahNameChanged(surahName);
        return _buildPage(context, verses, ref);
      },
      loading: () => Container(
        color: _kBg,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: _kAccent, strokeWidth: 2),
              const SizedBox(height: 16),
              Text('Sayfa $pageNumber yükleniyor...',
                  style: TextStyle(color: _kAccent, fontSize: 13)),
            ],
          ),
        ),
      ),
      error: (e, _) => Container(
        color: _kBg,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, color: _kAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              'Sayfa yüklenemedi.\nİnternet bağlantınızı kontrol edin.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _kText),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => ref.invalidate(pageDetailProvider(pageNumber)),
              child: Text('Tekrar Dene', style: TextStyle(color: _kAccent)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyPage() {
    return Container(
      color: _kBg,
      child: Center(
        child: Text('Bu sayfada içerik bulunamadı.',
            style: TextStyle(color: _kText)),
      ),
    );
  }

  Widget _buildPage(BuildContext context, List<QuranPageVerse> verses, WidgetRef ref) {
    // Sure değişimlerini takip et
    final List<Widget> children = [];
    int currentSurahId = -1;
    List<InlineSpan> spans = [];

    void flush() {
      if (spans.isNotEmpty) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: RichText(
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
              text: TextSpan(children: List.from(spans)),
            ),
          ),
        );
        spans.clear();
      }
    }

    for (final v in verses) {
      if (v.surahId != currentSurahId) {
        flush();
        currentSurahId = v.surahId;

        final surahName = v.surahName.replaceAll('سُورَةُ', '').trim();
        // Türkçe sure adını bul
        final surahMetadata = surahList.firstWhere(
          (s) => s.id == v.surahId,
          orElse: () => surahList.first,
        );

        children.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: _kAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: _kAccent.withValues(alpha: 0.5), width: 0.8),
            ),
            child: Column(
              children: [
                Text(
                  'سُورَةُ $surahName',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: _kSurahHeader,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  surahMetadata.turkishName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kAccent,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Ayet metni
      spans.add(
        TextSpan(
          text: '${v.arabicText} ',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 23,
            fontWeight: FontWeight.w400,
            height: 2.1,
            color: _kText,
          ),
        ),
      );

      // Ayet numarası (resimdeki gibi pembe daire)
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () => _showTranslation(context, v),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _kVerseNum, width: 1.2),
                color: _kVerseNum.withValues(alpha: 0.1),
              ),
              child: Text(
                _toArabicNumeral(v.numberInSurah),
                style: TextStyle(
                  fontSize: 10,
                  color: _kVerseNum,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiri',
                ),
              ),
            ),
          ),
        ),
      );

      spans.add(const TextSpan(text: ' '));
    }

    flush();

    // Sayfanın sonunda: numaralı Latince okunuş bloğu
    final transliBlock = _buildTransliterationFooter(verses);

    return Container(
      color: _kBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
        child: Column(
          children: [
            DecoratedBox(
              // Sayfa çerçevesi (kağıt efekti)
              decoration: BoxDecoration(
                color: _kPaper,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _kAccent.withValues(alpha: 0.4), width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),

            // Latince okunuş bloğu
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: BoxDecoration(
                color: _kPaper,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _kAccent.withValues(alpha: 0.3), width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('❖ ', style: TextStyle(color: _kAccent, fontSize: 12)),
                      Text(
                        'Okunuş',
                        style: TextStyle(
                          color: _kAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  transliBlock,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransliterationFooter(List<QuranPageVerse> verses) {
    final spans = <InlineSpan>[];
    for (final v in verses) {
      spans.add(TextSpan(
        text: '${v.numberInSurah} ',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: _kVerseNum,
        ),
      ));
      spans.add(TextSpan(
        text: '${v.transliterationText}  ',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.85,
          color: _kText,
        ),
      ));
    }
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(children: spans),
    );
  }

  // Ayet numarasını Arapça rakama çevir
  String _toArabicNumeral(int n) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((d) => arabicDigits[int.parse(d)]).join();
  }

  void _showTranslation(BuildContext context, QuranPageVerse verse) {
    final surahDisplay = verse.surahName.replaceAll('سُورَةُ', '').trim();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: BoxDecoration(
          color: _kPaper,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: _kAccent.withValues(alpha: 0.5), width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ayet no başlık
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('❖ ', style: TextStyle(color: _kAccent, fontSize: 14)),
                Text(
                  '$surahDisplay — ${verse.numberInSurah}. Ayet',
                  style: TextStyle(
                    color: _kSurahHeader,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Amiri',
                  ),
                ),
                Text(' ❖', style: TextStyle(color: _kAccent, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            // Arapça
            Text(
              verse.arabicText,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 22,
                fontWeight: FontWeight.w400,
                height: 1.8,
                color: _kText,
              ),
            ),
            Divider(color: _kAccent.withValues(alpha: 0.3), height: 24),
            // Türkçe meal
            Text(
              verse.translationText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kText.withValues(alpha: 0.85),
                fontSize: 14,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
