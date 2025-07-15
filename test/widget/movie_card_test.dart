import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_list_app/domain/entities/movie.dart';
import 'package:movie_list_app/presentation/widgets/movie_card.dart';

void main() {
  group('MovieCard Widget', () {
    final testMovie = Movie(
      id: '1',
      title: 'Test Movie',
      description: 'This is a test movie description for testing purposes',
      isFavorite: false,
      createdAt: DateTime(2024, 1, 1),
    );

    final favoriteMovie = Movie(
      id: '2',
      title: 'Favorite Movie',
      description: 'This is a favorite movie description for testing purposes',
      isFavorite: true,
      createdAt: DateTime(2024, 1, 2),
    );

    testWidgets('should display movie title and description', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: testMovie,
              onFavoriteToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Movie'), findsOneWidget);
      expect(
        find.text('This is a test movie description for testing purposes'),
        findsOneWidget,
      );
    });

    testWidgets('should display empty heart icon for non-favorite movie', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: testMovie,
              onFavoriteToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('should display filled heart icon for favorite movie', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: favoriteMovie,
              onFavoriteToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('should show favorite badge for favorite movie', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: favoriteMovie,
              onFavoriteToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('❤️ Favorite'), findsOneWidget);
    });

    testWidgets('should not show favorite badge for non-favorite movie', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: testMovie,
              onFavoriteToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('❤️ Favorite'), findsNothing);
    });

    testWidgets('should call onFavoriteToggle when favorite button is tapped', (
      tester,
    ) async {
      bool favoriteToggled = false;
      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: testMovie,
              onFavoriteToggle: () => favoriteToggled = true,
              onDelete: () => deleted = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      expect(favoriteToggled, isTrue);
      expect(deleted, isFalse);
    });

    testWidgets('should call onDelete when delete button is tapped', (
      tester,
    ) async {
      bool favoriteToggled = false;
      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: testMovie,
              onFavoriteToggle: () => favoriteToggled = true,
              onDelete: () => deleted = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(deleted, isTrue);
      expect(favoriteToggled, isFalse);
    });

    testWidgets('should show delete confirmation dialog on swipe to delete', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: testMovie,
              onFavoriteToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // Swipe to delete
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Should show confirmation dialog
      expect(find.text('Delete Movie'), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete "Test Movie"?'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should dismiss confirmation dialog when Cancel is tapped', (
      tester,
    ) async {
      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: testMovie,
              onFavoriteToggle: () {},
              onDelete: () => deleted = true,
            ),
          ),
        ),
      );

      // Swipe to delete
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog should be dismissed, movie should not be deleted
      expect(find.text('Delete Movie'), findsNothing);
      expect(deleted, isFalse);
    });
  });
}
