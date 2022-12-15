import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mishi/mishi/presentation/utils/enums.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

part 'player_status.g.dart';

@HiveType(typeId: 5)
class PlayerStatus extends Equatable {
  @HiveField(0)
  final String musicName;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String image;
  @HiveField(3)
  final AudioStatus status;

  const PlayerStatus(
      {required this.musicName,
      required this.description,
      required this.image,
      required this.status});

  String statusToString() {
    prettyPrint(msg: 'status to string ${status.name}');
    return status.name.toString();
  }

  @override
  List<Object?> get props => [musicName];
}
