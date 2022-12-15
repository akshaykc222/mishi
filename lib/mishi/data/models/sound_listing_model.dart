import 'package:hive_flutter/adapters.dart';
import 'package:mishi/mishi/domain/entities/sound_listing_entity.dart';

part 'sound_listing_model.g.dart';

@HiveType(typeId: 7)
class SoundListingModel extends SoundListingEntity {
  @HiveField(0)
  String id;
  @HiveField(1)
  String owner;
  @HiveField(2)
  int soundDisplayOrder;
  @HiveField(3)
  DateTime createdDate;
  @HiveField(4)
  String soundAudioUrl;
  @HiveField(5)
  DateTime updatedDate;
  @HiveField(6)
  bool soundLive;
  @HiveField(7)
  String brandId;
  @HiveField(8)
  String soundName;
  @HiveField(9)
  String platform;

  SoundListingModel(
      {required this.id,
      required this.owner,
      required this.soundDisplayOrder,
      required this.createdDate,
      required this.soundAudioUrl,
      required this.updatedDate,
      required this.soundLive,
      required this.brandId,
      required this.soundName,
      required this.platform})
      : super(
            id: id,
            owner: owner,
            soundDisplayOrder: soundDisplayOrder,
            createdDate: createdDate,
            soundAudioUrl: soundAudioUrl,
            updatedDate: updatedDate,
            soundLive: soundLive,
            brandId: brandId,
            soundName: soundName,
            platform: platform);
  factory SoundListingModel.fromJson(Map<String, dynamic> json) =>
      SoundListingModel(
        id: json["_id"],
        owner: json["_owner"],
        soundDisplayOrder: json["soundDisplayOrder"],
        createdDate: DateTime.parse(json["_createdDate"]),
        soundAudioUrl: json["soundAudioURL"],
        updatedDate: DateTime.parse(json["_updatedDate"]),
        soundLive: json["soundLive"],
        brandId: json["brandID"],
        soundName: json["soundName"],
        platform: json["platform"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "_owner": owner,
        "soundDisplayOrder": soundDisplayOrder,
        "_createdDate": createdDate.toIso8601String(),
        "soundAudioURL": soundAudioUrl,
        "_updatedDate": updatedDate.toIso8601String(),
        "soundLive": soundLive,
        "brandID": brandId,
        "soundName": soundName,
        "platform": platform,
      };
}
