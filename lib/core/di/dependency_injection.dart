import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import 'local_storage_client.dart';
import '../network/dio_client.dart';
import '../../data/models/movie_model.dart';
import '../../data/datasources/movie_local_datasource.dart';
import '../../data/datasources/movie_local_datasource_impl.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/get_movies.dart';
import '../../domain/usecases/add_movie.dart';
import '../../domain/usecases/update_movie.dart';
import '../../domain/usecases/delete_movie.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/usecases/toggle_watch_status.dart';
import '../../presentation/controllers/theme_controller.dart';
import '../../presentation/controllers/movie_controller.dart';
import '../../presentation/controllers/navigation_controller.dart';
import '../../presentation/controllers/tmdb_controller.dart';
import '../../presentation/controllers/search_controller.dart'
    as search_controller;
import '../../data/services/tmdb_cache_service.dart';
import '../../data/models/tmdb_movie_model.dart';
import '../../data/models/tmdb_cast_model.dart';
import '../../data/models/tmdb_video_model.dart';
import '../../data/models/tmdb/tmdb_cache_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GetIt getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // Core
    getIt.registerLazySingleton<LocalStorageClient>(
      () => HiveLocalStorageClient(),
    );

    // Register Hive adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MovieModelAdapter());
    }

    // Register TMDB cache adapters
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(TMDBCacheDataAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(TMDBMovieDetailsCacheAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(TMDBMovieAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(TMDBCastAdapter());
    }
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(TMDBVideoAdapter());
    }

    // Initialize local storage
    await getIt<LocalStorageClient>().init();

    // Initialize TMDB cache service
    final cacheService = TMDBCacheService();
    await cacheService.init();
    getIt.registerSingleton<TMDBCacheService>(cacheService);

    // Data sources
    getIt.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(getIt()),
    );

    // Repositories
    getIt.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(getIt()),
    );

    // Use cases
    getIt.registerLazySingleton(() => GetMovies(getIt()));
    getIt.registerLazySingleton(() => AddMovie(getIt()));
    getIt.registerLazySingleton(() => UpdateMovie(getIt()));
    getIt.registerLazySingleton(() => DeleteMovie(getIt()));
    getIt.registerLazySingleton(() => ToggleFavorite(getIt()));
    getIt.registerLazySingleton(() => ToggleWatchStatus(getIt()));

    // Initialize theme controller
    Get.put(ThemeController());

    // Initialize navigation controller
    Get.put(NavigationController());

    // Initialize movie controller first
    Get.put(MovieController());

    // Initialize search controller after movie controller is ready
    Get.put(search_controller.SearchController());

    // Register Dio client
    await Get.putAsync(() => DioClient().init());

    // Register TMDB controller
    Get.put(TMDBController());
  }
}
