import 'package:dartz/dartz.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class DeleteMovie {
  final MovieRepository repository;

  DeleteMovie(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteMovie(id);
  }
}
