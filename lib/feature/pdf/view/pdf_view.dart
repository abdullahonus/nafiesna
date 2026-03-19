import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/widget/common/app_error_state.dart';
import '../../../product/widget/common/app_loading_indicator.dart';

@RoutePage()
class PdfView extends ConsumerWidget {
  const PdfView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Evrad ve Kaside'),
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Kaside-i Kitapçığı'),
              Tab(text: 'Evrad-ı Şerif'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const TabBarView(
          children: [
            _PdfPage(assetPath: 'assets/kaside_i_burde.pdf', title: 'Kaside'),
            _PdfPage(
              assetPath: 'assets/evrad_i_serif.pdf',
              title: 'Evrad-ı Şerif',
            ),
          ],
        ),
      ),
    );
  }
}

class _PdfPage extends StatefulWidget {
  final String assetPath;
  final String title;

  const _PdfPage({required this.assetPath, required this.title});

  @override
  State<_PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<_PdfPage> with AutomaticKeepAliveClientMixin {
  final PdfViewerController _pdfController = PdfViewerController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _pageController = TextEditingController();
  PdfTextSearchResult? _searchResult;
  bool _isSearchMode = false;

  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _pdfController.dispose();
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    _searchResult = _pdfController.searchText(query);
    if (mounted) setState(() {});
  }

  void _jumpToPage(String value) {
    if (value.isEmpty) return;
    final page = int.tryParse(value);
    if (page != null && page > 0 && page <= _totalPages) {
      _pdfController.jumpToPage(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Column(
          children: [
            if (!_isLoading && !_hasError) _buildTopBar(),
            Expanded(child: _buildPdfViewer()),
          ],
        ),
        if (_isLoading)
          Container(
            color: AppColors.background,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLoadingIndicator(size: 32),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${widget.title} yükleniyor...',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        if (_hasError)
          AppErrorState(
            message: '${widget.title} yüklenemedi.\nAsset dosyası bulunamadı.',
          ),
      ],
    );
  }

  Widget _buildTopBar() {
    if (_isSearchMode) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
        color: AppColors.primary.withValues(alpha: 0.08),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 14),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Metin ara...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, size: 20, color: AppColors.primary),
                      onPressed: () {
                         _performSearch(_searchController.text);
                         FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  onSubmitted: (val) {
                    _performSearch(val);
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),
            if (_searchResult != null && _searchResult!.hasResult) ...[
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36),
                icon: const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.primary),
                onPressed: () {
                  _searchResult?.previousInstance();
                  setState(() {});
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                onPressed: () {
                  _searchResult?.nextInstance();
                  setState(() {});
                },
              ),
            ],
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36),
              icon: const Icon(Icons.close_rounded, color: AppColors.error),
              onPressed: () {
                setState(() {
                  _isSearchMode = false;
                  _searchResult?.clear();
                  _searchController.clear();
                });
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
      color: AppColors.surfaceVariant.withValues(alpha: 0.9),
      child: Row(
        children: [
          InkWell(
            onTap: () => setState(() => _isSearchMode = true),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Kelime Ara',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Sayfa:',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 52,
            height: 32,
            child: TextField(
              controller: _pageController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.go,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                hintText: '$_currentPage',
                hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
              ),
              onSubmitted: (val) {
                _jumpToPage(val);
                _pageController.clear();
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '/ $_totalPages',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              if (_pageController.text.isNotEmpty) {
                _jumpToPage(_pageController.text);
                _pageController.clear();
              }
              FocusScope.of(context).unfocus();
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfViewer() {
    return SfPdfViewer.asset(
      widget.assetPath,
      controller: _pdfController,
      scrollDirection: PdfScrollDirection.vertical,
      pageLayoutMode: PdfPageLayoutMode.continuous,
      canShowScrollHead: false,
      canShowScrollStatus: false,
      pageSpacing: 4,
      onDocumentLoaded: (details) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _totalPages = details.document.pages.count;
          });
        }
      },
      onDocumentLoadFailed: (_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      },
      onPageChanged: (details) {
        if (mounted) {
          setState(() {
            _currentPage = details.newPageNumber;
          });
        }
      },
    );
  }
}
