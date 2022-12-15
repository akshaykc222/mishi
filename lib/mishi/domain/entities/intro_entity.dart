import 'package:equatable/equatable.dart';

class IntroEntity extends Equatable {
  String name;
  int priority;
  String image;
  String sId;
  String sOwner;
  String sCreatedDate;
  String text;
  String sUpdatedDate;
  bool live;
  String platform;

  IntroEntity(
      {required this.name,
      required this.priority,
      required this.image,
      required this.sId,
      required this.sOwner,
      required this.sCreatedDate,
      required this.text,
      required this.sUpdatedDate,
      required this.live,
      required this.platform});

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}
