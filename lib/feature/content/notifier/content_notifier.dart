import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReligiousDay extends Equatable {
  const ReligiousDay({
    required this.name,
    required this.date,
    required this.description,
    required this.icon,
    this.isUpcoming = false,
  });

  final String name;
  final String date;
  final String description;
  final String icon;
  final bool isUpcoming;

  @override
  List<Object?> get props => [name, date, description, icon, isUpcoming];
}

class IslamicInfo extends Equatable {
  const IslamicInfo({
    required this.title,
    required this.content,
    required this.category,
  });

  final String title;
  final String content;
  final String category;

  @override
  List<Object?> get props => [title, content, category];
}

class ContentState extends Equatable {
  const ContentState({
    this.isLoading = false,
    this.religiousDays = const [],
    this.islamicInfos = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final List<ReligiousDay> religiousDays;
  final List<IslamicInfo> islamicInfos;
  final String? errorMessage;

  ContentState copyWith({
    bool? isLoading,
    List<ReligiousDay>? religiousDays,
    List<IslamicInfo>? islamicInfos,
    String? errorMessage,
  }) {
    return ContentState(
      isLoading: isLoading ?? this.isLoading,
      religiousDays: religiousDays ?? this.religiousDays,
      islamicInfos: islamicInfos ?? this.islamicInfos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, religiousDays, islamicInfos, errorMessage];
}

class ContentNotifier extends StateNotifier<ContentState> {
  ContentNotifier() : super(const ContentState());

  static const List<ReligiousDay> _days = [
    ReligiousDay(
      name: 'Regaib Gecesi',
      date: '30 Ocak 2025',
      description: 'Recep ayının ilk Cuma gecesi. Üç ayların başlangıcı.',
      icon: '🌙',
      isUpcoming: false,
    ),
    ReligiousDay(
      name: 'Miraç Kandili',
      date: '27 Şubat 2025',
      description: 'Hz. Peygamber\'in (s.a.v.) Allah\'ın huzuruna yükseldiği gece.',
      icon: '✨',
      isUpcoming: false,
    ),
    ReligiousDay(
      name: 'Berat Gecesi',
      date: '13 Mart 2025',
      description: 'Şaban ayının 15. gecesi. Beraat gecesi olarak da bilinir.',
      icon: '📿',
      isUpcoming: true,
    ),
    ReligiousDay(
      name: 'Ramazan Başlangıcı',
      date: '1 Mart 2025',
      description: 'Mübarek Ramazan ayının ilk günü. Oruç ibadeti başlar.',
      icon: '🕌',
      isUpcoming: true,
    ),
    ReligiousDay(
      name: 'Kadir Gecesi',
      date: '27 Mart 2025',
      description: 'Bin aydan hayırlı olan gece. Kur\'ân bu gecede indirildi.',
      icon: '⭐',
      isUpcoming: true,
    ),
    ReligiousDay(
      name: 'Ramazan Bayramı',
      date: '30 Mart 2025',
      description: 'Ramazan orucunun tamamlanmasının ardından kutlanan bayram.',
      icon: '🎊',
      isUpcoming: true,
    ),
    ReligiousDay(
      name: 'Kurban Bayramı',
      date: '6 Haziran 2025',
      description: 'Hz. İbrahim\'in (a.s.) sünnetinin yaşatıldığı mübarek bayram.',
      icon: '🌿',
      isUpcoming: true,
    ),
  ];

  static const List<IslamicInfo> _infos = [
    IslamicInfo(
      title: 'İslam\'ın Beş Şartı',
      content:
          'Kelime-i Şehadet, Namaz, Oruç, Zekât ve Hac. Bu beş temel ibadet İslam\'ın direğini oluşturur.',
      category: 'Temel Bilgiler',
    ),
    IslamicInfo(
      title: 'Beş Vakit Namaz',
      content:
          'Sabah, Öğle, İkindi, Akşam ve Yatsı. Günde beş vakit kılınan namaz, müminin Allah ile buluşmasıdır.',
      category: 'İbadet',
    ),
    IslamicInfo(
      title: 'Kur\'ân-ı Kerim',
      content:
          'Allah\'ın son vahyi. 114 sure, 6236 ayetten oluşur. Hz. Peygamber\'e (s.a.v.) 23 yılda indirilmiştir.',
      category: 'Kur\'ân',
    ),
    IslamicInfo(
      title: 'Sünnet ve Hadis',
      content:
          'Hz. Peygamber\'in (s.a.v.) sözleri, fiilleri ve tasvipleri. İslam\'ın ikinci ana kaynağını oluşturur.',
      category: 'Sünnet',
    ),
    IslamicInfo(
      title: 'Dua Adabı',
      content:
          'Kıbleye yönelmek, abdestli olmak, eller açık tutmak ve kalp huzuruyla yönelmek dua adabındandır.',
      category: 'İbadet',
    ),
  ];

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 200));
    state = state.copyWith(
      isLoading: false,
      religiousDays: _days,
      islamicInfos: _infos,
    );
  }
}
