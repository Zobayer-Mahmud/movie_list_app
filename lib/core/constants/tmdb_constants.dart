class TMDBConstants {
  // Public TMDB API Configuration
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String originalImageBaseUrl = 'https://image.tmdb.org/t/p/original';
  
  // Image sizes
  static const String posterSizeW185 = 'https://image.tmdb.org/t/p/w185';
  static const String posterSizeW342 = 'https://image.tmdb.org/t/p/w342';
  static const String posterSizeW500 = 'https://image.tmdb.org/t/p/w500';
  static const String posterSizeW780 = 'https://image.tmdb.org/t/p/w780';
  
  // Backdrop sizes
  static const String backdropSizeW300 = 'https://image.tmdb.org/t/p/w300';
  static const String backdropSizeW780 = 'https://image.tmdb.org/t/p/w780';
  static const String backdropSizeW1280 = 'https://image.tmdb.org/t/p/w1280';
  
  // API Endpoints
  static const String popularMoviesEndpoint = '/movie/popular';
  static const String topRatedMoviesEndpoint = '/movie/top_rated';
  static const String upcomingMoviesEndpoint = '/movie/upcoming';
  static const String trendingMoviesEndpoint = '/trending/movie/week';
  static const String searchMoviesEndpoint = '/search/movie';
  static const String movieDetailsEndpoint = '/movie';
}
