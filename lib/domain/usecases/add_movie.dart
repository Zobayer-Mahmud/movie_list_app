import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class AddMovie {
  final MovieRepository repository;

  AddMovie(this.repository);

  Future<Either<Failure, void>> call(Movie movie) async {
    return await repository.addMovie(movie);
  }
}
