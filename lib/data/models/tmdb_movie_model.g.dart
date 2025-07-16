// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TMDBMovieAdapter extends TypeAdapter<TMDBMovie> {
  @override
  final int typeId = 12;

  @override
  TMDBMovie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TMDBMovie(
      id: fields[0] as int,
      title: fields[1] as String,
      overview: fields[2] as String,
      posterPath: fields[3] as String?,
      backdropPath: fields[4] as String?,
      releaseDate: fields[5] as DateTime,
      voteAverage: fields[6] as double,
      voteCount: fields[7] as int,
      genreIds: (fields[8] as List).cast<int>(),
      adult: fields[9] as bool,
      originalLanguage: fields[10] as String,
      originalTitle: fields[11] as String,
      popularity: fields[12] as double,
      video: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TMDBMovie obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterPath)
      ..writeByte(4)
      ..write(obj.backdropPath)
      ..writeByte(5)
      ..write(obj.releaseDate)
      ..writeByte(6)
      ..write(obj.voteAverage)
      ..writeByte(7)
      ..write(obj.voteCount)
      ..writeByte(8)
      ..write(obj.genreIds)
      ..writeByte(9)
      ..write(obj.adult)
      ..writeByte(10)
      ..write(obj.originalLanguage)
      ..writeByte(11)
      ..write(obj.originalTitle)
      ..writeByte(12)
      ..write(obj.popularity)
      ..writeByte(13)
      ..write(obj.video);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TMDBMovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
