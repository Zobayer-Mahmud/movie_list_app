import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies.dart';
import '../../domain/usecases/add_movie.dart';
import '../../domain/usecases/update_movie.dart';
import '../../domain/usecases/delete_movie.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/usecases/toggle_watch_status.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/utils/id_generator.dart';
import '../../core/utils/movie_validator.dart';
import '../../core/constants/app_enums.dart';

class MovieController extends GetxController {
  // Use cases
  late final GetMovies _getMovies;
  late final AddMovie _addMovie;
  late final UpdateMovie _updateMovie;
  late final DeleteMovie _deleteMovie;
  late final ToggleFavorite _toggleFavorite;
  late final ToggleWatchStatus _toggleWatchStatus;

  // Observable variables
  final RxList<Movie> movies = <Movie>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isAddingMovie = false.obs;

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final RxString titleError = ''.obs;
  final RxString descriptionError = ''.obs;

  // New fields for genre and image
  final Rx<MovieGenre?> selectedGenre = Rx<MovieGenre?>(null);
  final RxString selectedImagePath = ''.obs;

  // New fields for rating, release year, and watch status
  final RxDouble selectedRating = 0.0.obs;
  final Rx<int?> selectedReleaseYear = Rx<int?>(null);
  final RxBool selectedIsWatched = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUseCases();
    loadMovies();
  }

  void _initializeUseCases() {
    _getMovies = getIt<GetMovies>();
    _addMovie = getIt<AddMovie>();
    _updateMovie = getIt<UpdateMovie>();
    _deleteMovie = getIt<DeleteMovie>();
    _toggleFavorite = getIt<ToggleFavorite>();
    _toggleWatchStatus = getIt<ToggleWatchStatus>();
  }

  Future<void> loadMovies() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _getMovies();
      result.fold(
        (failure) {
          errorMessage.value = failure.message ?? 'Failed to load movies';
        },
        (movieList) {
          movies.value = movieList;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMovie() async {
    if (!_validateForm()) return;

    try {
      isAddingMovie.value = true;
      errorMessage.value = '';

      final movie = Movie(
        id: IdGenerator.generateIdWithTimestamp(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        isFavorite: false,
        genre: selectedGenre.value,
        imagePath: selectedImagePath.value.isEmpty
            ? null
            : selectedImagePath.value,
        rating: selectedRating.value,
        releaseYear: selectedReleaseYear.value,
        isWatched: selectedIsWatched.value,
      );

      final result = await _addMovie(movie);
      result.fold(
        (failure) {
          errorMessage.value = failure.message ?? 'Failed to add movie';
        },
        (_) {
          _clearForm();
          loadMovies(); // Refresh the list
          Get.back(); // Close the add movie screen
          Get.snackbar(
            'Success',
            'Movie added successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isAddingMovie.value = false;
    }
  }

  Future<void> updateMovie(Movie movie) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _updateMovie(movie);
      result.fold(
        (failure) {
          errorMessage.value = failure.message ?? 'Failed to update movie';
        },
        (_) {
          loadMovies(); // Refresh the list
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMovie(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _deleteMovie(id);
      result.fold(
        (failure) {
          errorMessage.value = failure.message ?? 'Failed to delete movie';
        },
        (_) {
          loadMovies(); // Refresh the list
          Get.snackbar(
            'Success',
            'Movie deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(String id) async {
    try {
      final result = await _toggleFavorite(id);
      result.fold(
        (failure) {
          errorMessage.value = failure.message ?? 'Failed to update favorite';
        },
        (_) {
          loadMovies(); // Refresh the list
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    }
  }

  Future<void> toggleWatchStatus(String id) async {
    try {
      final result = await _toggleWatchStatus(id);
      result.fold(
        (failure) {
          errorMessage.value =
              failure.message ?? 'Failed to update watch status';
        },
        (_) {
          loadMovies(); // Refresh the list
          Get.snackbar(
            'Success',
            'Watch status updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
          );
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    }
  }

  bool _validateForm() {
    bool isValid = true;

    // Clear previous errors
    titleError.value = '';
    descriptionError.value = '';

    // Validate title
    final titleValidation = MovieValidator.validateTitle(titleController.text);
    if (titleValidation != null) {
      titleError.value = titleValidation;
      isValid = false;
    }

    // Validate description
    final descriptionValidation = MovieValidator.validateDescription(
      descriptionController.text,
    );
    if (descriptionValidation != null) {
      descriptionError.value = descriptionValidation;
      isValid = false;
    }

    return isValid;
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    titleError.value = '';
    descriptionError.value = '';
    selectedGenre.value = null;
    selectedImagePath.value = '';
    selectedRating.value = 0.0;
    selectedReleaseYear.value = null;
    selectedIsWatched.value = false;
  }

  void clearErrors() {
    errorMessage.value = '';
    titleError.value = '';
    descriptionError.value = '';
  }

  // New methods for handling genre and image
  void updateGenre(MovieGenre? genre) {
    selectedGenre.value = genre;
  }

  void updateImagePath(String? imagePath) {
    selectedImagePath.value = imagePath ?? '';
  }

  // New methods for rating, release year, and watch status
  void updateRating(double rating) {
    selectedRating.value = rating;
  }

  void updateReleaseYear(int? year) {
    selectedReleaseYear.value = year;
  }

  void updateWatchStatus(bool isWatched) {
    selectedIsWatched.value = isWatched;
  }

  // Getters for filtered lists
  List<Movie> get favoriteMovies =>
      movies.where((movie) => movie.isFavorite).toList();
  List<Movie> get regularMovies =>
      movies.where((movie) => !movie.isFavorite).toList();

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
