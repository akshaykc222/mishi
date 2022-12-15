import 'package:equatable/equatable.dart';

class SoundListingEntity extends Equatable {
  String id;
  String owner;
  int soundDisplayOrder;
  DateTime createdDate;
  String soundAudioUrl;
  DateTime updatedDate;
  double? volume = 0;
  bool soundLive;
  String brandId;
  String soundName;
  String platform;

  SoundListingEntity(
      {required this.id,
      required this.owner,
      required this.soundDisplayOrder,
      required this.createdDate,
      required this.soundAudioUrl,
      required this.updatedDate,
      required this.soundLive,
      required this.brandId,
      required this.soundName,
      required this.platform});

  @override
  List<Object?> get props => [id, soundName];
}
