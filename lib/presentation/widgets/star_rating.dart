import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double maxRating;
  final double size;
  final Color? color;
  final bool isInteractive;
  final ValueChanged<double>? onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5.0,
    this.size = 24.0,
    this.color,
    this.isInteractive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating.round(), (index) {
        return GestureDetector(
          onTap: isInteractive
              ? () {
                  final newRating = (index + 1).toDouble();
                  onRatingChanged?.call(newRating);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: _buildStar(index, effectiveColor),
          ),
        );
      }),
    );
  }

  Widget _buildStar(int index, Color color) {
    final starValue = index + 1;

    if (rating >= starValue) {
      // Full star
      return Icon(Icons.star, size: size, color: color);
    } else if (rating > starValue - 1) {
      // Half star
      return Stack(
        children: [
          Icon(Icons.star_border, size: size, color: color),
          ClipRect(
            clipper: _HalfStarClipper(rating - (starValue - 1)),
            child: Icon(Icons.star, size: size, color: color),
          ),
        ],
      );
    } else {
      // Empty star
      return Icon(Icons.star_border, size: size, color: color.withOpacity(0.4));
    }
  }
}

class _HalfStarClipper extends CustomClipper<Rect> {
  final double fraction;

  _HalfStarClipper(this.fraction);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fraction, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return oldClipper is _HalfStarClipper && oldClipper.fraction != fraction;
  }
}

class InteractiveStarRating extends StatefulWidget {
  final double initialRating;
  final double maxRating;
  final double size;
  final Color? color;
  final ValueChanged<double>? onRatingChanged;
  final String? label;

  const InteractiveStarRating({
    super.key,
    this.initialRating = 0.0,
    this.maxRating = 5.0,
    this.size = 32.0,
    this.color,
    this.onRatingChanged,
    this.label,
  });

  @override
  State<InteractiveStarRating> createState() => _InteractiveStarRatingState();
}

class _InteractiveStarRatingState extends State<InteractiveStarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StarRating(
              rating: _currentRating,
              maxRating: widget.maxRating,
              size: widget.size,
              color: widget.color,
              isInteractive: true,
              onRatingChanged: (rating) {
                setState(() {
                  _currentRating = rating;
                });
                widget.onRatingChanged?.call(rating);
              },
            ),
            const SizedBox(width: 8),
            Text(
              _currentRating.toStringAsFixed(1),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
