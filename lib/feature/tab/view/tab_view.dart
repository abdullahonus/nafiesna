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
          routes: const [HomeRoute(), DreamRoute(), PdfRoute(), ContentRoute(), QuranRoute()],
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Builder(
            builder: (context) {
              final tabsRouter = AutoTabsRouter.of(context);
              final isActive = tabsRouter.activeIndex == 2;
              return Container(
                margin: const EdgeInsets.only(top: 24), // Biraz yukarıda durması için
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: isActive ? AppColors.primary : AppColors.surface,
                  elevation: 4,
                  onPressed: () => tabsRouter.setActiveIndex(2),
                  child: Icon(
                    isActive ? Icons.menu_book_rounded : Icons.menu_book_outlined,
                    color: isActive ? AppColors.onPrimary : AppColors.primary,
                    size: 28,
                  ),
                ),
              );
            },
          ),
          bottomNavigationBuilder: (context, tabsRouter) {
            return BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              color: AppColors.navBackground,
              elevation: 8,
              padding: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(tabsRouter, 0, Icons.home_outlined, Icons.home_rounded, 'Ana Sayfa'),
                    _buildNavItem(tabsRouter, 1, Icons.nights_stay_outlined, Icons.nights_stay_rounded, 'Rüya'),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => tabsRouter.setActiveIndex(2),
                      child: SizedBox(
                        width: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Kitapçık',
                              style: TextStyle(
                                color: tabsRouter.activeIndex == 2 ? AppColors.navSelected : AppColors.navUnselected,
                                fontSize: 10,
                                fontWeight: tabsRouter.activeIndex == 2 ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    _buildNavItem(tabsRouter, 3, Icons.mosque_outlined, Icons.mosque_rounded, 'Bilgi'),
                    _buildNavItem(tabsRouter, 4, Icons.chrome_reader_mode_outlined, Icons.chrome_reader_mode_rounded, 'Kuran'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavItem(TabsRouter router, int index, IconData iconOff, IconData iconOn, String label) {
    final isActive = router.activeIndex == index;
    final color = isActive ? AppColors.navSelected : AppColors.navUnselected;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => router.setActiveIndex(index),
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? iconOn : iconOff, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

