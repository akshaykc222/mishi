import 'package:mishi/mishi/data/models/static_pages.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/domain/entities/sound_listing_entity.dart';

import '../entities/composition_entity.dart';
import '../entities/intro_entity.dart';
import '../entities/music_gif_entity.dart';

abstract class MusicListRepository {
  Future<List<MusicEntity>> getMusic(String tag);
  Future<List<CompositionEntity>> getMusicCompositions(String musicId);
  Future<void> playerStatus(PlayerStatus data);
  Future<List<MusicGifEntity>> getMusicVideos(String musicId);
  Future<List<IntroEntity>> getIntroSlides();
  Future<List<SoundListingEntity>> getSoundListings();
  Future<List<StaticPages>> getStaticPages();
}
