import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/domain/entities/music_gif_entity.dart';
import 'package:mishi/mishi/domain/repositories/music_list_repository.dart';

class MusicGifUseCase extends UseCase<List<MusicGifEntity>, String> {
  final MusicListRepository repository;

  MusicGifUseCase(this.repository);

  @override
  Future<List<MusicGifEntity>> call(String params) {
    return repository.getMusicVideos(params);
  }
}
