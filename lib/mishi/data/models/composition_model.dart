import 'package:hive/hive.dart';
import 'package:mishi/mishi/domain/entities/composition_entity.dart';

part 'composition_model.g.dart';

@HiveType(typeId: 2)
class CompositionModel extends CompositionEntity {
  @HiveField(0)
  final int instrumentDisplayOrder;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String owner;
  @HiveField(3)
  final DateTime createdDate;
  @HiveField(4)
  final String instrumentName;
  @HiveField(5)
  final String instrumentAudioUrl;
  @HiveField(6)
  final DateTime updatedDate;
  @HiveField(7)
  final bool instrumentLive;
  @HiveField(8)
  int instrumentVolumeDefault;
  @HiveField(9)
  final String musicId;
  @HiveField(10)
  final bool? dDownloaded;
  CompositionModel(
      {required this.instrumentDisplayOrder,
      required this.id,
      required this.owner,
      required this.createdDate,
      required this.instrumentName,
      required this.instrumentAudioUrl,
      required this.updatedDate,
      required this.instrumentLive,
      required this.instrumentVolumeDefault,
      required this.musicId,
      this.dDownloaded})
      : super(
            instrumentDisplayOrder: instrumentDisplayOrder,
            id: id,
            owner: owner,
            createdDate: createdDate,
            instrumentName: instrumentName,
            instrumentAudioUrl: instrumentAudioUrl,
            updatedDate: updatedDate,
            instrumentLive: instrumentLive,
            instrumentVolumeDefault: instrumentVolumeDefault,
            musicId: musicId,
            dCompleted: dDownloaded);
  factory CompositionModel.fromJson(Map<String, dynamic> json) =>
      CompositionModel(
        instrumentDisplayOrder: json["instrumentDisplayOrder"],
        id: json["_id"],
        owner: json["_owner"],
        createdDate: DateTime.parse(json["_createdDate"]),
        instrumentName: json["instrumentName"],
        instrumentAudioUrl: json["instrumentAudioURL"],
        updatedDate: DateTime.parse(json["_updatedDate"]),
        instrumentLive: json["instrumentLive"],
        instrumentVolumeDefault: json["instrumentVolumeDefault"],
        musicId: json["musicID"],
      );

  Map<String, dynamic> toJson() => {
        "instrumentDisplayOrder": instrumentDisplayOrder,
        "_id": id,
        "_owner": owner,
        "_createdDate": createdDate.toIso8601String(),
        "instrumentName": instrumentName,
        "instrumentAudioURL": instrumentAudioUrl,
        "_updatedDate": updatedDate.toIso8601String(),
        "instrumentLive": instrumentLive,
        "instrumentVolumeDefault": instrumentVolumeDefault,
        "musicID": musicId,
      };
}
