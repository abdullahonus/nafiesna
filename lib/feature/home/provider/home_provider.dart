import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/home_notifier.dart';
import '../../../data/repository/hadith_repository_impl.dart';
import '../../../service/hadith_service.dart';

final _hadithRepositoryProvider = Provider(
  (ref) => HadithRepositoryImpl(HadithService()),
);

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(ref.read(_hadithRepositoryProvider)),
);
