import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repository/hadith_repository.dart';

class HadithData extends Equatable {
  const HadithData({
    required this.text,
    required this.arabicText,
    required this.attribution,
    required this.grade,
  });

  /// Türkçe tam metin
  final String text;

  /// Arapça orijinal metin
  final String arabicText;

  /// Kaynak kitap bilgisi
  final String attribution;

  /// Hadis derecesi (Sahih, Hasen vb.)
  final String grade;

  @override
  List<Object?> get props => [text, arabicText, attribution, grade];
}

class HomeState extends Equatable {
  const HomeState({
    this.isLoading = false,
    this.hadith,
    this.errorMessage,
  });

  final bool isLoading;
  final HadithData? hadith;
  final String? errorMessage;

  bool get hasError => errorMessage != null;

  HomeState copyWith({
    bool? isLoading,
    HadithData? hadith,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      hadith: hadith ?? this.hadith,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, hadith, errorMessage];
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier(this._repository) : super(const HomeState());

  final HadithRepository _repository;

  Future<void> init() async {
    await loadHadith();
  }

  Future<void> loadHadith() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final model = await _repository.getHadithOfTheDay();
      state = state.copyWith(
        isLoading: false,
        hadith: HadithData(
          text: model.text,
          arabicText: model.arabicText,
          attribution: model.attribution,
          grade: model.grade,
        ),
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        hadith: _fallbackHadith,
      );
    }
  }

  static final HadithData _fallbackHadith = HadithData(
    text: _fallbacks[DateTime.now().difference(DateTime(DateTime.now().year)).inDays %
        _fallbacks.length],
    arabicText: '',
    attribution: 'Sahih-i Buhârî',
    grade: 'Sahih',
  );

  static const List<String> _fallbacks = [
    'Kolaylaştırınız, güçleştirmeyiniz. Müjdeleyiniz, nefret ettirmeyiniz.',
    'Müminin müminine karşı durumu, birbirini sıkıştıran binalar gibidir.',
    'Güzel ahlakı tamamlamak için gönderildim.',
    'Sizin en hayırlınız Kur\'ân\'ı öğrenen ve öğretendir.',
    'Komşusu açken tok yatan bizden değildir.',
    'İlim öğrenmek her Müslüman\'a farzdır.',
    'Bir kimse için kendine istediğini kardeşi için de istemedikçe gerçek mümin olamaz.',
  ];
}
