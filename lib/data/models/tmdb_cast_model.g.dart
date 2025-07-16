// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_cast_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TMDBCastAdapter extends TypeAdapter<TMDBCast> {
  @override
  final int typeId = 13;

  @override
  TMDBCast read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TMDBCast(
      id: fields[0] as int,
      name: fields[1] as String,
      character: fields[2] as String,
      profilePath: fields[3] as String?,
      order: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TMDBCast obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.character)
      ..writeByte(3)
      ..write(obj.profilePath)
      ..writeByte(4)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TMDBCastAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
