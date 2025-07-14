import '../models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getMovies();
  Future<void> addMovie(MovieModel movie);
  Future<void> deleteMovie(String id);
  Future<void> updateMovie(MovieModel movie);
  Future<MovieModel?> getMovieById(String id);
}
