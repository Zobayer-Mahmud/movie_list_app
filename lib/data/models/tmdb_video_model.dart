import 'package:hive/hive.dart';

part 'tmdb_video_model.g.dart';

@HiveType(typeId: 14)
class TMDBVideo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String key;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String site;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final int size;

  TMDBVideo({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.size,
  });

  factory TMDBVideo.fromJson(Map<String, dynamic> json) {
    return TMDBVideo(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'site': site,
      'type': type,
      'size': size,
    };
  }

  // Check if this is a YouTube trailer
  bool get isYouTubeTrailer =>
      site.toLowerCase() == 'youtube' && type.toLowerCase() == 'trailer';

  // Get YouTube URL
  String get youTubeUrl => 'https://www.youtube.com/watch?v=$key';

  // Get YouTube thumbnail URL
  String get youTubeThumbnailUrl =>
      'https://img.youtube.com/vi/$key/maxresdefault.jpg';
}

class TMDBVideosResponse {
  final List<TMDBVideo> results;

  TMDBVideosResponse({required this.results});

  factory TMDBVideosResponse.fromJson(Map<String, dynamic> json) {
    return TMDBVideosResponse(
      results:
          (json['results'] as List<dynamic>?)
              ?.map((item) => TMDBVideo.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'results': results.map((item) => item.toJson()).toList()};
  }

  // Get YouTube trailers only
  List<TMDBVideo> get trailers =>
      results.where((video) => video.isYouTubeTrailer).toList();
}
