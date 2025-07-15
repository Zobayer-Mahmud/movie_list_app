import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/di/dependency_injection.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_themes.dart';
import 'core/constants/app_routes.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/pages/movie_list_page.dart';
import 'presentation/pages/favorites_page.dart';
import 'presentation/pages/statistics_page.dart';
import 'presentation/pages/search_page.dart';
import 'presentation/pages/settings_page.dart';
import 'presentation/pages/add_movie_page.dart';
import 'presentation/pages/movie_details_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await DependencyInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: AppConstants.appName,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeController.themeMode,
      initialRoute: '/movies',
      getPages: [
        GetPage(name: '/movies', page: () => const MovieListPage()),
        GetPage(name: '/favorites', page: () => const FavoritesPage()),
        GetPage(name: '/statistics', page: () => const StatisticsPage()),
        GetPage(name: '/search', page: () => const SearchPage()),
        GetPage(name: '/settings', page: () => const SettingsPage()),
        GetPage(name: '/add-movie', page: () => const AddMoviePage()),
        GetPage(
          name: '/movie-details',
          page: () => MovieDetailsPage(movie: Get.arguments),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
