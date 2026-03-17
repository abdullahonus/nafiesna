import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../product/widget/common/app_loading_indicator.dart';
import '../../../product/widget/common/app_error_state.dart';

@RoutePage()
class PdfView extends ConsumerStatefulWidget {
  const PdfView({super.key});

  @override
  ConsumerState<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends ConsumerState<PdfView> {
  final PdfViewerController _pdfController = PdfViewerController();
  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 1;
  int _totalPages = 0;

  static const String _assetPath = 'assets/kaside.pdf';

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kaside-i Bürde'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          if (!_isLoading && !_hasError)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Center(
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_hasError) {
      return const AppErrorState(
        message: 'Kaside-i Bürde yüklenemedi.\nAsset dosyası bulunamadı.',
      );
    }

    return Stack(
      children: [
        SfPdfViewer.asset(
          _assetPath,
          controller: _pdfController,
          scrollDirection: PdfScrollDirection.vertical,
          pageLayoutMode: PdfPageLayoutMode.continuous,
          canShowScrollHead: false,
          canShowScrollStatus: false,
          pageSpacing: 4,
          onDocumentLoaded: (details) {
            setState(() {
              _isLoading = false;
              _totalPages = details.document.pages.count;
            });
          },
          onDocumentLoadFailed: (_) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
          onPageChanged: (details) {
            setState(() {
              _currentPage = details.newPageNumber;
            });
          },
        ),
        if (_isLoading)
          Container(
            color: AppColors.background,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLoadingIndicator(size: 32),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Kaside-i Bürde yükleniyor...',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
