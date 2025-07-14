import 'package:hive/hive.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class MovieModel extends Movie {
  @HiveField(0)
  final String modelId;
  
  @HiveField(1)
  final String modelTitle;
  
  @HiveField(2)
  final String modelDescription;
  
  @HiveField(3)
  final bool modelIsFavorite;

  const MovieModel({
    required this.modelId,
    required this.modelTitle,
    required this.modelDescription,
    required this.modelIsFavorite,
  }) : super(
          id: modelId,
          title: modelTitle,
          description: modelDescription,
          isFavorite: modelIsFavorite,
        );

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      modelId: movie.id,
      modelTitle: movie.title,
      modelDescription: movie.description,
      modelIsFavorite: movie.isFavorite,
    );
  }

  Movie toEntity() {
    return Movie(
      id: modelId,
      title: modelTitle,
      description: modelDescription,
      isFavorite: modelIsFavorite,
    );
  }

  @override
  MovieModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
  }) {
    return MovieModel(
      modelId: id ?? modelId,
      modelTitle: title ?? modelTitle,
      modelDescription: description ?? modelDescription,
      modelIsFavorite: isFavorite ?? modelIsFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': modelId,
      'title': modelTitle,
      'description': modelDescription,
      'isFavorite': modelIsFavorite,
    };
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      modelId: json['id'],
      modelTitle: json['title'],
      modelDescription: json['description'],
      modelIsFavorite: json['isFavorite'],
    );
  }
}
