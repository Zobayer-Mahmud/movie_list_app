import '../network/dio_client.dart';
import '../../data/models/tmdb_movie_response.dart';
import '../../data/models/tmdb_movie_model.dart';
import '../../data/models/tmdb_cast_model.dart';
import '../../data/models/tmdb_video_model.dart';
import '../../data/models/tmdb_cast_model.dart';
import '../../data/models/tmdb_video_model.dart';

class TMDBApiService {
  final DioClient _dioClient = DioClient.to;

  // Get popular movies
  Future<TMDBMovieResponse?> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dioClient.get(
        endpoint: '/movie/popular',
        queryParams: {'page': page},
      );

      if (response.isSuccess && response.data != null) {
        return TMDBMovieResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching popular movies: $e');
      return null;
    }
  }

  // Get trending movies
  Future<TMDBMovieResponse?> getTrendingMovies({int page = 1}) async {
    try {
      final response = await _dioClient.get(
        endpoint: '/trending/movie/week',
        queryParams: {'page': page},
      );

      if (response.isSuccess && response.data != null) {
        return TMDBMovieResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching trending movies: $e');
      return null;
    }
  }

  // Search movies
  Future<TMDBMovieResponse?> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dioClient.get(
        endpoint: '/search/movie',
        queryParams: {'query': query, 'page': page},
      );

      if (response.isSuccess && response.data != null) {
        return TMDBMovieResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error searching movies: $e');
      return null;
    }
  }

  // Get movie details
  Future<TMDBMovie?> getMovieDetails(int movieId) async {
    try {
      final response = await _dioClient.get(endpoint: '/movie/$movieId');

      if (response.isSuccess && response.data != null) {
        return TMDBMovie.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching movie details: $e');
      return null;
    }
  }

  // Get top rated movies
  Future<TMDBMovieResponse?> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dioClient.get(
        endpoint: '/movie/top_rated',
        queryParams: {'page': page},
      );

      if (response.isSuccess && response.data != null) {
        return TMDBMovieResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching top rated movies: $e');
      return null;
    }
  }

  // Get upcoming movies
  Future<TMDBMovieResponse?> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dioClient.get(
        endpoint: '/movie/upcoming',
        queryParams: {'page': page},
      );

      if (response.isSuccess && response.data != null) {
        return TMDBMovieResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching upcoming movies: $e');
      return null;
    }
  }

  // Get now playing movies
  Future<TMDBMovieResponse?> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dioClient.get(
        endpoint: '/movie/now_playing',
        queryParams: {'page': page},
      );

      if (response.isSuccess && response.data != null) {
        return TMDBMovieResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching now playing movies: $e');
      return null;
    }
  }

  // Get movie credits (cast and crew)
  Future<TMDBCreditsResponse?> getMovieCredits(int movieId) async {
    try {
      final response = await _dioClient.get(
        endpoint: '/movie/$movieId/credits',
      );

      if (response.isSuccess && response.data != null) {
        return TMDBCreditsResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching movie credits: $e');
      return null;
    }
  }

  // Get movie videos (trailers, teasers, etc.)
  Future<TMDBVideosResponse?> getMovieVideos(int movieId) async {
    try {
      final response = await _dioClient.get(endpoint: '/movie/$movieId/videos');

      if (response.isSuccess && response.data != null) {
        return TMDBVideosResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching movie videos: $e');
      return null;
    }
  }
}
