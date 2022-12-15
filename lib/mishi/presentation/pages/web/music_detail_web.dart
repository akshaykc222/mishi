import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mishi/core/response_classify.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

import '../../manager/controllers/web_music_detail_controller.dart';
import '../../utils/enums.dart';

class MusicDetailWeb extends StatefulWidget {
  final MusicEntity musicEntity;

  const MusicDetailWeb({Key? key, required this.musicEntity}) : super(key: key);

  @override
  State<MusicDetailWeb> createState() => _MusicDetailWebState();
}

class _MusicDetailWebState extends State<MusicDetailWeb>
    with SingleTickerProviderStateMixin {
  late AnimationController iconAnimationController;
  final controller = Get.find<MusicDetailControllerWeb>();
  late String name;
  late String desc;
  late String image;
  late String smallImage;
  late MusicEntity entity;
  @override
  void initState() {
    entity = widget.musicEntity;
    name = widget.musicEntity.musicName;
    desc = widget.musicEntity.musicDescription;
    image = widget.musicEntity.largeImageUrl;
    smallImage = widget.musicEntity.smallImageUrl;
    iconAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    controller.getAllCompositions(widget.musicEntity.musicId);
    super.initState();
  }

  @override
  void dispose() {
    // for (var element in controller.compositionAudioPlayers) {
    //   element.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black87,
          body: SingleChildScrollView(
            child: MediaQuery.of(context).size.width > 800
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Hero(
                              tag: widget.musicEntity.musicName,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      imageUrl:
                                          widget.musicEntity.largeImageUrl,
                                      placeholder: (context, value) =>
                                          const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                          height: 70,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                Colors.black.withOpacity(0.0),
                                                Colors.black.withOpacity(0.8)
                                              ],
                                                  begin: Alignment.topCenter,
                                                  end:
                                                      Alignment.bottomCenter))),
                                    ),
                                    Obx(() => Positioned(
                                        right: 18,
                                        bottom: 5,
                                        child: controller.playerBox.value ==
                                                null
                                            ? Container()
                                            : ValueListenableBuilder(
                                                valueListenable: controller
                                                    .playerBox.value!
                                                    .listenable(),
                                                builder: (context,
                                                    Box<PlayerStatus> data,
                                                    widget) {
                                                  var items =
                                                      data.values.toList();
                                                  if (items.isNotEmpty) {
                                                    if (items.first.musicName ==
                                                            entity.musicName &&
                                                        items.first.status ==
                                                            AudioStatus
                                                                .playing) {
                                                      iconAnimationController
                                                          .forward();
                                                    }
                                                  }
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      var items =
                                                          data.values.toList();
                                                      if (items.isNotEmpty) {
                                                        prettyPrint(
                                                            msg:
                                                                "not playing audio");

                                                        switch (items
                                                            .first.status) {
                                                          case AudioStatus
                                                              .downloading:
                                                            break;
                                                          case AudioStatus
                                                              .canPlay:
                                                            break;
                                                          case AudioStatus
                                                              .playing:
                                                            if (items.first
                                                                    .musicName !=
                                                                entity
                                                                    .musicName) {
                                                              prettyPrint(
                                                                  msg:
                                                                      "playing another audio file");
                                                              await controller
                                                                  .pauseAllPlayer();
                                                              await controller
                                                                  .disposePlayers();
                                                              controller.playAudio(
                                                                  musicEntity:
                                                                      entity);
                                                            } else {
                                                              iconAnimationController
                                                                  .reverse();
                                                              controller
                                                                  .pauseAllPlayer();
                                                            }

                                                            break;
                                                          case AudioStatus
                                                              .pause:
                                                            if (items.first
                                                                    .musicName !=
                                                                entity
                                                                    .musicName) {
                                                              await controller
                                                                  .pauseAllPlayer();
                                                              await controller
                                                                  .disposePlayers();
                                                              controller.playAudio(
                                                                  musicEntity:
                                                                      entity);
                                                            } else {
                                                              iconAnimationController
                                                                  .forward();
                                                              controller
                                                                  .resumeAllPlayers();
                                                            }

                                                            break;
                                                          case AudioStatus.stop:
                                                            break;
                                                        }
                                                      } else {
                                                        prettyPrint(
                                                            msg:
                                                                "playing audio");
                                                        controller
                                                            .changeSelectedMusicOnly(
                                                                entity);
                                                        iconAnimationController
                                                            .forward();
                                                        controller.playAudio(
                                                            musicEntity:
                                                                entity);
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 60,
                                                      height: 60,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      child: controller
                                                              .waitingPlayers
                                                              .value
                                                          ? const CircularProgressIndicator(
                                                              color: AppColors
                                                                  .primaryColor,
                                                            )
                                                          : Center(
                                                              child:
                                                                  AnimatedIcon(
                                                                icon: AnimatedIcons
                                                                    .play_pause,
                                                                progress:
                                                                    iconAnimationController,
                                                                size: 40,
                                                                color: AppColors
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                    ),
                                                  );
                                                })))
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Text(
                                  widget.musicEntity.musicName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.changeExpanded();
                                  },
                                  child: Obx(() => Text(
                                        widget.musicEntity.musicDescription,
                                        maxLines: controller.isExpanded.value
                                            ? 20
                                            : 5,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 12,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Obx(() => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Wrap(
                                children: [
                                  AnimatedContainer(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    // height: controller.isExpandedComposition.value
                                    //     ? MediaQuery.of(context).size.height * 0.4
                                    //     : 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          controller.isExpandedComposition.value
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            controller
                                                .changeExpandedCompositions();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text(
                                                  "Change Compositions",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.textColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  controller
                                                          .isExpandedComposition
                                                          .value
                                                      ? Icons
                                                          .keyboard_arrow_down_outlined
                                                      : Icons
                                                          .keyboard_arrow_up_outlined,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        controller.isExpandedComposition.value
                                            ? Wrap(
                                                // height: 300,
                                                children: [
                                                  Obx(() => controller
                                                              .compositionResponse
                                                              .value
                                                              .status ==
                                                          Status.LOADING
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        )
                                                      : controller
                                                                  .compositionResponse
                                                                  .value
                                                                  .status ==
                                                              Status.ERROR
                                                          ? const Center(
                                                              child: Text(
                                                                  "something went wrong"),
                                                            )
                                                          : ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemCount: controller
                                                                  .compositionResponse
                                                                  .value
                                                                  .data
                                                                  ?.length,
                                                              itemBuilder: (BuildContext
                                                                          context,
                                                                      int
                                                                          index) =>
                                                                  controller.compositionDataItem(
                                                                      index:
                                                                          index,
                                                                      model: controller
                                                                              .compositionList[
                                                                          index]),
                                                            ))
                                                ],
                                              )
                                            : Container()
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Hero(
                        tag: widget.musicEntity.musicName,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                imageUrl: widget.musicEntity.largeImageUrl,
                                placeholder: (context, value) => const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                          Colors.black.withOpacity(0.0),
                                          Colors.black.withOpacity(0.8)
                                        ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter))),
                              ),
                              Obx(() => Positioned(
                                  right: 18,
                                  bottom: 5,
                                  child: controller.playerBox.value == null
                                      ? Container()
                                      : ValueListenableBuilder(
                                          valueListenable: controller
                                              .playerBox.value!
                                              .listenable(),
                                          builder: (context,
                                              Box<PlayerStatus> data, widget) {
                                            var items = data.values.toList();
                                            if (items.isNotEmpty) {
                                              if (items.first.musicName ==
                                                      entity.musicName &&
                                                  items.first.status ==
                                                      AudioStatus.playing) {
                                                iconAnimationController
                                                    .forward();
                                              }
                                            }
                                            return GestureDetector(
                                              onTap: () async {
                                                var items =
                                                    data.values.toList();
                                                if (items.isNotEmpty) {
                                                  prettyPrint(
                                                      msg: "not playing audio");

                                                  switch (items.first.status) {
                                                    case AudioStatus
                                                        .downloading:
                                                      break;
                                                    case AudioStatus.canPlay:
                                                      break;
                                                    case AudioStatus.playing:
                                                      if (items.first
                                                              .musicName !=
                                                          entity.musicName) {
                                                        prettyPrint(
                                                            msg:
                                                                "playing another audio file");
                                                        await controller
                                                            .pauseAllPlayer();
                                                        await controller
                                                            .disposePlayers();
                                                        controller.playAudio(
                                                            musicEntity:
                                                                entity);
                                                      } else {
                                                        iconAnimationController
                                                            .reverse();
                                                        controller
                                                            .pauseAllPlayer();
                                                      }

                                                      break;
                                                    case AudioStatus.pause:
                                                      if (items.first
                                                              .musicName !=
                                                          entity.musicName) {
                                                        await controller
                                                            .pauseAllPlayer();
                                                        await controller
                                                            .disposePlayers();
                                                        controller.playAudio(
                                                            musicEntity:
                                                                entity);
                                                      } else {
                                                        iconAnimationController
                                                            .forward();
                                                        controller
                                                            .resumeAllPlayers();
                                                      }

                                                      break;
                                                    case AudioStatus.stop:
                                                      break;
                                                  }
                                                } else {
                                                  prettyPrint(
                                                      msg: "playing audio");
                                                  controller
                                                      .changeSelectedMusicOnly(
                                                          entity);
                                                  iconAnimationController
                                                      .forward();
                                                  controller.playAudio(
                                                      musicEntity: entity);
                                                }
                                              },
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                child: controller
                                                        .waitingPlayers.value
                                                    ? const CircularProgressIndicator(
                                                        color: AppColors
                                                            .primaryColor,
                                                      )
                                                    : Center(
                                                        child: AnimatedIcon(
                                                          icon: AnimatedIcons
                                                              .play_pause,
                                                          progress:
                                                              iconAnimationController,
                                                          size: 40,
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      ),
                                              ),
                                            );
                                          })))
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Text(
                            widget.musicEntity.musicName,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: GestureDetector(
                            onTap: () {
                              controller.changeExpanded();
                            },
                            child: Obx(() => Text(
                                  widget.musicEntity.musicDescription,
                                  maxLines:
                                      controller.isExpanded.value ? 10 : 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 12,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Obx(() => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Wrap(
                              children: [
                                AnimatedContainer(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  // height: controller.isExpandedComposition.value
                                  //     ? MediaQuery.of(context).size.height * 0.4
                                  //     : 50,
                                  child: Column(
                                    mainAxisAlignment:
                                        controller.isExpandedComposition.value
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          controller
                                              .changeExpandedCompositions();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                "Change Compositions",
                                                style: TextStyle(
                                                    color: AppColors.textColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Icon(
                                                controller.isExpandedComposition
                                                        .value
                                                    ? Icons
                                                        .keyboard_arrow_down_outlined
                                                    : Icons
                                                        .keyboard_arrow_up_outlined,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      controller.isExpandedComposition.value
                                          ? Wrap(
                                              // height: 300,
                                              children: [
                                                Obx(() => controller
                                                            .compositionResponse
                                                            .value
                                                            .status ==
                                                        Status.LOADING
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : controller.compositionResponse
                                                                .value.status ==
                                                            Status.ERROR
                                                        ? const Center(
                                                            child: Text(
                                                                "something went wrong"),
                                                          )
                                                        : ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount: controller
                                                                .compositionResponse
                                                                .value
                                                                .data
                                                                ?.length,
                                                            itemBuilder: (BuildContext
                                                                        context,
                                                                    int
                                                                        index) =>
                                                                controller.compositionDataItem(
                                                                    index:
                                                                        index,
                                                                    model: controller
                                                                            .compositionList[
                                                                        index]),
                                                          ))
                                              ],
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
          ),
        ),
        Obx(() => controller.compositionResponse.value.status == Status.LOADING
            ? Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.5)),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              )
            : Container())
      ],
    );
  }
}
