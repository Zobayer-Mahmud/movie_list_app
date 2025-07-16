import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movie_controller.dart';
import '../controllers/search_controller.dart' as search_controller;
import '../widgets/theme_toggle_button.dart';
import 'add_movie_page.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage>
    with TickerProviderStateMixin {
  late AnimationController _searchAnimationController;
  late AnimationController _fabAnimationController;
  final TextEditingController _searchController = TextEditingController();
  final RxBool _isSearchExpanded = false.obs;
  final RxBool _isGridView = true.obs;

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _fabAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.put(MovieController());
    final searchController = Get.find<search_controller.SearchController>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Search
          _buildModernAppBar(context),

          // Content Section
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState();
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return _buildErrorState(controller);
              }

              if (controller.movies.isEmpty) {
                return _buildEmptyState();
              }

              return _buildMovieContent(searchController);
            }),
          ),
        ],
      ),
      floatingActionButton: _buildModernFAB(),
    );
  }

  // Modern App Bar with integrated search
  Widget _buildModernAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Theme.of(context).colorScheme.secondary.withOpacity(0.05),
              ],
            ),
          ),
        ),
        title: Obx(
          () => _isSearchExpanded.value
              ? _buildSearchField(context)
              : const Text(
                  'My Movies',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
        ),
        centerTitle: false,
      ),
      actions: [
        // Search Toggle
        Obx(
          () => IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isSearchExpanded.value ? Icons.close : Icons.search,
                key: ValueKey(_isSearchExpanded.value),
              ),
            ),
            onPressed: _toggleSearch,
          ),
        ),

        // View Toggle
        Obx(
          () => IconButton(
            icon: Icon(_isGridView.value ? Icons.view_list : Icons.grid_view),
            onPressed: () => _isGridView.value = !_isGridView.value,
          ),
        ),

        // Theme Toggle
        const ThemeToggleButton(),
        const SizedBox(width: 8),
      ],
    );
  }

  // Modern search field
  Widget _buildSearchField(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search movies...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        onChanged: (value) {
          // Implement search logic here
        },
      ),
    );
  }

  // Movie content with grid/list view
  Widget _buildMovieContent(searchController) {
    return Obx(() {
      final moviesToShow = searchController.filteredMovies;

      if (moviesToShow.isEmpty) {
        return _buildNoResultsState();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Results summary
            _buildResultsHeader(moviesToShow.length),
            const SizedBox(height: 16),

            // Movies display
            _isGridView.value
                ? _buildGridView(moviesToShow)
                : _buildListView(moviesToShow),
          ],
        ),
      );
    });
  }

  // Results header with count
  Widget _buildResultsHeader(int count) {
    return Row(
      children: [
        Icon(
          Icons.movie_filter,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '$count ${count == 1 ? 'Movie' : 'Movies'}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _isGridView.value ? 'Grid View' : 'List View',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  // Modern grid view
  Widget _buildGridView(List moviesToShow) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: moviesToShow.length,
      itemBuilder: (context, index) {
        final movie = moviesToShow[index];
        return _buildModernMovieCard(movie, isGrid: true);
      },
    );
  }

  // Modern list view
  Widget _buildListView(List moviesToShow) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: moviesToShow.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final movie = moviesToShow[index];
        return _buildModernMovieCard(movie, isGrid: false);
      },
    );
  }

  // State management methods
  void _toggleSearch() {
    _isSearchExpanded.value = !_isSearchExpanded.value;
    if (!_isSearchExpanded.value) {
      _searchController.clear();
    }
  }

  // Modern FAB with animation
  Widget _buildModernFAB() {
    return ScaleTransition(
      scale: _fabAnimationController,
      child: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddMoviePage()),
        tooltip: 'Add Movie',
        icon: const Icon(Icons.add),
        label: const Text('Add Movie'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  // State widgets
  Widget _buildLoadingState() {
    return Container(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading movies...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(MovieController controller) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: controller.loadMovies,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              size: 96,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 24),
            Text(
              'No movies yet',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Start building your movie collection by adding your first movie!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => Get.to(() => const AddMoviePage()),
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Movie'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No movies found',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search to find what you\'re looking for.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                _isSearchExpanded.value = false;
              },
              icon: const Icon(Icons.clear),
              label: const Text('Clear Search'),
            ),
          ],
        ),
      ),
    );
  }

  // Modern movie card for both grid and list views
  Widget _buildModernMovieCard(dynamic movie, {required bool isGrid}) {
    final controller = Get.find<MovieController>();

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.toNamed('/movie-details', arguments: movie),
        child: isGrid
            ? _buildGridCardContent(movie, controller)
            : _buildListCardContent(movie, controller),
      ),
    );
  }

  Widget _buildGridCardContent(dynamic movie, MovieController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Theme.of(context).colorScheme.surface.withOpacity(0.8),
          ],
          stops: const [0.6, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie poster with overlays
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Poster image
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child:
                        movie.imagePath != null && movie.imagePath!.isNotEmpty
                        ? Image.network(
                            movie.imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPosterPlaceholder(),
                          )
                        : _buildPosterPlaceholder(),
                  ),
                ),

                // Top overlay with watched status and favorite
                Positioned(
                  top: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Watched status
                      if (movie.isWatched == true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check, size: 12, color: Colors.white),
                              const SizedBox(width: 2),
                              Text(
                                'Watched',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),

                      // Favorite button
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () => controller.toggleFavorite(movie.id),
                          child: Icon(
                            movie.isFavorite == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: movie.isFavorite == true
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Rating badge
                if (movie.rating != null && movie.rating! > 0)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 12, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            movie.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Movie info section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title ?? 'Unknown Title',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Genre chip
                  if (movie.genre != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        movie.genre!.displayName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Year and additional info
                  Row(
                    children: [
                      if (movie.releaseYear != null) ...[
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.releaseYear!.toString(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCardContent(dynamic movie, MovieController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Movie poster with overlays
          Stack(
            children: [
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: movie.imagePath != null && movie.imagePath!.isNotEmpty
                      ? Image.network(
                          movie.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPosterPlaceholder(),
                        )
                      : _buildPosterPlaceholder(),
                ),
              ),

              // Rating badge
              if (movie.rating != null && movie.rating! > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 10, color: Colors.amber),
                        const SizedBox(width: 1),
                        Text(
                          movie.rating!.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Movie info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Title
                Text(
                  movie.title ?? 'Unknown Title',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Genre and year row
                Row(
                  children: [
                    // Genre chip
                    if (movie.genre != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          movie.genre!.displayName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Year
                    if (movie.releaseYear != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          movie.releaseYear!.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // Description
                if (movie.description != null && movie.description!.isNotEmpty)
                  Text(
                    movie.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 12),

                // Status indicators
                Row(
                  children: [
                    // Watched status
                    if (movie.isWatched == true) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 12,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Watched',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ] else
                      const Spacer(),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Favorite button
              Container(
                decoration: BoxDecoration(
                  color: movie.isFavorite == true
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(
                    movie.isFavorite == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: movie.isFavorite == true
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => controller.toggleFavorite(movie.id),
                ),
              ),

              const SizedBox(height: 8),

              // Delete button
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.errorContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () =>
                      _showDeleteDialog(context, controller, movie),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPosterPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.movie,
        size: 32,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    MovieController controller,
    movie,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Movie'),
        content: Text('Are you sure you want to delete "${movie.title}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteMovie(movie.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
