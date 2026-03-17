import 'dart:async';
import 'dart:math';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

/// Kıble yönü hesaplama + pusula stream servisi.
///
/// Akış:
///   1. GPS'ten kullanıcı koordinatlarını al
///   2. Great Circle formülü ile Kabe'ye açıyı hesapla
///   3. flutter_compass ile cihaz heading'ini stream et
///   4. UI: qiblaAngle - deviceHeading = pusula üzerinde kıble yönü
class QiblaService {
  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;

  /// Cihaz pusula heading stream'i (0-360 derece, kuzey = 0).
  /// Cihazda manyetometre yoksa null döner.
  Stream<double>? get compassStream {
    return FlutterCompass.events?.map((event) => event.heading ?? 0);
  }

  /// Kullanıcı konumundan Kabe'ye olan açıyı derece cinsinden hesaplar.
  /// Kuzeyden saat yönünde 0-360.
  double calculateQiblaDirection(double userLat, double userLng) {
    final double lat1 = _toRadians(userLat);
    final double lng1 = _toRadians(userLng);
    final double lat2 = _toRadians(_kaabaLat);
    final double lng2 = _toRadians(_kaabaLng);

    final double dLng = lng2 - lng1;

    final double y = sin(dLng) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);

    double bearing = atan2(y, x);
    bearing = _toDegrees(bearing);
    return (bearing + 360) % 360;
  }

  /// Kullanıcı ile Kabe arasındaki mesafeyi km cinsinden döndürür.
  double distanceToKaaba(double userLat, double userLng) {
    return Geolocator.distanceBetween(
          userLat,
          userLng,
          _kaabaLat,
          _kaabaLng,
        ) /
        1000;
  }

  double _toRadians(double degree) => degree * (pi / 180);
  double _toDegrees(double radian) => radian * (180 / pi);
}
