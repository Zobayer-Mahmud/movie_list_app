import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/tmdb_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../data/services/tmdb_cache_service.dart';
import '../../core/di/dependency_injection.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final movieController = Get.find<MovieController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          _buildSectionHeader(context, 'Appearance'),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.palette,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Theme Preference',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Choose your preferred appearance',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Row(
                      children: [
                        // Light Theme Option
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (themeController.isDarkMode) {
                                themeController.toggleTheme();
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: !themeController.isDarkMode
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: !themeController.isDarkMode
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.outline,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.light_mode,
                                    size: 32,
                                    color: !themeController.isDarkMode
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Light',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: !themeController.isDarkMode
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Dark Theme Option
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!themeController.isDarkMode) {
                                themeController.toggleTheme();
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: themeController.isDarkMode
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.outline,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.dark_mode,
                                    size: 32,
                                    color: themeController.isDarkMode
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Dark',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: themeController.isDarkMode
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Row(
                      children: [
                        Icon(
                          themeController.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          themeController.isDarkMode
                              ? 'Dark theme is active'
                              : 'Light theme is active',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Data Management Section
          _buildSectionHeader(context, 'Data Management'),
          Card(
            child: Column(
              children: [
                Obx(
                  () => ListTile(
                    leading: const Icon(Icons.movie),
                    title: const Text('Total Movies'),
                    subtitle: Text(
                      '${movieController.movies.length} movies in your collection',
                    ),
                    trailing: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Obx(
                  () => ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text('Favorite Movies'),
                    subtitle: Text(
                      '${movieController.favoriteMovies.length} favorites',
                    ),
                    trailing: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh Data'),
                  subtitle: const Text('Reload all movies from storage'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    movieController.loadMovies();
                    Get.snackbar(
                      'Success',
                      'Movies refreshed successfully',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_sweep, color: Colors.red),
                  title: const Text('Clear All Data'),
                  subtitle: const Text('Delete all movies (cannot be undone)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showClearDataDialog(context, movieController),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Storage Section
          _buildSectionHeader(context, 'Storage'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Storage Location'),
                  subtitle: const Text('Local device storage'),
                  trailing: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Movie Images'),
                  subtitle: const Text('Stored in app documents folder'),
                  trailing: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Divider(height: 1),
                _buildCacheManagementTile(context),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                  trailing: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Built with Flutter'),
                  subtitle: const Text('Cross-platform movie management'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showAboutDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Rate this App'),
                  subtitle: const Text('Help us improve by leaving a review'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.snackbar(
                      'Thank You!',
                      'Rating feature coming soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Footer
          Center(
            child: Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Made with ❤️ using Flutter',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, MovieController controller) {
    final confirmationController = TextEditingController();
    final canDelete = false.obs;
    final tmdbController = Get.find<TMDBController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This will permanently delete:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Personal Data Section
              Obx(
                () => Row(
                  children: [
                    const Icon(Icons.movie, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${controller.movies.length} movies and their data',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    const Icon(Icons.favorite, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${controller.favoriteMovies.length} favorite movies',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.image, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(child: Text('All uploaded movie images')),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),

              // TMDB Cache Section
              const Text(
                'TMDB Cached Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    const Icon(Icons.trending_up, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${tmdbController.popularMovies.length} popular movies',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 20,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${tmdbController.trendingMovies.length} trending movies',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Row(
                  children: [
                    const Icon(Icons.star, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${tmdbController.topRatedMovies.length} top rated movies',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Row(
                  children: [
                    const Icon(Icons.upcoming, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${tmdbController.upcomingMovies.length} upcoming movies',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Type "DELETE" to confirm:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmationController,
                decoration: const InputDecoration(
                  hintText: 'Type DELETE here',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  canDelete.value = value.toUpperCase() == 'DELETE';
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              confirmationController.dispose();
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          Obx(
            () => TextButton(
              onPressed: canDelete.value
                  ? () {
                      confirmationController.dispose();
                      Get.back();
                      _clearAllData(controller);
                    }
                  : null,
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete Everything'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData(MovieController movieController) async {
    try {
      // Show loading dialog
      Get.dialog(
        const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Clearing all data...'),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      // Clear personal movie data
      await movieController.clearAllMovies();

      // Clear TMDB cache
      final cacheService = getIt<TMDBCacheService>();
      await cacheService.clearAllCache();

      // Clear TMDB controller data in memory
      final tmdbController = Get.find<TMDBController>();
      tmdbController.popularMovies.clear();
      tmdbController.trendingMovies.clear();
      tmdbController.topRatedMovies.clear();
      tmdbController.upcomingMovies.clear();
      tmdbController.searchResults.clear();
      tmdbController.movieCast.clear();
      tmdbController.movieVideos.clear();

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'All data cleared successfully. The app will restart with fresh data.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Optionally restart data loading
      Future.delayed(const Duration(seconds: 1), () {
        tmdbController.refreshAllData();
      });
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Failed to clear all data: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.movie, size: 48),
      children: [
        const Text(
          'A beautiful and feature-rich movie management app built with Flutter.',
        ),
        const SizedBox(height: 16),
        const Text('Features:'),
        const Text('• Add and manage your movie collection'),
        const Text('• Upload movie posters'),
        const Text('• Categorize by genres'),
        const Text('• Mark favorites'),
        const Text('• Search and filter'),
        const Text('• View statistics'),
        const Text('• Dark/Light theme support'),
      ],
    );
  }

  Widget _buildCacheManagementTile(BuildContext context) {
    final tmdbController = Get.find<TMDBController>();
    final cacheService = getIt<TMDBCacheService>();

    return ExpansionTile(
      leading: const Icon(Icons.cached),
      title: const Text('TMDB Cache'),
      subtitle: Obx(
        () => Text(
          tmdbController.isOnline.value
              ? 'Online - Cache enabled'
              : 'Offline - Using cached data',
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cache helps load movie data faster and enables offline viewing.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Cache Status
              FutureBuilder<Map<String, dynamic>>(
                future: _getCacheStatus(cacheService),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final cacheStatus = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cache Status:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      _buildCacheStatusItem(
                        'Popular Movies',
                        cacheStatus['popularMovies'],
                      ),
                      _buildCacheStatusItem(
                        'Trending Movies',
                        cacheStatus['trendingMovies'],
                      ),
                      _buildCacheStatusItem(
                        'Top Rated Movies',
                        cacheStatus['topRatedMovies'],
                      ),
                      _buildCacheStatusItem(
                        'Upcoming Movies',
                        cacheStatus['upcomingMovies'],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Movie Details Cache: ${cacheStatus['totalDetailsCache']} items',
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              // Cache Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _refreshCache(tmdbController),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh Cache'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _clearCache(cacheService),
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear Cache'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCacheStatusItem(String title, Map<String, dynamic> status) {
    final isCached = status['cached'] as bool;
    final count = status['count'] as int;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isCached ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isCached ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text('$title: ${isCached ? '$count items' : 'Not cached'}'),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _getCacheStatus(
    TMDBCacheService cacheService,
  ) async {
    return cacheService.getCacheStatus();
  }

  Future<void> _refreshCache(TMDBController tmdbController) async {
    try {
      await tmdbController.refreshAllData();
      Get.snackbar(
        'Success',
        'Cache refreshed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh cache: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _clearCache(TMDBCacheService cacheService) async {
    try {
      await cacheService.clearAllCache();
      Get.snackbar(
        'Success',
        'Cache cleared successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear cache: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
