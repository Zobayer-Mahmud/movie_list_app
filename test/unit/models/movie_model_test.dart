import 'package:flutter_test/flutter_test.dart';
import 'package:movie_list_app/data/models/movie_model.dart';
import 'package:movie_list_app/domain/entities/movie.dart';

void main() {
  group('MovieModel', () {
    const String testId = 'test_id';
    const String testTitle = 'Test Movie';
    const String testDescription = 'This is a test movie description';
    const bool testIsFavorite = true;
    final DateTime testCreatedAt = DateTime(2024, 1, 1);

    late MovieModel movieModel;

    setUp(() {
      movieModel = MovieModel(
        modelId: testId,
        modelTitle: testTitle,
        modelDescription: testDescription,
        modelIsFavorite: testIsFavorite,
        modelCreatedAt: testCreatedAt,
      );
    });

    test('should extend Movie entity', () {
      expect(movieModel, isA<Movie>());
    });

    test('should return correct properties', () {
      expect(movieModel.id, testId);
      expect(movieModel.title, testTitle);
      expect(movieModel.description, testDescription);
      expect(movieModel.isFavorite, testIsFavorite);
    });

    test('should create MovieModel from Movie entity', () {
      final movie = Movie(
        id: testId,
        title: testTitle,
        description: testDescription,
        isFavorite: testIsFavorite,
        createdAt: testCreatedAt,
      );

      final movieModel = MovieModel.fromEntity(movie);

      expect(movieModel.modelId, testId);
      expect(movieModel.modelTitle, testTitle);
      expect(movieModel.modelDescription, testDescription);
      expect(movieModel.modelIsFavorite, testIsFavorite);
    });

    test('should convert MovieModel to Movie entity', () {
      final movie = movieModel.toEntity();

      expect(movie.id, testId);
      expect(movie.title, testTitle);
      expect(movie.description, testDescription);
      expect(movie.isFavorite, testIsFavorite);
      expect(movie, isA<Movie>());
    });

    test('should create copy with updated values', () {
      const newTitle = 'Updated Movie';
      const newIsFavorite = false;

      final updatedMovie = movieModel.copyWith(
        title: newTitle,
        isFavorite: newIsFavorite,
      );

      expect(updatedMovie.modelId, testId);
      expect(updatedMovie.modelTitle, newTitle);
      expect(updatedMovie.modelDescription, testDescription);
      expect(updatedMovie.modelIsFavorite, newIsFavorite);
    });

    test('should convert to JSON correctly', () {
      final json = movieModel.toJson();

      expect(json['id'], testId);
      expect(json['title'], testTitle);
      expect(json['description'], testDescription);
      expect(json['isFavorite'], testIsFavorite);
    });

    test('should create MovieModel from JSON', () {
      final json = {
        'id': testId,
        'title': testTitle,
        'description': testDescription,
        'isFavorite': testIsFavorite,
      };

      final movieModel = MovieModel.fromJson(json);

      expect(movieModel.modelId, testId);
      expect(movieModel.modelTitle, testTitle);
      expect(movieModel.modelDescription, testDescription);
      expect(movieModel.modelIsFavorite, testIsFavorite);
    });

    test('should maintain equality based on properties', () {
      final movie1 = MovieModel(
        modelId: testId,
        modelTitle: testTitle,
        modelDescription: testDescription,
        modelIsFavorite: testIsFavorite,
        modelCreatedAt: testCreatedAt,
      );

      final movie2 = MovieModel(
        modelId: testId,
        modelTitle: testTitle,
        modelDescription: testDescription,
        modelIsFavorite: testIsFavorite,
        modelCreatedAt: testCreatedAt,
      );

      expect(movie1, equals(movie2));
    });
  });
}
