import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/domain/repositories/music_list_repository.dart';

class MusicListUseCase extends UseCase<List<MusicEntity?>, String> {
  final MusicListRepository repository;

  MusicListUseCase(this.repository);

  @override
  Future<List<MusicEntity?>> call(String params) async {
    return repository.getMusic(params);
    // var box =
    //     await HiveService().getBox<MusicModel>(boxName: AppBoxNames.musicBox);
    // prettyPrint(msg: "saved item length ${box.values.length.toString()}");
    //
    // return Future.value(
    //     box.watch().map((event) => event.value as MusicEntity?));
  }
}
