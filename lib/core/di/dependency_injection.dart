import 'package:get_it/get_it.dart';
import 'local_storage_client.dart';
import '../../data/models/movie_model.dart';
import '../../data/datasources/movie_local_datasource.dart';
import '../../data/datasources/movie_local_datasource_impl.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/get_movies.dart';
import '../../domain/usecases/add_movie.dart';
import '../../domain/usecases/delete_movie.dart';
import '../../domain/usecases/toggle_favorite.dart';
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

    // Initialize local storage
    await getIt<LocalStorageClient>().init();

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
    getIt.registerLazySingleton(() => DeleteMovie(getIt()));
    getIt.registerLazySingleton(() => ToggleFavorite(getIt()));
  }
}
