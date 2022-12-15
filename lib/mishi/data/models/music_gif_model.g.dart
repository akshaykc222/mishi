// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_gif_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicGifModelAdapter extends TypeAdapter<MusicGifModel> {
  @override
  final int typeId = 6;

  @override
  MusicGifModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicGifModel(
      name: fields[0] as String,
      priority: fields[1] as int,
      mp4Url: fields[2] as String,
      musicId: fields[3] as String,
      id: fields[4] as String,
      owner: fields[5] as String,
      updatedDate: fields[7] as DateTime,
      createdDate: fields[6] as DateTime,
      mainCollection: fields[8] as bool,
      live: fields[9] as bool,
      brandId: fields[10] as String,
      thumbImage: fields[11] as String,
      platform: fields[12] as String,
      free: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MusicGifModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.priority)
      ..writeByte(2)
      ..write(obj.mp4Url)
      ..writeByte(3)
      ..write(obj.musicId)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.owner)
      ..writeByte(6)
      ..write(obj.createdDate)
      ..writeByte(7)
      ..write(obj.updatedDate)
      ..writeByte(8)
      ..write(obj.mainCollection)
      ..writeByte(9)
      ..write(obj.live)
      ..writeByte(10)
      ..write(obj.brandId)
      ..writeByte(11)
      ..write(obj.thumbImage)
      ..writeByte(12)
      ..write(obj.platform)
      ..writeByte(13)
      ..write(obj.free);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicGifModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
