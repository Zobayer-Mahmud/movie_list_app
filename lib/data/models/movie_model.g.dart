// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = 0;

  @override
  MovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieModel(
      modelId: fields[0] as String,
      modelTitle: fields[1] as String,
      modelDescription: fields[2] as String,
      modelIsFavorite: fields[3] as bool,
      modelCreatedAt: fields[4] as DateTime,
      modelGenre: fields[5] as String?,
      modelImagePath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.modelId)
      ..writeByte(1)
      ..write(obj.modelTitle)
      ..writeByte(2)
      ..write(obj.modelDescription)
      ..writeByte(3)
      ..write(obj.modelIsFavorite)
      ..writeByte(4)
      ..write(obj.modelCreatedAt)
      ..writeByte(5)
      ..write(obj.modelGenre)
      ..writeByte(6)
      ..write(obj.modelImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
