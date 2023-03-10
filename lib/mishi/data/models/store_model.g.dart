// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreModelAdapter extends TypeAdapter<StoreModel> {
  @override
  final int typeId = 10;

  @override
  StoreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreModel(
      musicName: fields[0] as String,
      storeLoc: fields[1] as List<String>,
      totSize: fields[2] as double,
      totalMusic: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StoreModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.musicName)
      ..writeByte(1)
      ..write(obj.storeLoc)
      ..writeByte(2)
      ..write(obj.totSize)
      ..writeByte(3)
      ..write(obj.totalMusic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
