import 'package:mishi/core/hive_service.dart';
import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/data/app_remote_routes.dart';
import 'package:mishi/mishi/data/models/composition_model.dart';
import 'package:mishi/mishi/domain/entities/composition_entity.dart';
import 'package:mishi/mishi/domain/repositories/music_list_repository.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

class GetMusicCompositionsUseCase
    extends UseCase<List<CompositionEntity>, String> {
  final MusicListRepository repository;
  final HiveService hiveService;

  GetMusicCompositionsUseCase(
    this.repository,
    this.hiveService,
  );

  @override
  Future<List<CompositionEntity>> call(String params) async {
    try {
      await repository.getMusicCompositions(params);
    } catch (e) {
      prettyPrint(msg: "No internet exception $e");
    }

    var box = await hiveService.getBox<CompositionModel>(
        boxName: AppBoxNames.compositionBox);
    return box.values.where((element) => element.musicId == params).toList();
  }
}
