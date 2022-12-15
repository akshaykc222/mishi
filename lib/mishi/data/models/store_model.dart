import 'package:hive/hive.dart';

part 'store_model.g.dart';

@HiveType(typeId: 10)
class StoreModel {
  @HiveField(0)
  final String musicName;

  @HiveField(1)
  final String storeLoc;
  @HiveField(2)
  final double totSize;

  StoreModel({
    required this.musicName,
    required this.storeLoc,
    required this.totSize,
  });
}
