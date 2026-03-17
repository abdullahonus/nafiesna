import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../../domain/repository/prayer_times_repository.dart';
import '../../../data/model/prayer_times_model.dart';
import '../../../service/location_service.dart';

class PrayerTime extends Equatable {
  const PrayerTime({
    required this.name,
    required this.time,
    required this.icon,
  });

  final String name;
  final String time;
  final String icon;

  @override
  List<Object?> get props => [name, time, icon];
}

/// Konum izin durumu
enum LocationStatus {
  idle,
  loading,
  permitted,
  denied,
  deniedForever,
  serviceDisabled,
}

class PrayerTimesState extends Equatable {
  const PrayerTimesState({
    this.isLoading = false,
    this.prayers = const [],
    this.errorMessage,
    this.currentPrayerIndex = -1,
    this.dateLabel = '',
    this.hijriDate = '',
    this.locationName = '',
    this.locationStatus = LocationStatus.idle,
  });

  final bool isLoading;
  final List<PrayerTime> prayers;
  final String? errorMessage;
  final int currentPrayerIndex;
  final String dateLabel;
  final String hijriDate;

  /// Gösterilen konum adı ("İstanbul", "Berlin", "İstanbul — Diyanet", vb.)
  final String locationName;

  /// Konum izni ve GPS durumu
  final LocationStatus locationStatus;

  bool get hasError => errorMessage != null;
  bool get isLocationLoading => locationStatus == LocationStatus.loading;
  bool get isPermissionDenied => locationStatus == LocationStatus.denied;
  bool get isPermissionDeniedForever =>
      locationStatus == LocationStatus.deniedForever;
  bool get isServiceDisabled => locationStatus == LocationStatus.serviceDisabled;

  PrayerTimesState copyWith({
    bool? isLoading,
    List<PrayerTime>? prayers,
    String? errorMessage,
    bool clearError = false,
    int? currentPrayerIndex,
    String? dateLabel,
    String? hijriDate,
    String? locationName,
    LocationStatus? locationStatus,
  }) {
    return PrayerTimesState(
      isLoading: isLoading ?? this.isLoading,
      prayers: prayers ?? this.prayers,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentPrayerIndex: currentPrayerIndex ?? this.currentPrayerIndex,
      dateLabel: dateLabel ?? this.dateLabel,
      hijriDate: hijriDate ?? this.hijriDate,
      locationName: locationName ?? this.locationName,
      locationStatus: locationStatus ?? this.locationStatus,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        prayers,
        errorMessage,
        currentPrayerIndex,
        dateLabel,
        hijriDate,
        locationName,
        locationStatus,
      ];
}

class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  PrayerTimesNotifier(this._repository, this._locationService)
      : super(const PrayerTimesState());

  final PrayerTimesRepository _repository;
  final LocationService _locationService;

  // ── Başlangıç ─────────────────────────────────────────────────────────────

  /// İlk yükleme: GPS konumunu dener, başarısız olursa İstanbul varsayılanı.
  Future<void> init() async {
    state = state.copyWith(isLoading: true, clearError: true);

    // GPS servisi açık mı?
    final serviceEnabled = await _locationService.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(locationStatus: LocationStatus.serviceDisabled);
      _loadFallback();
      return;
    }

    // İzin durumunu kontrol et
    final permission = await _locationService.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // İzin yok → İstanbul varsayılanı yükle, UI'da izin isteği göster
      final status = permission == LocationPermission.deniedForever
          ? LocationStatus.deniedForever
          : LocationStatus.denied;
      state = state.copyWith(locationStatus: status);
      _loadFallback();
      return;
    }

    // İzin var → konumla yükle
    await _loadWithLocation();
  }

  // ── İzin İsteme ───────────────────────────────────────────────────────────

  /// Kullanıcı "Konum İzni Ver" butonuna bastığında çağrılır.
  Future<void> requestLocationPermission() async {
    state = state.copyWith(
      locationStatus: LocationStatus.loading,
      clearError: true,
    );

    final permission = await _locationService.checkAndRequestPermission();

    if (permission == LocationPermission.denied) {
      state = state.copyWith(locationStatus: LocationStatus.denied);
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      state = state.copyWith(locationStatus: LocationStatus.deniedForever);
      return;
    }

    // İzin verildi → konumla yükle
    await _loadWithLocation();
  }

  /// Kalıcı red durumunda sistem ayarlarını açar.
  Future<void> openAppSettings() => _locationService.openAppSettings();

  /// GPS kapalıyken sistem konum ayarlarını açar.
  Future<void> openLocationSettings() =>
      _locationService.openLocationSettings();

  // ── Konum ile yükleme ─────────────────────────────────────────────────────

  Future<void> _loadWithLocation() async {
    state = state.copyWith(
      isLoading: true,
      locationStatus: LocationStatus.loading,
      clearError: true,
    );

    try {
      final position = await _locationService.getCurrentPosition();
      final lat = position.latitude;
      final lng = position.longitude;

      // Şehir adını Nominatim'den al
      final cityName = await _locationService.getCityName(lat, lng);

      // Diyanet'te şehri ara (Türkiye içi)
      int? locationId;
      String displayName = cityName ?? 'Bilinmiyor';

      if (cityName != null && cityName.isNotEmpty) {
        locationId = await _locationService.searchDiyanetLocationId(cityName);
      }

      final model = await _repository.getTodayTimingsByCoordinates(
        latitude: lat,
        longitude: lng,
        locationId: locationId,
      );

      final prayers = _buildPrayerList(model.timings);
      final now = DateTime.now();

      // Kaynak bilgisini etiketle
      final sourceLabel = locationId != null ? ' — Diyanet' : '';

      state = state.copyWith(
        isLoading: false,
        locationStatus: LocationStatus.permitted,
        prayers: prayers,
        currentPrayerIndex: _findCurrentPrayer(prayers, now),
        dateLabel: DateFormat('d MMMM yyyy, EEEE', 'tr_TR').format(now),
        hijriDate: model.hijriDate.formatted,
        locationName: '$displayName$sourceLabel',
      );
    } catch (e) {
      // GPS / ağ hatası → fallback
      state = state.copyWith(locationStatus: LocationStatus.permitted);
      _loadFallback();
    }
  }

  // ── Yenile ────────────────────────────────────────────────────────────────

  /// Namaz vakitlerini konumu güncelleyerek yeniler.
  Future<void> refresh() async {
    final hasPermission = state.locationStatus == LocationStatus.permitted;
    if (hasPermission) {
      await _loadWithLocation();
    } else {
      await init();
    }
  }

  // ── Yardımcı ──────────────────────────────────────────────────────────────

  List<PrayerTime> _buildPrayerList(PrayerTimingsData timings) {
    return [
      PrayerTime(name: 'İmsak', time: timings.imsak, icon: '🌙'),
      PrayerTime(name: 'Sabah', time: timings.fajr, icon: '🌅'),
      PrayerTime(name: 'Öğle', time: timings.dhuhr, icon: '☀️'),
      PrayerTime(name: 'İkindi', time: timings.asr, icon: '🌤'),
      PrayerTime(name: 'Akşam', time: timings.maghrib, icon: '🌆'),
      PrayerTime(name: 'Yatsı', time: timings.isha, icon: '🌃'),
    ];
  }

  int _findCurrentPrayer(List<PrayerTime> prayers, DateTime now) {
    final currentMinutes = now.hour * 60 + now.minute;
    int current = -1;
    for (int i = 0; i < prayers.length; i++) {
      final parts = prayers[i].time.split(':');
      if (parts.length < 2) continue;
      final prayerMinutes =
          int.parse(parts[0]) * 60 + int.parse(parts[1]);
      if (currentMinutes >= prayerMinutes) current = i;
    }
    return current;
  }

  // ── Fallback (ağ/GPS yoksa İstanbul ortalaması) ───────────────────────────

  void _loadFallback() {
    final now = DateTime.now();
    final month = now.month;

    const fallback = <int, List<String>>{
      1: ['06:37', '06:47', '13:26', '15:57', '17:56', '19:17'],
      2: ['06:22', '06:32', '13:27', '16:08', '18:09', '19:32'],
      3: ['05:58', '06:08', '13:21', '16:20', '18:24', '19:47'],
      4: ['05:20', '05:30', '13:12', '16:35', '18:44', '20:07'],
      5: ['04:36', '04:46', '13:00', '16:47', '19:02', '20:26'],
      6: ['04:04', '04:14', '12:53', '16:57', '19:17', '20:46'],
      7: ['04:11', '04:21', '13:00', '17:08', '19:20', '20:48'],
      8: ['04:48', '04:58', '13:11', '17:08', '19:07', '20:26'],
      9: ['05:23', '05:33', '13:19', '17:02', '18:46', '20:00'],
      10: ['05:57', '06:07', '13:20', '16:51', '18:20', '19:35'],
      11: ['06:32', '06:42', '13:23', '16:39', '17:58', '19:13'],
      12: ['06:57', '07:07', '13:31', '16:29', '17:43', '18:57'],
    };

    final times = fallback[month] ??
        ['05:20', '05:30', '13:00', '16:30', '19:00', '20:30'];

    final timings = PrayerTimingsData(
      imsak: times[0],
      fajr: times[1],
      dhuhr: times[2],
      asr: times[3],
      maghrib: times[4],
      isha: times[5],
    );

    final prayers = _buildPrayerList(timings);

    state = state.copyWith(
      isLoading: false,
      prayers: prayers,
      currentPrayerIndex: _findCurrentPrayer(prayers, now),
      dateLabel: DateFormat('d MMMM yyyy, EEEE', 'tr_TR').format(now),
      hijriDate: '',
      locationName: 'İstanbul (varsayılan)',
    );
  }
}
