import 'package:hive/hive.dart';
import 'package:mishi/mishi/domain/entities/categories.dart';

part 'categories_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel extends CategoriesEntity {
  @HiveField(0)
  final String displayName;
  @HiveField(1)
  final String tagDescription;
  @HiveField(2)
  final String tagName;
  @HiveField(3)
  final int tagOrder;
  @HiveField(4)
  final String id;
  @HiveField(5)
  final String owner;
  @HiveField(6)
  final DateTime createdDate;
  @HiveField(7)
  final DateTime updatedDate;
  @HiveField(8)
  final bool tagLive;
  @HiveField(9)
  final String brandId;

  CategoryModel({
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
  }) : super(
            displayName: displayName,
            tagDescription: tagDescription,
            tagName: tagName,
            tagOrder: tagOrder,
            id: id,
            owner: owner,
            createdDate: createdDate,
            updatedDate: updatedDate,
            tagLive: tagLive,
            brandId: brandId);

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        displayName: json["displayName"],
        tagDescription: json["tagDescription"],
        tagName: json["tagName"],
        tagOrder: json["tagOrder"],
        id: json["_id"],
        owner: json["_owner"],
        createdDate: DateTime.parse(json["_createdDate"]),
        updatedDate: DateTime.parse(json["_updatedDate"]),
        tagLive: json["tagLive"],
        brandId: json["brandID"],
      );
}
