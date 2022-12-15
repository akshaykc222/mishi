import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/domain/repositories/music_list_repository.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

import '../../../core/hive_service.dart';
import '../../data/app_remote_routes.dart';
import '../../data/models/music_model.dart';

class MusicListUseCase extends UseCase<Stream<MusicEntity?>, String> {
  final MusicListRepository repository;

  MusicListUseCase(this.repository);

  @override
  Future<Stream<MusicEntity?>> call(String params) async {
    repository.getMusic(params);
    var box =
        await HiveService().getBox<MusicModel>(boxName: AppBoxNames.musicBox);
    prettyPrint(msg: "saved item length ${box.values.length.toString()}");

    return Future.value(
        box.watch().map((event) => event.value as MusicEntity?));
  }
}
