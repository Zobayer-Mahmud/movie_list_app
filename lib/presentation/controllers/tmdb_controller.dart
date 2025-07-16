import 'dart:async';
import 'package:get/get.dart';
import '../../core/services/tmdb_api_service.dart';
import '../../data/models/tmdb_movie_model.dart';
import '../../data/models/tmdb_cast_model.dart';
import '../../data/models/tmdb_video_model.dart';
import '../../data/services/tmdb_cache_service.dart';
import '../../core/di/dependency_injection.dart';

class TMDBController extends GetxController {
  final TMDBApiService _tmdbService = TMDBApiService();
  late final TMDBCacheService _cacheService;

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

  // Connectivity and cache states
  final isOnline = true.obs;
  final isLoadingFromCache = false.obs;

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
    _cacheService = getIt<TMDBCacheService>();
    _initializeData();
  }

  // Initialize data with cache-first strategy
  Future<void> _initializeData() async {
    // Check connectivity
    isOnline.value = await _cacheService.hasNetworkConnection();

    // Load from cache first (immediate display)
    _loadFromCache();

    // Then try to refresh from network if online
    if (isOnline.value) {
      _refreshFromNetwork();
    } else {
      // Show offline message if no cached data
      if (!_cacheService.hasDiscoverData()) {
        Get.snackbar(
          'Offline',
          'No internet connection. Please check your network.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  // Load data from cache
  void _loadFromCache() {
    isLoadingFromCache.value = true;

    final cachedPopular = _cacheService.getCachedPopularMovies();
    if (cachedPopular != null) {
      popularMovies.value = cachedPopular;
    }

    final cachedTrending = _cacheService.getCachedTrendingMovies();
    if (cachedTrending != null) {
      trendingMovies.value = cachedTrending;
    }

    final cachedTopRated = _cacheService.getCachedTopRatedMovies();
    if (cachedTopRated != null) {
      topRatedMovies.value = cachedTopRated;
    }

    final cachedUpcoming = _cacheService.getCachedUpcomingMovies();
    if (cachedUpcoming != null) {
      upcomingMovies.value = cachedUpcoming;
    }

    isLoadingFromCache.value = false;
  }

  // Refresh data from network in background
  Future<void> _refreshFromNetwork() async {
    await Future.wait([
      loadPopularMovies(),
      loadTrendingMovies(),
      loadTopRatedMovies(),
      loadUpcomingMovies(),
    ]);
  }

  // Public method to refresh all data
  Future<void> refreshAllData() async {
    isOnline.value = await _cacheService.hasNetworkConnection();
    if (isOnline.value) {
      await _refreshFromNetwork();
    } else {
      Get.snackbar(
        'Offline',
        'No internet connection. Showing cached data.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Load popular movies with caching
  Future<void> loadPopularMovies() async {
    try {
      isLoadingPopular.value = true;

      // Check connectivity
      final hasNetwork = await _cacheService.hasNetworkConnection();
      if (!hasNetwork) {
        // Load from cache if offline
        final cached = _cacheService.getCachedPopularMovies();
        if (cached != null) {
          popularMovies.value = cached;
        }
        return;
      }

      final response = await _tmdbService.getPopularMovies();
      if (response != null) {
        popularMovies.value = response.results;
        // Cache the new data
        await _cacheService.cachePopularMovies(response.results);
      }
    } catch (e) {
      // On error, try to load from cache
      final cached = _cacheService.getCachedPopularMovies();
      if (cached != null) {
        popularMovies.value = cached;
        Get.snackbar(
          'Network Error',
          'Showing cached popular movies',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load popular movies: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoadingPopular.value = false;
    }
  }

  // Load trending movies with caching
  Future<void> loadTrendingMovies() async {
    try {
      isLoadingTrending.value = true;

      // Check connectivity
      final hasNetwork = await _cacheService.hasNetworkConnection();
      if (!hasNetwork) {
        // Load from cache if offline
        final cached = _cacheService.getCachedTrendingMovies();
        if (cached != null) {
          trendingMovies.value = cached;
        }
        return;
      }

      final response = await _tmdbService.getTrendingMovies();
      if (response != null) {
        trendingMovies.value = response.results;
        // Cache the new data
        await _cacheService.cacheTrendingMovies(response.results);
      }
    } catch (e) {
      // On error, try to load from cache
      final cached = _cacheService.getCachedTrendingMovies();
      if (cached != null) {
        trendingMovies.value = cached;
        Get.snackbar(
          'Network Error',
          'Showing cached trending movies',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load trending movies: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoadingTrending.value = false;
    }
  }

  // Load top rated movies with caching
  Future<void> loadTopRatedMovies() async {
    try {
      isLoadingTopRated.value = true;

      // Check connectivity
      final hasNetwork = await _cacheService.hasNetworkConnection();
      if (!hasNetwork) {
        // Load from cache if offline
        final cached = _cacheService.getCachedTopRatedMovies();
        if (cached != null) {
          topRatedMovies.value = cached;
        }
        return;
      }

      final response = await _tmdbService.getTopRatedMovies();
      if (response != null) {
        topRatedMovies.value = response.results;
        // Cache the new data
        await _cacheService.cacheTopRatedMovies(response.results);
      }
    } catch (e) {
      // On error, try to load from cache
      final cached = _cacheService.getCachedTopRatedMovies();
      if (cached != null) {
        topRatedMovies.value = cached;
        Get.snackbar(
          'Network Error',
          'Showing cached top rated movies',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load top rated movies: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoadingTopRated.value = false;
    }
  }

  // Load upcoming movies with caching
  Future<void> loadUpcomingMovies() async {
    try {
      isLoadingUpcoming.value = true;

      // Check connectivity
      final hasNetwork = await _cacheService.hasNetworkConnection();
      if (!hasNetwork) {
        // Load from cache if offline
        final cached = _cacheService.getCachedUpcomingMovies();
        if (cached != null) {
          upcomingMovies.value = cached;
        }
        return;
      }

      final response = await _tmdbService.getUpcomingMovies();
      if (response != null) {
        upcomingMovies.value = response.results;
        // Cache the new data
        await _cacheService.cacheUpcomingMovies(response.results);
      }
    } catch (e) {
      // On error, try to load from cache
      final cached = _cacheService.getCachedUpcomingMovies();
      if (cached != null) {
        upcomingMovies.value = cached;
        Get.snackbar(
          'Network Error',
          'Showing cached upcoming movies',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to load upcoming movies: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
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

  // Load movie details (cast and videos) with caching
  Future<void> loadMovieDetails(int movieId, TMDBMovie movieDetails) async {
    // Check if we have cached details
    final cachedDetails = _cacheService.getCachedMovieDetails(movieId);

    if (cachedDetails != null) {
      // Load from cache immediately
      movieCast.value = cachedDetails.cast.take(10).toList();
      movieVideos.value = cachedDetails.videos;

      // If cache is still valid, don't fetch from network
      if (cachedDetails.isValid) {
        return;
      }
    }

    // Check connectivity for fresh data
    final hasNetwork = await _cacheService.hasNetworkConnection();
    if (!hasNetwork) {
      if (cachedDetails == null) {
        Get.snackbar(
          'Offline',
          'No internet connection. Movie details not available offline.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
      return;
    }

    // Fetch fresh data from network
    try {
      final castResponse = await _tmdbService.getMovieCredits(movieId);
      final videosResponse = await _tmdbService.getMovieVideos(movieId);

      if (castResponse != null && videosResponse != null) {
        final cast = castResponse.cast;
        final videos = videosResponse.trailers;

        // Update UI
        movieCast.value = cast.take(10).toList();
        movieVideos.value = videos;

        // Cache the new data
        await _cacheService.cacheMovieDetails(
          movieId: movieId,
          movieDetails: movieDetails,
          cast: cast,
          videos: videos,
        );
      }
    } catch (e) {
      // On error, keep cached data if available
      if (cachedDetails == null) {
        Get.snackbar(
          'Error',
          'Failed to load movie details: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  // Load movie cast with caching
  Future<void> loadMovieCast(int movieId) async {
    // Check if we have cached details first
    final cachedDetails = _cacheService.getCachedMovieDetails(movieId);
    if (cachedDetails != null) {
      movieCast.value = cachedDetails.cast.take(10).toList();
      if (cachedDetails.isValid) return;
    }

    // Check connectivity
    final hasNetwork = await _cacheService.hasNetworkConnection();
    if (!hasNetwork) {
      if (cachedDetails == null) {
        Get.snackbar(
          'Offline',
          'No internet connection. Cast information not available offline.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
      return;
    }

    try {
      final response = await _tmdbService.getMovieCredits(movieId);
      if (response != null) {
        movieCast.value = response.cast
            .take(10)
            .toList(); // Show top 10 cast members
      }
    } catch (e) {
      // Keep cached data if available
      if (cachedDetails == null) {
        Get.snackbar(
          'Error',
          'Failed to load movie cast: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // Load movie videos (trailers) with caching
  Future<void> loadMovieVideos(int movieId) async {
    // Check if we have cached details first
    final cachedDetails = _cacheService.getCachedMovieDetails(movieId);
    if (cachedDetails != null) {
      movieVideos.value = cachedDetails.videos;
      if (cachedDetails.isValid) return;
    }

    // Check connectivity
    final hasNetwork = await _cacheService.hasNetworkConnection();
    if (!hasNetwork) {
      if (cachedDetails == null) {
        Get.snackbar(
          'Offline',
          'No internet connection. Trailer information not available offline.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
      return;
    }

    try {
      final response = await _tmdbService.getMovieVideos(movieId);
      if (response != null) {
        movieVideos.value = response.trailers; // Only get trailers
      }
    } catch (e) {
      // Keep cached data if available
      if (cachedDetails == null) {
        Get.snackbar(
          'Error',
          'Failed to load movie videos: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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
