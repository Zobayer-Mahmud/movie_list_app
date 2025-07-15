import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/dependency_injection.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_themes.dart';
import 'presentation/controllers/navigation_controller.dart';
import 'presentation/pages/movie_list_page.dart';
import 'presentation/pages/favorites_page.dart';
import 'presentation/pages/statistics_page.dart';
import 'presentation/pages/search_page.dart';
import 'presentation/pages/settings_page.dart';
import 'presentation/pages/add_movie_page.dart';
import 'presentation/pages/edit_movie_page.dart';
import 'presentation/pages/movie_details_page.dart';
import 'presentation/pages/tmdb_discovery_page.dart';
import 'presentation/pages/tmdb_search_page.dart';
import 'presentation/pages/tmdb_movie_details_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (private keys only)
  try {
    await dotenv.load(fileName: ".env");
    print('✅ Environment file loaded successfully');
  } catch (e) {
    print('⚠️ .env file not found, using fallback values');
    // Initialize dotenv with fallback values for private keys
    dotenv.testLoad(
      fileInput: '''
TMDB_API_KEY=25c739ef422b1e83ae45152cafba0047
TMDB_BEARER_TOKEN=eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNWM3MzllZjQyMmIxZTgzYWU0NTE1MmNhZmJhMDA0NyIsIm5iZiI6MTc1MjYwMjQ5MC4yODksInN1YiI6IjY4NzY5NzdhODQzNzZiOGE5ODg5NjI2NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.hoxnMardhsWUqGUdJ7PFAjXBOO1RK0TsgLj8_J-2hSo
''',
    );
  }

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize dependencies
  await DependencyInjection.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system, // Use system theme initially
      home: MainNavigationPage(),
      getPages: [
        GetPage(name: '/movies', page: () => MovieListPage()),
        GetPage(name: '/favorites', page: () => FavoritesPage()),
        GetPage(name: '/statistics', page: () => StatisticsPage()),
        GetPage(name: '/search', page: () => SearchPage()),
        GetPage(name: '/settings', page: () => SettingsPage()),
        GetPage(name: '/add-movie', page: () => AddMoviePage()),
        GetPage(
          name: '/edit-movie',
          page: () => EditMoviePage(movie: Get.arguments),
        ),
        GetPage(
          name: '/movie-details',
          page: () => MovieDetailsPage(movie: Get.arguments),
        ),
        GetPage(name: '/tmdb-discovery', page: () => TMDBDiscoveryPage()),
        GetPage(name: '/tmdb-search', page: () => TMDBSearchPage()),
        GetPage(
          name: '/tmdb-details',
          page: () => TMDBMovieDetailsPage(movie: Get.arguments),
        ),
      ],
    );
  }
}

class MainNavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavigationController());

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navController.selectedIndex.value,
          children: [
            MovieListPage(),
            TMDBDiscoveryPage(), // TMDB Discovery tab
            FavoritesPage(),
            SearchPage(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navController.selectedIndex.value,
          onTap: (index) {
            navController.selectedIndex.value = index;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
