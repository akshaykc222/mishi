import 'package:equatable/equatable.dart';

class CategoriesEntity extends Equatable {
  CategoriesEntity({
    required this.displayName,
    required this.tagDescription,
    required this.tagName,
    required this.tagOrder,
    required this.id,
    required this.owner,
    required this.createdDate,
    required this.updatedDate,
    required this.tagLive,
    required this.brandId,
  });

  String displayName;
  String tagDescription;
  String tagName;
  int tagOrder;
  String id;
  String owner;
  DateTime createdDate;
  DateTime updatedDate;
  bool tagLive;
  String brandId;

  @override
  String toString() {
    return displayName;
  }

  @override
  List<Object?> get props => [displayName, id];
}
