import 'tmdb_movie_model.dart';

class TMDBMovieResponse {
  final int page;
  final List<TMDBMovie> results;
  final int totalPages;
  final int totalResults;

  TMDBMovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TMDBMovieResponse.fromJson(Map<String, dynamic> json) {
    return TMDBMovieResponse(
      page: json['page'] ?? 1,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((movie) => TMDBMovie.fromJson(movie))
              .toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': results.map((movie) => movie.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}
