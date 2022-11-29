// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poem.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PoemAdapter extends TypeAdapter<Poem> {
  @override
  final int typeId = 0;

  @override
  Poem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Poem(
      name: fields[0] as String,
      author: fields[1] as String,
      poetic: fields[2] as String,
      content: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Poem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.poetic)
      ..writeByte(3)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
