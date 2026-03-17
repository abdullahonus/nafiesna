import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../service/islamic_calendar_service.dart';

class ReligiousDay extends Equatable {
  const ReligiousDay({
    required this.name,
    required this.date,
    required this.description,
    required this.icon,
    this.isUpcoming = false,
    this.daysUntil = 0,
  });

  final String name;
  final String date;
  final String description;
  final String icon;
  final bool isUpcoming;
  final int daysUntil;

  @override
  List<Object?> get props => [name, date, description, icon, isUpcoming, daysUntil];
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
  ContentNotifier(this._calendarService) : super(const ContentState());

  final IslamicCalendarService _calendarService;

  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    try {
      final events = await _calendarService.getUpcomingEvents();
      final days = _mapEventsToReligiousDays(events);

      state = state.copyWith(
        isLoading: false,
        religiousDays: days,
        islamicInfos: _infos,
      );
    } catch (_) {
      final fallback = IslamicCalendarService.getFallback2026();
      final days = _mapEventsToReligiousDays(fallback);

      state = state.copyWith(
        isLoading: false,
        religiousDays: days,
        islamicInfos: _infos,
      );
    }
  }

  List<ReligiousDay> _mapEventsToReligiousDays(List<IslamicEvent> events) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return events.map((event) {
      final eventDay = DateTime(event.date.year, event.date.month, event.date.day);
      final bool upcoming = !eventDay.isBefore(today);
      final int daysLeft = eventDay.difference(today).inDays;
      final String dateStr = DateFormat('d MMMM yyyy, EEEE', 'tr_TR').format(event.date);

      return ReligiousDay(
        name: event.name,
        date: dateStr,
        description: _getDescription(event.name),
        icon: _getIcon(event.name),
        isUpcoming: upcoming,
        daysUntil: daysLeft,
      );
    }).toList();
  }

  String _getIcon(String name) {
    const Map<String, String> icons = {
      'Ramazan Bayramı': '🎊',
      'Kurban Bayramı': '🌿',
      'Kadir Gecesi': '⭐',
      'Hicri Yılbaşı': '🕌',
      'Aşure Günü': '📿',
      'Mevlid Kandili': '🌙',
      'Miraç Kandili': '✨',
      'Berat Kandili': '📿',
      'Regaib Kandili': '🌙',
      'Ramazan Başlangıcı': '🕌',
      'Üç Ayların Başlangıcı': '🌙',
      'Arefe (Kurban)': '🌿',
    };
    return icons[name] ?? '🌙';
  }

  String _getDescription(String name) {
    const Map<String, String> descriptions = {
      'Ramazan Bayramı': 'Ramazan orucunun tamamlanmasının ardından kutlanan bayram.',
      'Kurban Bayramı': 'Hz. İbrahim\'in (a.s.) sünnetinin yaşatıldığı mübarek bayram.',
      'Kadir Gecesi': 'Bin aydan hayırlı olan gece. Kur\'ân bu gecede indirildi.',
      'Hicri Yılbaşı': 'İslami takvimde yeni yılın başlangıcı.',
      'Aşure Günü': 'Muharrem ayının 10. günü. Birçok önemli olayın yaşandığı gün.',
      'Mevlid Kandili': 'Hz. Peygamber\'in (s.a.v.) doğum günü.',
      'Miraç Kandili': 'Hz. Peygamber\'in (s.a.v.) Allah\'ın huzuruna yükseldiği gece.',
      'Berat Kandili': 'Şaban ayının 15. gecesi. Beraat gecesi olarak da bilinir.',
      'Regaib Kandili': 'Recep ayının ilk Cuma gecesi. Üç ayların başlangıcı.',
      'Ramazan Başlangıcı': 'Mübarek Ramazan ayının ilk günü. Oruç ibadeti başlar.',
      'Üç Ayların Başlangıcı': 'Recep, Şaban ve Ramazan aylarının başlangıcı.',
      'Arefe (Kurban)': 'Kurban Bayramı\'ndan önceki gün. Hacıların Arafat\'a çıktığı gün.',
    };
    return descriptions[name] ?? '';
  }

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
}
