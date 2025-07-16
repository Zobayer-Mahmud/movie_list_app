import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../../core/constants/app_enums.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieController = Get.find<MovieController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            onPressed: movieController.loadMovies,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        final movies = movieController.movies;
        final favoriteMovies = movieController.favoriteMovies;

        if (movies.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Statistics Available',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Add some movies to see statistics'),
              ],
            ),
          );
        }

        // Calculate genre statistics
        final genreStats = <MovieGenre, int>{};
        for (final movie in movies) {
          if (movie.genre != null) {
            genreStats[movie.genre!] = (genreStats[movie.genre!] ?? 0) + 1;
          }
        }

        final totalWithGenre = genreStats.values.fold(0, (a, b) => a + b);
        final moviesWithoutGenre = movies.length - totalWithGenre;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Total Movies',
                      movies.length.toString(),
                      Icons.movie,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Favorites',
                      favoriteMovies.length.toString(),
                      Icons.favorite,
                      Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'With Genre',
                      totalWithGenre.toString(),
                      Icons.category,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Without Genre',
                      moviesWithoutGenre.toString(),
                      Icons.help_outline,
                      Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Genre Breakdown
              Text(
                'Genre Distribution',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              if (genreStats.isNotEmpty) ...[
                ...genreStats.entries.map((entry) {
                  final percentage = (entry.value / totalWithGenre * 100);
                  return _buildGenreBar(
                    context,
                    entry.key,
                    entry.value,
                    percentage,
                  );
                }).toList(),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('No genre data available')),
                ),
              ],

              const SizedBox(height: 24),

              // Recent Activity
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              ...movies.take(5).map((movie) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        movie.isFavorite ? Icons.favorite : Icons.movie,
                        color: movie.isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (movie.genre != null)
                              Text(
                                movie.genre!.displayName,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        _formatDate(movie.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGenreBar(
    BuildContext context,
    MovieGenre genre,
    int count,
    double percentage,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                genre.displayName,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '$count (${percentage.toStringAsFixed(1)}%)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(_getGenreColor(genre)),
          ),
        ],
      ),
    );
  }

  Color _getGenreColor(MovieGenre genre) {
    switch (genre) {
      case MovieGenre.action:
        return Colors.red;
      case MovieGenre.adventure:
        return Colors.orange;
      case MovieGenre.animation:
        return Colors.purple;
      case MovieGenre.comedy:
        return Colors.yellow.shade700;
      case MovieGenre.crime:
        return Colors.grey.shade700;
      case MovieGenre.documentary:
        return Colors.brown;
      case MovieGenre.drama:
        return Colors.blue;
      case MovieGenre.family:
        return Colors.green;
      case MovieGenre.fantasy:
        return Colors.deepPurple;
      case MovieGenre.history:
        return Colors.brown.shade600;
      case MovieGenre.horror:
        return Colors.black;
      case MovieGenre.music:
        return Colors.pink;
      case MovieGenre.mystery:
        return Colors.indigo;
      case MovieGenre.romance:
        return Colors.pink.shade300;
      case MovieGenre.scienceFiction:
        return Colors.cyan;
      case MovieGenre.thriller:
        return Colors.red.shade900;
      case MovieGenre.war:
        return Colors.grey.shade800;
      case MovieGenre.western:
        return Colors.amber.shade800;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
