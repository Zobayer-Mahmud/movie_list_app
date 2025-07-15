import 'package:dartz/dartz.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class ToggleWatchStatus {
  final MovieRepository repository;

  ToggleWatchStatus(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.toggleWatchStatus(id);
  }
}
