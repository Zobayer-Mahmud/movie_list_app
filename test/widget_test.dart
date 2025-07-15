import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:movie_list_app/presentation/widgets/movie_card.dart';
import 'package:movie_list_app/domain/entities/movie.dart';

void main() {
  testWidgets('MovieCard displays movie information correctly', (
    WidgetTester tester,
  ) async {
    // Create a test movie
    final movie = Movie(
      id: '1',
      title: 'Test Movie',
      description: 'This is a test movie description',
      isFavorite: false,
    );

    // Build the MovieCard widget
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: MovieCard(
            movie: movie,
            onFavoriteToggle: () {},
            onDelete: () {},
          ),
        ),
      ),
    );

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify that the movie information is displayed
    expect(find.text('Test Movie'), findsOneWidget);
    expect(find.text('This is a test movie description'), findsOneWidget);

    // Verify that the favorite and delete buttons are displayed
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);

    // Clean up
    Get.reset();
  });

  testWidgets('MovieCard shows favorite icon when movie is favorite', (
    WidgetTester tester,
  ) async {
    // Create a favorite test movie
    final movie = Movie(
      id: '1',
      title: 'Favorite Movie',
      description: 'This is a favorite movie',
      isFavorite: true,
    );

    // Build the MovieCard widget
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: MovieCard(
            movie: movie,
            onFavoriteToggle: () {},
            onDelete: () {},
          ),
        ),
      ),
    );

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify that the filled favorite icon is displayed
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsNothing);

    // Clean up
    Get.reset();
  });
}
