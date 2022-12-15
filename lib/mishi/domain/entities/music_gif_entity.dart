import 'package:equatable/equatable.dart';

class MusicGifEntity extends Equatable {
  MusicGifEntity({
    required this.name,
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
    required this.free,
  });

  String name;
  int priority;
  String mp4Url;
  String musicId;
  String id;
  String owner;
  DateTime createdDate;
  DateTime updatedDate;
  bool mainCollection;
  bool live;
  String brandId;
  String thumbImage;
  String platform;
  bool free;

  @override
  List<Object?> get props => [name, id];
}
