import '../../domain/repository/prayer_times_repository.dart';
import '../../data/model/prayer_times_model.dart';
import '../../service/prayer_times_service.dart';

class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  PrayerTimesRepositoryImpl(this._service);

  final PrayerTimesService _service;

  @override
  Future<PrayerTimesModel> getTodayTimings({int locationId = 9541}) {
    return _service.getTodayTimings(locationId: locationId);
  }

  @override
  Future<PrayerTimesModel> getTodayTimingsByCoordinates({
    required double latitude,
    required double longitude,
    int? locationId,
  }) {
    return _service.getTodayTimingsByCoordinates(
      latitude: latitude,
      longitude: longitude,
      locationId: locationId,
    );
  }
}
