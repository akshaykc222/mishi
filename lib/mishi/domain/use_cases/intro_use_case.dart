import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/data/models/static_pages.dart';
import 'package:mishi/mishi/domain/entities/intro_entity.dart';
import 'package:mishi/mishi/domain/repositories/music_list_repository.dart';

class IntroUseCase extends UseCase<List<IntroEntity>, NoParams> {
  final MusicListRepository repository;

  IntroUseCase(this.repository);

  @override
  Future<List<IntroEntity>> call(NoParams params) {
    return repository.getIntroSlides();
  }
}

class StaticPageUseCase extends UseCase<List<StaticPages>, NoParams> {
  final MusicListRepository repository;

  StaticPageUseCase(this.repository);

  @override
  Future<List<StaticPages>> call(NoParams params) {
    return repository.getStaticPages();
  }
}
