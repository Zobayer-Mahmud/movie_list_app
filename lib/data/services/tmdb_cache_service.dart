import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/tmdb_movie_model.dart';
import '../models/tmdb_cast_model.dart';
import '../models/tmdb_video_model.dart';
import '../models/tmdb/tmdb_cache_data.dart';

class TMDBCacheService {
  static const String _cacheBoxName = 'tmdb_cache';
  static const String _detailsCacheBoxName = 'tmdb_details_cache';

  // Cache expiry durations
  static const Duration _discoverCacheExpiry = Duration(hours: 6);
  static const Duration _detailsCacheExpiry = Duration(days: 1);

  // Cache keys
  static const String _popularMoviesKey = 'popular_movies';
  static const String _trendingMoviesKey = 'trending_movies';
  static const String _topRatedMoviesKey = 'top_rated_movies';
  static const String _upcomingMoviesKey = 'upcoming_movies';

  late Box<TMDBCacheData> _cacheBox;
  late Box<TMDBMovieDetailsCache> _detailsCacheBox;

  Future<void> init() async {
    _cacheBox = await Hive.openBox<TMDBCacheData>(_cacheBoxName);
    _detailsCacheBox = await Hive.openBox<TMDBMovieDetailsCache>(
      _detailsCacheBoxName,
    );
  }

  // Check network connectivity
  Future<bool> hasNetworkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  // Cache discover movies
  Future<void> cachePopularMovies(List<TMDBMovie> movies) async {
    final cacheData = TMDBCacheData(
      cacheKey: _popularMoviesKey,
      movies: movies,
      cachedAt: DateTime.now(),
      cacheExpiry: _discoverCacheExpiry,
    );
    await _cacheBox.put(_popularMoviesKey, cacheData);
  }

  Future<void> cacheTrendingMovies(List<TMDBMovie> movies) async {
    final cacheData = TMDBCacheData(
      cacheKey: _trendingMoviesKey,
      movies: movies,
      cachedAt: DateTime.now(),
      cacheExpiry: _discoverCacheExpiry,
    );
    await _cacheBox.put(_trendingMoviesKey, cacheData);
  }

  Future<void> cacheTopRatedMovies(List<TMDBMovie> movies) async {
    final cacheData = TMDBCacheData(
      cacheKey: _topRatedMoviesKey,
      movies: movies,
      cachedAt: DateTime.now(),
      cacheExpiry: _discoverCacheExpiry,
    );
    await _cacheBox.put(_topRatedMoviesKey, cacheData);
  }

  Future<void> cacheUpcomingMovies(List<TMDBMovie> movies) async {
    final cacheData = TMDBCacheData(
      cacheKey: _upcomingMoviesKey,
      movies: movies,
      cachedAt: DateTime.now(),
      cacheExpiry: _discoverCacheExpiry,
    );
    await _cacheBox.put(_upcomingMoviesKey, cacheData);
  }

  // Get cached discover movies
  List<TMDBMovie>? getCachedPopularMovies() {
    final cacheData = _cacheBox.get(_popularMoviesKey);
    if (cacheData != null && cacheData.isValid) {
      return cacheData.movies;
    }
    return null;
  }

  List<TMDBMovie>? getCachedTrendingMovies() {
    final cacheData = _cacheBox.get(_trendingMoviesKey);
    if (cacheData != null && cacheData.isValid) {
      return cacheData.movies;
    }
    return null;
  }

  List<TMDBMovie>? getCachedTopRatedMovies() {
    final cacheData = _cacheBox.get(_topRatedMoviesKey);
    if (cacheData != null && cacheData.isValid) {
      return cacheData.movies;
    }
    return null;
  }

  List<TMDBMovie>? getCachedUpcomingMovies() {
    final cacheData = _cacheBox.get(_upcomingMoviesKey);
    if (cacheData != null && cacheData.isValid) {
      return cacheData.movies;
    }
    return null;
  }

  // Cache movie details with cast and videos
  Future<void> cacheMovieDetails({
    required int movieId,
    required TMDBMovie movieDetails,
    required List<TMDBCast> cast,
    required List<TMDBVideo> videos,
  }) async {
    final cacheData = TMDBMovieDetailsCache(
      movieId: movieId,
      movieDetails: movieDetails,
      cast: cast,
      videos: videos,
      cachedAt: DateTime.now(),
      cacheExpiry: _detailsCacheExpiry,
    );
    await _detailsCacheBox.put(movieId.toString(), cacheData);
  }

  // Get cached movie details
  TMDBMovieDetailsCache? getCachedMovieDetails(int movieId) {
    final cacheData = _detailsCacheBox.get(movieId.toString());
    if (cacheData != null && cacheData.isValid) {
      return cacheData;
    }
    return null;
  }

  // Check if discover data is available (cached or fresh)
  bool hasDiscoverData() {
    return getCachedPopularMovies() != null ||
        getCachedTrendingMovies() != null ||
        getCachedTopRatedMovies() != null ||
        getCachedUpcomingMovies() != null;
  }

  // Check if movie details are cached
  bool hasMovieDetails(int movieId) {
    return getCachedMovieDetails(movieId) != null;
  }

  // Cache management
  Future<void> clearExpiredCache() async {
    // Clear expired discover cache
    final cacheKeys = [
      _popularMoviesKey,
      _trendingMoviesKey,
      _topRatedMoviesKey,
      _upcomingMoviesKey,
    ];

    for (final key in cacheKeys) {
      final cacheData = _cacheBox.get(key);
      if (cacheData != null && cacheData.isExpired) {
        await _cacheBox.delete(key);
      }
    }

    // Clear expired movie details cache
    final detailsKeys = _detailsCacheBox.keys.toList();
    for (final key in detailsKeys) {
      final cacheData = _detailsCacheBox.get(key);
      if (cacheData != null && cacheData.isExpired) {
        await _detailsCacheBox.delete(key);
      }
    }
  }

  Future<void> clearAllCache() async {
    await _cacheBox.clear();
    await _detailsCacheBox.clear();
  }

  // Get cache status information
  Map<String, dynamic> getCacheStatus() {
    final now = DateTime.now();

    return {
      'popularMovies': _getCacheInfo(_cacheBox.get(_popularMoviesKey), now),
      'trendingMovies': _getCacheInfo(_cacheBox.get(_trendingMoviesKey), now),
      'topRatedMovies': _getCacheInfo(_cacheBox.get(_topRatedMoviesKey), now),
      'upcomingMovies': _getCacheInfo(_cacheBox.get(_upcomingMoviesKey), now),
      'totalDetailsCache': _detailsCacheBox.length,
      'hasNetworkConnection': true, // Will be updated by the controller
    };
  }

  Map<String, dynamic> _getCacheInfo(TMDBCacheData? cacheData, DateTime now) {
    if (cacheData == null) {
      return {'cached': false, 'count': 0};
    }

    return {
      'cached': true,
      'count': cacheData.movies.length,
      'cachedAt': cacheData.cachedAt.toIso8601String(),
      'isValid': cacheData.isValid,
      'expiresAt': cacheData.cachedAt
          .add(cacheData.cacheExpiry)
          .toIso8601String(),
    };
  }
}
