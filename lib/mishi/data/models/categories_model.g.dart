// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final int typeId = 1;

  @override
  CategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryModel(
      displayName: fields[0] as String,
      tagDescription: fields[1] as String,
      tagName: fields[2] as String,
      tagOrder: fields[3] as int,
      id: fields[4] as String,
      owner: fields[5] as String,
      createdDate: fields[6] as DateTime,
      updatedDate: fields[7] as DateTime,
      tagLive: fields[8] as bool,
      brandId: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.tagDescription)
      ..writeByte(2)
      ..write(obj.tagName)
      ..writeByte(3)
      ..write(obj.tagOrder)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.owner)
      ..writeByte(6)
      ..write(obj.createdDate)
      ..writeByte(7)
      ..write(obj.updatedDate)
      ..writeByte(8)
      ..write(obj.tagLive)
      ..writeByte(9)
      ..write(obj.brandId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
