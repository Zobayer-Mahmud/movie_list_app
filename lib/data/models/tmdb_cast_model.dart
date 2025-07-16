import 'package:hive/hive.dart';

part 'tmdb_cast_model.g.dart';

@HiveType(typeId: 13)
class TMDBCast extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String character;

  @HiveField(3)
  final String? profilePath;

  @HiveField(4)
  final int order;

  TMDBCast({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
    required this.order,
  });

  factory TMDBCast.fromJson(Map<String, dynamic> json) {
    return TMDBCast(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'character': character,
      'profile_path': profilePath,
      'order': order,
    };
  }
}

class TMDBCreditsResponse {
  final List<TMDBCast> cast;

  TMDBCreditsResponse({required this.cast});

  factory TMDBCreditsResponse.fromJson(Map<String, dynamic> json) {
    return TMDBCreditsResponse(
      cast:
          (json['cast'] as List<dynamic>?)
              ?.map((item) => TMDBCast.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'cast': cast.map((item) => item.toJson()).toList()};
  }
}
