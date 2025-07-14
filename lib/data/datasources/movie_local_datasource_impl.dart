import 'movie_local_datasource.dart';
import '../models/movie_model.dart';
import '../../core/di/local_storage_client.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final LocalStorageClient localStorageClient;

  MovieLocalDataSourceImpl(this.localStorageClient);

  @override
  Future<List<MovieModel>> getMovies() async {
    try {
      final movies = await localStorageClient.getAll<MovieModel>(
        AppConstants.movieBoxName,
      );
      return movies;
    } catch (e) {
      throw CacheException('Failed to get movies: $e');
    }
  }

  @override
  Future<void> addMovie(MovieModel movie) async {
    try {
      await localStorageClient.put<MovieModel>(
        AppConstants.movieBoxName,
        movie.modelId,
        movie,
      );
    } catch (e) {
      throw CacheException('Failed to add movie: $e');
    }
  }

  @override
  Future<void> deleteMovie(String id) async {
    try {
      await localStorageClient.delete(AppConstants.movieBoxName, id);
    } catch (e) {
      throw CacheException('Failed to delete movie: $e');
    }
  }

  @override
  Future<void> updateMovie(MovieModel movie) async {
    try {
      await localStorageClient.put<MovieModel>(
        AppConstants.movieBoxName,
        movie.modelId,
        movie,
      );
    } catch (e) {
      throw CacheException('Failed to update movie: $e');
    }
  }

  @override
  Future<MovieModel?> getMovieById(String id) async {
    try {
      return await localStorageClient.get<MovieModel>(
        AppConstants.movieBoxName,
        id,
      );
    } catch (e) {
      throw CacheException('Failed to get movie by id: $e');
    }
  }
}
