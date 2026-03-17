import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../service/location_service.dart';
import '../../../service/qibla_service.dart';

class QiblaState extends Equatable {
  const QiblaState({
    this.isLoading = true,
    this.qiblaDirection = 0,
    this.deviceHeading = 0,
    this.distanceKm = 0,
    this.hasCompass = true,
    this.errorMessage,
  });

  final bool isLoading;

  /// Kuzeyden saat yönünde Kabe'ye olan açı (0-360)
  final double qiblaDirection;

  /// Cihazın manyetometre heading'i (0-360, kuzey = 0)
  final double deviceHeading;

  /// Kullanıcı → Kabe mesafesi (km)
  final double distanceKm;

  /// Cihazda manyetometre sensörü var mı
  final bool hasCompass;

  final String? errorMessage;

  /// Pusula üzerinde kıble iğnesinin dönme açısı
  double get needleAngle => qiblaDirection - deviceHeading;

  QiblaState copyWith({
    bool? isLoading,
    double? qiblaDirection,
    double? deviceHeading,
    double? distanceKm,
    bool? hasCompass,
    String? errorMessage,
  }) {
    return QiblaState(
      isLoading: isLoading ?? this.isLoading,
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      deviceHeading: deviceHeading ?? this.deviceHeading,
      distanceKm: distanceKm ?? this.distanceKm,
      hasCompass: hasCompass ?? this.hasCompass,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        qiblaDirection,
        deviceHeading,
        distanceKm,
        hasCompass,
        errorMessage,
      ];
}

class QiblaNotifier extends StateNotifier<QiblaState> {
  QiblaNotifier(this._qiblaService, this._locationService)
      : super(const QiblaState());

  final QiblaService _qiblaService;
  final LocationService _locationService;
  StreamSubscription<double>? _compassSub;

  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    try {
      final position = await _locationService.getCurrentPosition();
      final double qibla = _qiblaService.calculateQiblaDirection(
        position.latitude,
        position.longitude,
      );
      final double distance = _qiblaService.distanceToKaaba(
        position.latitude,
        position.longitude,
      );

      state = state.copyWith(
        qiblaDirection: qibla,
        distanceKm: distance,
        isLoading: false,
      );

      _startCompass();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Konum alınamadı. Lütfen konum iznini kontrol edin.',
      );
    }
  }

  void _startCompass() {
    final Stream<double>? stream = _qiblaService.compassStream;
    if (stream == null) {
      state = state.copyWith(hasCompass: false);
      return;
    }

    _compassSub = stream.listen(
      (double heading) {
        if (mounted) {
          state = state.copyWith(deviceHeading: heading);
        }
      },
      onError: (_) {
        if (mounted) {
          state = state.copyWith(hasCompass: false);
        }
      },
    );
  }

  @override
  void dispose() {
    _compassSub?.cancel();
    super.dispose();
  }
}
