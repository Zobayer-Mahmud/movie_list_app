import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  const Movie({
    required this.id,
    required this.title,
    required this.description,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object> get props => [id, title, description, isFavorite];
}
