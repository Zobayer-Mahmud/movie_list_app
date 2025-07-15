import 'package:flutter_test/flutter_test.dart';
import 'package:movie_list_app/core/utils/movie_validator.dart';
import 'package:movie_list_app/core/constants/app_constants.dart';

void main() {
  group('MovieValidator', () {
    group('validateTitle', () {
      test('should return null for valid title', () {
        const validTitle = 'Valid Movie Title';
        final result = MovieValidator.validateTitle(validTitle);
        expect(result, isNull);
      });

      test('should return error for null title', () {
        final result = MovieValidator.validateTitle(null);
        expect(result, AppConstants.titleRequiredMessage);
      });

      test('should return error for empty title', () {
        final result = MovieValidator.validateTitle('');
        expect(result, AppConstants.titleRequiredMessage);
      });

      test('should return error for whitespace-only title', () {
        final result = MovieValidator.validateTitle('   ');
        expect(result, AppConstants.titleRequiredMessage);
      });

      test('should return error for title less than 2 characters', () {
        final result = MovieValidator.validateTitle('A');
        expect(result, AppConstants.titleMinLengthMessage);
      });

      test('should return null for title with exactly 2 characters', () {
        final result = MovieValidator.validateTitle('Ab');
        expect(result, isNull);
      });

      test('should trim title and validate correctly', () {
        final result = MovieValidator.validateTitle('  Valid Title  ');
        expect(result, isNull);
      });
    });

    group('validateDescription', () {
      test('should return null for valid description', () {
        const validDescription =
            'This is a valid movie description with enough characters';
        final result = MovieValidator.validateDescription(validDescription);
        expect(result, isNull);
      });

      test('should return error for null description', () {
        final result = MovieValidator.validateDescription(null);
        expect(result, AppConstants.descriptionRequiredMessage);
      });

      test('should return error for empty description', () {
        final result = MovieValidator.validateDescription('');
        expect(result, AppConstants.descriptionRequiredMessage);
      });

      test('should return error for whitespace-only description', () {
        final result = MovieValidator.validateDescription('   ');
        expect(result, AppConstants.descriptionRequiredMessage);
      });

      test('should return error for description less than 10 characters', () {
        final result = MovieValidator.validateDescription('Short');
        expect(result, AppConstants.descriptionMinLengthMessage);
      });

      test('should return null for description with exactly 10 characters', () {
        final result = MovieValidator.validateDescription('1234567890');
        expect(result, isNull);
      });

      test('should trim description and validate correctly', () {
        final result = MovieValidator.validateDescription(
          '  Valid description here  ',
        );
        expect(result, isNull);
      });
    });

    group('isValidMovie', () {
      test('should return true for valid title and description', () {
        const validTitle = 'Valid Movie';
        const validDescription = 'This is a valid description';

        final result = MovieValidator.isValidMovie(
          validTitle,
          validDescription,
        );
        expect(result, isTrue);
      });

      test('should return false for invalid title', () {
        const invalidTitle = 'A';
        const validDescription = 'This is a valid description';

        final result = MovieValidator.isValidMovie(
          invalidTitle,
          validDescription,
        );
        expect(result, isFalse);
      });

      test('should return false for invalid description', () {
        const validTitle = 'Valid Movie';
        const invalidDescription = 'Short';

        final result = MovieValidator.isValidMovie(
          validTitle,
          invalidDescription,
        );
        expect(result, isFalse);
      });

      test('should return false for both invalid title and description', () {
        const invalidTitle = '';
        const invalidDescription = '';

        final result = MovieValidator.isValidMovie(
          invalidTitle,
          invalidDescription,
        );
        expect(result, isFalse);
      });
    });
  });
}
