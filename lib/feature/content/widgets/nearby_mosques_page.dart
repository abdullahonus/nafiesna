import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../product/constants/app_spacing.dart';
import '../../../product/init/theme/app_text_styles.dart';
import '../../../product/widget/common/permission_warnings.dart';
import '../../../product/widget/common/username_badge.dart';
import '../../../service/location_service.dart';
import '../../../service/nearby_mosques_service.dart';

// ── Providers ──────────────────────────────────────────────────────────────────

final _mosqueServiceProvider = Provider((ref) => NearbyMosquesService());
final _locationServiceProvider = Provider((ref) => LocationService());

// ── Ana Sayfa ──────────────────────────────────────────────────────────────────

class NearbyMosquesPage extends StatelessWidget {
  const NearbyMosquesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: _buildAppBar(context),
        body: const TabBarView(
          children: [
            _PlacesListTab(type: PlaceType.mosque),
            _TurbeView(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.colors.surface,
      elevation: 0,
      title: Text(
        'Yakın İbadet Yerleri',
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
      actions: const [
        LocationInfoWarningButton(),
        UsernameBadge(),
        SizedBox(width: 8),
      ],
      bottom: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          color: context.colors.accent.withValues(alpha: 0.15),
        ),
        labelColor: context.colors.accent,
        unselectedLabelColor: context.colors.textSecondary,
        labelStyle: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(
          fontSize: 13,
        ),
        dividerColor: context.colors.border,
        tabs: const [
          Tab(
            icon: Icon(Icons.mosque_rounded, size: 20),
            text: 'Camiler',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
          Tab(
            icon: Icon(Icons.account_balance_rounded, size: 20),
            text: 'Türbeler',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
        ],
      ),
    );
  }
}

// ── Türbeler Ana Widget (Liste | Harita sub-tab) ────────────────────────────────

class _TurbeView extends ConsumerStatefulWidget {
  const _TurbeView();

  @override
  ConsumerState<_TurbeView> createState() => _TurbeViewState();
}

class _TurbeViewState extends ConsumerState<_TurbeView>
    with AutomaticKeepAliveClientMixin {
  List<NearbyPlace>? _turbes;
  bool _isLoading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadTurbes();
  }

  Future<void> _loadTurbes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final List<NearbyPlace> result = await ref
          .read(_mosqueServiceProvider)
          .getTurkeyTurbes();
      if (mounted) {
        setState(() {
          _turbes = result;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Türbeler yüklenirken hata oluştu.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: context.colors.accent),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Türkiye türbeleri yükleniyor…',
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
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
                onPressed: _loadTurbes,
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

    final List<NearbyPlace> turbes = _turbes ?? [];

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Sub-TabBar
          Container(
            color: context.colors.surface,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 2.5,
                  color: context.colors.accent,
                ),
              ),
              labelColor: context.colors.accent,
              unselectedLabelColor: context.colors.textSecondary,
              labelStyle: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: const [
                Tab(icon: Icon(Icons.list_rounded, size: 18), text: 'Liste'),
                Tab(icon: Icon(Icons.map_rounded, size: 18), text: 'Harita'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _TurbeListTab(turbes: turbes, onRefresh: _loadTurbes),
                _PlacesMapTab(
                  places: turbes,
                  initialCenter: const LatLng(39.0, 35.0),
                  initialZoom: 5.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Türbe Liste Sekmesi ─────────────────────────────────────────────────────────

class _TurbeListTab extends StatefulWidget {
  const _TurbeListTab({required this.turbes, required this.onRefresh});

  final List<NearbyPlace> turbes;
  final VoidCallback onRefresh;

  @override
  State<_TurbeListTab> createState() => _TurbeListTabState();
}

class _TurbeListTabState extends State<_TurbeListTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<NearbyPlace> get _filtered {
    if (_query.isEmpty) return widget.turbes;
    final String q = _query.toLowerCase();
    return widget.turbes
        .where((t) => t.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<NearbyPlace> filtered = _filtered;

    return Column(
      children: [
        // Arama kutusu
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xs,
          ),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _query = v),
            style: context.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Türbe ara…',
              hintStyle: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.textHint,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: context.colors.accent,
                size: 20,
              ),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: context.colors.textSecondary,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: context.colors.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(
                  color: context.colors.border,
                  width: 0.6,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(
                  color: context.colors.accent,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
        // Sonuç sayısı
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Text(
                '${filtered.length} türbe',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Liste
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_balance_outlined,
                        color: context.colors.textSecondary.withValues(
                          alpha: 0.35,
                        ),
                        size: 56,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        _query.isEmpty
                            ? 'Türkiye genelinde türbe bulunamadı.'
                            : '"$_query" için sonuç yok.',
                        style: context.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: context.colors.accent,
                  onRefresh: () async => widget.onRefresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xs,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, int i) => _PlaceCard(place: filtered[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

// ── Harita Sekmesi ────────────────────────────────────────────────────────

class _PlacesMapTab extends StatefulWidget {
  const _PlacesMapTab({
    required this.places,
    required this.initialCenter,
    required this.initialZoom,
  });

  final List<NearbyPlace> places;
  final LatLng initialCenter;
  final double initialZoom;

  @override
  State<_PlacesMapTab> createState() => _PlacesMapTabState();
}

class _PlacesMapTabState extends State<_PlacesMapTab>
    with AutomaticKeepAliveClientMixin {
  final MapController _mapCtrl = MapController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<Marker> markers = widget.places.map((NearbyPlace p) {
      final Color pinColor = p.type == PlaceType.mosque
          ? context.colors.primary
          : context.colors.accent;
          
      return Marker(
        point: LatLng(p.latitude, p.longitude),
        width: 32,
        height: 32,
        child: GestureDetector(
          onTap: () => _showDetail(context, p),
          child: _PlacePin(color: pinColor, type: p.type),
        ),
      );
    }).toList();

    return FlutterMap(
      mapController: _mapCtrl,
      options: MapOptions(
        initialCenter: widget.initialCenter,
        initialZoom: widget.initialZoom,
        maxZoom: 18,
        minZoom: 4,
      ),
      children: [
        // OSM tile katmanı
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.artra.nafiesna',
          maxZoom: 18,
        ),
        // Pinler
        MarkerLayer(markers: markers),
        // Sağ alt OSM atıf
        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution('OpenStreetMap katkıda bulunanlar'),
          ],
        ),
      ],
    );
  }

  void _showDetail(BuildContext context, NearbyPlace place) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlaceDetailSheet(place: place),
    );
  }
}

// ── Pin ikonu ─────────────────────────────────────────────────────────────

class _PlacePin extends StatelessWidget {
  const _PlacePin({required this.color, required this.type});
  final Color color;
  final PlaceType type;

  @override
  Widget build(BuildContext context) {
    final IconData icon = type == PlaceType.mosque
        ? Icons.mosque_rounded
        : Icons.account_balance_rounded;
        
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.location_on_rounded, color: color, size: 32),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Icon(
            icon,
            color: context.colors.surface,
            size: 13,
          ),
        ),
      ],
    );
  }
}

// ── Detail modal ─────────────────────────────────────────────────────────

class _PlaceDetailSheet extends StatelessWidget {
  const _PlaceDetailSheet({required this.place});
  final NearbyPlace place;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = place.type == PlaceType.mosque
        ? context.colors.primary
        : context.colors.accent;
    final IconData placeIcon = place.type == PlaceType.mosque
        ? Icons.mosque_rounded
        : Icons.account_balance_rounded;
        
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sergiyi tut çubuğu
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // İkon + isim
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withValues(alpha: 0.12),
                ),
                child: Icon(
                  placeIcon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  place.name,
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: context.colors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (place.address != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: context.colors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    place.address!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          // Haritada Aç butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openInMaps(context),
              icon: const Icon(Icons.directions_rounded, size: 18),
              label: const Text('Google Maps\'ta Aç'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  Future<void> _openInMaps(BuildContext context) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${place.latitude},${place.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    if (context.mounted) Navigator.of(context).pop();
  }
}

// ── Cami ListeSekmesi (yakın camiler) ──────────────────────────────────────────

class _PlacesListTab extends ConsumerStatefulWidget {
  const _PlacesListTab({required this.type});

  final PlaceType type;

  @override
  ConsumerState<_PlacesListTab> createState() => _PlacesListTabState();
}

class _PlacesListTabState extends ConsumerState<_PlacesListTab>
    with AutomaticKeepAliveClientMixin {
  List<NearbyPlace>? _places;
  Position? _currentPosition;
  bool _isLoading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  bool get _isMosque => widget.type == PlaceType.mosque;

  String get _emptyMessage => _isMosque
      ? '3 km içinde cami bulunamadı.'
      : '5 km içinde türbe bulunamadı.';

  String get _loadingMessage => _isMosque
      ? 'Yakındaki camiler aranıyor…'
      : 'Yakındaki türbeler aranıyor…';

  String get _errorMessage => _isMosque
      ? 'Camiler yüklenirken hata oluştu.'
      : 'Türbeler yüklenirken hata oluştu.';

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final LocationService locationService = ref.read(
        _locationServiceProvider,
      );

      final bool serviceEnabled = await locationService
          .isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _error = 'Konum servisi kapalı. Lütfen açın.';
            _isLoading = false;
          });
        }
        return;
      }

      final LocationPermission permission = await locationService
          .checkAndRequestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _error = 'Konum izni gerekli. Lütfen izin verin.';
            _isLoading = false;
          });
        }
        return;
      }

      final Position position = await locationService.getCurrentPosition();
      final NearbyMosquesService service = ref.read(_mosqueServiceProvider);

      final List<NearbyPlace> places = _isMosque
          ? await service.getNearbyMosques(
              latitude: position.latitude,
              longitude: position.longitude,
            )
          : await service.getNearbyTurbes(
              latitude: position.latitude,
              longitude: position.longitude,
            );

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _places = places;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = _errorMessage;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) return _buildLoading(context);
    if (_error != null) return _buildError(context);
    
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: context.colors.surface,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 2.5,
                  color: context.colors.accent,
                ),
              ),
              labelColor: context.colors.accent,
              unselectedLabelColor: context.colors.textSecondary,
              labelStyle: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: const [
                Tab(icon: Icon(Icons.list_rounded, size: 18), text: 'Liste'),
                Tab(icon: Icon(Icons.map_rounded, size: 18), text: 'Harita'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildList(context),
                _places == null || _places!.isEmpty
                    ? _buildEmptyMap(context)
                    : _PlacesMapTab(
                        places: _places!,
                        initialCenter: _currentPosition != null
                            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                            : const LatLng(39.0, 35.0),
                        initialZoom: 13.0,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMap(BuildContext context) {
    return Center(
      child: Text(_emptyMessage, style: context.textTheme.bodyMedium),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: context.colors.accent),
          const SizedBox(height: AppSpacing.lg),
          Text(_loadingMessage, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
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
              onPressed: _load,
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

  Widget _buildList(BuildContext context) {
    if (_places == null || _places!.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isMosque
                  ? Icons.mosque_outlined
                  : Icons.account_balance_outlined,
              color: context.colors.textSecondary.withValues(alpha: 0.35),
              size: 64,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(_emptyMessage, style: context.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: _load,
              icon: Icon(
                Icons.refresh_rounded,
                size: 16,
                color: context.colors.accent,
              ),
              label: Text(
                'Yenile',
                style: TextStyle(color: context.colors.accent),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: context.colors.accent,
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        itemCount: _places!.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, int index) => _PlaceCard(place: _places![index]),
      ),
    );
  }
}

// ── Ortak Yer Kartı ─────────────────────────────────────────────────────────────

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place});
  final NearbyPlace place;

  bool get _isMosque => place.type == PlaceType.mosque;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = _isMosque
        ? context.colors.primary
        : context.colors.accent;
    final IconData placeIcon = _isMosque
        ? Icons.mosque_rounded
        : Icons.account_balance_rounded;

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
              color: iconColor.withValues(alpha: 0.12),
            ),
            child: Icon(placeIcon, color: iconColor, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: context.textTheme.headlineSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.directions_walk_rounded,
                      color: context.colors.accent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      place.formattedDistance,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (place.address != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          place.address!,
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
                color: context.colors.primary.withValues(alpha: 0.12),
                border: Border.all(
                  color: context.colors.primary.withValues(alpha: 0.35),
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
      '&destination=${place.latitude},${place.longitude}',
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
