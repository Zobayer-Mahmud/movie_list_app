import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/movie.dart';
import '../widgets/star_rating.dart';
import '../widgets/watch_status.dart';
import '../widgets/genre_badge.dart';
import '../controllers/movie_controller.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movieController = Get.find<MovieController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    tooltip: 'Go back',
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildMoviePoster(context),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: IconButton(
                      onPressed: () => movieController.toggleFavorite(movie.id),
                      icon: Obx(() {
                        final currentMovie = movieController.movies
                            .firstWhereOrNull((m) => m.id == movie.id);
                        return Icon(
                          currentMovie?.isFavorite ?? movie.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: currentMovie?.isFavorite ?? movie.isFavorite
                              ? Colors.red
                              : Colors.white,
                          size: 24,
                        );
                      }),
                      padding: EdgeInsets.zero,
                      splashRadius: 20,
                      tooltip: 'Toggle favorite',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Year
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (movie.releaseYear != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${movie.releaseYear}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Rating and Watch Status Row
                  Row(
                    children: [
                      if (movie.rating > 0) ...[
                        StarRating(rating: movie.rating, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          '${movie.rating.toStringAsFixed(1)}/5.0',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Obx(() {
                        final currentMovie = movieController.movies
                            .firstWhereOrNull((m) => m.id == movie.id);
                        final isWatched =
                            currentMovie?.isWatched ?? movie.isWatched;

                        return WatchStatusBadge(
                          isWatched: isWatched,
                          showText: true,
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Genre
                  if (movie.genre != null) ...[
                    Text(
                      'Genre',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GenreBadge(genre: movie.genre!),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),

                  const SizedBox(height: 32),

                  // Movie Info Cards
                  _buildInfoCards(context, movie),

                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButtons(context, movie, movieController),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviePoster(BuildContext context) {
    if (movie.imagePath != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(movie.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderPoster(context);
            },
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return _buildPlaceholderPoster(context);
  }

  Widget _buildPlaceholderPoster(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.movie,
          size: 80,
          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context, Movie movie) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            'Added',
            _formatDate(movie.createdAt),
            Icons.calendar_today,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            context,
            'Status',
            movie.isWatched ? 'Watched' : 'To Watch',
            movie.isWatched ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    Movie movie,
    MovieController controller,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Obx(() {
            final currentMovie = controller.movies.firstWhereOrNull(
              (m) => m.id == movie.id,
            );
            final isWatched = currentMovie?.isWatched ?? movie.isWatched;

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: isWatched
                      ? [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.8),
                        ]
                      : [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.8),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isWatched
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary)
                            .withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.toggleWatchStatus(movie.id);
                },
                icon: Icon(
                  isWatched ? Icons.visibility_off : Icons.visibility,
                  size: 24,
                ),
                label: Text(
                  isWatched ? 'Mark as Unwatched' : 'Mark as Watched',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Get.toNamed('/edit-movie', arguments: movie);
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Movie'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
