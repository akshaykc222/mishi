// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:mishi/core/hive_service.dart';
// import 'package:mishi/core/response_classify.dart';
// import 'package:mishi/mishi/data/app_remote_routes.dart';
// import 'package:mishi/mishi/domain/entities/composition_entity.dart';
// import 'package:mishi/mishi/domain/entities/music_entity.dart';
// import 'package:mishi/mishi/domain/entities/player_status.dart';
// import 'package:mishi/mishi/domain/use_cases/add_player_status.dart';
// import 'package:mishi/mishi/domain/use_cases/get_music_composition_usecase.dart';
// import 'package:mishi/mishi/presentation/utils/app_colors.dart';
// import 'package:mishi/mishi/presentation/utils/enums.dart';
// import 'package:mishi/mishi/presentation/utils/pretty_print.dart';
//
// class MusicDetailControllerWeb extends GetxController {
//   final GetMusicCompositionsUseCase compositionsUseCase;
//   final AddPlayerStatusUseCase playerStatusUseCase;
//   final HiveService hiveService;
//   MusicDetailControllerWeb(
//       this.compositionsUseCase, this.playerStatusUseCase, this.hiveService);
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
//   changeSelectedMusic(MusicEntity entity) {
//     selectedMusic.value = entity;
//     playerStatusUseCase.call(PlayerStatus(
//         musicName: entity.musicName,
//         description: entity.musicDescription,
//         image: entity.smallImageUrl,
//         status: AudioStatus.downloading));
//   }
//
//   final compositionList = <CompositionEntity>[].obs;
//   final compositionAudioPlayers = <AudioPlayer>[].obs;
//
//   final isExpanded = false.obs;
//
//   changeExpanded() {
//     isExpanded.value = !isExpanded.value;
//   }
//
//   final playerStatus = AudioStatus.canPlay.obs;
//   // changeAudioStatus(AudioStatus status) {
//   //   playerStatus.value = status;
//   // }
//
//   final isExpandedComposition = false.obs;
//
//   changeExpandedCompositions() {
//     isExpandedComposition.value = !isExpandedComposition.value;
//   }
//
//   final waitingPlayers = false.obs;
//
//   playAudio({required MusicEntity musicEntity}) async {
//     waitingPlayers.value = true;
//     compositionAudioPlayers.asMap().forEach((index, value) {
//       compositionAudioPlayers[index].dispose();
//     });
//     compositionAudioPlayers.clear();
//     await getAllCompositions(musicEntity.musicId);
//     if (kIsWeb) {
//       waitingPlayers.value = false;
//       playerStatusUseCase.call(PlayerStatus(
//           musicName: musicEntity.musicName,
//           description: musicEntity.musicDescription,
//           image: musicEntity.smallImageUrl,
//           status: AudioStatus.playing));
//       compositionAudioPlayers
//           .addAll(List.generate(compositionList.length, (index) {
//         debugPrint(index.toString());
//         return AudioPlayer();
//       }));
//
//       compositionAudioPlayers.asMap().forEach((index, data) {
//         // var audioFile =
//         // File("${tempPath.path}/${compositionList[index].instrumentName}");
//         compositionAudioPlayers[index]
//             .setUrl(compositionList[index].instrumentAudioUrl);
//         compositionAudioPlayers[index].play();
//         compositionAudioPlayers[index]
//             .setVolume(compositionList[index].instrumentVolumeDefault * 0.01);
//         // compositionAudioPlayers[i].pause();
//         playerStatus.value = AudioStatus.playing;
//         compositionAudioPlayers[index].setLoopMode(LoopMode.one);
//         // playerStatusUseCase.call(PlayerStatus(
//         //     musicName: selectedMusic.value?.musicName ?? "",
//         //     description: selectedMusic.value?.musicDescription ?? "",
//         //     image: selectedMusic.value?.smallImageUrl ?? "",
//         //     status: AudioStatus.playing));
//       });
//
//       debugPrint("playing audio");
//       waitingPlayers.value = false;
//     }
//   }
//
//   changePlayerStatus(PlayerStatus data) {
//     playerStatusUseCase.call(data);
//   }
//
//   getAllCompositions(String id) async {
//     compositionResponse.value = ResponseClassify.loading();
//     try {
//       compositionResponse.value =
//           ResponseClassify.completed(await compositionsUseCase.call(id));
//       compositionList.clear();
//       compositionList.addAll(compositionResponse.value.data ?? []);
//       // await playerStatusUseCase.call(PlayerStatus(
//       //     musicName: selectedMusic.value?.musicName ?? "",
//       //     description: selectedMusic.value?.musicDescription ?? "",
//       //     image: selectedMusic.value?.smallImageUrl ?? "",
//       //     status: AudioStatus.downloading));
//       prettyPrint(msg: "composition list length ${compositionList.length}");
//       waitingPlayers.value = false;
//       if (!kIsWeb) {
//         // downloadAllCompositions();
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
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16.0),
//               child: Text(
//                 model.instrumentName,
//                 style: const TextStyle(color: AppColors.textColor),
//               ),
//             )),
//         Expanded(
//             flex: 2,
//             child: Slider(
//               min: 0,
//               max: 2,
//               onChanged: (double value) {
//                 defaultVolume.value = ((value / 2) * 100).toInt();
//                 // if (defaultVolume.value > 70) {
//                 //   compositionAudioPlayers[index].resume();
//                 // }
//                 compositionAudioPlayers[index].setVolume(value);
//                 model.instrumentVolumeDefault = defaultVolume.value;
//                 compositionResponse.refresh();
//               },
//               value: defaultVolume.value * 0.02,
//             ))
//       ],
//     );
//   }
//
//   pauseAllPlayer() {
//     playerStatusUseCase.call(PlayerStatus(
//         musicName: selectedMusic.value?.musicName ?? "",
//         description: selectedMusic.value?.musicDescription ?? "",
//         image: selectedMusic.value?.smallImageUrl ?? "",
//         status: AudioStatus.pause));
//     compositionAudioPlayers.asMap().forEach((key, value) {
//       compositionAudioPlayers[key].pause();
//     });
//     playerStatus.value = AudioStatus.pause;
//   }
//
//   resumeAllPlayers() {
//     playerStatusUseCase.call(PlayerStatus(
//         musicName: selectedMusic.value?.musicName ?? "",
//         description: selectedMusic.value?.musicDescription ?? "",
//         image: selectedMusic.value?.smallImageUrl ?? "",
//         status: AudioStatus.playing));
//     compositionAudioPlayers.asMap().forEach((key, value) {
//       compositionAudioPlayers[key].play();
//     });
//     playerStatus.value = AudioStatus.playing;
//   }
//
//   final playerBox = Rxn<Box<PlayerStatus>>();
//   disposePlayers() {
//     compositionAudioPlayers.asMap().forEach((key, value) {
//       compositionAudioPlayers[key].dispose();
//     });
//   }
//
//   clearDb() async {
//     final box =
//         await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
//     box.clear();
//   }
//
//   @override
//   Future<void> onInit() async {
//     playerBox.value =
//         await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
// }
