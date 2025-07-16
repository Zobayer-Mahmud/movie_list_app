// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_video_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TMDBVideoAdapter extends TypeAdapter<TMDBVideo> {
  @override
  final int typeId = 14;

  @override
  TMDBVideo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TMDBVideo(
      id: fields[0] as String,
      key: fields[1] as String,
      name: fields[2] as String,
      site: fields[3] as String,
      type: fields[4] as String,
      size: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TMDBVideo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.key)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.site)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.size);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TMDBVideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
