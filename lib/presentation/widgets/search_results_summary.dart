import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_enums.dart';
import '../controllers/search_controller.dart' as search_controller;
import '../controllers/movie_controller.dart';

class SearchResultsSummary extends StatelessWidget {
  const SearchResultsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<search_controller.SearchController>();
    final movieController = Get.find<MovieController>();

    return Obx(() {
      final filteredCount = searchController.filteredMovies.length;
      final totalCount = movieController.movies.length;
      final hasActiveFilters =
          searchController.searchQuery.value.isNotEmpty ||
          searchController.selectedFilter.value != FilterOption.all ||
          searchController.selectedSort.value != SortOption.dateNewest;

      if (!hasActiveFilters && filteredCount == totalCount) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getResultsText(filteredCount, totalCount, searchController),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (hasActiveFilters)
              TextButton(
                onPressed: searchController.resetFilters,
                child: const Text('Clear All'),
              ),
          ],
        ),
      );
    });
  }

  String _getResultsText(
    int filteredCount,
    int totalCount,
    search_controller.SearchController controller,
  ) {
    if (filteredCount == 0) {
      if (controller.searchQuery.value.isNotEmpty) {
        return 'No movies found for "${controller.searchQuery.value}"';
      } else {
        return 'No movies match the current filters';
      }
    }

    if (filteredCount == totalCount) {
      return 'Showing all $totalCount movies';
    }

    return 'Showing $filteredCount of $totalCount movies';
  }
}
