import 'package:equatable/equatable.dart';

class MusicEntity extends Equatable {
  MusicEntity(
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
      required this.musicPremium});

  String largeImageUrl;
  String? tag6;
  String musicDescription;
  int priority;
  String id;
  String owner;
  DateTime createdDate;
  DateTime updatedDate;
  String musicName;
  String? tag3;
  String? brandId;
  String tag1;
  String? status;
  String allTags;
  bool musicLive;
  bool? musicNew;
  bool? musicPremium;
  String? tag2;
  String? musicDescription2;
  String musicId;
  String smallImageUrl;

  @override
  String toString() {
    return musicName;
  }

  @override
  List<Object?> get props => [musicId];
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
