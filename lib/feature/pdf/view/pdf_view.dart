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
  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Column(
          children: [
            if (!_isLoading && !_hasError)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xs,
                  horizontal: AppSpacing.md,
                ),
                color: AppColors.surfaceVariant,
                width: double.infinity,
                child: Text(
                  'Sayfa: $_currentPage / $_totalPages',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
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
