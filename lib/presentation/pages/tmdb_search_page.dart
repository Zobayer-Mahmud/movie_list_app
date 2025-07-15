import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tmdb_controller.dart';
import '../widgets/tmdb_movie_card.dart';
import '../widgets/theme_toggle_button.dart';

class TMDBSearchPage extends StatelessWidget {
  const TMDBSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TMDBController controller = Get.find<TMDBController>();
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
        actions: [const ThemeToggleButton()],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    controller.clearSearch();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  controller.searchMovies(query);
                }
              },
            ),
          ),

          // Search results
          Expanded(
            child: Obx(() {
              if (controller.isLoadingSearch.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.searchQuery.value.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Search for movies',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.movie_filter,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No movies found for "${controller.searchQuery.value}"',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final movie = controller.searchResults[index];
                  return TMDBMovieCard(
                    movie: movie,
                    onTap: () => Get.toNamed('/tmdb-details', arguments: movie),
                    onAddToList: () => _showAddToListDialog(context, movie),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddToListDialog(BuildContext context, movie) {
    Get.dialog(
      AlertDialog(
        title: const Text('Add to Your List'),
        content: Text('Add "${movie.title}" to your personal movie list?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              _addMovieToPersonalList(movie);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addMovieToPersonalList(movie) {
    // TODO: Convert TMDB movie to local movie format and add to personal list
    Get.snackbar(
      'Feature Coming Soon',
      'Adding TMDB movies to personal list will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
