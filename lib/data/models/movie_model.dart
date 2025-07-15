import 'package:hive/hive.dart';
import '../../domain/entities/movie.dart';
import '../../core/constants/app_enums.dart';

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

  @HiveField(4)
  final DateTime modelCreatedAt;

  @HiveField(5)
  final String? modelGenre;

  @HiveField(6)
  final String? modelImagePath;

  @HiveField(7)
  final double modelRating;

  @HiveField(8)
  final int? modelReleaseYear;

  @HiveField(9)
  final bool modelIsWatched;

  MovieModel({
    required this.modelId,
    required this.modelTitle,
    required this.modelDescription,
    required this.modelIsFavorite,
    required this.modelCreatedAt,
    this.modelGenre,
    this.modelImagePath,
    this.modelRating = 0.0,
    this.modelReleaseYear,
    this.modelIsWatched = false,
  }) : super(
         id: modelId,
         title: modelTitle,
         description: modelDescription,
         isFavorite: modelIsFavorite,
         genre: MovieGenre.fromString(modelGenre),
         imagePath: modelImagePath,
         rating: modelRating,
         releaseYear: modelReleaseYear,
         isWatched: modelIsWatched,
         createdAt: modelCreatedAt,
       );

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      modelId: movie.id,
      modelTitle: movie.title,
      modelDescription: movie.description,
      modelIsFavorite: movie.isFavorite,
      modelCreatedAt: movie.createdAt,
      modelGenre: movie.genre?.name,
      modelImagePath: movie.imagePath,
    );
  }

  Movie toEntity() {
    return Movie(
      id: modelId,
      title: modelTitle,
      description: modelDescription,
      isFavorite: modelIsFavorite,
      genre: MovieGenre.fromString(modelGenre),
      imagePath: modelImagePath,
      createdAt: modelCreatedAt,
    );
  }

  @override
  MovieModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
    MovieGenre? genre,
    String? imagePath,
    DateTime? createdAt,
    double? rating,
    int? releaseYear,
    bool? isWatched,
  }) {
    return MovieModel(
      modelId: id ?? modelId,
      modelTitle: title ?? modelTitle,
      modelDescription: description ?? modelDescription,
      modelIsFavorite: isFavorite ?? modelIsFavorite,
      modelCreatedAt: createdAt ?? modelCreatedAt,
      modelGenre: genre?.name ?? modelGenre,
      modelImagePath: imagePath ?? modelImagePath,
      modelRating: rating ?? modelRating,
      modelReleaseYear: releaseYear ?? modelReleaseYear,
      modelIsWatched: isWatched ?? modelIsWatched,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': modelId,
      'title': modelTitle,
      'description': modelDescription,
      'isFavorite': modelIsFavorite,
      'genre': modelGenre,
      'imagePath': modelImagePath,
      'createdAt': modelCreatedAt.toIso8601String(),
      'rating': modelRating,
      'releaseYear': modelReleaseYear,
      'isWatched': modelIsWatched,
    };
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      modelId: json['id'],
      modelTitle: json['title'],
      modelDescription: json['description'],
      modelIsFavorite: json['isFavorite'],
      modelGenre: json['genre'],
      modelImagePath: json['imagePath'],
      modelCreatedAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      modelRating: json['rating']?.toDouble() ?? 0.0,
      modelReleaseYear: json['releaseYear'],
      modelIsWatched: json['isWatched'] ?? false,
    );
  }
}
