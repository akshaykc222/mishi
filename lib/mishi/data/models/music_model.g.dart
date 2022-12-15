// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicModelAdapter extends TypeAdapter<MusicModel> {
  @override
  final int typeId = 3;

  @override
  MusicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicModel(
      largeImageUrl: fields[0] as String,
      tag6: fields[1] as String?,
      musicDescription: fields[2] as String,
      priority: fields[3] as int,
      id: fields[4] as String,
      owner: fields[5] as String,
      createdDate: fields[6] as DateTime,
      updatedDate: fields[7] as DateTime,
      musicName: fields[8] as String,
      tag3: fields[9] as String?,
      brandId: fields[10] as String?,
      tag1: fields[11] as String,
      status: fields[12] as String?,
      allTags: fields[13] as String,
      musicLive: fields[14] as bool,
      musicNew: fields[15] as bool?,
      tag2: fields[16] as String?,
      musicDescription2: fields[17] as String?,
      musicId: fields[18] as String,
      smallImageUrl: fields[19] as String,
      musicPremium: fields[20] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, MusicModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.largeImageUrl)
      ..writeByte(1)
      ..write(obj.tag6)
      ..writeByte(2)
      ..write(obj.musicDescription)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.owner)
      ..writeByte(6)
      ..write(obj.createdDate)
      ..writeByte(7)
      ..write(obj.updatedDate)
      ..writeByte(8)
      ..write(obj.musicName)
      ..writeByte(9)
      ..write(obj.tag3)
      ..writeByte(10)
      ..write(obj.brandId)
      ..writeByte(11)
      ..write(obj.tag1)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.allTags)
      ..writeByte(14)
      ..write(obj.musicLive)
      ..writeByte(15)
      ..write(obj.musicNew)
      ..writeByte(16)
      ..write(obj.tag2)
      ..writeByte(17)
      ..write(obj.musicDescription2)
      ..writeByte(18)
      ..write(obj.musicId)
      ..writeByte(19)
      ..write(obj.smallImageUrl)
      ..writeByte(20)
      ..write(obj.musicPremium);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
