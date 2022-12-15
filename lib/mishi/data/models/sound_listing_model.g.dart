// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_listing_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoundListingModelAdapter extends TypeAdapter<SoundListingModel> {
  @override
  final int typeId = 7;

  @override
  SoundListingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoundListingModel(
      id: fields[0] as String,
      owner: fields[1] as String,
      soundDisplayOrder: fields[2] as int,
      createdDate: fields[3] as DateTime,
      soundAudioUrl: fields[4] as String,
      updatedDate: fields[5] as DateTime,
      soundLive: fields[6] as bool,
      brandId: fields[7] as String,
      soundName: fields[8] as String,
      platform: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SoundListingModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.owner)
      ..writeByte(2)
      ..write(obj.soundDisplayOrder)
      ..writeByte(3)
      ..write(obj.createdDate)
      ..writeByte(4)
      ..write(obj.soundAudioUrl)
      ..writeByte(5)
      ..write(obj.updatedDate)
      ..writeByte(6)
      ..write(obj.soundLive)
      ..writeByte(7)
      ..write(obj.brandId)
      ..writeByte(8)
      ..write(obj.soundName)
      ..writeByte(9)
      ..write(obj.platform);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoundListingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
