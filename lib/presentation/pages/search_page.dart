import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart' as search_controller;
import '../controllers/movie_controller.dart';
import '../widgets/movie_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/advanced_filter_sheet.dart';
import '../../core/constants/app_enums.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void _showAdvancedFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AdvancedFilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<search_controller.SearchController>();
    final movieController = Get.find<MovieController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
        actions: [
          IconButton(
            onPressed: () => _showAdvancedFilters(context),
            icon: const Icon(Icons.tune),
            tooltip: 'Advanced Filters',
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          // Enhanced Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController.searchTextController,
              onChanged: searchController.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search by title, description, or genre...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                suffixIcon: Obx(() {
                  return searchController.searchQuery.value.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          onPressed: searchController.clearSearch,
                        );
                }),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),

          // Quick Filter Chips
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickFilter(
                  context,
                  'All',
                  FilterOption.all,
                  searchController,
                ),
                _buildQuickFilter(
                  context,
                  'Favorites',
                  FilterOption.favoritesOnly,
                  searchController,
                ),
                ...SortOption.values.map(
                  (sort) => _buildSortChip(context, sort, searchController),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Results Summary
          Obx(() {
            final filteredCount = searchController.filteredMovies.length;
            final totalCount = movieController.movies.length;
            final hasSearch = searchController.searchQuery.value.isNotEmpty;

            if (hasSearch || filteredCount != totalCount) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hasSearch
                            ? 'Found $filteredCount result${filteredCount == 1 ? '' : 's'} for "${searchController.searchQuery.value}"'
                            : 'Showing $filteredCount of $totalCount movies',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    if (hasSearch)
                      TextButton(
                        onPressed: searchController.clearSearch,
                        child: const Text('Clear'),
                      ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          const SizedBox(height: 8),

          // Search Results
          Expanded(
            child: Obx(() {
              final filteredMovies = searchController.filteredMovies;

              if (movieController.movies.isEmpty) {
                return const EmptyStateWidget(
                  message:
                      'No movies available.\nAdd some movies to search through them!',
                );
              }

              if (filteredMovies.isEmpty) {
                return EmptyStateWidget(
                  message: searchController.searchQuery.value.isNotEmpty
                      ? 'No movies found for "${searchController.searchQuery.value}".\nTry adjusting your search terms.'
                      : 'No movies match the current filters.\nTry changing your filter settings.',
                );
              }

              return RefreshIndicator(
                onRefresh: movieController.loadMovies,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = filteredMovies[index];
                    return MovieCard(
                      movie: movie,
                      onFavoriteToggle: () =>
                          movieController.toggleFavorite(movie.id),
                      onDelete: () =>
                          _showDeleteDialog(context, movieController, movie),
                      onTap: () =>
                          Get.toNamed('/movie-details', arguments: movie),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildQuickFilter(
    BuildContext context,
    String label,
    FilterOption option,
    search_controller.SearchController controller,
  ) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == option;
      return Container(
        margin: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => controller.updateFilterOption(option),
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
          labelStyle: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    });
  }

  Widget _buildSortChip(
    BuildContext context,
    SortOption option,
    search_controller.SearchController controller,
  ) {
    return Obx(() {
      final isSelected = controller.selectedSort.value == option;
      return Container(
        margin: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(option.displayName),
          selected: isSelected,
          onSelected: (_) => controller.updateSortOption(option),
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedColor: Theme.of(context).colorScheme.secondaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.onSecondaryContainer,
          labelStyle: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 12,
          ),
        ),
      );
    });
  }

  void _showDeleteDialog(
    BuildContext context,
    MovieController controller,
    movie,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Movie'),
        content: Text('Are you sure you want to delete "${movie.title}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteMovie(movie.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
