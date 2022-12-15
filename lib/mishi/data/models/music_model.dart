import 'package:hive/hive.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';

part 'music_model.g.dart';

@HiveType(typeId: 3)
class MusicModel extends MusicEntity {
  @HiveField(0)
  String largeImageUrl;
  @HiveField(1)
  String? tag6;
  @HiveField(2)
  String musicDescription;
  @HiveField(3)
  int priority;
  @HiveField(4)
  String id;
  @HiveField(5)
  String owner;
  @HiveField(6)
  DateTime createdDate;
  @HiveField(7)
  DateTime updatedDate;
  @HiveField(8)
  String musicName;

  @HiveField(9)
  String? tag3;
  @HiveField(10)
  String? brandId;
  @HiveField(11)
  String tag1;
  @HiveField(12)
  String? status;
  @HiveField(13)
  String allTags;
  @HiveField(14)
  bool musicLive;
  @HiveField(15)
  bool? musicNew;
  @HiveField(16)
  String? tag2;
  @HiveField(17)
  String? musicDescription2;
  @HiveField(18)
  String musicId;
  @HiveField(19)
  String smallImageUrl;
  @HiveField(20)
  bool? musicPremium;

  MusicModel(
      {required this.largeImageUrl,
      required this.tag6,
      required this.musicDescription,
      required this.priority,
      required this.id,
      required this.owner,
      required this.createdDate,
      required this.updatedDate,
      required this.musicName,
      required this.tag3,
      required this.brandId,
      required this.tag1,
      required this.status,
      required this.allTags,
      required this.musicLive,
      required this.musicNew,
      required this.tag2,
      required this.musicDescription2,
      required this.musicId,
      required this.smallImageUrl,
      required this.musicPremium})
      : super(
            largeImageUrl: largeImageUrl,
            tag6: tag6,
            musicDescription: musicDescription,
            priority: priority,
            id: id,
            owner: owner,
            createdDate: createdDate,
            updatedDate: updatedDate,
            musicName: musicName,
            tag3: tag3,
            brandId: brandId,
            tag1: tag1,
            status: status,
            allTags: allTags,
            musicLive: musicLive,
            musicNew: musicNew,
            tag2: tag2,
            musicDescription2: musicDescription2,
            musicId: musicId,
            smallImageUrl: smallImageUrl,
            musicPremium: musicPremium);
  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
        largeImageUrl: json["largeImageURL"] ?? "",
        tag6: json["tag6"] ?? "",
        musicDescription: json["musicDescription"] ?? "",
        priority: json["priority"] ?? "",
        id: json["_id"] ?? "",
        owner: json["_owner"] ?? "",
        createdDate: DateTime.parse(json["_createdDate"]),
        updatedDate: DateTime.parse(json["_updatedDate"]),
        musicName: json["musicName"],
        tag3: json["tag3"] ?? "",
        brandId: json["brandId"] ?? "",
        tag1: json["tag1"] ?? "",
        status: json["status"],
        allTags: json["allTags"],
        musicLive: json["musicLive"],
        musicNew: json["musicNew"],
        tag2: json["tag2"],
        musicDescription2: json["musicDescription2"] ?? "",
        musicId: json["musicID"],
        smallImageUrl: json["smallImageURL"],
        musicPremium: json["musicPremium"],
      );

  Map<String, dynamic> toJson() => {
        "largeImageURL": largeImageUrl,
        "tag6": tag6,
        "musicDescription": musicDescription,
        "priority": priority,
        "_id": id,
        "_owner": owner,
        "_createdDate": createdDate.toIso8601String(),
        "_updatedDate": updatedDate.toIso8601String(),
        "musicName": musicName,
        "tag3": tag3,
        "brandId": brandId,
        "tag1": tag1,
        "status": status,
        "allTags": allTags,
        "musicLive": musicLive,
        "musicNew": musicNew,
        "tag2": tag2,
        "musicDescription2": musicDescription2,
        "musicID": musicId,
        "smallImageURL": smallImageUrl,
      };
}
