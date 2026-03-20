import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/constants/app_spacing.dart';
import '../../../service/nearby_mosques_service.dart';
import '../../../service/location_service.dart';
import '../../../product/widget/common/permission_warnings.dart';

final _mosqueServiceProvider = Provider((ref) => NearbyMosquesService());
final _locationServiceProvider = Provider((ref) => LocationService());

class NearbyMosquesPage extends ConsumerStatefulWidget {
  const NearbyMosquesPage({super.key});

  @override
  ConsumerState<NearbyMosquesPage> createState() => _NearbyMosquesPageState();
}

class _NearbyMosquesPageState extends ConsumerState<NearbyMosquesPage> {
  List<Mosque>? _mosques;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMosques();
  }

  Future<void> _loadMosques() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final LocationService locationService =
          ref.read(_locationServiceProvider);

      final bool serviceEnabled =
          await locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'Konum servisi kapalı. Lütfen açın.';
          _isLoading = false;
        });
        return;
      }

      final LocationPermission permission =
          await locationService.checkAndRequestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Konum izni gerekli. Lütfen izin verin.';
          _isLoading = false;
        });
        return;
      }

      final Position position = await locationService.getCurrentPosition();
      final List<Mosque> mosques =
          await ref.read(_mosqueServiceProvider).getNearbyMosques(
                latitude: position.latitude,
                longitude: position.longitude,
              );

      if (mounted) {
        setState(() {
          _mosques = mosques;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Camiler yüklenirken hata oluştu.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        title: Text(
          'Yakın Camiler',
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.colors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        actions: [
          LocationInfoWarningButton(),
          IconButton(
            onPressed: _isLoading ? null : _loadMosques,
            icon: Icon(Icons.refresh_rounded, color: context.colors.accent),
            tooltip: 'Yenile',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: context.colors.accent),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Yakındaki camiler aranıyor...',
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : _error != null
              ? _buildError()
              : _buildList(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_rounded,
              color: context.colors.error,
              size: 56,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              _error!,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: _loadMosques,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_mosques == null || _mosques!.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mosque_outlined,
              color: context.colors.textSecondary.withValues(alpha: 0.4),
              size: 64,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '3 km içinde cami bulunamadı.',
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _mosques!.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, int index) {
        final Mosque mosque = _mosques![index];
        return _MosqueCard(mosque: mosque);
      },
    );
  }
}

class _MosqueCard extends StatelessWidget {
  const _MosqueCard({required this.mosque});

  final Mosque mosque;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: context.colors.surface,
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.primary.withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.mosque_rounded,
              color: context.colors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mosque.name,
                  style: context.textTheme.headlineSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.directions_walk_rounded,
                      color: context.colors.accent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      mosque.formattedDistance,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (mosque.address != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          mosque.address!,
                          style: context.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: () => _openInMaps(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.primary.withValues(alpha: 0.15),
                border: Border.all(
                  color: context.colors.primary.withValues(alpha: 0.4),
                ),
              ),
              child: Icon(
                Icons.directions_rounded,
                color: context.colors.primary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openInMaps(BuildContext context) async {
    final Uri mapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${mosque.latitude},${mosque.longitude}',
    );

    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harita uygulaması açılamadı.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}