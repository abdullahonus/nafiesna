import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../service/youtube_live_service.dart';

// TODO: YouTube Data API key'i güvenli bir yere taşınacak (env / remote config)
const String _youtubeApiKey = 'AIzaSyC2AcvtBZ9TZCQft6az47UspEI5sJbo1UM';

final _ytServiceProvider = Provider(
  (ref) => YouTubeLiveService(apiKey: _youtubeApiKey),
);

final _liveStatusProvider = FutureProvider.autoDispose<LiveStreamInfo>((ref) {
  return ref.read(_ytServiceProvider).checkLiveStatus();
});

class LiveStreamCard extends ConsumerWidget {
  const LiveStreamCard({super.key});

  static const String _channelUrl =
      'https://www.youtube.com/@bloomberght/streams';

  Future<void> _openUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('YouTube açılamadı.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<LiveStreamInfo> liveAsync = ref.watch(_liveStatusProvider);
    final bool isLive = liveAsync.valueOrNull?.isLive ?? false;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surfaceVariant],
        ),
        border: Border.all(
          color: isLive ? Colors.red.withValues(alpha: 0.4) : AppColors.border,
          width: isLive ? 1.0 : 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isLive
                ? Colors.red.withValues(alpha: 0.15)
                : AppColors.accent.withValues(alpha: 0.08),
            blurRadius: isLive ? 24 : 16,
            spreadRadius: isLive ? 2 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThumbnail(context, liveAsync),
          _buildInfo(context, isLive),
        ],
      ),
    );
  }

  Widget _buildThumbnail(
    BuildContext context,
    AsyncValue<LiveStreamInfo> liveAsync,
  ) {
    final LiveStreamInfo? info = liveAsync.valueOrNull;
    final bool isLive = info?.isLive ?? false;

    return GestureDetector(
      onTap: () {
        final String url = isLive && info?.videoId != null
            ? info!.videoUrl
            : _channelUrl;
        _openUrl(context, url);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusLg),
          topRight: Radius.circular(AppSpacing.radiusLg),
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (isLive && info?.thumbnailUrl != null)
                Image.network(
                  info!.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildGradientBg(),
                )
              else
                _buildGradientBg(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 68,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildBadge(isLive),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientBg() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A1628), Color(0xFF001A1A)],
        ),
      ),
    );
  }

  Widget _buildBadge(bool isLive) {
    if (isLive) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.5),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PulsingDot(),
            SizedBox(width: 6),
            Text(
              'CANLI YAYIN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: const Text(
        'CANLI YAYIN YOK',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context, bool isLive) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('NafiEsna', style: AppTextStyles.labelLarge),
                Text(
                  isLive ? 'Şu an canlı yayında!' : 'Canlı Yayın & Sohbet',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isLive ? Colors.red : AppColors.textSecondary,
                    fontWeight: isLive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _openUrl(context, _channelUrl),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isLive ? Colors.red : AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                isLive ? 'İzle' : 'Kanala Git',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Canlı yayın göstergesi — nabız gibi atan kırmızı nokta
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(
              alpha: 0.5 + (_controller.value * 0.5),
            ),
          ),
        );
      },
    );
  }
}
