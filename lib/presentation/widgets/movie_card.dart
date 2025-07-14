import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onFavoriteToggle,
    required this.onDelete,
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: movie.isFavorite ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                    tooltip: movie.isFavorite
                        ? 'Remove from favorites'
                        : 'Add to favorites',
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    tooltip: 'Delete movie',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                movie.description,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
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
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );
  }
}
