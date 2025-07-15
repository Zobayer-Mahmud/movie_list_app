import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class UpdateMovie {
  final MovieRepository repository;

  UpdateMovie(this.repository);

  Future<Either<Failure, void>> call(Movie movie) async {
    return await repository.updateMovie(movie);
  }
}
