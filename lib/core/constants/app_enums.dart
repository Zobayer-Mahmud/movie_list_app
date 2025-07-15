enum SortOption {
  dateNewest('Date Added (Newest First)'),
  dateOldest('Date Added (Oldest First)'),
  titleAZ('Title (A-Z)'),
  titleZA('Title (Z-A)'),
  favoritesFirst('Favorites First');

  const SortOption(this.displayName);

  final String displayName;
}

enum FilterOption {
  all('All Movies'),
  favoritesOnly('Favorites Only');

  const FilterOption(this.displayName);

  final String displayName;
}

enum MovieGenre {
  action('Action'),
  adventure('Adventure'),
  animation('Animation'),
  comedy('Comedy'),
  crime('Crime'),
  documentary('Documentary'),
  drama('Drama'),
  family('Family'),
  fantasy('Fantasy'),
  history('History'),
  horror('Horror'),
  music('Music'),
  mystery('Mystery'),
  romance('Romance'),
  scienceFiction('Science Fiction'),
  thriller('Thriller'),
  war('War'),
  western('Western');

  const MovieGenre(this.displayName);

  final String displayName;

  static MovieGenre? fromString(String? value) {
    if (value == null) return null;
    try {
      return MovieGenre.values.firstWhere((genre) => genre.name == value);
    } catch (e) {
      return null;
    }
  }
}
