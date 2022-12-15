import 'package:hive/hive.dart';
import 'package:mishi/mishi/domain/entities/music_gif_entity.dart';

part 'music_gif_model.g.dart';

@HiveType(typeId: 6)
class MusicGifModel extends MusicGifEntity {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int priority;
  @HiveField(2)
  final String mp4Url;
  @HiveField(3)
  final String musicId;
  @HiveField(4)
  final String id;
  @HiveField(5)
  final String owner;
  @HiveField(6)
  final DateTime createdDate;
  @HiveField(7)
  final DateTime updatedDate;
  @HiveField(8)
  final bool mainCollection;
  @HiveField(9)
  final bool live;
  @HiveField(10)
  final String brandId;
  @HiveField(11)
  final String thumbImage;
  @HiveField(12)
  final String platform;
  @HiveField(13)
  final bool free;
  MusicGifModel(
      {required this.name,
      required this.priority,
      required this.mp4Url,
      required this.musicId,
      required this.id,
      required this.owner,
      required this.updatedDate,
      required this.createdDate,
      required this.mainCollection,
      required this.live,
      required this.brandId,
      required this.thumbImage,
      required this.platform,
      required this.free})
      : super(
            name: name,
            priority: priority,
            mp4Url: mp4Url,
            musicId: musicId,
            id: id,
            owner: owner,
            updatedDate: updatedDate,
            createdDate: createdDate,
            mainCollection: mainCollection,
            live: live,
            brandId: brandId,
            thumbImage: thumbImage,
            platform: platform,
            free: free);

  factory MusicGifModel.fromJson(Map<String, dynamic> json) => MusicGifModel(
        name: json["name"] ?? "",
        priority: json["priority"] ?? 0,
        mp4Url: json["mp4Url"] ?? "",
        musicId: json["musicId"] ?? "",
        id: json["_id"] ?? "",
        owner: json["_owner"] ?? "",
        createdDate: DateTime.parse(json["_createdDate"]),
        updatedDate: DateTime.parse(json["_updatedDate"]),
        mainCollection: json["mainCollection"] ?? false,
        live: json["live"] ?? false,
        brandId: json["brandID"] ?? "",
        thumbImage: json["thumbImage"] ?? "",
        platform: json["platform"] ?? "",
        free: json["free"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "priority": priority,
        "mp4Url": mp4Url,
        "musicId": musicId,
        "_id": id,
        "_owner": owner,
        "_createdDate": createdDate.toIso8601String(),
        "_updatedDate": updatedDate.toIso8601String(),
        "mainCollection": mainCollection,
        "live": live,
        "brandID": brandId,
        "thumbImage": thumbImage,
        "platform": platform,
        "free": free,
      };
}
