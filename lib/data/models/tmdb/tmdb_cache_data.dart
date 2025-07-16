import 'package:hive/hive.dart';
import '../tmdb_movie_model.dart';
import '../tmdb_cast_model.dart';
import '../tmdb_video_model.dart';

part 'tmdb_cache_data.g.dart';

@HiveType(typeId: 10)
class TMDBCacheData extends HiveObject {
  @HiveField(0)
  String cacheKey;

  @HiveField(1)
  List<TMDBMovie> movies;

  @HiveField(2)
  DateTime cachedAt;

  @HiveField(3)
  Duration cacheExpiry;

  TMDBCacheData({
    required this.cacheKey,
    required this.movies,
    required this.cachedAt,
    required this.cacheExpiry,
  });

  bool get isExpired => DateTime.now().isAfter(cachedAt.add(cacheExpiry));

  bool get isValid => !isExpired;
}

@HiveType(typeId: 11)
class TMDBMovieDetailsCache extends HiveObject {
  @HiveField(0)
  int movieId;

  @HiveField(1)
  TMDBMovie movieDetails;

  @HiveField(2)
  List<TMDBCast> cast;

  @HiveField(3)
  List<TMDBVideo> videos;

  @HiveField(4)
  DateTime cachedAt;

  @HiveField(5)
  Duration cacheExpiry;

  TMDBMovieDetailsCache({
    required this.movieId,
    required this.movieDetails,
    required this.cast,
    required this.videos,
    required this.cachedAt,
    required this.cacheExpiry,
  });

  bool get isExpired => DateTime.now().isAfter(cachedAt.add(cacheExpiry));

  bool get isValid => !isExpired;
}
