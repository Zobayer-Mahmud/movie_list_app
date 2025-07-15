import 'package:flutter/material.dart';
import '../../core/constants/app_enums.dart';

class GenreBadge extends StatelessWidget {
  final MovieGenre genre;
  final double? fontSize;
  final EdgeInsets? padding;

  const GenreBadge({
    super.key,
    required this.genre,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getGenreColor(genre, context).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getGenreColor(genre, context).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getGenreColor(genre, context),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            genre.displayName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getGenreColor(genre, context),
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGenreColor(MovieGenre genre, BuildContext context) {
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
}
