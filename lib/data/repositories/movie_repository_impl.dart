import 'package:dartz/dartz.dart';

import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/movie_local_datasource.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Movie>>> getMovies() async {
    try {
      final movieModels = await localDataSource.getMovies();
      final movies = movieModels.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addMovie(Movie movie) async {
    try {
      final movieModel = MovieModel.fromEntity(movie);
      await localDataSource.addMovie(movieModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMovie(Movie movie) async {
    try {
      final movieModel = MovieModel.fromEntity(movie);
      await localDataSource.updateMovie(movieModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMovie(String id) async {
    try {
      await localDataSource.deleteMovie(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String id) async {
    try {
      final movieModel = await localDataSource.getMovieById(id);
      if (movieModel == null) {
        return const Left(CacheFailure('Movie not found'));
      }

      final updatedMovie = movieModel.copyWith(
        isFavorite: !movieModel.modelIsFavorite,
      );

      await localDataSource.updateMovie(updatedMovie);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleWatchStatus(String id) async {
    try {
      final movieModel = await localDataSource.getMovieById(id);
      if (movieModel == null) {
        return const Left(CacheFailure('Movie not found'));
      }

      final updatedMovie = movieModel.copyWith(
        isWatched: !movieModel.modelIsWatched,
      );

      await localDataSource.updateMovie(updatedMovie);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
