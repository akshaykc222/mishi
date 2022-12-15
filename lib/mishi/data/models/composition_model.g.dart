// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composition_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompositionModelAdapter extends TypeAdapter<CompositionModel> {
  @override
  final int typeId = 2;

  @override
  CompositionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompositionModel(
      instrumentDisplayOrder: fields[0] as int,
      id: fields[1] as String,
      owner: fields[2] as String,
      createdDate: fields[3] as DateTime,
      instrumentName: fields[4] as String,
      instrumentAudioUrl: fields[5] as String,
      updatedDate: fields[6] as DateTime,
      instrumentLive: fields[7] as bool,
      instrumentVolumeDefault: fields[8] as int,
      musicId: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CompositionModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.instrumentDisplayOrder)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.owner)
      ..writeByte(3)
      ..write(obj.createdDate)
      ..writeByte(4)
      ..write(obj.instrumentName)
      ..writeByte(5)
      ..write(obj.instrumentAudioUrl)
      ..writeByte(6)
      ..write(obj.updatedDate)
      ..writeByte(7)
      ..write(obj.instrumentLive)
      ..writeByte(8)
      ..write(obj.instrumentVolumeDefault)
      ..writeByte(9)
      ..write(obj.musicId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompositionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
