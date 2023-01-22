import 'package:hive/hive.dart';

part 'store_model.g.dart';

@HiveType(typeId: 10)
class StoreModel {
  @HiveField(0)
  final String musicName;

  @HiveField(1)
  final List<String> storeLoc;
  @HiveField(2)
  final double totSize;
  @HiveField(3)
  final int totalMusic;

  StoreModel(
      {required this.musicName,
      required this.storeLoc,
      required this.totSize,
      required this.totalMusic});
}
