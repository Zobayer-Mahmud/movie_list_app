import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tmdb_controller.dart';
import '../widgets/tmdb_movie_card.dart';
import '../widgets/theme_toggle_button.dart';

class TMDBDiscoveryPage extends StatelessWidget {
  const TMDBDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TMDBController controller = Get.put(TMDBController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed('/tmdb-search'),
            tooltip: 'Search TMDB',
          ),
          const ThemeToggleButton(),
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
                    controller.popularMovies,
                    controller.loadPopularMovies,
                  ),
                  _buildMovieList(
                    controller.trendingMovies,
                    controller.loadTrendingMovies,
                  ),
                  _buildMovieList(
                    controller.topRatedMovies,
                    controller.loadTopRatedMovies,
                  ),
                  _buildMovieList(
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

  Widget _buildMovieList(RxList<dynamic> movies, Function() loadFunction) {
    return Obx(() {
      if (movies.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loadFunction,
                child: const Text('Load Movies'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => loadFunction(),
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
