import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tmdb_controller.dart';
import '../widgets/tmdb_movie_card.dart';
import '../widgets/theme_toggle_button.dart';

class TMDBSearchPage extends StatefulWidget {
  const TMDBSearchPage({super.key});

  @override
  State<TMDBSearchPage> createState() => _TMDBSearchPageState();
}

class _TMDBSearchPageState extends State<TMDBSearchPage> {
  final TMDBController controller = Get.find<TMDBController>();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus search field when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });

    // Set initial value if there's an existing search
    searchController.text = controller.searchQuery.value;
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
        actions: [const ThemeToggleButton()],
      ),
      body: Column(
        children: [
          // Enhanced search bar
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search for movies, actors, directors...',
                prefixIcon: Obx(
                  () => controller.isLoadingSearch.value
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : const Icon(Icons.search),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    controller.clearSearch();
                    searchFocusNode.requestFocus();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              textInputAction: TextInputAction.search,
              onChanged: (query) {
                controller.onSearchChanged(query);
              },
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  controller.onSearchChanged(query);
                }
              },
            ),
          ),

          // Search results section
          Expanded(child: Obx(() => _buildSearchContent())),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    // Show initial search prompt
    if (!controller.hasSearched.value && controller.searchQuery.value.isEmpty) {
      return _buildSearchPrompt();
    }

    // Show loading state
    if (controller.isLoadingSearch.value && controller.searchResults.isEmpty) {
      return _buildLoadingState();
    }

    // Show error state
    if (controller.searchError.value.isNotEmpty) {
      return _buildErrorState();
    }

    // Show empty results
    if (controller.hasSearched.value && controller.searchResults.isEmpty) {
      return _buildEmptyResults();
    }

    // Show search results
    return _buildSearchResults();
  }

  Widget _buildSearchPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Discover Amazing Movies',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search for movies, actors, or directors\nfrom The Movie Database',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Search suggestions
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestionChip('Avengers'),
              _buildSuggestionChip('Inception'),
              _buildSuggestionChip('The Dark Knight'),
              _buildSuggestionChip('Interstellar'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion) {
    return ActionChip(
      label: Text(suggestion),
      onPressed: () {
        searchController.text = suggestion;
        controller.onSearchChanged(suggestion);
      },
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Searching movies...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.searchError.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonalIcon(
            onPressed: () {
              if (controller.searchQuery.value.isNotEmpty) {
                controller.onSearchChanged(controller.searchQuery.value);
              }
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No movies found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'No movies found for "${controller.searchQuery.value}"\nTry different keywords or check spelling',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${controller.searchResults.length} result${controller.searchResults.length == 1 ? '' : 's'} for "${controller.searchQuery.value}"',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),

        // Results grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final movie = controller.searchResults[index];
              return TMDBMovieCard(
                movie: movie,
                onTap: () => Get.toNamed('/tmdb-details', arguments: movie),
                onAddToList: () => _showAddToListDialog(context, movie),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddToListDialog(BuildContext context, movie) {
    Get.dialog(
      AlertDialog(
        title: const Text('Add to Your List'),
        content: Text('Add "${movie.title}" to your personal movie list?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              _addMovieToPersonalList(movie);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addMovieToPersonalList(movie) {
    // TODO: Convert TMDB movie to local movie format and add to personal list
    Get.snackbar(
      'Feature Coming Soon',
      'Adding TMDB movies to personal list will be implemented soon!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      colorText: Get.theme.colorScheme.primary,
    );
  }
}
