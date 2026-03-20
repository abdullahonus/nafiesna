import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../product/init/theme/app_colors.dart';
import '../../../product/navigation/app_router.dart';
import '../../../product/state/auth/auth_provider.dart';
import '../../../product/state/auth/model/user_role.dart';
import '../../../product/widget/common/floating_particles_background.dart';

@RoutePage()
class TabView extends ConsumerWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Logout olunca login sayfasına yönlendir
    ref.listen(authProvider, (previous, next) {
      if (next.role == UserRole.unauthenticated) {
        context.router.root.replaceAll([const LoginRoute()]);
      }
    });

    return Stack(
      children: [
        // Animasyonlu arka plan — RepaintBoundary sayfa içeriğini yeniden
        // çizmeden bağımsız olarak çalışır (performans koruması)
        const RepaintBoundary(child: FloatingParticlesBackground()),

        AutoTabsScaffold(
          // Partiküllerin görünmesi için scaffold şeffaf
          backgroundColor: Colors.transparent,
          routes: const [HomeRoute(), DreamRoute(), PdfRoute(), ContentRoute()],
          bottomNavigationBuilder: (context, tabsRouter) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home_rounded),
                    label: 'Ana Sayfa',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.nights_stay_outlined),
                    activeIcon: Icon(Icons.nights_stay_rounded),
                    label: 'Rüya',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book_outlined),
                    activeIcon: Icon(Icons.menu_book_rounded),
                    label: 'Kitapçık',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mosque_outlined),
                    activeIcon: Icon(Icons.mosque_rounded),
                    label: 'Bilgi',
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

