import 'package:get/get.dart';
import '../../core/services/tmdb_api_service.dart';
import '../../data/models/tmdb_movie_model.dart';

class TMDBController extends GetxController {
  final TMDBApiService _tmdbService = TMDBApiService();

  // Observable lists for different movie categories
  final popularMovies = <TMDBMovie>[].obs;
  final trendingMovies = <TMDBMovie>[].obs;
  final topRatedMovies = <TMDBMovie>[].obs;
  final upcomingMovies = <TMDBMovie>[].obs;
  final searchResults = <TMDBMovie>[].obs;

  // Loading states
  final isLoadingPopular = false.obs;
  final isLoadingTrending = false.obs;
  final isLoadingTopRated = false.obs;
  final isLoadingUpcoming = false.obs;
  final isLoadingSearch = false.obs;

  // Search query
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load all movie categories on initialization
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

  // Search movies
  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoadingSearch.value = true;
      searchQuery.value = query;
      final response = await _tmdbService.searchMovies(query);
      if (response != null) {
        searchResults.value = response.results;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search movies: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingSearch.value = false;
    }
  }

  // Clear search results
  void clearSearch() {
    searchResults.clear();
    searchQuery.value = '';
  }
}
