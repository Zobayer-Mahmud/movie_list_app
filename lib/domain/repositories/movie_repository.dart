import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../../core/error/failures.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getMovies();
  Future<Either<Failure, void>> addMovie(Movie movie);
  Future<Either<Failure, void>> deleteMovie(String id);
  Future<Either<Failure, void>> toggleFavorite(String id);
}
