import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import '../../core/constants/app_enums.dart';
import '../../domain/entities/movie.dart';
import '../widgets/advanced_filter_sheet.dart';
import 'movie_controller.dart';

class SearchController extends GetxController {
  final MovieController _movieController = Get.find<MovieController>();

  final TextEditingController searchTextController = TextEditingController();

  final RxString searchQuery = ''.obs;
  final Rx<SortOption> selectedSort = SortOption.dateNewest.obs;
  final Rx<FilterOption> selectedFilter = FilterOption.all.obs;

  // Advanced filter properties
  final RxDouble minRating = 0.0.obs;
  final RxDouble maxRating = 5.0.obs;
  final RxInt minYear = 1900.obs;
  final RxInt maxYear = DateTime.now().year.obs;
  final RxList<MovieGenre> selectedGenres = <MovieGenre>[].obs;
  final Rx<WatchStatusFilter> watchStatusFilter = WatchStatusFilter.all.obs;
  final Rx<SortOption> sortOption = SortOption.dateNewest.obs;

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

    // Apply rating range filter
    movies = movies.where((movie) {
      return movie.rating >= minRating.value && movie.rating <= maxRating.value;
    }).toList();

    // Apply year range filter
    movies = movies.where((movie) {
      if (movie.releaseYear == null)
        return true; // Include movies without release year
      return movie.releaseYear! >= minYear.value &&
          movie.releaseYear! <= maxYear.value;
    }).toList();

    // Apply genre filter
    if (selectedGenres.isNotEmpty) {
      movies = movies.where((movie) {
        return movie.genre != null && selectedGenres.contains(movie.genre);
      }).toList();
    }

    // Apply watch status filter
    switch (watchStatusFilter.value) {
      case WatchStatusFilter.watched:
        movies = movies.where((movie) => movie.isWatched).toList();
        break;
      case WatchStatusFilter.unwatched:
        movies = movies.where((movie) => !movie.isWatched).toList();
        break;
      case WatchStatusFilter.all:
        // No additional filtering needed
        break;
    }

    // Apply sorting
    switch (sortOption.value) {
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
      case SortOption.ratingAsc:
        movies.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case SortOption.ratingDesc:
        movies.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.yearAsc:
        movies.sort((a, b) {
          if (a.releaseYear == null && b.releaseYear == null) return 0;
          if (a.releaseYear == null) return 1;
          if (b.releaseYear == null) return -1;
          return a.releaseYear!.compareTo(b.releaseYear!);
        });
        break;
      case SortOption.yearDesc:
        movies.sort((a, b) {
          if (a.releaseYear == null && b.releaseYear == null) return 0;
          if (a.releaseYear == null) return 1;
          if (b.releaseYear == null) return -1;
          return b.releaseYear!.compareTo(a.releaseYear!);
        });
        break;
      case SortOption.favoritesFirst:
        movies.sort((a, b) {
          if (a.isFavorite == b.isFavorite) {
            return b.createdAt.compareTo(a.createdAt); // Secondary sort by date
          }
          return a.isFavorite ? -1 : 1; // Favorites first
        });
        break;
      // Keep compatibility with old enum values
      case SortOption.dateAsc:
        movies.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.dateDesc:
        movies.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.titleAsc:
        movies.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case SortOption.titleDesc:
        movies.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;
    }

    filteredMovies.value = movies;
  }

  // Advanced filtering methods
  void setRatingRange(double min, double max) {
    minRating.value = min;
    maxRating.value = max;
    _applyFilters();
  }

  void setYearRange(int min, int max) {
    minYear.value = min;
    maxYear.value = max;
    _applyFilters();
  }

  void addGenreFilter(MovieGenre genre) {
    if (!selectedGenres.contains(genre)) {
      selectedGenres.add(genre);
      _applyFilters();
    }
  }

  void removeGenreFilter(MovieGenre genre) {
    selectedGenres.remove(genre);
    _applyFilters();
  }

  void setWatchStatusFilter(WatchStatusFilter filter) {
    watchStatusFilter.value = filter;
    _applyFilters();
  }

  void setSortOption(SortOption option) {
    sortOption.value = option;
    selectedSort.value = option; // Keep compatibility
    _applyFilters();
  }

  void clearAllFilters() {
    minRating.value = 0.0;
    maxRating.value = 5.0;
    minYear.value = 1900;
    maxYear.value = DateTime.now().year;
    selectedGenres.clear();
    watchStatusFilter.value = WatchStatusFilter.all;
    sortOption.value = SortOption.dateNewest;
    selectedSort.value = SortOption.dateNewest;
    selectedFilter.value = FilterOption.all;
    searchQuery.value = '';
    searchTextController.clear();
    _applyFilters();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
