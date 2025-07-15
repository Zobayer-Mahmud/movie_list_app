import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/movie.dart';
import '../controllers/movie_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/genre_selector.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/star_rating.dart';
import '../widgets/year_picker.dart' as custom_year_picker;
import '../widgets/watch_status.dart';

class EditMoviePage extends StatefulWidget {
  final Movie movie;

  const EditMoviePage({super.key, required this.movie});

  @override
  State<EditMoviePage> createState() => _EditMoviePageState();
}

class _EditMoviePageState extends State<EditMoviePage> {
  late MovieController controller;
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MovieController>();

    // Initialize controllers with current movie data
    titleController = TextEditingController(text: widget.movie.title);
    descriptionController = TextEditingController(
      text: widget.movie.description,
    );

    // Set current movie values in the controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedGenre.value = widget.movie.genre;
      controller.selectedImagePath.value = widget.movie.imagePath ?? '';
      controller.selectedRating.value = widget.movie.rating;
      controller.selectedReleaseYear.value = widget.movie.releaseYear;
      controller.selectedIsWatched.value = widget.movie.isWatched;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Movie'),
        actions: const [ThemeToggleButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Update your movie details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Title Field
            Obx(
              () => CustomTextField(
                controller: titleController,
                labelText: 'Movie Title',
                hintText: 'Enter movie title',
                errorText: controller.titleError.value.isEmpty
                    ? null
                    : controller.titleError.value,
                prefixIcon: Icons.movie,
                onChanged: (value) {
                  if (controller.titleError.value.isNotEmpty) {
                    controller.titleError.value = '';
                  }
                },
              ),
            ),
            const SizedBox(height: 20),

            // Description Field
            Obx(
              () => CustomTextField(
                controller: descriptionController,
                labelText: 'Description',
                hintText: 'Enter movie description (at least 10 characters)',
                errorText: controller.descriptionError.value.isEmpty
                    ? null
                    : controller.descriptionError.value,
                prefixIcon: Icons.description,
                maxLines: 4,
                onChanged: (value) {
                  if (controller.descriptionError.value.isNotEmpty) {
                    controller.descriptionError.value = '';
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            // Image Picker
            Obx(
              () => ImagePickerWidget(
                initialImagePath: controller.selectedImagePath.value.isEmpty
                    ? null
                    : controller.selectedImagePath.value,
                onImageChanged: controller.updateImagePath,
              ),
            ),
            const SizedBox(height: 24),

            // Genre Selector
            Obx(
              () => GenreSelector(
                selectedGenre: controller.selectedGenre.value,
                onGenreChanged: controller.updateGenre,
              ),
            ),
            const SizedBox(height: 24),

            // Star Rating
            Obx(
              () => InteractiveStarRating(
                initialRating: controller.selectedRating.value,
                label: 'Rating',
                onRatingChanged: controller.updateRating,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),

            // Release Year Picker
            Obx(
              () => custom_year_picker.YearPicker(
                selectedYear: controller.selectedReleaseYear.value,
                label: 'Release Year',
                hintText: 'Select release year (optional)',
                onYearChanged: controller.updateReleaseYear,
              ),
            ),
            const SizedBox(height: 24),

            // Watch Status Toggle
            Obx(
              () => WatchStatusToggle(
                isWatched: controller.selectedIsWatched.value,
                label: 'Watch Status',
                style: WatchStatusStyle.switch_,
                onChanged: controller.updateWatchStatus,
              ),
            ),
            const SizedBox(height: 32),

            // Error Message
            Obx(() {
              if (controller.errorMessage.value.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ),
                      IconButton(
                        onPressed: controller.clearErrors,
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        color: Colors.red[600],
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Update Button
            Obx(
              () => ElevatedButton(
                onPressed: controller.isAddingMovie.value
                    ? null
                    : () => _updateMovie(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isAddingMovie.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Update Movie',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Cancel Button
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMovie() async {
    // Validate form
    controller.titleError.value = '';
    controller.descriptionError.value = '';
    controller.errorMessage.value = '';

    if (titleController.text.trim().isEmpty) {
      controller.titleError.value = 'Title is required';
      return;
    }

    if (titleController.text.trim().length < 2) {
      controller.titleError.value = 'Title must be at least 2 characters';
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      controller.descriptionError.value = 'Description is required';
      return;
    }

    if (descriptionController.text.trim().length < 10) {
      controller.descriptionError.value =
          'Description must be at least 10 characters';
      return;
    }

    // Create updated movie
    final updatedMovie = widget.movie.copyWith(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      genre: controller.selectedGenre.value,
      imagePath: controller.selectedImagePath.value.isEmpty
          ? null
          : controller.selectedImagePath.value,
      rating: controller.selectedRating.value,
      releaseYear: controller.selectedReleaseYear.value,
      isWatched: controller.selectedIsWatched.value,
    );

    try {
      controller.isAddingMovie.value = true;
      await controller.updateMovie(updatedMovie);

      Get.back(); // Close edit page
      Get.snackbar(
        'Success',
        'Movie updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      controller.errorMessage.value = 'Failed to update movie';
    } finally {
      controller.isAddingMovie.value = false;
    }
  }
}
