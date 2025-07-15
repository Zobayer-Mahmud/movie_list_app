import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import '../../core/constants/app_enums.dart';
import '../../domain/entities/movie.dart';
import 'movie_controller.dart';

class SearchController extends GetxController {
  final MovieController _movieController = Get.find<MovieController>();

  final TextEditingController searchTextController = TextEditingController();

  final RxString searchQuery = ''.obs;
  final Rx<SortOption> selectedSort = SortOption.dateNewest.obs;
  final Rx<FilterOption> selectedFilter = FilterOption.all.obs;

  RxList<Movie> filteredMovies = <Movie>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSearch();
  }

  void _initializeSearch() {
    // Listen to search query changes
    searchQuery.listen((_) => _applyFilters());

    // Listen to sort option changes
    selectedSort.listen((_) => _applyFilters());

    // Listen to filter option changes
    selectedFilter.listen((_) => _applyFilters());

    // Listen to movies list changes
    _movieController.movies.listen((_) => _applyFilters());

    // Initial filter application
    _applyFilters();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateSortOption(SortOption option) {
    selectedSort.value = option;
  }

  void updateFilterOption(FilterOption option) {
    selectedFilter.value = option;
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
  }

  void resetFilters() {
    clearSearch();
    selectedSort.value = SortOption.dateNewest;
    selectedFilter.value = FilterOption.all;
  }

  void _applyFilters() {
    List<Movie> movies = List.from(_movieController.movies);

    // Apply text search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      movies = movies.where((movie) {
        return movie.title.toLowerCase().contains(query) ||
            movie.description.toLowerCase().contains(query);
      }).toList();
    }

    // Apply favorite filter
    if (selectedFilter.value == FilterOption.favoritesOnly) {
      movies = movies.where((movie) => movie.isFavorite).toList();
    }

    // Apply sorting
    switch (selectedSort.value) {
      case SortOption.dateNewest:
        movies.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.dateOldest:
        movies.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.titleAZ:
        movies.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case SortOption.titleZA:
        movies.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;
      case SortOption.favoritesFirst:
        movies.sort((a, b) {
          if (a.isFavorite == b.isFavorite) {
            return b.createdAt.compareTo(a.createdAt); // Secondary sort by date
          }
          return a.isFavorite ? -1 : 1; // Favorites first
        });
        break;
    }

    filteredMovies.value = movies;
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
