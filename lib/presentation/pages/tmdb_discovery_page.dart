import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tmdb_controller.dart';
import '../widgets/tmdb_movie_card.dart';

class TMDBDiscoveryPage extends StatelessWidget {
  const TMDBDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TMDBController controller = Get.put(TMDBController());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Discover Movies'),
            Obx(() {
              if (!controller.isOnline.value) {
                return const Text(
                  'Offline - Showing cached data',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                );
              } else if (controller.isLoadingFromCache.value) {
                return const Text(
                  'Loading from cache...',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                Icons.refresh,
                color: controller.isOnline.value ? null : Colors.grey,
              ),
              onPressed: controller.isOnline.value
                  ? controller.refreshAllData
                  : null,
              tooltip: 'Refresh data',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed('/tmdb-search'),
            tooltip: 'Search TMDB',
          ),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Popular'),
                Tab(text: 'Trending'),
                Tab(text: 'Top Rated'),
                Tab(text: 'Upcoming'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildMovieList(
                    context,
                    controller.popularMovies,
                    controller.loadPopularMovies,
                  ),
                  _buildMovieList(
                    context,
                    controller.trendingMovies,
                    controller.loadTrendingMovies,
                  ),
                  _buildMovieList(
                    context,
                    controller.topRatedMovies,
                    controller.loadTopRatedMovies,
                  ),
                  _buildMovieList(
                    context,
                    controller.upcomingMovies,
                    controller.loadUpcomingMovies,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(
    BuildContext context,
    RxList<dynamic> movies,
    Function() loadFunction,
  ) {
    final TMDBController controller = Get.find<TMDBController>();

    return Obx(() {
      if (movies.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                controller.isOnline.value ? Icons.movie : Icons.wifi_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                controller.isOnline.value
                    ? 'Loading movies...'
                    : 'No offline data available',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (controller.isOnline.value)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: controller.refreshAllData,
                  child: const Text('Retry'),
                ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.refreshAllData();
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return TMDBMovieCard(
              movie: movie,
              onTap: () => Get.toNamed('/tmdb-details', arguments: movie),
            );
          },
        ),
      );
    });
  }
}
