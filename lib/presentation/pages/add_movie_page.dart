import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/genre_selector.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/star_rating.dart';
import '../widgets/year_picker.dart' as custom_year_picker;
import '../widgets/watch_status.dart';

class AddMoviePage extends StatelessWidget {
  const AddMoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.find<MovieController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie'),
        actions: const [ThemeToggleButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Add a new movie to your collection',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            Obx(
              () => CustomTextField(
                controller: controller.titleController,
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
            Obx(
              () => CustomTextField(
                controller: controller.descriptionController,
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
            Obx(
              () => ElevatedButton(
                onPressed: controller.isAddingMovie.value
                    ? null
                    : controller.addMovie,
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
                        'Add Movie',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
