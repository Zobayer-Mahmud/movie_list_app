import 'package:equatable/equatable.dart';
import '../../core/constants/app_enums.dart';

class Movie extends Equatable {
  Movie({
    required this.id,
    required this.title,
    required this.description,
    this.isFavorite = false,
    this.genre,
    this.imagePath,
    this.rating = 0.0,
    this.releaseYear,
    this.isWatched = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String title;
  final String description;
  final bool isFavorite;
  final MovieGenre? genre;
  final String? imagePath;
  final double rating; // 0.0 to 5.0 stars
  final int? releaseYear;
  final bool isWatched;
  final DateTime createdAt;

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
    MovieGenre? genre,
    String? imagePath,
    double? rating,
    int? releaseYear,
    bool? isWatched,
    DateTime? createdAt,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      genre: genre ?? this.genre,
      imagePath: imagePath ?? this.imagePath,
      rating: rating ?? this.rating,
      releaseYear: releaseYear ?? this.releaseYear,
      isWatched: isWatched ?? this.isWatched,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isFavorite,
    genre,
    imagePath,
    rating,
    releaseYear,
    isWatched,
    createdAt,
  ];
}
