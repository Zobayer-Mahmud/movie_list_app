import 'package:flutter_test/flutter_test.dart';
import 'package:movie_list_app/core/utils/id_generator.dart';

void main() {
  group('IdGenerator', () {
    group('generateId', () {
      test('should generate non-empty string', () {
        final id = IdGenerator.generateId();
        expect(id, isNotEmpty);
      });

      test('should generate string with 16 characters', () {
        final id = IdGenerator.generateId();
        expect(id.length, 16);
      });

      test('should generate different IDs on multiple calls', () {
        final id1 = IdGenerator.generateId();
        final id2 = IdGenerator.generateId();
        expect(id1, isNot(equals(id2)));
      });

      test('should generate ID with valid characters only', () {
        final id = IdGenerator.generateId();
        const validChars =
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

        for (int i = 0; i < id.length; i++) {
          expect(
            validChars.contains(id[i]),
            isTrue,
            reason: 'Character ${id[i]} is not valid',
          );
        }
      });
    });

    group('generateIdWithTimestamp', () {
      test('should generate non-empty string', () {
        final id = IdGenerator.generateIdWithTimestamp();
        expect(id, isNotEmpty);
      });

      test('should contain underscore separator', () {
        final id = IdGenerator.generateIdWithTimestamp();
        expect(id.contains('_'), isTrue);
      });

      test('should start with timestamp', () {
        final beforeTimestamp = DateTime.now().millisecondsSinceEpoch;
        final id = IdGenerator.generateIdWithTimestamp();
        final afterTimestamp = DateTime.now().millisecondsSinceEpoch;

        final timestampPart = id.split('_')[0];
        final timestamp = int.tryParse(timestampPart);

        expect(timestamp, isNotNull);
        expect(timestamp! >= beforeTimestamp, isTrue);
        expect(timestamp <= afterTimestamp, isTrue);
      });

      test('should have random part after timestamp', () {
        final id = IdGenerator.generateIdWithTimestamp();
        final parts = id.split('_');

        expect(parts.length, 2);
        expect(parts[1].length, 16); // Same length as generateId()
      });

      test('should generate different IDs on multiple calls', () {
        final id1 = IdGenerator.generateIdWithTimestamp();
        final id2 = IdGenerator.generateIdWithTimestamp();
        expect(id1, isNot(equals(id2)));
      });

      test('should generate IDs with chronological timestamps', () async {
        final id1 = IdGenerator.generateIdWithTimestamp();
        await Future.delayed(const Duration(milliseconds: 1));
        final id2 = IdGenerator.generateIdWithTimestamp();

        final timestamp1 = int.parse(id1.split('_')[0]);
        final timestamp2 = int.parse(id2.split('_')[0]);

        expect(timestamp2 >= timestamp1, isTrue);
      });
    });
  });
}
