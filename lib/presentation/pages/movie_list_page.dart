import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../widgets/movie_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_widget.dart';
import 'add_movie_page.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.put(MovieController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: controller.loadMovies,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return MovieErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.loadMovies,
          );
        }

        if (controller.movies.isEmpty) {
          return const EmptyStateWidget(
            message:
                'No movies added yet.\nTap the + button to add your first movie!',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadMovies,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.movies.length,
            itemBuilder: (context, index) {
              final movie = controller.movies[index];
              return MovieCard(
                movie: movie,
                onFavoriteToggle: () => controller.toggleFavorite(movie.id),
                onDelete: () => _showDeleteDialog(context, controller, movie),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddMoviePage()),
        tooltip: 'Add Movie',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    MovieController controller,
    movie,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Movie'),
        content: Text('Are you sure you want to delete "${movie.title}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteMovie(movie.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
