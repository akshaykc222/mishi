// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerStatusAdapter extends TypeAdapter<PlayerStatus> {
  @override
  final int typeId = 5;

  @override
  PlayerStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerStatus(
      musicName: fields[0] as String,
      description: fields[1] as String,
      image: fields[2] as String,
      status: getAudioStatusFromString(fields[3]),
    );
  }

  @override
  void write(BinaryWriter writer, PlayerStatus obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.musicName)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.status.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
