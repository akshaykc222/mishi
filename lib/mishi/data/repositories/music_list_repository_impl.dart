import 'package:mishi/mishi/data/data_sources/local/music_list_local_data_source.dart';
import 'package:mishi/mishi/data/data_sources/remote/music_list_remote_data_source.dart';
import 'package:mishi/mishi/data/models/static_pages.dart';
import 'package:mishi/mishi/domain/entities/composition_entity.dart';
import 'package:mishi/mishi/domain/entities/intro_entity.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/domain/entities/music_gif_entity.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/domain/entities/sound_listing_entity.dart';
import 'package:mishi/mishi/domain/repositories/music_list_repository.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

import '../../../core/connection_checker.dart';

class MusicListRepositoryImpl extends MusicListRepository {
  ConnectionChecker connectionChecker;
  final MusicListRemoteDataSource dataSource;
  final MusicListLocalDataSource localDataSource;

  MusicListRepositoryImpl(
    this.connectionChecker,
    this.dataSource,
    this.localDataSource,
  );

  @override
  Future<List<MusicEntity>> getMusic(String tag) {
    return dataSource.getMusic(tag);
  }

  @override
  Future<List<CompositionEntity>> getMusicCompositions(String musicId) {
    return dataSource.getMusicCompositions(musicId);
  }

  @override
  Future<void> playerStatus(PlayerStatus data) {
    return localDataSource.saveCurrentPlaying(data);
  }

  @override
  Future<List<MusicGifEntity>> getMusicVideos(String musicId) {
    return dataSource.getMusicGif(musicId);
  }

  @override
  Future<List<IntroEntity>> getIntroSlides() {
    return dataSource.getIntroSlides();
  }

  @override
  Future<List<SoundListingEntity>> getSoundListings() {
    prettyPrint(msg: "getting sound list");
    return dataSource.getSoundListings();
  }

  @override
  Future<List<StaticPages>> getStaticPages() {
    return dataSource.getStaticPages();
  }
}
