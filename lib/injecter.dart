// import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mishi/core/connection_checker.dart';
import 'package:mishi/mishi/data/data_sources/local/music_list_local_data_source.dart';
import 'package:mishi/mishi/data/data_sources/remote/music_list_remote_data_source.dart';
import 'package:mishi/mishi/data/data_sources/remote/music_tag_data_source.dart';
import 'package:mishi/mishi/data/models/composition_model.dart';
import 'package:mishi/mishi/data/models/music_gif_model.dart';
import 'package:mishi/mishi/data/models/music_model.dart';
import 'package:mishi/mishi/data/models/sound_listing_model.dart';
import 'package:mishi/mishi/data/models/store_model.dart';
import 'package:mishi/mishi/data/repositories/category_repository_impl.dart';
import 'package:mishi/mishi/data/repositories/connection_repository_impl.dart';
// import 'package:mishi/mishi/data/repositories/connection_repository_impl.dart';
import 'package:mishi/mishi/data/repositories/music_list_repository_impl.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/domain/repositories/category_repository.dart';
import 'package:mishi/mishi/domain/repositories/music_list_repository.dart';
import 'package:mishi/mishi/domain/use_cases/add_player_status.dart';
import 'package:mishi/mishi/domain/use_cases/conncetion_check_usecase.dart';
import 'package:mishi/mishi/domain/use_cases/get_music_composition_usecase.dart';
import 'package:mishi/mishi/domain/use_cases/intro_use_case.dart';
import 'package:mishi/mishi/domain/use_cases/music_gif_use_case.dart';
import 'package:mishi/mishi/domain/use_cases/music_list_usecase.dart';
import 'package:mishi/mishi/domain/use_cases/sound_listing_use_case.dart';
import 'package:mishi/mishi/domain/use_cases/tag_list_usecase.dart';

import 'core/api_provider.dart';
import 'core/hive_service.dart';
import 'mishi/data/models/categories_model.dart';
import 'mishi/domain/repositories/connection_repository.dart';
import 'mishi/presentation/manager/controllers/music_detail_controller.dart';
import 'mishi/presentation/utils/app_data.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //data source
  sl.registerLazySingleton<MusicListRemoteDataSource>(
      () => MusicListRemoteDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<MusicListLocalDataSource>(
      () => MusicListLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<MusicTagDataSource>(
      () => MusicTagDataSourceImpl(sl(), sl()));
  // sl.registerLazySingleton<ConnectionChecker>(
  //     () => ConnectionCheckerImpl(sl()));

  //repository
  sl.registerLazySingleton<MusicListRepository>(() => MusicListRepositoryImpl(
        sl(),
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl()));
  // sl.registerLazySingleton<ConnectionRepository>(
  //     () => ConnectionCheckerImpl(sl()));
  sl.registerLazySingleton<ConnectionRepository>(
      () => ConnectionRepositoryImpl(sl()));
  //usecase

  sl.registerLazySingleton<MusicListUseCase>(() => MusicListUseCase(sl()));
  sl.registerLazySingleton<SoundListUseCase>(() => SoundListUseCase(sl()));
  sl.registerLazySingleton<TagListUseCase>(() => TagListUseCase(sl(), sl()));
  sl.registerLazySingleton<GetMusicCompositionsUseCase>(
      () => GetMusicCompositionsUseCase(sl(), sl()));
  sl.registerLazySingleton<ConnectionCheckUseCase>(
      () => ConnectionCheckUseCase(sl()));
  sl.registerLazySingleton<StaticPageUseCase>(() => StaticPageUseCase(sl()));
  sl.registerLazySingleton<AddPlayerStatusUseCase>(
      () => AddPlayerStatusUseCase(sl()));
  sl.registerLazySingleton<MusicGifUseCase>(() => MusicGifUseCase(sl()));

  //core
  sl.registerLazySingleton<ApiProvider>(() => ApiProvider());
  sl.registerLazySingleton<IntroUseCase>(() => IntroUseCase(sl()));
  sl.registerLazySingleton<HiveService>(() => HiveService());
  sl.registerLazySingleton<MusicDetailController>(() => MusicDetailController(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));
  await GetStorage.init();
  // sl.registerSingleton(NavigationBarMoksha(sl()));
  if (!kIsWeb) {
    sl.registerLazySingleton<ConnectionChecker>(
        () => ConnectionCheckerImpl(sl()));
  }

  if (!kIsWeb) {
    sl.registerLazySingleton<InternetConnectionChecker>(
        () => InternetConnectionChecker());
  }

  sl.registerLazySingleton(() => GetStorage());
  sl.registerLazySingleton<AppData>(() => AppData());
  //hive
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(MusicModelAdapter());
  Hive.registerAdapter(CompositionModelAdapter());
  Hive.registerAdapter(PlayerStatusAdapter());
  Hive.registerAdapter(MusicGifModelAdapter());
  Hive.registerAdapter(SoundListingModelAdapter());
  Hive.registerAdapter(StoreModelAdapter());

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings("img");

  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //       channelGroupKey: 'media_player',
  //       icon: 'resource://drawable/res_media_icon',
  //       channelKey: 'media_player',
  //       channelName: 'Media player controller',
  //       channelDescription: 'Media player controller',
  //       defaultPrivacy: NotificationPrivacy.Public,
  //       enableVibration: false,
  //       enableLights: false,
  //       playSound: false,
  //       locked: true),
  // ], channelGroups: [
  //   NotificationChannelGroup(
  //       channelGroupkey: 'media_player', channelGroupName: 'Media Player ')
  // ]);
  // Magic.instance = Magic("pk_live_21ECF09CC2BC10BF");
}
