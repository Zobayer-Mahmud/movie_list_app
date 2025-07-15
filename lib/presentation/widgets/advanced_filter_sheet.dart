import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_enums.dart';
import '../controllers/search_controller.dart' as search_controller;

class AdvancedFilterBottomSheet extends StatelessWidget {
  const AdvancedFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCtrl = Get.find<search_controller.SearchController>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Advanced Filters',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  searchCtrl.clearAllFilters();
                  Get.back();
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Rating Filter
          _buildRatingFilter(context, searchCtrl),
          const SizedBox(height: 24),

          // Release Year Filter
          _buildYearFilter(context, searchCtrl),
          const SizedBox(height: 24),

          // Genre Filter
          _buildGenreFilter(context, searchCtrl),
          const SizedBox(height: 24),

          // Watch Status Filter
          _buildWatchStatusFilter(context, searchCtrl),
          const SizedBox(height: 24),

          // Sort Options
          _buildSortOptions(context, searchCtrl),
          const SizedBox(height: 32),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingFilter(
    BuildContext context,
    search_controller.SearchController searchCtrl,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Row(
            children: [
              Text('${searchCtrl.minRating.value.toStringAsFixed(1)}'),
              Expanded(
                child: RangeSlider(
                  values: RangeValues(
                    searchCtrl.minRating.value,
                    searchCtrl.maxRating.value,
                  ),
                  min: 0.0,
                  max: 5.0,
                  divisions: 10,
                  labels: RangeLabels(
                    searchCtrl.minRating.value.toStringAsFixed(1),
                    searchCtrl.maxRating.value.toStringAsFixed(1),
                  ),
                  onChanged: (values) {
                    searchCtrl.setRatingRange(values.start, values.end);
                  },
                ),
              ),
              Text('${searchCtrl.maxRating.value.toStringAsFixed(1)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildYearFilter(
    BuildContext context,
    search_controller.SearchController searchCtrl,
  ) {
    final theme = Theme.of(context);
    final currentYear = DateTime.now().year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Release Year Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Row(
            children: [
              Text('${searchCtrl.minYear.value}'),
              Expanded(
                child: RangeSlider(
                  values: RangeValues(
                    searchCtrl.minYear.value.toDouble(),
                    searchCtrl.maxYear.value.toDouble(),
                  ),
                  min: 1900.0,
                  max: currentYear.toDouble(),
                  divisions: (currentYear - 1900) ~/ 5, // 5-year steps
                  labels: RangeLabels(
                    '${searchCtrl.minYear.value}',
                    '${searchCtrl.maxYear.value}',
                  ),
                  onChanged: (values) {
                    searchCtrl.setYearRange(
                      values.start.round(),
                      values.end.round(),
                    );
                  },
                ),
              ),
              Text('${searchCtrl.maxYear.value}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenreFilter(
    BuildContext context,
    search_controller.SearchController searchCtrl,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genres',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MovieGenre.values.map((genre) {
            return Obx(
              () => FilterChip(
                label: Text(genre.displayName),
                selected: searchCtrl.selectedGenres.contains(genre),
                onSelected: (selected) {
                  if (selected) {
                    searchCtrl.addGenreFilter(genre);
                  } else {
                    searchCtrl.removeGenreFilter(genre);
                  }
                },
                selectedColor: theme.colorScheme.primaryContainer,
                checkmarkColor: theme.colorScheme.onPrimaryContainer,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWatchStatusFilter(
    BuildContext context,
    search_controller.SearchController searchCtrl,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Watch Status',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: FilterChip(
                  label: const Text('Watched'),
                  selected:
                      searchCtrl.watchStatusFilter.value ==
                      WatchStatusFilter.watched,
                  onSelected: (selected) {
                    searchCtrl.setWatchStatusFilter(
                      selected
                          ? WatchStatusFilter.watched
                          : WatchStatusFilter.all,
                    );
                  },
                  selectedColor: theme.colorScheme.primaryContainer,
                  checkmarkColor: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterChip(
                  label: const Text('Unwatched'),
                  selected:
                      searchCtrl.watchStatusFilter.value ==
                      WatchStatusFilter.unwatched,
                  onSelected: (selected) {
                    searchCtrl.setWatchStatusFilter(
                      selected
                          ? WatchStatusFilter.unwatched
                          : WatchStatusFilter.all,
                    );
                  },
                  selectedColor: theme.colorScheme.primaryContainer,
                  checkmarkColor: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptions(
    BuildContext context,
    search_controller.SearchController searchCtrl,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSortChip(
                context,
                'Title A-Z',
                SortOption.titleAsc,
                searchCtrl,
              ),
              _buildSortChip(
                context,
                'Title Z-A',
                SortOption.titleDesc,
                searchCtrl,
              ),
              _buildSortChip(
                context,
                'Date Added ↑',
                SortOption.dateAsc,
                searchCtrl,
              ),
              _buildSortChip(
                context,
                'Date Added ↓',
                SortOption.dateDesc,
                searchCtrl,
              ),
              _buildSortChip(
                context,
                'Rating ↑',
                SortOption.ratingAsc,
                searchCtrl,
              ),
              _buildSortChip(
                context,
                'Rating ↓',
                SortOption.ratingDesc,
                searchCtrl,
              ),
              _buildSortChip(context, 'Year ↑', SortOption.yearAsc, searchCtrl),
              _buildSortChip(
                context,
                'Year ↓',
                SortOption.yearDesc,
                searchCtrl,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortChip(
    BuildContext context,
    String label,
    SortOption option,
    search_controller.SearchController searchCtrl,
  ) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: searchCtrl.sortOption.value == option,
      onSelected: (_) => searchCtrl.setSortOption(option),
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
    );
  }
}

// New filter enums
enum WatchStatusFilter { all, watched, unwatched }
