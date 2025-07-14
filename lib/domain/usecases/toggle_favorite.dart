import 'package:dartz/dartz.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class ToggleFavorite {
  final MovieRepository repository;

  ToggleFavorite(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.toggleFavorite(id);
  }
}
