import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../controllers/theme_controller.dart';
import '../../core/constants/app_constants.dart';

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
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to delete all movies?\n\nThis action cannot be undone and will remove all your movies and their images.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              // Clear all movies (this would need to be implemented in the controller)
              Get.snackbar(
                'Feature Coming Soon',
                'Clear all data functionality will be added in a future update',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
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
}
