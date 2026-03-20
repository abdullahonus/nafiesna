import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../product/constants/app_spacing.dart';
import '../../../../product/init/theme/app_colors.dart';
import '../../../../product/init/theme/app_text_styles.dart';
import '../../../../product/navigation/app_router.dart';
import '../../model/surah_list_data.dart';
import 'islamic_star.dart';

class SurahListTab extends StatefulWidget {
  const SurahListTab({super.key});

  @override
  State<SurahListTab> createState() => _SurahListTabState();
}

class _SurahListTabState extends State<SurahListTab> {
  int _selectedIndex = 0; // 0: Kur'ân, 1: Alfabetik, 2: Nüzul Sırası
  String _searchQuery = '';
  List<SurahMetadata> _displayedSurahs = [];

  @override
  void initState() {
    super.initState();
    _displayedSurahs = List.from(surahList);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applySortingAndFiltering();
    });
  }

  void _onCategoryChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _applySortingAndFiltering();
    });
  }

  void _applySortingAndFiltering() {
    List<SurahMetadata> filtered = surahList.where((s) {
      // Türkçe veya Arapça adına göre arama. (İstenirse englishName de eklenebilir)
      return s.turkishName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.arabicName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.englishName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_selectedIndex == 1) {
      // Alfabetik
      filtered.sort((a, b) => a.turkishName.compareTo(b.turkishName));
    } else if (_selectedIndex == 2) {
      // Nüzul Sırası
      filtered.sort((a, b) {
        if (a.revelationType == b.revelationType) return a.id.compareTo(b.id);
        return a.revelationType == 'Meccan' ? -1 : 1;
      });
    } else {
      // Kur'ân Sırası
      filtered.sort((a, b) => a.id.compareTo(b.id));
    }

    _displayedSurahs = filtered;
  }

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: c.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildCategoryTab('Kur\'ân', 0),
                _buildCategoryTab('Alfabetik', 1),
                _buildCategoryTab('Nüzul Sırası', 2),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: c.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: c.border.withValues(alpha: 0.5)),
            ),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Sure Adı Ara',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: c.textSecondary,
                ),
                prefixIcon: Icon(Icons.search, color: c.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            itemCount: _displayedSurahs.length,
            separatorBuilder: (context, index) =>
                Divider(color: c.border.withValues(alpha: 0.3), height: 1),
            itemBuilder: (context, index) {
              final surah = _displayedSurahs[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 0,
                ),
                leading: IslamicStar(text: '${surah.id}'),
                title: Text(
                  surah.turkishName,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.englishName.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: c.textSecondary.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '${surah.ayahsCount} Ayet',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  surah.arabicName,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: c.onBackground,
                    fontFamily: 'Amiri', // Optional
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                  ),
                ),
                onTap: () {
                  context.router.push(
                    SurahDetailRoute(
                      surahId: surah.id,
                      surahName: surah.turkishName,
                      arabicName: surah.arabicName,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTab(String title, int index) {
    bool isSelected = _selectedIndex == index;
    final c = AppThemeColors.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => _onCategoryChanged(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? c.accent.withValues(alpha: 0.8)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTextStyles.labelLarge.copyWith(
              color: isSelected ? Colors.white : c.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
