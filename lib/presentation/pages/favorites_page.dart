import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../widgets/movie_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/bottom_nav_bar.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieController = Get.find<MovieController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            onPressed: movieController.loadMovies,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        final favoriteMovies = movieController.favoriteMovies;

        if (favoriteMovies.isEmpty) {
          return const EmptyStateWidget(
            message:
                'No favorite movies yet.\nAdd some movies to your favorites to see them here!\nTap the heart icon on any movie card.',
          );
        }

        return Column(
          children: [
            // Stats header
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${favoriteMovies.length} Favorite Movie${favoriteMovies.length == 1 ? '' : 's'}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        Text(
                          'Your handpicked collection',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                    .withValues(alpha: 0.8),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Movies list
            Expanded(
              child: RefreshIndicator(
                onRefresh: movieController.loadMovies,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: favoriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = favoriteMovies[index];
                    return MovieCard(
                      movie: movie,
                      onFavoriteToggle: () =>
                          movieController.toggleFavorite(movie.id),
                      onDelete: () =>
                          _showDeleteDialog(context, movieController, movie),
                      onTap: () =>
                          Get.toNamed('/movie-details', arguments: movie),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const BottomNavBar(),
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
