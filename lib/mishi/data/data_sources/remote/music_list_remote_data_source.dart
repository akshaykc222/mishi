import 'package:flutter/foundation.dart';
import 'package:mishi/core/api_provider.dart';
import 'package:mishi/core/hive_service.dart';
import 'package:mishi/mishi/data/app_remote_routes.dart';
import 'package:mishi/mishi/data/models/composition_model.dart';
import 'package:mishi/mishi/data/models/intro_model.dart';
import 'package:mishi/mishi/data/models/music_gif_model.dart';
import 'package:mishi/mishi/data/models/music_model.dart';
import 'package:mishi/mishi/data/models/sound_listing_model.dart';
import 'package:mishi/mishi/domain/entities/intro_entity.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/domain/entities/sound_listing_entity.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

import '../../../domain/entities/composition_entity.dart';
import '../../../domain/entities/music_gif_entity.dart';
import '../../../presentation/utils/constants.dart';
import '../../models/static_pages.dart';

abstract class MusicListRemoteDataSource {
  Future<List<MusicEntity>> getMusic(String tag);
  Future<List<CompositionEntity>> getMusicCompositions(String musicId);
  Future<List<SoundListingEntity>> getSoundListings();
  Future<List<MusicGifEntity>> getMusicGif(String musicId);
  Future<List<IntroEntity>> getIntroSlides();
  Future<List<StaticPages>> getStaticPages();
  // Future<List<IntroEntity>> getIntroSlides();
}

class MusicListRemoteDataSourceImpl extends MusicListRemoteDataSource {
  final ApiProvider apiProvider;
  final HiveService hiveService;

  MusicListRemoteDataSourceImpl(this.apiProvider, this.hiveService);

  @override
  Future<List<MusicEntity>> getMusic(String tag) async {
    final data = await apiProvider.get(
        "${AppRemoteRoutes.musicList}tag=$tag&platform=${kIsWeb ? "web" : "android"}");
    // prettyPrint(msg: data.toString());
    final listItem = List<MusicModel>.from(
        data['musicListings'].map((x) => MusicModel.fromJson(x)));
    await hiveService.clearAllValues<MusicModel>(AppBoxNames.musicBox);
    hiveService.addBoxes<MusicModel>(listItem, AppBoxNames.musicBox);

    return listItem;
  }

  @override
  Future<List<CompositionEntity>> getMusicCompositions(String musicId) async {
    final data = await apiProvider.get(
        "${AppRemoteRoutes.musicCompositions}musicID=$musicId&platform=${kIsWeb ? "web" : "android"}");
    final listItems = List<CompositionModel>.from(
        data['compositionListings'].map((x) => CompositionModel.fromJson(x)));
    // await hiveService
    //     .clearAllValues<CompositionModel>(AppBoxNames.compositionBox);
    hiveService.addBoxes<CompositionModel>(
        listItems, AppBoxNames.compositionBox);

    return listItems;
  }

  @override
  Future<List<MusicGifEntity>> getMusicGif(String musicId) async {
    await hiveService.clearAllValues<MusicGifModel>(AppBoxNames.gifBox);
    bool paid = await IsProUser();
    final data = await apiProvider.get(
        "${AppRemoteRoutes.musicVideo}musicID=$musicId&platform=${kIsWeb ? "web" : "android"}&paidUser=${paid ? 1 : 0}");
    prettyPrint(
        msg:
            "${AppRemoteRoutes.musicVideo}musicID=$musicId&platform=${kIsWeb ? "web" : "android"}&paidUser=${paid ? 1 : 0}");
    final listItems = List<MusicGifModel>.from(
        data['motionImagesListings'].map((x) => MusicGifModel.fromJson(x)));
    // await hiveService.clearAllValues<MusicGifModel>(AppBoxNames.gifBox);
    hiveService.addBoxes<MusicGifModel>(listItems, AppBoxNames.gifBox);
    return listItems;
  }

  @override
  Future<List<IntroEntity>> getIntroSlides() async {
    final data = await apiProvider.get(
        "${AppRemoteRoutes.introScreen}platform=${kIsWeb ? "web" : "android"}");
    final listData =
        List<IntroEntity>.from(data['tags'].map((x) => IntroModel.fromJson(x)));
    listData.sort((a, b) => a.priority.compareTo(b.priority));
    return listData;
  }

  @override
  Future<List<SoundListingEntity>> getSoundListings() async {
    final data = await apiProvider.get(
        "${AppRemoteRoutes.soundListings}platform=${kIsWeb ? "web" : "android"}");
    final listData = List<SoundListingModel>.from(
        data['soundsListings'].map((x) => SoundListingModel.fromJson(x)));
    prettyPrint(msg: listData.toString());
    await hiveService
        .clearAllValues<SoundListingModel>(AppBoxNames.soundListingBox);
    hiveService.addBoxes<SoundListingModel>(
        listData, AppBoxNames.soundListingBox);
    listData.sort((a, b) => a.soundDisplayOrder.compareTo(b.soundDisplayOrder));
    return listData;
  }

  @override
  Future<List<StaticPages>> getStaticPages() async {
    final data = await apiProvider.get(AppRemoteRoutes.staticPages);
    return List<StaticPages>.from(
        data["appStaticPages"].map((x) => StaticPages.fromJson(x)));
  }
}
