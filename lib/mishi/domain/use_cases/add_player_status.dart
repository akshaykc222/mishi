import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/domain/repositories/music_list_repository.dart';

class AddPlayerStatusUseCase extends UseCase<void, PlayerStatus> {
  final MusicListRepository repository;

  AddPlayerStatusUseCase(this.repository);

  @override
  Future<void> call(PlayerStatus params) {
    return repository.playerStatus(params);
  }
}
