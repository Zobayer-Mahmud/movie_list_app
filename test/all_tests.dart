import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'unit/models/movie_model_test.dart' as movie_model_tests;
import 'unit/utils/movie_validator_test.dart' as validator_tests;
import 'unit/utils/id_generator_test.dart' as id_generator_tests;
import 'unit/usecases/use_cases_test.dart' as use_case_tests;
import 'widget/movie_card_test.dart' as movie_card_tests;
import 'widget/custom_text_field_test.dart' as text_field_tests;

void main() {
  group('All Unit Tests', () {
    movie_model_tests.main();
    validator_tests.main();
    id_generator_tests.main();
    use_case_tests.main();
  });

  group('All Widget Tests', () {
    movie_card_tests.main();
    text_field_tests.main();
  });
}
