import 'package:equatable/equatable.dart';
import 'package:mishi/mishi/presentation/utils/enums.dart';

class CompositionEntity extends Equatable {
  CompositionEntity({
    required this.instrumentDisplayOrder,
    required this.id,
    required this.owner,
    required this.createdDate,
    required this.instrumentName,
    required this.instrumentAudioUrl,
    required this.updatedDate,
    required this.instrumentLive,
    required this.instrumentVolumeDefault,
    required this.musicId,
    this.dCompleted,
  });

  final int instrumentDisplayOrder;
  final String id;
  final String owner;
  final DateTime createdDate;
  final String instrumentName;
  final String instrumentAudioUrl;
  final DateTime updatedDate;
  final bool instrumentLive;
  int instrumentVolumeDefault;
  bool? dCompleted;
  final String musicId;
  AudioStatus status = AudioStatus.downloading;

  @override
  List<Object?> get props => [id, musicId];
  @override
  String toString() {
    return instrumentName;
  }
}
