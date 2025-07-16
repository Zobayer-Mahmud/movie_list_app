import 'package:hive/hive.dart';

part 'tmdb_movie_model.g.dart';

@HiveType(typeId: 12)
class TMDBMovie extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String? posterPath;

  @HiveField(4)
  final String? backdropPath;

  @HiveField(5)
  final DateTime releaseDate;

  @HiveField(6)
  final double voteAverage;

  @HiveField(7)
  final int voteCount;

  @HiveField(8)
  final List<int> genreIds;

  @HiveField(9)
  final bool adult;

  @HiveField(10)
  final String originalLanguage;

  @HiveField(11)
  final String originalTitle;

  @HiveField(12)
  final double popularity;

  @HiveField(13)
  final bool video;

  TMDBMovie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.video,
  });

  factory TMDBMovie.fromJson(Map<String, dynamic> json) {
    return TMDBMovie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate:
          DateTime.tryParse(json['release_date'] ?? '') ?? DateTime.now(),
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      video: json['video'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate.toIso8601String().split('T')[0],
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
      'adult': adult,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'popularity': popularity,
      'video': video,
    };
  }

  String get fullPosterUrl {
    if (posterPath == null) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get fullBackdropUrl {
    if (backdropPath == null) return '';
    return 'https://image.tmdb.org/t/p/w780$backdropPath';
  }
}
