import '../constants/app_constants.dart';

class MovieValidator {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.titleRequiredMessage;
    }
    if (value.trim().length < 2) {
      return AppConstants.titleMinLengthMessage;
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.descriptionRequiredMessage;
    }
    if (value.trim().length < 10) {
      return AppConstants.descriptionMinLengthMessage;
    }
    return null;
  }

  static bool isValidMovie(String title, String description) {
    return validateTitle(title) == null &&
        validateDescription(description) == null;
  }
}
