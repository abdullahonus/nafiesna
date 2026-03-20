import 'package:auto_route/auto_route.dart';
import '../../feature/tab/view/tab_view.dart';
import './auth_guard.dart';
import '../../feature/home/view/home_view.dart';
import '../../feature/dream/view/dream_view.dart';
import '../../feature/pdf/view/pdf_view.dart';
import '../../feature/content/view/content_view.dart';
import '../../feature/auth/view/login_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.authGuard});
  final AuthGuard authGuard;

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, path: '/login'),
        AutoRoute(
          path: '/',
          page: TabRoute.page,
          guards: [authGuard],
          initial: true,
          children: [
            AutoRoute(page: HomeRoute.page, path: 'home', initial: true),
            AutoRoute(page: DreamRoute.page, path: 'dream'),
            AutoRoute(page: PdfRoute.page, path: 'pdf'),
            AutoRoute(page: ContentRoute.page, path: 'content'),
          ],
        ),
      ];
}
