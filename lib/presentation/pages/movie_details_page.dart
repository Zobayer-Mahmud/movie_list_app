import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/movie.dart';
import '../widgets/star_rating.dart';
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
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Classic App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.onSurface,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
                tooltip: 'Go back',
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero Image
                  _buildClassicHeroSection(context),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          theme.colorScheme.surface.withOpacity(0.8),
                          theme.colorScheme.surface,
                        ],
                        stops: const [0.0, 0.4, 0.8, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(() {
                  final currentMovie = movieController.movies.firstWhereOrNull(
                    (m) => m.id == movie.id,
                  );
                  final isFavorite =
                      currentMovie?.isFavorite ?? movie.isFavorite;
                  return IconButton(
                    onPressed: () => movieController.toggleFavorite(movie.id),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? Colors.red
                          : theme.colorScheme.onSurface,
                      size: 24,
                    ),
                    tooltip: 'Toggle favorite',
                  );
                }),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => Get.toNamed('/edit-movie', arguments: movie),
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.onSurface,
                    size: 22,
                  ),
                  tooltip: 'Edit movie',
                ),
              ),
            ],
          ),

          // Classic Content Section
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Classic Title Section
                    _buildClassicTitleSection(context),

                    const SizedBox(height: 24),

                    // Movie Stats Row
                    _buildMovieStatsRow(context),

                    const SizedBox(height: 32),

                    // Description Section
                    _buildDescriptionSection(context),

                    const SizedBox(height: 32),

                    // Action Buttons
                    _buildActionButtons(context, movieController),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassicHeroSection(BuildContext context) {
    if (movie.imagePath != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(movie.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderHero(context);
            },
          ),
          // Subtle overlay for classic look
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return _buildPlaceholderHero(context);
  }

  Widget _buildPlaceholderHero(BuildContext context) {
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
          size: 100,
          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildClassicTitleSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Movie Title
        Text(
          movie.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        // Release Year
        if (movie.releaseYear != null) ...[
          Text(
            '${movie.releaseYear}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Genre
        if (movie.genre != null) ...[
          GenreBadge(genre: movie.genre!),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildMovieStatsRow(BuildContext context) {
    final theme = Theme.of(context);
    final movieController = Get.find<MovieController>();

    return Row(
      children: [
        // Rating
        if (movie.rating > 0) ...[
          StarRating(rating: movie.rating, size: 20),
          const SizedBox(width: 8),
          Text(
            '${movie.rating.toStringAsFixed(1)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 20,
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
          const SizedBox(width: 16),
        ],

        // Watch Status
        Obx(() {
          final currentMovie = movieController.movies.firstWhereOrNull(
            (m) => m.id == movie.id,
          );
          final isWatched = currentMovie?.isWatched ?? movie.isWatched;

          return Row(
            children: [
              Icon(
                isWatched ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: isWatched
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                isWatched ? 'Watched' : 'To Watch',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isWatched
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        }),

        const Spacer(),

        // Added Date
        Text(
          _formatDate(movie.createdAt),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          movie.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, MovieController controller) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Watch Status Button
        SizedBox(
          width: double.infinity,
          child: Obx(() {
            final currentMovie = controller.movies.firstWhereOrNull(
              (m) => m.id == movie.id,
            );
            final isWatched = currentMovie?.isWatched ?? movie.isWatched;

            return ElevatedButton.icon(
              onPressed: () => controller.toggleWatchStatus(movie.id),
              icon: Icon(
                isWatched ? Icons.visibility_off : Icons.visibility,
                size: 20,
              ),
              label: Text(
                isWatched ? 'Mark as Unwatched' : 'Mark as Watched',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isWatched
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.primary,
                foregroundColor: isWatched
                    ? theme.colorScheme.onSecondary
                    : theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            );
          }),
        ),

        const SizedBox(height: 12),

        // Edit Button
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton.icon(
        //     onPressed: () => Get.toNamed('/edit-movie', arguments: movie),
        //     icon: const Icon(Icons.edit_outlined, size: 20),
        //     label: const Text(
        //       'Edit Movie',
        //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        //     ),
        //     style: OutlinedButton.styleFrom(
        //       padding: const EdgeInsets.symmetric(vertical: 16),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       side: BorderSide(color: theme.colorScheme.outline, width: 1.5),
        //     ),
        //   ),
        // ),
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
