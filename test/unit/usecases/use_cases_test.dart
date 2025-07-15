import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_list_app/domain/entities/movie.dart';
import 'package:movie_list_app/domain/repositories/movie_repository.dart';
import 'package:movie_list_app/domain/usecases/get_movies.dart';
import 'package:movie_list_app/domain/usecases/add_movie.dart';
import 'package:movie_list_app/domain/usecases/delete_movie.dart';
import 'package:movie_list_app/domain/usecases/toggle_favorite.dart';
import 'package:movie_list_app/core/error/failures.dart';

import 'use_cases_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late MockMovieRepository mockRepository;
  late GetMovies getMovies;
  late AddMovie addMovie;
  late DeleteMovie deleteMovie;
  late ToggleFavorite toggleFavorite;

  setUp(() {
    mockRepository = MockMovieRepository();
    getMovies = GetMovies(mockRepository);
    addMovie = AddMovie(mockRepository);
    deleteMovie = DeleteMovie(mockRepository);
    toggleFavorite = ToggleFavorite(mockRepository);
  });

  group('GetMovies', () {
    final tMovieList = [
      Movie(
        id: '1',
        title: 'Test Movie 1',
        description: 'Test Description 1',
        isFavorite: false,
        createdAt: DateTime(2024, 1, 1),
      ),
      Movie(
        id: '2',
        title: 'Test Movie 2',
        description: 'Test Description 2',
        isFavorite: true,
        createdAt: DateTime(2024, 1, 2),
      ),
    ];

    test('should get movies from repository', () async {
      // arrange
      when(
        mockRepository.getMovies(),
      ).thenAnswer((_) async => Right(tMovieList));

      // act
      final result = await getMovies();

      // assert
      expect(result, Right(tMovieList));
      verify(mockRepository.getMovies());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = CacheFailure('Cache error');
      when(
        mockRepository.getMovies(),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await getMovies();

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.getMovies());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('AddMovie', () {
    final tMovie = Movie(
      id: '1',
      title: 'Test Movie',
      description: 'Test Description',
      isFavorite: false,
      createdAt: DateTime(2024, 1, 1),
    );

    test('should add movie to repository', () async {
      // arrange
      when(
        mockRepository.addMovie(tMovie),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await addMovie(tMovie);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.addMovie(tMovie));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = CacheFailure('Failed to add movie');
      when(
        mockRepository.addMovie(tMovie),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await addMovie(tMovie);

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.addMovie(tMovie));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('DeleteMovie', () {
    const tMovieId = '1';

    test('should delete movie from repository', () async {
      // arrange
      when(
        mockRepository.deleteMovie(tMovieId),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await deleteMovie(tMovieId);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.deleteMovie(tMovieId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = CacheFailure('Failed to delete movie');
      when(
        mockRepository.deleteMovie(tMovieId),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await deleteMovie(tMovieId);

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.deleteMovie(tMovieId));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('ToggleFavorite', () {
    const tMovieId = '1';

    test('should toggle favorite status in repository', () async {
      // arrange
      when(
        mockRepository.toggleFavorite(tMovieId),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await toggleFavorite(tMovieId);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.toggleFavorite(tMovieId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = CacheFailure('Failed to toggle favorite');
      when(
        mockRepository.toggleFavorite(tMovieId),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await toggleFavorite(tMovieId);

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.toggleFavorite(tMovieId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
