import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/views/home_view.dart';
import '../../features/prayer_times/views/prayer_times_view.dart';
import '../../features/pdf/views/pdf_view.dart';
import '../../features/content/views/content_view.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    final List<Widget> screens = [
      const HomeView(),
      const PrayerTimesView(),
      const PdfView(),
      const ContentView(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_getAppBarTitle(currentIndex))),
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(navigationIndexProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Namaz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            label: 'Kaside',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Bilgi'),
        ],
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'NafieSna';
      case 1:
        return 'Namaz Vakitleri';
      case 2:
        return 'Kaside-i Bürde';
      case 3:
        return 'Dini Bilgiler';
      default:
        return 'NafieSna';
    }
  }
}
