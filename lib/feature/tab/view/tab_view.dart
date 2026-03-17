import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/init/theme/app_colors.dart';
import '../../../product/navigation/app_router.dart';

@RoutePage()
class TabView extends ConsumerWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsScaffold(
      routes: const [
        HomeRoute(),
        PrayerTimesRoute(),
        PdfRoute(),
        ContentRoute(),
      ],
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
                icon: Icon(Icons.access_time_outlined),
                activeIcon: Icon(Icons.access_time_filled_rounded),
                label: 'Namaz',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                activeIcon: Icon(Icons.menu_book_rounded),
                label: 'Kaside',
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
    );
  }
}
