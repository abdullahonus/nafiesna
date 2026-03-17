import 'package:auto_route/auto_route.dart';
import '../../feature/tab/view/tab_view.dart';
import '../../feature/home/view/home_view.dart';
import '../../feature/prayer_times/view/prayer_times_view.dart';
import '../../feature/pdf/view/pdf_view.dart';
import '../../feature/content/view/content_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: TabRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page, path: 'home', initial: true),
            AutoRoute(page: PrayerTimesRoute.page, path: 'prayer'),
            AutoRoute(page: PdfRoute.page, path: 'pdf'),
            AutoRoute(page: ContentRoute.page, path: 'content'),
          ],
        ),
      ];
}
