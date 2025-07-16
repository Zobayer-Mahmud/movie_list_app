// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_cache_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TMDBCacheDataAdapter extends TypeAdapter<TMDBCacheData> {
  @override
  final int typeId = 10;

  @override
  TMDBCacheData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TMDBCacheData(
      cacheKey: fields[0] as String,
      movies: (fields[1] as List).cast<TMDBMovie>(),
      cachedAt: fields[2] as DateTime,
      cacheExpiry: fields[3] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, TMDBCacheData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cacheKey)
      ..writeByte(1)
      ..write(obj.movies)
      ..writeByte(2)
      ..write(obj.cachedAt)
      ..writeByte(3)
      ..write(obj.cacheExpiry);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TMDBCacheDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TMDBMovieDetailsCacheAdapter extends TypeAdapter<TMDBMovieDetailsCache> {
  @override
  final int typeId = 11;

  @override
  TMDBMovieDetailsCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TMDBMovieDetailsCache(
      movieId: fields[0] as int,
      movieDetails: fields[1] as TMDBMovie,
      cast: (fields[2] as List).cast<TMDBCast>(),
      videos: (fields[3] as List).cast<TMDBVideo>(),
      cachedAt: fields[4] as DateTime,
      cacheExpiry: fields[5] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, TMDBMovieDetailsCache obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.movieId)
      ..writeByte(1)
      ..write(obj.movieDetails)
      ..writeByte(2)
      ..write(obj.cast)
      ..writeByte(3)
      ..write(obj.videos)
      ..writeByte(4)
      ..write(obj.cachedAt)
      ..writeByte(5)
      ..write(obj.cacheExpiry);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TMDBMovieDetailsCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
