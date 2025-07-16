import 'dart:async';
import 'package:get/get.dart';
import '../../core/services/tmdb_api_service.dart';
import '../../data/models/tmdb_movie_model.dart';
import '../../data/models/tmdb_cast_model.dart';
import '../../data/models/tmdb_video_model.dart';

class TMDBController extends GetxController {
  final TMDBApiService _tmdbService = TMDBApiService();

  // Observable lists for different movie categories
  final popularMovies = <TMDBMovie>[].obs;
  final trendingMovies = <TMDBMovie>[].obs;
  final topRatedMovies = <TMDBMovie>[].obs;
  final upcomingMovies = <TMDBMovie>[].obs;
  final searchResults = <TMDBMovie>[].obs;

  // Movie details data
  final movieCast = <TMDBCast>[].obs;
  final movieVideos = <TMDBVideo>[].obs;

  // Loading states
  final isLoadingPopular = false.obs;
  final isLoadingTrending = false.obs;
  final isLoadingTopRated = false.obs;
  final isLoadingUpcoming = false.obs;
  final isLoadingSearch = false.obs;

  // Search states
  final searchQuery = ''.obs;
  final hasSearched = false.obs;
  final searchError = ''.obs;

  // Search debouncing
  Timer? _searchDebounce;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    loadPopularMovies();
    loadTrendingMovies();
    loadTopRatedMovies();
    loadUpcomingMovies();
  }

  // Load popular movies
  Future<void> loadPopularMovies() async {
    try {
      isLoadingPopular.value = true;
      final response = await _tmdbService.getPopularMovies();
      if (response != null) {
        popularMovies.value = response.results;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load popular movies: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingPopular.value = false;
    }
  }

  // Load trending movies
  Future<void> loadTrendingMovies() async {
    try {
      isLoadingTrending.value = true;
      final response = await _tmdbService.getTrendingMovies();
      if (response != null) {
        trendingMovies.value = response.results;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load trending movies: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingTrending.value = false;
    }
  }

  // Load top rated movies
  Future<void> loadTopRatedMovies() async {
    try {
      isLoadingTopRated.value = true;
      final response = await _tmdbService.getTopRatedMovies();
      if (response != null) {
        topRatedMovies.value = response.results;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load top rated movies: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingTopRated.value = false;
    }
  }

  // Load upcoming movies
  Future<void> loadUpcomingMovies() async {
    try {
      isLoadingUpcoming.value = true;
      final response = await _tmdbService.getUpcomingMovies();
      if (response != null) {
        upcomingMovies.value = response.results;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load upcoming movies: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  // Enhanced search with debouncing and text change handling
  void onSearchChanged(String query) {
    // Cancel previous debounce timer
    _searchDebounce?.cancel();

    // Update search query immediately for UI feedback
    searchQuery.value = query;

    // Clear error state
    searchError.value = '';

    // Handle empty query
    if (query.trim().isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      isLoadingSearch.value = false;
      return;
    }

    // Set loading state immediately for better UX
    isLoadingSearch.value = true;

    // Debounce the actual search
    _searchDebounce = Timer(_debounceDuration, () {
      _performSearch(query.trim());
    });
  }

  // Perform the actual search
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      isLoadingSearch.value = false;
      return;
    }

    try {
      hasSearched.value = true;

      final response = await _tmdbService.searchMovies(query);
      if (response != null) {
        searchResults.value = response.results;

        // Handle empty results
        if (response.results.isEmpty) {
          searchError.value = 'No movies found for "$query"';
        }
      } else {
        searchError.value = 'Failed to search movies. Please try again.';
      }
    } catch (e) {
      searchError.value = 'Search failed: ${e.toString()}';
      Get.snackbar(
        'Search Error',
        'Failed to search movies: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    } finally {
      isLoadingSearch.value = false;
    }
  }

  // Legacy search method for backwards compatibility
  Future<void> searchMovies(String query) async {
    onSearchChanged(query);
  }

  // Clear search results and state
  void clearSearch() {
    _searchDebounce?.cancel();
    searchResults.clear();
    searchQuery.value = '';
    hasSearched.value = false;
    searchError.value = '';
    isLoadingSearch.value = false;
  }

  // Load movie cast
  Future<void> loadMovieCast(int movieId) async {
    try {
      final response = await _tmdbService.getMovieCredits(movieId);
      if (response != null) {
        movieCast.value = response.cast
            .take(10)
            .toList(); // Show top 10 cast members
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load movie cast: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Load movie videos (trailers)
  Future<void> loadMovieVideos(int movieId) async {
    try {
      final response = await _tmdbService.getMovieVideos(movieId);
      if (response != null) {
        movieVideos.value = response.trailers; // Only get trailers
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load movie videos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Clear movie details data
  void clearMovieDetails() {
    movieCast.clear();
    movieVideos.clear();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }
}
