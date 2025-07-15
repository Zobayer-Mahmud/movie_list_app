import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import 'genre_badge.dart';
import 'star_rating.dart';
import 'watch_status.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onFavoriteToggle,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Dismissible(
        key: Key(movie.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 28),
        ),
        confirmDismiss: (direction) async {
          return await _showDeleteConfirmation(context);
        },
        onDismissed: (direction) => onDelete(),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie poster/image
                  if (movie.imagePath != null)
                    Container(
                      width: 80,
                      height: 120,
                      margin: const EdgeInsets.only(right: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(movie.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 80,
                      height: 120,
                      margin: const EdgeInsets.only(right: 16),
                      child: _buildPlaceholderImage(),
                    ),

                  // Movie details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                movie.title,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: onFavoriteToggle,
                              icon: Icon(
                                movie.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: movie.isFavorite
                                    ? Colors.red
                                    : Colors.grey,
                                size: 24,
                              ),
                              tooltip: movie.isFavorite
                                  ? 'Remove from favorites'
                                  : 'Add to favorites',
                            ),
                            IconButton(
                              onPressed: onDelete,
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                                size: 20,
                              ),
                              tooltip: 'Delete movie',
                            ),
                          ],
                        ),

                        // Genre badge
                        if (movie.genre != null) ...[
                          GenreBadge(genre: movie.genre!),
                          const SizedBox(height: 8),
                        ],

                        // Rating and additional info row
                        Row(
                          children: [
                            // Star rating
                            if (movie.rating > 0) ...[
                              StarRating(rating: movie.rating, size: 16),
                              const SizedBox(width: 8),
                            ],

                            // Release year
                            if (movie.releaseYear != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${movie.releaseYear}',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],

                            // Watch status badge
                            WatchStatusBadge(
                              isWatched: movie.isWatched,
                              showText: false,
                              iconSize: 12,
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          movie.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const Spacer(),

                        if (movie.isFavorite) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Text(
                              '❤️ Favorite',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.movie, size: 40, color: Colors.grey),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Movie'),
          content: Text('Are you sure you want to delete "${movie.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
