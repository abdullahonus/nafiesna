import '../../data/model/hadith_model.dart';

abstract class HadithRepository {
  Future<HadithModel> getHadithOfTheDay();
}
