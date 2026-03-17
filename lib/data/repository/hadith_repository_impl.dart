import '../../domain/repository/hadith_repository.dart';
import '../../data/model/hadith_model.dart';
import '../../service/hadith_service.dart';

class HadithRepositoryImpl implements HadithRepository {
  HadithRepositoryImpl(this._service);

  final HadithService _service;

  @override
  Future<HadithModel> getHadithOfTheDay() {
    return _service.getHadithOfTheDay();
  }
}
