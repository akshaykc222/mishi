// import 'dart:async';
// import 'dart:io';
//
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
// import 'package:just_audio/just_audio.dart' as audio;
// import 'package:mishi/core/hive_service.dart';
// import 'package:mishi/core/response_classify.dart';
// import 'package:mishi/core/usecase.dart';
// import 'package:mishi/mishi/data/app_remote_routes.dart';
// import 'package:mishi/mishi/data/models/music_gif_model.dart';
// import 'package:mishi/mishi/data/models/store_model.dart';
// import 'package:mishi/mishi/domain/entities/composition_entity.dart';
// import 'package:mishi/mishi/domain/entities/music_entity.dart';
// import 'package:mishi/mishi/domain/entities/player_status.dart';
// import 'package:mishi/mishi/domain/entities/sound_listing_entity.dart';
// import 'package:mishi/mishi/domain/use_cases/add_player_status.dart';
// import 'package:mishi/mishi/domain/use_cases/get_music_composition_usecase.dart';
// import 'package:mishi/mishi/domain/use_cases/music_gif_use_case.dart';
// import 'package:mishi/mishi/domain/use_cases/sound_listing_use_case.dart';
// import 'package:mishi/mishi/presentation/utils/app_colors.dart';
// import 'package:mishi/mishi/presentation/utils/enums.dart';
// import 'package:mishi/mishi/presentation/utils/pretty_print.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../../../data/models/sound_listing_model.dart';
//
// class MusicDetailController extends GetxController {
//   final GetMusicCompositionsUseCase compositionsUseCase;
//   final AddPlayerStatusUseCase playerStatusUseCase;
//   final MusicGifUseCase gifUseCase;
//   final SoundListUseCase soundListUseCase;
//   final HiveService hiveService;
//   MusicDetailController(this.compositionsUseCase, this.playerStatusUseCase,
//       this.hiveService, this.gifUseCase, this.soundListUseCase);
//   final compositionResponse =
//       ResponseClassify<List<CompositionEntity>>.loading().obs;
//
//   final isPlaying = false.obs;
//
//   changePlayingMode() {
//     isPlaying.value = !isPlaying.value;
//   }
//
//   final selectedMusic = Rxn<MusicEntity>();
//   changeSelectedMusicOnly(MusicEntity entity) {
//     selectedMusic.value = entity;
//   }
//
//   final tempCompositionList = <CompositionEntity>[].obs;
//   changeSelectedMusic(MusicEntity entity) {
//     selectedMusic.value = entity;
//     tempCompositionList.clear();
//     tempCompositionList.addAll(compositionList);
//     playerStatusUseCase.call(PlayerStatus(
//         musicName: entity.musicName,
//         description: entity.musicDescription,
//         image: entity.smallImageUrl,
//         status: AudioStatus.downloading));
//   }
//
//   changeListValues() {
//     prettyPrint(msg: "Calling");
//     compositionList.clear();
//     compositionList.addAll(tempCompositionList);
//     update();
//   }
//
//   final compositionList = <CompositionEntity>[].obs;
//   // final compositionAudioPlayers = <AudioPlayer>[].obs;
//   final compositionAudioPlayersJustAudio = <audio.AudioPlayer>[].obs;
//
//   final soundAudioPlayers = <audio.AudioPlayer>[].obs;
//
//   final isExpanded = false.obs;
//
//   changeExpanded() {
//     AssetsAudioPlayer.allPlayers().values.forEach((element) {
//       element.dispose();
//     });
//     isExpanded.value = !isExpanded.value;
//   }
//
//   final playerStatus = AudioStatus.canPlay.obs;
//   // changeAudioStatus(AudioStatus status) {
//   //   playerStatus.value = status;
//   // }
//
//   final isExpandedComposition = false.obs;
//   final isExpandedMotion = false.obs;
//   final isOtherExpanded = false.obs;
//   changeOtherExpanded() {
//     isOtherExpanded.value = !isOtherExpanded.value;
//   }
//
//   changeExpandedCompositions() {
//     isExpandedComposition.value = !isExpandedComposition.value;
//   }
//
//   changeExpandedMotion() {
//     isExpandedMotion.value = !isExpandedMotion.value;
//   }
//
//   final waitingPlayers = false.obs;
//   Future showMediaNotification() async {
//     const AndroidNotificationDetails("audio_channel_id", "audio_channel",
//         color: Colors.deepOrange,
//         enableLights: true,
//         playSound: false,
//         enableVibration: false,
//         largeIcon: DrawableResourceAndroidBitmap("img"),
//         showProgress: true,
//         styleInformation: MediaStyleInformation(
//             htmlFormatContent: true, htmlFormatTitle: true));
//
//     // await _flutterLocalNotificationsPlugin.show(
//     //     0,
//     //     selectedMusic.value?.musicName ?? "null",
//     //     selectedMusic.value?.musicDescription ?? "null",
//     //     platform);
//   }
//
//   playAudio({required MusicEntity musicEntity, bool? recursive}) async {
//     // showMediaNotification();
//     try {
//       waitingPlayers.value = true;
//       // compositionAudioPlayersJustAudio.asMap().forEach((index, value) {
//       //   compositionAudioPlayersJustAudio[index].dispose();
//       // });
//       for (var r in compositionAudioPlayersJustAudio) {
//         r.dispose();
//       }
//       compositionAudioPlayersJustAudio.clear();
//       for (var element in soundAudioPlayers) {
//         element.dispose();
//       }
//       soundAudioPlayers.clear();
//
//       // compositionAudioPlayers.clear();
//       if (recursive == true) {
//       } else {
//         compositionList.clear();
//         await getAllCompositions(musicEntity.musicId, musicEntity.musicName,
//             download: true);
//       }
//
//       if (kIsWeb) {
//         waitingPlayers.value = false;
//         playerStatusUseCase.call(PlayerStatus(
//             musicName: musicEntity.musicName,
//             description: musicEntity.musicDescription,
//             image: musicEntity.smallImageUrl,
//             status: AudioStatus.playing));
//         compositionAudioPlayersJustAudio
//             .addAll(List.generate(compositionList.length, (index) {
//           debugPrint(index.toString());
//           return audio.AudioPlayer();
//         }));
//
//         compositionAudioPlayersJustAudio.asMap().forEach((index, data) {
//           // var audioFile =
//           // File("${tempPath.path}/${compositionList[index].instrumentName}");
//           compositionAudioPlayersJustAudio[index]
//               .setUrl(compositionList[index].instrumentAudioUrl);
//           compositionAudioPlayersJustAudio[index].play();
//           // compositionAudioPlayers[i].pause();
//           playerStatus.value = AudioStatus.playing;
//           compositionAudioPlayersJustAudio[index]
//               .setVolume(compositionList[index].instrumentVolumeDefault * 0.1);
//           compositionAudioPlayersJustAudio[index]
//               .setLoopMode(audio.LoopMode.all);
//           // playerStatusUseCase.call(PlayerStatus(
//           //     musicName: selectedMusic.value?.musicName ?? "",
//           //     description: selectedMusic.value?.musicDescription ?? "",
//           //     image: selectedMusic.value?.smallImageUrl ?? "",
//           //     status: AudioStatus.playing));
//         });
//
//         debugPrint("playing audio");
//         waitingPlayers.value = false;
//       } else {
//         final tempPath = await getApplicationDocumentsDirectory();
//         final data = compositionList
//             .where((element) => element.status == AudioStatus.canPlay);
//         debugPrint(
//             " downloaded status : ${data.length} out of ${compositionList.length}");
//         if (data.length == compositionList.length) {
//           waitingPlayers.value = false;
//           playerStatusUseCase.call(PlayerStatus(
//               musicName: musicEntity.musicName,
//               description: musicEntity.musicDescription,
//               image: musicEntity.smallImageUrl,
//               status: AudioStatus.playing));
//           // compositionAudioPlayers.addAll(List.generate(data.length, (index) {
//           //   debugPrint(index.toString());
//           //   return AudioPlayer();
//           // }));
//           compositionAudioPlayersJustAudio
//               .addAll(List.generate(data.length, (index) {
//             debugPrint(index.toString());
//             return audio.AudioPlayer();
//           }));
//           compositionAudioPlayersJustAudio.asMap().forEach((index, data) {
//             var audioFile =
//                 File("${tempPath.path}/${compositionList[index].id}");
//             compositionAudioPlayersJustAudio[index].setFilePath(audioFile.path);
//             compositionAudioPlayersJustAudio[index].play();
//             compositionAudioPlayersJustAudio[index]
//                 .setLoopMode(audio.LoopMode.all);
//             compositionAudioPlayersJustAudio[index].setVolume(
//                 compositionList[index].instrumentVolumeDefault * 0.01);
//           });
//           // compositionAudioPlayers.asMap().forEach((index, data) {
//           //   var audioFile =
//           //       File("${tempPath.path}/${compositionList[index].instrumentName}");
//           //   // compositionAudioPlayers[index].play(
//           //   //   DeviceFileSource(audioFile.path),
//           //   //   volume: compositionList[index].instrumentVolumeDefault * 0.02,
//           //   // );
//           //   // // compositionAudioPlayers[i].pause();
//           //   // playerStatus.value = AudioStatus.playing;
//           //   // compositionAudioPlayers[index].setReleaseMode(ReleaseMode.loop);
//           //   // if (index == 0) {
//           //   //   // compositionAudioPlayers[index].
//           //   //   compositionAudioPlayers[index]
//           //   //       .getCurrentPosition()
//           //   //       .asStream()
//           //   //       .listen((event) async {
//           //   //     var musicTot = await compositionAudioPlayers[index].getDuration();
//           //   //     prettyPrint(msg: "${event?.inSeconds} == ${musicTot?.inSeconds}");
//           //   //     // musicTot =musicTot
//           //   //     // if(event.inSeconds== musicTot?.inSeconds.)
//           //   //   });
//           //   // }
//           //
//           //   // compositionAudioPlayers[index].
//           //   // playerStatusUseCase.call(PlayerStatus(
//           //   //     musicName: selectedMusic.value?.musicName ?? "",
//           //   //     description: selectedMusic.value?.musicDescription ?? "",
//           //   //     image: selectedMusic.value?.smallImageUrl ?? "",
//           //   //     status: AudioStatus.playing));
//           // });
//           if (soundListingBox.value!.values.isEmpty) {
//             await getSoundListing();
//           }
//           await setSoundAudioPlayer(soundListingBox.value!.values.toList());
//           debugPrint("playing audio");
//           if (getTimerinSeconds() != 0) {
//             prettyPrint(msg: "TIMER STARTED");
//             startTimer(getTimerinSeconds());
//           } else {
//             prettyPrint(msg: "NOT SHOWING TIMER");
//           }
//           waitingPlayers.value = false;
//         } else {
//           debugPrint("downloading ....");
//           playerStatusUseCase.call(PlayerStatus(
//               musicName: selectedMusic.value?.musicName ?? "",
//               description: selectedMusic.value?.musicDescription ?? "",
//               image: selectedMusic.value?.smallImageUrl ?? "",
//               status: AudioStatus.downloading));
//           waitingPlayers.value = true;
//           Future.delayed(const Duration(seconds: 1), () {
//             playAudio(musicEntity: musicEntity, recursive: true);
//           });
//         }
//       }
//     } catch (e) {
//       waitingPlayers.value = false;
//       await stopAllPlayers();
//     }
//   }
//
//   changePlayerStatus(PlayerStatus data) {
//     playerStatusUseCase.call(data);
//   }
//
//   getAllCompositions(String id, String musicName, {bool? download}) async {
//     compositionResponse.value = ResponseClassify.loading();
//     try {
//       compositionResponse.value =
//           ResponseClassify.completed(await compositionsUseCase.call(id));
//       gifUseCase.call(id);
//       compositionList.clear();
//       compositionList.addAll(compositionResponse.value.data ?? []);
//
//       // await playerStatusUseCase.call(PlayerStatus(
//       //     musicName: selectedMusic.value?.musicName ?? "",
//       //     description: selectedMusic.value?.musicDescription ?? "",
//       //     image: selectedMusic.value?.smallImageUrl ?? "",
//       //     status: AudioStatus.downloading));
//       prettyPrint(msg: "composition list length ${compositionList.length}");
//       waitingPlayers.value = false;
//       if (!kIsWeb && download == true) {
//         downloadAllCompositions(musicName);
//       } else {}
//     } catch (e) {
//       waitingPlayers.value = false;
//       compositionResponse.value = ResponseClassify.error(e.toString());
//     }
//   }
//
//   Widget compositionDataItem(
//       {required CompositionEntity model, required int index}) {
//     final defaultVolume = model.instrumentVolumeDefault.obs;
//     return Row(
//       children: [
//         Expanded(
//             // flex: 2,
//             child: Padding(
//           padding: const EdgeInsets.only(left: 16.0),
//           child: Text(
//             model.instrumentName,
//             style: const TextStyle(color: AppColors.textColor),
//           ),
//         )),
//         Expanded(
//             // flex: 1,
//             child: CupertinoSlider(
//           min: 0,
//           max: 1,
//           thumbColor:
//               defaultVolume.value == 0 ? Colors.grey : AppColors.thumbColor,
//           activeColor: AppColors.thumbColor.withOpacity(0.6),
//           // inactiveColor: Colors.white60,
//           onChanged: (double value) {
//             defaultVolume.value = ((value) * 100).toInt();
//             // if (defaultVolume.value > 70) {
//             //   compositionAudioPlayers[index].resume();
//             // }
//             compositionAudioPlayersJustAudio[index].setVolume(value);
//             model.instrumentVolumeDefault = defaultVolume.value;
//             if (tempCompositionList.contains(model)) {
//               var data =
//                   tempCompositionList.firstWhere((element) => element == model);
//               data.instrumentVolumeDefault = defaultVolume.value;
//             }
//             compositionResponse.refresh();
//           },
//           value: defaultVolume.value * 0.01,
//         ))
//       ],
//     );
//   }
//
//   setSoundAudioPlayer(List<SoundListingEntity> data) {
//     for (var element in data) {
//       element.volume = 0.0;
//       soundAudioPlayers.add(audio.AudioPlayer());
//     }
//     soundAudioPlayers.asMap().forEach((index, value) async {
//       prettyPrint(msg: "Seting sound $index");
//       var tempDir = await getApplicationDocumentsDirectory();
//       var temFile = File("${tempDir.path}/s${data[index].id}");
//       if (await temFile.exists()) {
//         soundAudioPlayers[index].setFilePath(temFile.path);
//         soundAudioPlayers[index].setLoopMode(audio.LoopMode.all);
//         soundAudioPlayers[index].play();
//
//         soundAudioPlayers[index].setVolume(0.0);
//       } else {
//         Future.delayed(const Duration(seconds: 20), () async {
//           if (await temFile.exists()) {
//             soundAudioPlayers[index].setFilePath(temFile.path);
//             soundAudioPlayers[index].play();
//             soundAudioPlayers[index].setLoopMode(audio.LoopMode.all);
//             soundAudioPlayers[index].setVolume(0.0);
//           }
//         });
//       }
//     });
//   }
//
//   Widget soundListDataItem(
//       {required SoundListingEntity model,
//       required int index,
//       required bool show}) {
//     final defaultVolume = model.volume.obs;
//     // soundAudioPlayers[index].setVolume(model.volume ?? 0.0);
//     return Row(
//       children: [
//         Expanded(
//             // flex: 1,
//             child: Padding(
//           padding: const EdgeInsets.only(left: 16.0),
//           child: Text(
//             model.soundName,
//             style: const TextStyle(color: AppColors.textColor),
//           ),
//         )),
//         show
//             ? Obx(() => Expanded(
//                     // flex: 2,
//                     child: CupertinoSlider(
//                   min: 0,
//                   max: 1,
//                   thumbColor: defaultVolume.value == 0
//                       ? Colors.grey
//                       : AppColors.thumbColor,
//                   activeColor: AppColors.thumbColor.withOpacity(0.6),
//                   // inactiveColor: Colors.white60,
//                   onChanged: (double value) {
//                     defaultVolume.value = (value * 100).toDouble();
//                     // if (defaultVolume.value > 70) {
//                     //   compositionAudioPlayers[index].resume();
//                     // }
//
//                     soundAudioPlayers[index].setVolume(value);
//                     model.volume = defaultVolume.value;
//                     // compositionResponse.refresh();
//                   },
//                   value: (defaultVolume.value ?? 0) * 0.01,
//                 )))
//             : Expanded(
//                 // flex: 2,
//                 child: CupertinoSlider(
//                 min: 0,
//                 max: 1,
//                 thumbColor: AppColors.thumbColor,
//                 activeColor: AppColors.thumbColor.withOpacity(0.6),
//                 onChanged: (double value) {
//                   // compositionResponse.refresh();
//                 },
//                 value: 0,
//               ))
//       ],
//     );
//   }
//
//   downloadAllCompositions(String musicName) async {
//     var tempDir = await getApplicationDocumentsDirectory();
//
//     compositionResponse.value.data?.forEach((element) async {
//       var temFile = File("${tempDir.path}/${element.id}");
//       if (await temFile.exists()) {
//         // playerStatusUseCase.call(PlayerStatus(musicName: selectedMusic.value?.musicName??"", description: selectedMusic.value?.musicDescription??"", image: selectedMusic.value?.smallImageUrl??"", status: AudioStatus.canPlay));
//         element.status = AudioStatus.canPlay;
//         // if(compositionResponse.value.data!.last==element){
//         //   waitingPlayers.value=false;
//         // }
//       } else {
//         List<String> tempLoc = [];
//         compositionResponse.value.data?.forEach((element) {
//           var temFile = File("${tempDir.path}/${element.id}");
//           tempLoc.add(temFile.path);
//         });
//         prettyPrint(
//             msg:
//                 "islast item ${compositionResponse.value.data?.last.id == element.id}");
//         downloadAudio(
//           entity: element,
//           musicName: musicName,
//           isLasItem: compositionResponse.value.data?.last.id == element.id,
//           storeLoc: tempLoc,
//         );
//       }
//
//       debugPrint("not waiting for fully download ${element.musicId}");
//     });
//   }
//
//   List<StoreModel> tempStoreItems = [];
//   downloadAudio(
//       {required CompositionEntity entity,
//       required String musicName,
//       required bool isLasItem,
//       required List<String> storeLoc}) async {
//     var tempDir = await getApplicationDocumentsDirectory();
//     var temFile = File("${tempDir.path}/${entity.id}");
//
//     var response = await http.Client()
//         .send(http.Request('GET', Uri.parse(entity.instrumentAudioUrl)));
//
//     var tempWrite = temFile.openWrite();
//     var length = response.contentLength ?? 0;
//     var received = 0;
//     response.stream
//         .map((s) {
//           received += s.length;
//           debugPrint(
//               "${(received / length) * 100}  % ${entity.instrumentName} file size : ${temFile.lengthSync()} ");
//           double per = (received / length) * 100;
//           if (per > 70) {
//             entity.status = AudioStatus.canPlay;
//
//             compositionResponse.refresh();
//           }
//           if (per == 100) {
//             entity.dCompleted = true;
//             compositionResponse.refresh();
//             // tempStoreItems.add(StoreModel(
//             //   musicName: selectedMusic.value?.musicName ?? "",
//             //   storeLoc: storeLoc,
//             //   totSize: temFile.lengthSync().toDouble(),
//             //   totalMusic: compositionList.length,
//             // ));
//             prettyPrint(msg: "added store model $musicName");
//             // if (isLasItem) {
//             //
//             //   double tot = 0.0;
//             //   for (var element in storeLoc) {
//             //     var file = File(element);
//             //     if (file.existsSync()) {
//             //       tot = tot + file.lengthSync().toDouble();
//             //     }
//             //   }
//             //   hiveService.addBoxes<StoreModel>([
//             //     StoreModel(
//             //       musicName: selectedMusic.value?.musicName ?? "",
//             //       storeLoc: storeLoc,
//             //       totSize: tot,
//             //       totalMusic: compositionList.length,
//             //     )
//             //   ], AppBoxNames.cache_box);
//             // }
//           }
//           return s;
//         })
//         .pipe(tempWrite)
//         .whenComplete(() {
//           if (isLasItem) {
//             double tot = 0.0;
//             for (var element in storeLoc) {
//               var file = File(element);
//               if (file.existsSync()) {
//                 tot = tot + file.lengthSync().toDouble();
//               }
//             }
//             hiveService.addBoxes<StoreModel>([
//               StoreModel(
//                 musicName: selectedMusic.value?.musicName ?? "",
//                 storeLoc: storeLoc,
//                 totSize: tot,
//                 totalMusic: compositionList.length,
//               )
//             ], AppBoxNames.cache_box);
//           }
//         });
//   }
//
//   pauseAllPlayer(MusicEntity entity) {
//     if (getTimerinSeconds() != 0) {
//       pauseTimer();
//     }
//
//     prettyPrint(msg: "${compositionAudioPlayersJustAudio.length}");
//     playerStatusUseCase.call(PlayerStatus(
//         musicName: entity.musicName,
//         description: entity.musicDescription,
//         image: entity.smallImageUrl,
//         status: AudioStatus.pause));
//     compositionAudioPlayersJustAudio.asMap().forEach((key, value) {
//       compositionAudioPlayersJustAudio[key].pause();
//     });
//     soundAudioPlayers.asMap().forEach((key, value) {
//       soundAudioPlayers[key].pause();
//     });
//     playerStatus.value = AudioStatus.pause;
//     prettyPrint(msg: "PAUSING ALL PLAYERS");
//   }
//
//   stopAllPlayers() async {
//     compositionAudioPlayersJustAudio.asMap().forEach((key, value) {
//       compositionAudioPlayersJustAudio[key].stop();
//     });
//     soundAudioPlayers.asMap().forEach((key, value) {
//       soundAudioPlayers[key].stop();
//     });
//     playerStatus.value = AudioStatus.pause;
//     final box =
//         await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
//     box.clear();
//     prettyPrint(msg: "STOPPING ALL PLAYERS");
//   }
//
//   resumeAllPlayers(MusicEntity entity) {
//     if (getTimerinSeconds() != 0) {
//       unpauseTimer();
//     }
//
//     // showMediaNotification();
//
//     // compositionAudioPlayersJustAudio.asMap().forEach((key, value) {
//     //   // var vl = compositionAudioPlayersJustAudio[key].volume;
//     //   // await compositionAudioPlayersJustAudio[key].setVolume(0);
//     //   compositionAudioPlayersJustAudio[key].play();
//     //   // compositionAudioPlayersJustAudio[key].setVolume(compositionList[key].instrumentVolumeDefault.toDouble());
//     // });
//     for (var j in compositionAudioPlayersJustAudio) {
//       j.play();
//     }
//     for (var k in soundAudioPlayers) {
//       k.play();
//     }
//     // soundAudioPlayers.asMap().forEach((key, value) {
//     //   // var vl = soundAudioPlayers[key].volume;
//     //   // await soundAudioPlayers[key].setVolume(0);
//     //   soundAudioPlayers[key].play();
//     //   // soundAudioPlayers[key].setVolume(vl);
//     // });
//     playerStatusUseCase.call(PlayerStatus(
//         musicName: entity.musicName,
//         description: entity.musicDescription ?? "",
//         image: entity.smallImageUrl,
//         status: AudioStatus.playing));
//     playerStatus.value = AudioStatus.playing;
//     prettyPrint(msg: "RESUMING ALL PLAYERS");
//   }
//
//   final cacheBox = Rxn<Box<StoreModel>>();
//   final playerBox = Rxn<Box<PlayerStatus>>();
//   final motionGifBox = Rxn<Box<MusicGifModel>>();
//   final toogleBox = Rxn<Box<bool>>();
//   final soundListingBox = Rxn<Box<SoundListingModel>>();
//   disposePlayers() {
//     // compositionAudioPlayersJustAudio.asMap().forEach((key, value) {
//     //   compositionAudioPlayersJustAudio[key].dispose();
//     // });
//     compositionAudioPlayersJustAudio.asMap().forEach((key, value) {
//       compositionAudioPlayersJustAudio[key].dispose();
//     });
//     soundAudioPlayers.asMap().forEach((key, value) {
//       soundAudioPlayers[key].dispose();
//     });
//     _timer.value?.cancel();
//   }
//
//   clearDb() async {
//     final box =
//         await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
//     box.clear();
//   }
//
//   getSoundListing() async {
//     try {
//       var d = await soundListUseCase.call(NoParams());
//       var tempDir = await getApplicationDocumentsDirectory();
//
//       for (var element in d) {
//         var temFile = File("${tempDir.path}/s${element.id}");
//         prettyPrint(msg: "tempFile exists ${await temFile.exists()}");
//         if (await temFile.exists()) {
//           GetStorage storage = GetStorage();
//           String? e = storage.read('lastDate');
//
//           DateTime eDate = DateTime.parse(e ?? "");
//           prettyPrint(msg: "e ${eDate.difference(element.updatedDate).inDays}");
//           if (eDate.difference(element.updatedDate).inDays > 0) {
//             prettyPrint(msg: "this part is wrking");
//             downloadSoundAudio(entity: element);
//           }
//         } else {
//           GetStorage storage = GetStorage();
//           storage.write("lastDate", element.updatedDate.toIso8601String());
//           downloadSoundAudio(entity: element);
//         }
//       }
//     } catch (e) {
//       prettyPrint(msg: e.toString());
//     }
//   }
//
//   changeToogleFader(bool value) async {
//     var storage = GetStorage();
//     toogleFader.value = value;
//     storage.write(AppBoxNames.toogle_fader, value);
//   }
//
//   final toogleFader = false.obs;
//   bool getToogleFader() {
//     var storage = GetStorage();
//     final d = storage.read(AppBoxNames.toogle_fader);
//     if (d != null) {
//       toogleFader.value = d;
//     } else {
//       toogleFader.value = false;
//       return false;
//     }
//
//     return d;
//   }
//
//   int getTimerinSeconds() {
//     String time = getTiming();
//     switch (time) {
//       case "infinite":
//         return 0;
//       case "10 mins":
//         return 600;
//       case "20 mins":
//         return 1200;
//       case "30 mins":
//         return 1800;
//       case "40 mins":
//         return 2400;
//       case "1 hour":
//         return 3600;
//       case "2 hours":
//         return 7200;
//       case "4 hours":
//         return 14400;
//       case "8 hours":
//         return 28800;
//       default:
//         return 0;
//     }
//   }
//
//   writeTiming(String data) {
//     var storage = GetStorage();
//     prettyPrint(msg: "writing time$data");
//     storage.write('timer', data);
//     getTiming();
//   }
//
//   final timingValue = "30 mins".obs;
//   String getTiming() {
//     var storage = GetStorage();
//     if (storage.hasData('timer')) {
//       final d = storage.read('timer');
//       timingValue.value = d;
//       return d;
//     } else {
//       timingValue.value = "30 mins";
//       return "30 mins";
//     }
//   }
//
//   initCache() async {
//     cacheBox.value =
//         await hiveService.getBox<StoreModel>(boxName: AppBoxNames.cache_box);
//   }
//
//   @override
//   Future<void> onInit() async {
//     playerBox.value =
//         await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
//     toogleBox.value =
//         await hiveService.getBox<bool>(boxName: AppBoxNames.toogle_fader);
//     motionGifBox.value =
//         await hiveService.getBox<MusicGifModel>(boxName: AppBoxNames.gifBox);
//     soundListingBox.value = await hiveService.getBox<SoundListingModel>(
//         boxName: AppBoxNames.soundListingBox);
//     cacheBox.value =
//         await hiveService.getBox<StoreModel>(boxName: AppBoxNames.cache_box);
//     getSoundListing();
//     super.onInit();
//   }
//   //timer
//
//   final _timer = Rxn<Timer>();
//
//   Duration get currentDuration => _currentDuration;
//   final Duration _currentDuration = Duration.zero;
//
//   bool get isRunning => _timer.value != null;
//
//   //timer setting
//   @override
//   void dispose() {
//     stopAllPlayers();
//     disposePlayers();
//     super.dispose();
//   }
//
//   final start = 0.obs;
//
//   void startTimer(int timerDuration) {
//     int len = getTimerinSeconds();
//     double fadeTime = len * 0.30;
//     if (_timer.value != null) {
//       _timer.value?.cancel();
//     }
//     prettyPrint(msg: "starting timer");
//
//     start.value = timerDuration;
//
//     const oneSec = Duration(seconds: 1);
//
//     _timer.value = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (start.value < 1) {
//           stopAllPlayers();
//           timer.cancel();
//         } else {
//           if (getToogleFader()) {
//             prettyPrint(msg: "starting timer $fadeTime");
//             if (start.value < 15) {
//               prettyPrint(msg: "fade time wrking $fadeTime");
//               changeAllPlayerVolumeByFade(fadeTime);
//             }
//           }
//           start.value = start.value - 1;
//         }
//       },
//     );
//   }
//
//   changeAllPlayerVolumeByFade(double fadeLen) {
//     for (var player in compositionAudioPlayersJustAudio) {
//       // var v = (player.volume / 5);
//       // prettyPrint(msg: "decresing length $v");
//       player.setVolume(player.volume * 0.75);
//     }
//     for (var player in soundAudioPlayers) {
//       // var v = (player.volume / 5);
//       player.setVolume(player.volume * 0.75);
//     }
//   }
//
//   void pauseTimer() {
//     if (_timer.value != null) _timer.value?.cancel();
//   }
//
//   void unpauseTimer() => startTimer(start.value);
//
//   downloadSoundAudio({required SoundListingEntity entity}) async {
//     var tempDir = await getApplicationDocumentsDirectory();
//     var temFile = File("${tempDir.path}/s${entity.id}");
//
//     var response = await http.Client()
//         .send(http.Request('GET', Uri.parse(entity.soundAudioUrl)));
//
//     var tempWrite = temFile.openWrite();
//     var length = response.contentLength ?? 0;
//     var received = 0;
//
//     response.stream.map((s) {
//       received += s.length;
//       debugPrint(
//           "${(received / length) * 100}  % ${entity.soundAudioUrl} file size : ${temFile.lengthSync()} ");
//       double per = (received / length) * 100;
//
//       if (per == 100) {
//         prettyPrint(msg: "added store model ${entity.soundName}");
//         // hiveService.addBoxes<StoreModel>([
//         //   StoreModel(
//         //     musicName: "Sounds",
//         //     storeLoc: temFile.path,
//         //     totSize: temFile.lengthSync().toDouble(),
//         //   )
//         // ], AppBoxNames.cache_box);
//       }
//       return s;
//     }).pipe(tempWrite);
//   }
// }
