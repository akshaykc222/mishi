import 'package:mishi/mishi/domain/entities/intro_entity.dart';

class IntroModel extends IntroEntity {
  IntroModel(
      {required super.name,
      required super.priority,
      required super.image,
      required super.sId,
      required super.sOwner,
      required super.sCreatedDate,
      required super.text,
      required super.sUpdatedDate,
      required super.live,
      required super.platform});

  factory IntroModel.fromJson(Map<String, dynamic> json) => IntroModel(
      name: json['name'],
      priority: json['priority'],
      image: json['image'],
      sId: json['_id'],
      sOwner: json['_owner'],
      sCreatedDate: json['_createdDate'],
      text: json['text'],
      sUpdatedDate: json['_updatedDate'],
      live: json['live'],
      platform: json['platform']);
}
