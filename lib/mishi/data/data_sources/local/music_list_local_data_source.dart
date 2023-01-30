import 'package:mishi/mishi/data/app_remote_routes.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

import '../../../../core/hive_service.dart';

abstract class MusicListLocalDataSource {
  Future<void> saveCurrentPlaying(PlayerStatus data);
}

class MusicListLocalDataSourceImpl extends MusicListLocalDataSource {
  final HiveService hiveService;

  MusicListLocalDataSourceImpl(this.hiveService);

  @override
  Future<void> saveCurrentPlaying(PlayerStatus data) async {
    var box =
        await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
    List<PlayerStatus> dataList = box.values.toList();
    if (dataList.contains(data)) {
      prettyPrint(msg: "updating box data");
      box.putAt(0, data);
    } else {
      await box.clear();
      prettyPrint(msg: "inserting box data");
      box.add(data);
    }
  }

  // Future<List<CompositionEntity>> getCompostions(){
  //   var data=hiveService.getBox(boxName: boxName)
  // }
}
