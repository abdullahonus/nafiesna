// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ContentView]
class ContentRoute extends PageRouteInfo<ContentRouteArgs> {
  ContentRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        ContentRoute.name,
        args: ContentRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ContentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ContentRouteArgs>(
        orElse: () => const ContentRouteArgs(),
      );
      return ContentView(key: args.key);
    },
  );
}

class ContentRouteArgs {
  const ContentRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'ContentRouteArgs{key: $key}';
  }
}

/// generated route for
/// [DreamView]
class DreamRoute extends PageRouteInfo<DreamRouteArgs> {
  DreamRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        DreamRoute.name,
        args: DreamRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'DreamRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DreamRouteArgs>(
        orElse: () => const DreamRouteArgs(),
      );
      return DreamView(key: args.key);
    },
  );
}

class DreamRouteArgs {
  const DreamRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'DreamRouteArgs{key: $key}';
  }
}

/// generated route for
/// [HomeView]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeView();
    },
  );
}

/// generated route for
/// [LoginView]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginView();
    },
  );
}

/// generated route for
/// [MushafPageView]
class MushafPageRoute extends PageRouteInfo<MushafPageRouteArgs> {
  MushafPageRoute({
    Key? key,
    required int pageNumber,
    List<PageRouteInfo>? children,
  }) : super(
         MushafPageRoute.name,
         args: MushafPageRouteArgs(key: key, pageNumber: pageNumber),
         initialChildren: children,
       );

  static const String name = 'MushafPageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MushafPageRouteArgs>();
      return MushafPageView(key: args.key, pageNumber: args.pageNumber);
    },
  );
}

class MushafPageRouteArgs {
  const MushafPageRouteArgs({this.key, required this.pageNumber});

  final Key? key;

  final int pageNumber;

  @override
  String toString() {
    return 'MushafPageRouteArgs{key: $key, pageNumber: $pageNumber}';
  }
}

/// generated route for
/// [PdfView]
class PdfRoute extends PageRouteInfo<PdfRouteArgs> {
  PdfRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        PdfRoute.name,
        args: PdfRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'PdfRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PdfRouteArgs>(
        orElse: () => const PdfRouteArgs(),
      );
      return PdfView(key: args.key);
    },
  );
}

class PdfRouteArgs {
  const PdfRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'PdfRouteArgs{key: $key}';
  }
}

/// generated route for
/// [QuranView]
class QuranRoute extends PageRouteInfo<void> {
  const QuranRoute({List<PageRouteInfo>? children})
    : super(QuranRoute.name, initialChildren: children);

  static const String name = 'QuranRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuranView();
    },
  );
}

/// generated route for
/// [SurahDetailView]
class SurahDetailRoute extends PageRouteInfo<SurahDetailRouteArgs> {
  SurahDetailRoute({
    Key? key,
    required int surahId,
    required String surahName,
    required String arabicName,
    List<PageRouteInfo>? children,
  }) : super(
         SurahDetailRoute.name,
         args: SurahDetailRouteArgs(
           key: key,
           surahId: surahId,
           surahName: surahName,
           arabicName: arabicName,
         ),
         initialChildren: children,
       );

  static const String name = 'SurahDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SurahDetailRouteArgs>();
      return SurahDetailView(
        key: args.key,
        surahId: args.surahId,
        surahName: args.surahName,
        arabicName: args.arabicName,
      );
    },
  );
}

class SurahDetailRouteArgs {
  const SurahDetailRouteArgs({
    this.key,
    required this.surahId,
    required this.surahName,
    required this.arabicName,
  });

  final Key? key;

  final int surahId;

  final String surahName;

  final String arabicName;

  @override
  String toString() {
    return 'SurahDetailRouteArgs{key: $key, surahId: $surahId, surahName: $surahName, arabicName: $arabicName}';
  }
}

/// generated route for
/// [TabView]
class TabRoute extends PageRouteInfo<void> {
  const TabRoute({List<PageRouteInfo>? children})
    : super(TabRoute.name, initialChildren: children);

  static const String name = 'TabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TabView();
    },
  );
}
