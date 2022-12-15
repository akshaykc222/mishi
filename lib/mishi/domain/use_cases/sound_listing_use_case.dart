import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/domain/entities/sound_listing_entity.dart';

import '../repositories/music_list_repository.dart';

class SoundListUseCase extends UseCase<List<SoundListingEntity>, NoParams> {
  final MusicListRepository repository;

  SoundListUseCase(this.repository);

  @override
  Future<List<SoundListingEntity>> call(NoParams params) {
    return repository.getSoundListings();
  }
}
