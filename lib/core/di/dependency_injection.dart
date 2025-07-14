import 'package:get_it/get_it.dart';
import 'local_storage_client.dart';

final GetIt getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // Core
    getIt.registerLazySingleton<LocalStorageClient>(
      () => HiveLocalStorageClient(),
    );

    // Initialize local storage
    await getIt<LocalStorageClient>().init();
  }
}
