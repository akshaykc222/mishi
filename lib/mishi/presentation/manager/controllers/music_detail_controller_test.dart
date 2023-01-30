import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mishi/core/custom_exception.dart';
import 'package:mishi/core/hive_service.dart';
import 'package:mishi/core/response_classify.dart';
import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/data/app_remote_routes.dart';
import 'package:mishi/mishi/data/models/music_gif_model.dart';
import 'package:mishi/mishi/data/models/store_model.dart';
import 'package:mishi/mishi/domain/entities/composition_entity.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/domain/entities/sound_listing_entity.dart';
import 'package:mishi/mishi/domain/use_cases/add_player_status.dart';
import 'package:mishi/mishi/domain/use_cases/get_music_composition_usecase.dart';
import 'package:mishi/mishi/domain/use_cases/music_gif_use_case.dart';
import 'package:mishi/mishi/domain/use_cases/sound_listing_use_case.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:mishi/mishi/presentation/utils/enums.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/models/sound_listing_model.dart';
import '../../../domain/entities/music_gif_entity.dart';

class MusicDetailController extends GetxController {
  final GetMusicCompositionsUseCase compositionsUseCase;
  final AddPlayerStatusUseCase playerStatusUseCase;
  final MusicGifUseCase gifUseCase;
  final SoundListUseCase soundListUseCase;
  final HiveService hiveService;
  MusicDetailController(this.compositionsUseCase, this.playerStatusUseCase,
      this.hiveService, this.gifUseCase, this.soundListUseCase);
  final compositionResponse =
      ResponseClassify<List<CompositionEntity>>.loading().obs;
  final motionResponse = ResponseClassify<List<MusicGifEntity>>.loading().obs;
  final isPlaying = false.obs;

  changePlayingMode() {
    isPlaying.value = !isPlaying.value;
  }

  final selectedMusic = Rxn<MusicEntity>();
  changeSelectedMusicOnly(MusicEntity entity) {
    selectedMusic.value = entity;
  }

  final tempCompositionList = <CompositionEntity>[].obs;
  changeSelectedMusic(MusicEntity entity) async {
    selectedMusic.value = entity;
    tempCompositionList.clear();
    motionResponse.value = ResponseClassify.loading();
    tempCompositionList.addAll(compositionList);
    await disposePlayers();
    if (_timer.value != null) {
      _timer.value?.cancel();
    }
    start.value = 0;
    playerStatusUseCase.call(PlayerStatus(
        musicName: entity.musicName,
        description: entity.musicDescription,
        image: entity.smallImageUrl,
        status: AudioStatus.downloading));
  }

  changeListValues(String id) async {
    prettyPrint(msg: "Calling");
    compositionList.clear();
    compositionList.addAll(tempCompositionList);
    await hiveService.clearAllValues<MusicGifModel>(AppBoxNames.gifBox);
    // getAllMotion(id);
    update();
  }

  final compositionList = <CompositionEntity>[].obs;
  // final compositionAudioPlayers = <AudioPlayer>[].obs;
  final compositionAudioPlayersJustAudio = <AssetsAudioPlayer>[].obs;

  final soundAudioPlayers = <AssetsAudioPlayer>[].obs;

  final isExpanded = false.obs;

  changeExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  final playerStatus = AudioStatus.canPlay.obs;
  // changeAudioStatus(AudioStatus status) {
  //   playerStatus.value = status;
  // }

  final isExpandedComposition = false.obs;
  final isExpandedMotion = false.obs;
  final isOtherExpanded = false.obs;
  changeOtherExpanded() {
    isOtherExpanded.value = !isOtherExpanded.value;
  }

  changeExpandedCompositions() {
    isExpandedComposition.value = !isExpandedComposition.value;
  }

  changeExpandedMotion() {
    isExpandedMotion.value = !isExpandedMotion.value;
  }

  changeExpandedMotionFalse() {
    isExpandedMotion.value = false;
  }

  final waitingPlayers = false.obs;
  Future showMediaNotification() async {
    const AndroidNotificationDetails("audio_channel_id", "audio_channel",
        color: Colors.deepOrange,
        enableLights: true,
        playSound: false,
        enableVibration: false,
        largeIcon: DrawableResourceAndroidBitmap("img"),
        showProgress: true,
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true));

    // await _flutterLocalNotificationsPlugin.show(
    //     0,
    //     selectedMusic.value?.musicName ?? "null",
    //     selectedMusic.value?.musicDescription ?? "null",
    //     platform);
  }

  AudioStatus currentAudioStatus = AudioStatus.canPlay;
  String selectedTitle = "";
  playAudio({required MusicEntity musicEntity, bool? recursive}) async {
    // showMediaNotification();
    // bool success = await FlutterBackground.enableBackgroundExecution();
    currentAudioStatus = AudioStatus.playing;
    selectedTitle = musicEntity.musicName;
    FlutterForegroundTask.updateService(
        notificationTitle: musicEntity.musicName);
    try {
      waitingPlayers.value = true;
      // compositionAudioPlayersJustAudio.asMap().forEach((index, value) {
      //   compositionAudioPlayersJustAudio[index].dispose();
      // });
      await disposePlayers();
      compositionAudioPlayersJustAudio.clear();
      soundAudioPlayers.clear();

      // compositionAudioPlayers.clear();
      if (recursive == true) {
      } else {
        compositionList.clear();
        await getAllCompositions(musicEntity.musicId, musicEntity.musicName,
            download: true, fromPlay: true);
      }

      if (kIsWeb) {
      } else {
        final tempPath = await getApplicationDocumentsDirectory();
        final data = tempCompositionList
            .where((element) => element.status == AudioStatus.canPlay);
        debugPrint(
            " downloaded status : ${data.length} out of ${tempCompositionList.length}");
        if (data.length == tempCompositionList.length) {
          waitingPlayers.value = false;

          // compositionAudioPlayers.addAll(List.generate(data.length, (index) {
          //   debugPrint(index.toString());
          //   return AudioPlayer();
          // }));
          compositionAudioPlayersJustAudio
              .addAll(List.generate(data.length, (index) {
            debugPrint(index.toString());
            return AssetsAudioPlayer.newPlayer();
          }));
          compositionAudioPlayersJustAudio.asMap().forEach((index, data) async {
            var audioFile =
                File("${tempPath.path}/${tempCompositionList[index].id}");
            await compositionAudioPlayersJustAudio[index].open(
                Audio.file(audioFile.path,
                    metas: Metas(
                        id: selectedMusic.value?.id,
                        title: selectedMusic.value?.musicName,
                        image: MetasImage(
                            path: selectedMusic.value?.smallImageUrl ?? "",
                            type: ImageType.network))),
                showNotification: false,
                autoStart: false,
                playInBackground: PlayInBackground.enabled,
                audioFocusStrategy: const AudioFocusStrategy.request(
                    resumeAfterInterruption: false,
                    resumeOthersPlayersAfterDone: false),
                notificationSettings: NotificationSettings(
                    seekBarEnabled: false,
                    stopEnabled: false,
                    nextEnabled: false,
                    playPauseEnabled: true,
                    prevEnabled: false,
                    customPlayPauseAction: (v) {
                      if (AssetsAudioPlayer.allPlayers().isNotEmpty) {
                        pauseFromNoti();
                      }
                    }));

            compositionAudioPlayersJustAudio[index]
                .setLoopMode(LoopMode.single);
            compositionAudioPlayersJustAudio[index].setVolume(
                tempCompositionList[index].instrumentVolumeDefault * 0.01);
          });
          compositionAudioPlayersJustAudio.last.onReadyToPlay.listen((event) {
            for (var element in compositionAudioPlayersJustAudio) {
              element.play();
            }
          });
          Future.delayed(const Duration(seconds: 10), () {
            if (AssetsAudioPlayer.allPlayers().isNotEmpty) {
              AssetsAudioPlayer.allPlayers()
                  .values
                  .first
                  .realtimePlayingInfos
                  .listen((event) async {
                prettyPrint(msg: "${event.isPlaying}");
                // var pr = await hiveService.getBox<PlayerStatus>(
                //     boxName: AppBoxNames.playerBox);
                // if (pr.values.isNotEmpty) {
                if (currentAudioStatus == AudioStatus.stop ||
                    currentAudioStatus == AudioStatus.stop) {
                } else if (event.isPlaying == false &&
                    currentAudioStatus == AudioStatus.playing) {
                  pauseAllPlayer(selectedMusic.value!);
                } else if (event.isPlaying &&
                    currentAudioStatus == AudioStatus.pause) {
                  resumeAllPlayers(selectedMusic.value!);
                }
                // }
              });
            }
          });
          // compositionAudioPlayers.asMap().forEach((index, data) {
          //   var audioFile =
          //       File("${tempPath.path}/${compositionList[index].instrumentName}");
          //   // compositionAudioPlayers[index].play(
          //   //   DeviceFileSource(audioFile.path),
          //   //   volume: compositionList[index].instrumentVolumeDefault * 0.02,
          //   // );
          //   // // compositionAudioPlayers[i].pause();
          //   // playerStatus.value = AudioStatus.playing;
          //   // compositionAudioPlayers[index].setReleaseMode(ReleaseMode.loop);
          //   // if (index == 0) {
          //   //   // compositionAudioPlayers[index].
          //   //   compositionAudioPlayers[index]
          //   //       .getCurrentPosition()
          //   //       .asStream()
          //   //       .listen((event) async {
          //   //     var musicTot = await compositionAudioPlayers[index].getDuration();
          //   //     prettyPrint(msg: "${event?.inSeconds} == ${musicTot?.inSeconds}");
          //   //     // musicTot =musicTot
          //   //     // if(event.inSeconds== musicTot?.inSeconds.)
          //   //   });
          //   // }
          //
          //   // compositionAudioPlayers[index].
          //   // playerStatusUseCase.call(PlayerStatus(
          //   //     musicName: selectedMusic.value?.musicName ?? "",
          //   //     description: selectedMusic.value?.musicDescription ?? "",
          //   //     image: selectedMusic.value?.smallImageUrl ?? "",
          //   //     status: AudioStatus.playing));
          // });
          if (soundListingBox.value!.values.isEmpty) {
            await getSoundListing();
          }
          await setSoundAudioPlayer(soundListingBox.value!.values.toList());
          debugPrint("playing audio");
          if (getTimerinSeconds() != 0) {
            prettyPrint(msg: "TIMER STARTED");
            startTimer(getTimerinSeconds());
          } else {
            prettyPrint(msg: "NOT SHOWING TIMER");
          }
          playerStatusUseCase.call(PlayerStatus(
              musicName: musicEntity.musicName,
              description: musicEntity.musicDescription,
              image: musicEntity.smallImageUrl,
              status: AudioStatus.playing));
          waitingPlayers.value = false;
        } else {
          debugPrint("downloading ....");
          playerStatusUseCase.call(PlayerStatus(
              musicName: selectedMusic.value?.musicName ?? "",
              description: selectedMusic.value?.musicDescription ?? "",
              image: selectedMusic.value?.smallImageUrl ?? "",
              status: AudioStatus.downloading));
          waitingPlayers.value = true;
          Future.delayed(const Duration(seconds: 1), () {
            playAudio(musicEntity: musicEntity, recursive: true);
          });
        }
      }
    } catch (e) {
      waitingPlayers.value = false;
      await pauseAllPlayer(musicEntity);
      await stopAllPlayers();

      final tempPath = await getApplicationDocumentsDirectory();
      for (var element in tempCompositionList) {
        var audioFile = File("${tempPath.path}/${element.id}");
        try {
          if (await File(audioFile.path).exists()) {
            await File(audioFile.path).delete(recursive: true);
          }
          if (tempCompositionList.last == element) {
            var it = await HiveService()
                .getBox<StoreModel>(boxName: AppBoxNames.cache_box);
            it.values.toList().asMap().forEach((key, value) {
              if (value.musicName == (selectedMusic.value?.musicName ?? "")) {
                it.deleteAt(key);
              }
            });
            // var index=it
            // it.deleteAt(widget.index);
          }
        } catch (e) {
          prettyPrint(msg: e.toString());
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.black, colorText: Colors.white);
    }
  }

  changePlayerStatus(PlayerStatus data) {
    playerStatusUseCase.call(data);
  }

  getAllMotion(String id) async {
    motionResponse.value = ResponseClassify.loading();
    try {
      motionResponse.value =
          ResponseClassify.completed(await gifUseCase.call(id));
    } catch (e) {
      motionResponse.value = ResponseClassify.error("");
      // Get.snackbar("Error", e.toString());
    }
  }

  getAllCompositions(String id, String musicName,
      {bool? download, bool? fromPlay}) async {
    compositionResponse.value = ResponseClassify.loading();
    try {
      compositionResponse.value =
          ResponseClassify.completed(await compositionsUseCase.call(id));
      // getAllMotion(id);
      compositionList.clear();

      compositionList.addAll(compositionResponse.value.data ?? []);

      // await playerStatusUseCase.call(PlayerStatus(
      //     musicName: selectedMusic.value?.musicName ?? "",
      //     description: selectedMusic.value?.musicDescription ?? "",
      //     image: selectedMusic.value?.smallImageUrl ?? "",
      //     status: AudioStatus.downloading));
      prettyPrint(msg: "composition list length ${compositionList.length}");
      waitingPlayers.value = false;
      if (!kIsWeb && download == true) {
        tempCompositionList.clear();
        tempCompositionList.addAll(compositionResponse.value.data ?? []);
        downloadAllCompositions(musicName);
      } else {}
    } catch (e) {
      waitingPlayers.value = false;
      compositionResponse.value = ResponseClassify.error(e.toString());
      if (fromPlay == true) {
        throw BadRequestException("Failed to download. Connection timed out.");
      }
    }
  }

  Widget compositionDataItem(
      {required CompositionEntity model,
      required int index,
      required bool current}) {
    final defaultVolume = model.instrumentVolumeDefault.obs;
    return Row(
      children: [
        Expanded(
            // flex: 2,
            child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            model.instrumentName,
            style: const TextStyle(color: AppColors.textColor),
          ),
        )),
        Expanded(
            // flex: 1,
            child: CupertinoSlider(
          min: 0,
          max: 1,
          thumbColor:
              defaultVolume.value == 0 ? Colors.grey : AppColors.thumbColor,
          activeColor: AppColors.thumbColor.withOpacity(0.6),
          // inactiveColor: Colors.white60,
          onChanged: (double value) {
            if (current) {
              defaultVolume.value = ((value) * 100).toInt();
              // if (defaultVolume.value > 70) {
              //   compositionAudioPlayers[index].resume();
              // }
              compositionAudioPlayersJustAudio[index].setVolume(value);
              model.instrumentVolumeDefault = defaultVolume.value;
              if (tempCompositionList.contains(model)) {
                var data = tempCompositionList
                    .firstWhere((element) => element == model);
                data.instrumentVolumeDefault = defaultVolume.value;
              }
              compositionResponse.refresh();
            }
          },
          value: defaultVolume.value * 0.01,
        ))
      ],
    );
  }

  setSoundAudioPlayer(List<SoundListingEntity> data) {
    for (var element in data) {
      element.volume = 0.0;
      soundAudioPlayers.add(AssetsAudioPlayer());
    }
    soundAudioPlayers.asMap().forEach((index, value) async {
      prettyPrint(msg: "Seting sound $index");
      var tempDir = await getApplicationDocumentsDirectory();
      var temFile = File("${tempDir.path}/s${data[index].id}");
      if (await temFile.exists()) {
        await soundAudioPlayers[index].open(
            Audio.file(temFile.path,
                metas: Metas(
                    id: selectedMusic.value?.id,
                    title: selectedMusic.value?.musicName,
                    image: MetasImage(
                        path: selectedMusic.value?.smallImageUrl ?? "",
                        type: ImageType.network))),
            showNotification: false,
            autoStart: false,
            audioFocusStrategy: const AudioFocusStrategy.request(
                resumeAfterInterruption: false,
                resumeOthersPlayersAfterDone: false),
            playInBackground: PlayInBackground.enabled);
        soundAudioPlayers[index].setLoopMode(LoopMode.single);
        // soundAudioPlayers[index].play();

        soundAudioPlayers[index].setVolume(0.0);
      } else {
        Future.delayed(const Duration(seconds: 20), () async {
          if (await temFile.exists()) {
            await soundAudioPlayers[index].open(
                Audio.file(temFile.path,
                    metas: Metas(
                        id: selectedMusic.value?.id,
                        title: selectedMusic.value?.musicName,
                        image: MetasImage(
                            path: selectedMusic.value?.smallImageUrl ?? "",
                            type: ImageType.network))),
                showNotification: false,
                audioFocusStrategy: const AudioFocusStrategy.request(
                    resumeAfterInterruption: false,
                    resumeOthersPlayersAfterDone: false),
                autoStart: false,
                notificationSettings: NotificationSettings(
                    seekBarEnabled: false,
                    stopEnabled: false,
                    nextEnabled: false,
                    playPauseEnabled: true,
                    prevEnabled: false,
                    customPlayPauseAction: (v) {
                      pauseFromNoti();
                    }),
                playInBackground: PlayInBackground.enabled);
            soundAudioPlayers[index].setLoopMode(LoopMode.single);
            // soundAudioPlayers[index].play();

            soundAudioPlayers[index].setVolume(0.0);
          }
        });
      }
    });
    soundAudioPlayers.last.onReadyToPlay.listen((event) {
      for (var element in soundAudioPlayers) {
        element.play();
      }
    });
  }

  Widget soundListDataItem(
      {required SoundListingEntity model,
      required int index,
      required bool show}) {
    final defaultVolume = model.volume.obs;
    // soundAudioPlayers[index].setVolume(model.volume ?? 0.0);
    return Row(
      children: [
        Expanded(
            // flex: 1,
            child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            model.soundName,
            style: const TextStyle(color: AppColors.textColor),
          ),
        )),
        show
            ? Obx(() => Expanded(
                    // flex: 2,
                    child: CupertinoSlider(
                  min: 0,
                  max: 1,
                  thumbColor: defaultVolume.value == 0
                      ? Colors.grey
                      : AppColors.thumbColor,
                  activeColor: AppColors.thumbColor.withOpacity(0.6),
                  // inactiveColor: Colors.white60,
                  onChanged: (double value) {
                    defaultVolume.value = (value * 100).toDouble();
                    // if (defaultVolume.value > 70) {
                    //   compositionAudioPlayers[index].resume();
                    // }

                    soundAudioPlayers[index].setVolume(value);
                    model.volume = defaultVolume.value;
                    // compositionResponse.refresh();
                  },
                  value: (defaultVolume.value ?? 0) * 0.01,
                )))
            : Expanded(
                // flex: 2,
                child: CupertinoSlider(
                min: 0,
                max: 1,
                thumbColor: AppColors.thumbColor,
                activeColor: AppColors.thumbColor.withOpacity(0.6),
                onChanged: (double value) {
                  // compositionResponse.refresh();
                },
                value: 0,
              ))
      ],
    );
  }

  downloadAllCompositions(String musicName) async {
    var tempDir = await getApplicationDocumentsDirectory();
    // compositionList.clear();
    // compositionList.addAll(compositionResponse.value.data ?? []);
    tempCompositionList.forEach((element) async {
      var temFile = File("${tempDir.path}/${element.id}");

      if (await temFile.exists()) {
        // playerStatusUseCase.call(PlayerStatus(musicName: selectedMusic.value?.musicName??"", description: selectedMusic.value?.musicDescription??"", image: selectedMusic.value?.smallImageUrl??"", status: AudioStatus.canPlay));
        element.status = AudioStatus.canPlay;
        tempCompositionList.refresh();
        // if(compositionResponse.value.data!.last==element){
        //   waitingPlayers.value=false;
        // }
      } else {
        List<String> tempLoc = [];
        for (var element in tempCompositionList) {
          var temFile = File("${tempDir.path}/${element.id}");
          tempLoc.add(temFile.path);
        }
        prettyPrint(
            msg:
                "islast item ${compositionResponse.value.data?.last.id == element.id}");
        try {
          downloadAudio(
            entity: element,
            musicName: musicName,
            isLasItem: tempCompositionList.last.id == element.id,
            storeLoc: tempLoc,
          );
        } catch (e) {
          throw BadRequestException();
        }
      }

      debugPrint("not waiting for fully download ${element.musicId}");
    });
  }

  List<StoreModel> tempStoreItems = [];
  downloadAudio(
      {required CompositionEntity entity,
      required String musicName,
      required bool isLasItem,
      required List<String> storeLoc}) async {
    var tempDir = await getApplicationDocumentsDirectory();
    var temFile = File("${tempDir.path}/${entity.id}");

    try {
      final HttpClientRequest request =
          await HttpClient().getUrl(Uri.parse(entity.instrumentAudioUrl));
      final HttpClientResponse response =
          await request.close().timeout(const Duration(seconds: 100));
      // var response = await http.Client()
      //     .send(http.Request(
      //       'GET',
      //       Uri.parse(entity.instrumentAudioUrl),
      //     ))
      //     .timeout(const Duration(seconds: 20))
      //     .onError((error, stackTrace) => throw BadRequestException(
      //         "Failed to download. Connection timed out."));

      var tempWrite = temFile.openWrite();
      var length = response.contentLength;
      var received = 0;

      response
          .map((s) {
            received += s.length;
            debugPrint(
                "${(received / length) * 100}  % ${entity.instrumentName} file size : ${temFile.lengthSync()} ");
            double per = (received / length) * 100;
            if (per > 95) {
              entity.status = AudioStatus.canPlay;

              tempCompositionList.refresh();
            }
            if (per == 100) {
              entity.dCompleted = true;
              tempCompositionList.refresh();
              // tempStoreItems.add(StoreModel(
              //   musicName: selectedMusic.value?.musicName ?? "",
              //   storeLoc: storeLoc,
              //   totSize: temFile.lengthSync().toDouble(),
              //   totalMusic: compositionList.length,
              // ));
              prettyPrint(msg: "added store model $musicName");
              // if (isLasItem) {
              //
              //   double tot = 0.0;
              //   for (var element in storeLoc) {
              //     var file = File(element);
              //     if (file.existsSync()) {
              //       tot = tot + file.lengthSync().toDouble();
              //     }
              //   }
              //   hiveService.addBoxes<StoreModel>([
              //     StoreModel(
              //       musicName: selectedMusic.value?.musicName ?? "",
              //       storeLoc: storeLoc,
              //       totSize: tot,
              //       totalMusic: compositionList.length,
              //     )
              //   ], AppBoxNames.cache_box);
              // }
            }
            return s;
          })
          .pipe(tempWrite)
          .whenComplete(() {
            if (isLasItem) {
              double tot = 0.0;
              for (var element in storeLoc) {
                var file = File(element);
                if (file.existsSync()) {
                  tot = tot + file.lengthSync().toDouble();
                }
              }
              hiveService.addBoxes<StoreModel>([
                StoreModel(
                  musicName: selectedMusic.value?.musicName ?? "",
                  storeLoc: storeLoc,
                  totSize: tot,
                  totalMusic: compositionList.length,
                )
              ], AppBoxNames.cache_box);
            }
          });
    } on TimeoutException catch (_) {
      prettyPrint(msg: _.toString());
      temFile.delete();
      throw BadRequestException("Failed to download. Connection timed out.");
    } catch (e) {
      temFile.delete();
      prettyPrint(msg: e.toString());
      throw BadRequestException("Failed to download.");
    }
  }

  pauseFromNoti() {
    bool play = false;
    AssetsAudioPlayer.allPlayers().values.forEach((element) {
      play = element.isPlaying.value;
      element.playOrPause();
    });
    playerStatusUseCase.call(PlayerStatus(
        musicName: selectedMusic.value!.musicName,
        description: selectedMusic.value!.musicDescription,
        image: selectedMusic.value!.smallImageUrl,
        status: play ? AudioStatus.pause : AudioStatus.playing));
  }

  pauseAllPlayer(MusicEntity entity) {
    currentAudioStatus = AudioStatus.pause;
    if (getTimerinSeconds() != 0) {
      pauseTimer();
    }

    // FlutterForegroundTask.stopService();
    prettyPrint(msg: "${compositionAudioPlayersJustAudio.length}");
    playerStatusUseCase.call(PlayerStatus(
        musicName: entity.musicName,
        description: entity.musicDescription,
        image: entity.smallImageUrl,
        status: AudioStatus.pause));
    compositionAudioPlayersJustAudio.asMap().forEach((key, value) {
      compositionAudioPlayersJustAudio[key].pause();
    });
    soundAudioPlayers.asMap().forEach((key, value) {
      soundAudioPlayers[key].pause();
    });
    playerStatus.value = AudioStatus.pause;
    prettyPrint(msg: "PAUSING ALL PLAYERS");
    FlutterForegroundTask.updateService(notificationTitle: entity.musicName);
  }

  stopAllPlayers() async {
    compositionAudioPlayersJustAudio.asMap().forEach((key, value) {
      compositionAudioPlayersJustAudio[key].pause();
    });
    soundAudioPlayers.asMap().forEach((key, value) {
      soundAudioPlayers[key].pause();
    });
    // compositionAudioPlayersJustAudio.asMap().forEach((key, value) {
    //   compositionAudioPlayersJustAudio[key].stop();
    // });
    // soundAudioPlayers.asMap().forEach((key, value) {
    //   soundAudioPlayers[key].stop();
    // });

    // await disposePlayers();

    currentAudioStatus = AudioStatus.stop;
    playerStatus.value = AudioStatus.stop;
    final box =
        await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
    box.clear();
    prettyPrint(msg: "STOPPING ALL PLAYERS");
    start.value = 0;
    _timer.value?.cancel();
  }

  resumeAllPlayers(MusicEntity entity) async {
    if (currentAudioStatus != AudioStatus.stop) {
      currentAudioStatus = AudioStatus.playing;
      if (getTimerinSeconds() != 0) {
        unpauseTimer();
      }

      // showMediaNotification();

      // compositionAudioPlayersJustAudio.asMap().forEach((key, value) {
      //   // var vl = compositionAudioPlayersJustAudio[key].volume;
      //   // await compositionAudioPlayersJustAudio[key].setVolume(0);
      //   compositionAudioPlayersJustAudio[key].play();
      //   // compositionAudioPlayersJustAudio[key].setVolume(compositionList[key].instrumentVolumeDefault.toDouble());
      // });
      for (var j in compositionAudioPlayersJustAudio) {
        j.play();
      }
      for (var k in soundAudioPlayers) {
        k.play();
      }
      // soundAudioPlayers.asMap().forEach((key, value) {
      //   // var vl = soundAudioPlayers[key].volume;
      //   // await soundAudioPlayers[key].setVolume(0);
      //   soundAudioPlayers[key].play();
      //   // soundAudioPlayers[key].setVolume(vl);
      // });
      playerStatusUseCase.call(PlayerStatus(
          musicName: entity.musicName,
          description: entity.musicDescription ?? "",
          image: entity.smallImageUrl,
          status: AudioStatus.playing));
      playerStatus.value = AudioStatus.playing;
      prettyPrint(msg: "RESUMING ALL PLAYERS");
      FlutterForegroundTask.updateService(notificationTitle: entity.musicName);
    }

    // bool success = await FlutterBackground.enableBackgroundExecution();
  }

  final cacheBox = Rxn<Box<StoreModel>>();
  final playerBox = Rxn<Box<PlayerStatus>>();
  final motionGifBox = Rxn<Box<MusicGifModel>>();

  final toogleBox = Rxn<Box<bool>>();
  final soundListingBox = Rxn<Box<SoundListingModel>>();
  disposePlayers() async {
    for (var element in compositionAudioPlayersJustAudio) {
      element.dispose();
    }
    for (var element in soundAudioPlayers) {
      element.dispose();
    }
    AssetsAudioPlayer.allPlayers().values.forEach((element) async {
      element.dispose();
    });
    _timer.value?.cancel();
    // await FlutterBackground.disableBackgroundExecution();
  }

  clearDb() async {
    final box =
        await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
    box.clear();
  }

  getSoundListing() async {
    try {
      var d = await soundListUseCase.call(NoParams());
      var tempDir = await getApplicationDocumentsDirectory();

      for (var element in d) {
        var temFile = File("${tempDir.path}/s${element.id}");
        prettyPrint(msg: "tempFile exists ${await temFile.exists()}");
        if (await temFile.exists()) {
          GetStorage storage = GetStorage();
          String? e = storage.read('lastDate');

          DateTime eDate = DateTime.parse(e ?? "");
          prettyPrint(msg: "e ${eDate.difference(element.updatedDate).inDays}");
          if (eDate.difference(element.updatedDate).inDays > 0) {
            prettyPrint(msg: "this part is wrking");
            downloadSoundAudio(entity: element);
          }
        } else {
          GetStorage storage = GetStorage();
          storage.write("lastDate", element.updatedDate.toIso8601String());
          downloadSoundAudio(entity: element);
        }
      }
    } catch (e) {
      prettyPrint(msg: e.toString());
    }
  }

  changeToogleFader(bool value) async {
    var storage = GetStorage();
    toogleFader.value = value;
    storage.write(AppBoxNames.toogle_fader, value);
  }

  final toogleFader = false.obs;
  bool getToogleFader() {
    var storage = GetStorage();
    final d = storage.read(AppBoxNames.toogle_fader);
    if (d != null) {
      toogleFader.value = d;
    } else {
      toogleFader.value = false;
      return false;
    }

    return d;
  }

  int getTimerinSeconds() {
    String time = getTiming();
    switch (time) {
      case "infinite":
        return 0;
      case "10 mins":
        return 600;
      case "20 mins":
        return 1200;
      case "30 mins":
        return 1800;
      case "40 mins":
        return 2400;
      case "1 hour":
        return 3600;
      case "2 hours":
        return 7200;
      case "4 hours":
        return 14400;
      case "8 hours":
        return 28800;
      default:
        return 0;
    }
  }

  writeTiming(String data) {
    var storage = GetStorage();
    prettyPrint(msg: "writing time$data");
    storage.write('timer', data);
    getTiming();
  }

  final timingValue = "30 mins".obs;
  String getTiming() {
    var storage = GetStorage();
    if (storage.hasData('timer')) {
      final d = storage.read('timer');
      timingValue.value = d;
      return d;
    } else {
      timingValue.value = "30 mins";
      return "30 mins";
    }
  }

  initCache() async {
    cacheBox.value =
        await hiveService.getBox<StoreModel>(boxName: AppBoxNames.cache_box);
    update();
  }

  @override
  Future<void> onInit() async {
    playerBox.value =
        await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
    toogleBox.value =
        await hiveService.getBox<bool>(boxName: AppBoxNames.toogle_fader);
    motionGifBox.value =
        await hiveService.getBox<MusicGifModel>(boxName: AppBoxNames.gifBox);
    soundListingBox.value = await hiveService.getBox<SoundListingModel>(
        boxName: AppBoxNames.soundListingBox);
    cacheBox.value =
        await hiveService.getBox<StoreModel>(boxName: AppBoxNames.cache_box);
    disposePlayers();
    getSoundListing();
    super.onInit();
  }
  //timer

  final _timer = Rxn<Timer>();

  Duration get currentDuration => _currentDuration;
  final Duration _currentDuration = Duration.zero;

  bool get isRunning => _timer.value != null;

  //timer setting
  @override
  void dispose() {
    stopAllPlayers();
    FlutterForegroundTask.stopService();
    disposePlayers();
    super.dispose();
  }

  final start = 0.obs;

  void startTimer(int timerDuration) {
    int len = getTimerinSeconds();
    double fadeTime = len * 0.30;
    if (_timer.value != null) {
      _timer.value?.cancel();
    }
    prettyPrint(msg: "starting timer");

    start.value = timerDuration;

    const oneSec = Duration(seconds: 1);

    _timer.value = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (start.value < 1) {
          timer.cancel();
          await stopAllPlayers();
        } else {
          FlutterForegroundTask.updateService(
              notificationTitle: selectedMusic.value?.musicName,
              notificationText: "");
          if (getToogleFader()) {
            prettyPrint(msg: "starting timer $fadeTime");
            if (start.value < 15) {
              prettyPrint(msg: "fade time wrking $fadeTime");
              changeAllPlayerVolumeByFade(fadeTime);
            }
          }
          start.value = start.value - 1;
        }
      },
    );
  }

  changeAllPlayerVolumeByFade(double fadeLen) {
    for (var player in compositionAudioPlayersJustAudio) {
      // var v = (player.volume / 5);
      // prettyPrint(msg: "decresing length $v");
      player.setVolume(player.volume.value * 0.75);
    }
    for (var player in soundAudioPlayers) {
      // var v = (player.volume / 5);
      player.setVolume(player.volume.value * 0.75);
    }
  }

  void pauseTimer() {
    if (_timer.value != null) _timer.value?.cancel();
  }

  void unpauseTimer() => startTimer(start.value);

  downloadSoundAudio({required SoundListingEntity entity}) async {
    var tempDir = await getApplicationDocumentsDirectory();
    var temFile = File("${tempDir.path}/s${entity.id}");

    var response = await http.Client()
        .send(http.Request('GET', Uri.parse(entity.soundAudioUrl)));

    var tempWrite = temFile.openWrite();
    var length = response.contentLength ?? 0;
    var received = 0;

    response.stream.map((s) {
      received += s.length;
      // debugPrint(
      //     "${(received / length) * 100}  % ${entity.soundAudioUrl} file size : ${temFile.lengthSync()} ");
      double per = (received / length) * 100;

      if (per == 100) {
        prettyPrint(msg: "added store model ${entity.soundName}");
        // hiveService.addBoxes<StoreModel>([
        //   StoreModel(
        //     musicName: "Sounds",
        //     storeLoc: temFile.path,
        //     totSize: temFile.lengthSync().toDouble(),
        //   )
        // ], AppBoxNames.cache_box);
      }
      return s;
    }).pipe(tempWrite);
  }
}
