import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mishi/core/response_classify.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/presentation/pages/payment_page.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:mishi/mishi/presentation/utils/favourite_toggle_icon_widget.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wakelock/wakelock.dart';

import '../../../core/hive_service.dart';
import '../../data/app_remote_routes.dart';
import '../../data/models/music_gif_model.dart';
import '../../data/models/sound_listing_model.dart';
import '../manager/controllers/music_detail_controller.dart';
import '../utils/enums.dart';
import 'motion_image.dart';

class MusicDetail extends StatefulWidget {
  final MusicEntity musicEntity;

  const MusicDetail({Key? key, required this.musicEntity}) : super(key: key);

  @override
  State<MusicDetail> createState() => _MusicDetailState();
}

class _MusicDetailState extends State<MusicDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController iconAnimationController;
  final controller = Get.find<MusicDetailController>();
  late String name;
  late String desc;
  late String image;
  late String smallImage;
  late MusicEntity entity;

  getAudios() async {
    prettyPrint(msg: "getting audio");
    var hiveService = HiveService();
    var t =
        await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
    if (t.values.isEmpty) {
      controller.getAllCompositions(
          widget.musicEntity.musicId, widget.musicEntity.musicName);
    } else if (t.values.first.musicName == widget.musicEntity.musicName) {
      controller.changeListValues();
    } else {
      controller.getAllCompositions(
          widget.musicEntity.musicId, widget.musicEntity.musicName);
    }
  }

  @override
  void initState() {
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    entity = widget.musicEntity;
    name = widget.musicEntity.musicName;
    desc = widget.musicEntity.musicDescription;
    image = widget.musicEntity.largeImageUrl;
    smallImage = widget.musicEntity.smallImageUrl;
    iconAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    getAudios();
    controller.getTiming();
    super.initState();
  }

  formatedTime({required int timeInSecond}) {
    // int minutes = (timeInSecond / 60).truncate();
    // String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    final time = Duration(seconds: timeInSecond);
    var s = (time.inMilliseconds % (60 * 1000)) / 1000;
    return '${time.inMinutes}:${s.toStringAsFixed(0)}';
  }

  Widget timerDialog() {
    return Obx(() => Dialog(
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black87),
              child: Wrap(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Timer/Fader",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          controller.timingValue.value == "infinite"
                              ? Container()
                              : Row(
                                  children: [
                                    const Text(
                                      "Fade\nout",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Switch(
                                        inactiveTrackColor: Colors.white70,
                                        activeColor: Colors.green,
                                        activeTrackColor: Colors.green,
                                        value: controller.toogleFader.value,
                                        onChanged: (val) {
                                          controller.changeToogleFader(val);
                                        }),
                                  ],
                                )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Divider(
                          color: Colors.white70,
                        ),
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: timingList.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 15),
                            child: InkWell(
                              onTap: () async {
                                await controller.writeTiming(timingList[index]);
                                prettyPrint(
                                    msg:
                                        "after writing ${controller.getTiming()}");
                                if (timingList[index] == "infinite") {
                                  controller.pauseTimer();
                                  controller.start.value = 0;
                                } else {
                                  var hiveService = HiveService();
                                  var t =
                                      await hiveService.getBox<PlayerStatus>(
                                          boxName: AppBoxNames.playerBox);
                                  if (t.values.isEmpty) {
                                    prettyPrint(msg: "Not Restoring values");
                                    controller.getTimerinSeconds();
                                  } else {
                                    var td = t.values.first;
                                    if (td.status == AudioStatus.playing) {
                                      prettyPrint(msg: "Restoring values");
                                      controller.startTimer(
                                          controller.getTimerinSeconds());
                                    } else {
                                      prettyPrint(msg: "Not Restoring values");

                                      ;
                                      controller.start.value =
                                          controller.getTimerinSeconds();
                                    }
                                  }
                                }

                                Get.back();
                              },
                              child: Text(
                                timingList[index],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: controller.timingValue.value ==
                                            timingList[index]
                                        ? AppColors.thumbColor
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
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
    return Scaffold(
      // backgroundColor: Colors.white12,
      body: Stack(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                      image: CachedNetworkImageProvider(
                          widget.musicEntity.largeImageUrl))),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.3)),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag: widget.musicEntity.musicName,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: const Offset(0.0, 20.0),
                        spreadRadius: 4,
                        blurRadius: 8.0,
                      ),
                    ]),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          imageUrl: widget.musicEntity.largeImageUrl,
                          // placeholder: (context, string) =>
                          //     Image.asset("assets/images/place_holder.jpg"),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
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
                            bottom: 0,
                            width: MediaQuery.of(context).size.width,
                            child: controller.playerBox.value == null
                                ? Container()
                                : Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Heart(
                                                      data: widget.musicEntity),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        try {
                                                          Get.dialog(
                                                              timerDialog());
                                                        } catch (e) {
                                                          prettyPrint(
                                                              msg:
                                                                  e.toString());
                                                        }
                                                      },
                                                      child: Image.asset(
                                                        "assets/images/timer.png",
                                                        width: 25,
                                                        height: 25,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                            ),
                                            ValueListenableBuilder(
                                                valueListenable: controller
                                                    .playerBox.value!
                                                    .listenable(),
                                                builder: (context,
                                                    Box<PlayerStatus> data,
                                                    widget) {
                                                  var items =
                                                      data.values.toList();
                                                  if (items.isNotEmpty &&
                                                      items.first.musicName !=
                                                          entity.musicName) {
                                                    return Container();
                                                  } else {
                                                    return Obx(() => SizedBox(
                                                          width: 50,
                                                          child: controller
                                                                      .start
                                                                      .value ==
                                                                  0
                                                              ? Container(
                                                                  child: controller
                                                                              .timingValue
                                                                              .value ==
                                                                          timingList
                                                                              .first
                                                                      ? Image
                                                                          .asset(
                                                                          "assets/images/infinity.png",
                                                                          fit: BoxFit
                                                                              .contain,
                                                                          width:
                                                                              25,
                                                                          height:
                                                                              18,
                                                                        )
                                                                      : Text(
                                                                          controller
                                                                              .timingValue
                                                                              .value
                                                                              .replaceAll("mins", ":00")
                                                                              .replaceAll("\n", "")
                                                                              .trim(),
                                                                          style:
                                                                              const TextStyle(color: Colors.white70),
                                                                        ))
                                                              : InkWell(
                                                                  onTap: () {
                                                                    // Get.dialog(
                                                                    //     timerDialog());
                                                                  },
                                                                  child: Text(
                                                                      " ${formatedTime(timeInSecond: controller.start.value)}",
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.white70)),
                                                                ),
                                                        ));
                                                  }
                                                }),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: ValueListenableBuilder(
                                                  valueListenable: controller
                                                      .playerBox.value!
                                                      .listenable(),
                                                  builder: (context,
                                                      Box<PlayerStatus> data,
                                                      widget) {
                                                    var items =
                                                        data.values.toList();
                                                    if (items.isNotEmpty) {
                                                      if (items.first
                                                                  .musicName ==
                                                              entity
                                                                  .musicName &&
                                                          items.first.status ==
                                                              AudioStatus
                                                                  .playing) {
                                                        iconAnimationController
                                                            .forward();
                                                      }
                                                    } else {
                                                      iconAnimationController
                                                          .reverse();
                                                    }
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        controller
                                                            .changeSelectedMusic(
                                                                entity);
                                                        var items = data.values
                                                            .toList();
                                                        prettyPrint(
                                                            msg:
                                                                "items length : ${items.length}");
                                                        if (items.isNotEmpty) {
                                                          prettyPrint(
                                                              msg:
                                                                  "not playing audio ${items.first.status.toString()}");
                                                          if (items.first
                                                                  .musicName ==
                                                              entity
                                                                  .musicName) {
                                                            prettyPrint(
                                                                msg:
                                                                    "Condition equal executing ${items.first.musicName}==${entity.musicName}");
                                                            switch (items
                                                                .first.status) {
                                                              case AudioStatus
                                                                  .downloading:
                                                                // TODO: Handle this case.
                                                                break;
                                                              case AudioStatus
                                                                  .canPlay:
                                                                // TODO: Handle this case.
                                                                break;
                                                              case AudioStatus
                                                                  .playing:
                                                                await controller
                                                                    .pauseAllPlayer(
                                                                        entity);
                                                                iconAnimationController
                                                                    .reverse();
                                                                break;
                                                              case AudioStatus
                                                                  .pause:
                                                                await controller
                                                                    .resumeAllPlayers(
                                                                        entity);
                                                                iconAnimationController
                                                                    .forward();
                                                                break;
                                                              case AudioStatus
                                                                  .stop:
                                                                // TODO: Handle this case.
                                                                break;
                                                            }
                                                          } else {
                                                            prettyPrint(
                                                                msg:
                                                                    "Condition not equal executing ${items.first.musicName}==${entity.musicName}");
                                                            //clearing box values
                                                            final box = await HiveService().getBox<
                                                                    PlayerStatus>(
                                                                boxName: AppBoxNames
                                                                    .playerBox);
                                                            box.clear();
                                                            switch (items
                                                                .first.status) {
                                                              case AudioStatus
                                                                  .downloading:
                                                                // TODO: Handle this case.
                                                                break;
                                                              case AudioStatus
                                                                  .canPlay:
                                                                // TODO: Handle this case.
                                                                break;
                                                              case AudioStatus
                                                                  .playing:
                                                                prettyPrint(
                                                                    msg:
                                                                        "playing another audio file");
                                                                await controller
                                                                    .pauseAllPlayer(
                                                                        entity);
                                                                await controller
                                                                    .disposePlayers();
                                                                controller.playAudio(
                                                                    musicEntity:
                                                                        entity);
                                                                break;
                                                              case AudioStatus
                                                                  .pause:
                                                                await controller
                                                                    .pauseAllPlayer(
                                                                        entity);
                                                                await controller
                                                                    .disposePlayers();
                                                                controller.playAudio(
                                                                    musicEntity:
                                                                        entity);
                                                                break;
                                                              case AudioStatus
                                                                  .stop:
                                                                await controller
                                                                    .pauseAllPlayer(
                                                                        entity);
                                                                break;
                                                            }
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
                                                                color: Color(
                                                                    0xFF8888BE)),
                                                        child: controller
                                                                .waitingPlayers
                                                                .value
                                                            ? const CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            : Center(
                                                                child: AnimatedIcon(
                                                                    icon: AnimatedIcons
                                                                        .play_pause,
                                                                    progress:
                                                                        iconAnimationController,
                                                                    size: 40,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),
                                        // RotatedBox(
                                        //   quarterTurns: -2,
                                        //   child: Countdown(
                                        //     seconds: controller
                                        //         .getTimerinSeconds(),
                                        //     build: (BuildContext context,
                                        //             double time) =>
                                        //         Slider(
                                        //       min: 0,
                                        //       max: controller
                                        //           .getTimerinSeconds()
                                        //           .toDouble(),
                                        //       value: time,
                                        //       onChanged: (val) => {},
                                        //       inactiveColor: Colors.white,
                                        //       activeColor: Colors.white60,
                                        //     ),
                                        //     interval:
                                        //         const Duration(seconds: 1),
                                        //     onFinished: () {
                                        //       controller.pauseAllPlayer();
                                        //     },
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  )))
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black, Colors.black.withOpacity(0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 30),
                          child: Text(
                            widget.musicEntity.musicName,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Scrollbar(
                          // isAlwaysShown: true,
                          thumbVisibility: true,
                          thickness: 5,
                          radius: const Radius.circular(
                              20), //corner radius of scrollbar
                          scrollbarOrientation: ScrollbarOrientation.right,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                widget.musicEntity.musicDescription,
                                // maxLines: 5,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: 8.0, horizontal: 30),
                      //     child: SizedBox(
                      //       height: 150,
                      //       child: Text(
                      //         widget.musicEntity.musicDescription,
                      //         overflow: TextOverflow.ellipsis,
                      //         style: const TextStyle(
                      //           color: AppColors.textColor,
                      //           fontSize: 14,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(() => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Wrap(
                              children: [
                                AnimatedContainer(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  color: Colors.transparent,
                                  // decoration: BoxDecoration(
                                  //     color: Colors.white.withOpacity(0.2),
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(12))),
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
                                      Container(
                                        height: 43,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12))),
                                        child: InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            controller
                                                .changeExpandedCompositions();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Image.asset(
                                                  "assets/images/composition-icon.png",
                                                  width: 25,
                                                  height: 40,
                                                  fit: BoxFit.fill,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.0),
                                                  child: Text(
                                                    "Composition",
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.textColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                // Icon(
                                                //   controller.isExpandedComposition
                                                //           .value
                                                //       ? Icons
                                                //           .keyboard_arrow_up_outlined
                                                //       : Icons
                                                //           .keyboard_arrow_down_outlined,
                                                //   color: Colors.white,
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      controller.isExpandedComposition.value
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Wrap(
                                                // height: 300,
                                                children: [
                                                  Obx(() => controller
                                                              .compositionResponse
                                                              .value
                                                              .status ==
                                                          Status.LOADING
                                                      ? const SizedBox()
                                                      : controller
                                                                  .compositionResponse
                                                                  .value
                                                                  .status ==
                                                              Status.ERROR
                                                          ? const Center(
                                                              child: Text(
                                                                  "something went wrong"),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          20.0),
                                                              child: ListView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                itemCount:
                                                                    controller
                                                                        .compositionList
                                                                        .length,
                                                                itemBuilder: (BuildContext
                                                                            context,
                                                                        int
                                                                            index) =>
                                                                    controller.compositionDataItem(
                                                                        index:
                                                                            index,
                                                                        model: controller
                                                                            .compositionList[index]),
                                                              ),
                                                            ))
                                                ],
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Wrap(
                              children: [
                                AnimatedContainer(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  color: Colors.transparent,
                                  // decoration: BoxDecoration(
                                  //     color: Colors.white.withOpacity(0.2),
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(12))),
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
                                      Container(
                                        height: 43,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12))),
                                        child: InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            controller.changeOtherExpanded();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Image.asset(
                                                  "assets/images/sounds-icon.png",
                                                  width: 25,
                                                  height: 40,
                                                  fit: BoxFit.fill,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                                  child: Text(
                                                    "Sounds ",
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.textColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                // Icon(
                                                //   controller.isOtherExpanded.value
                                                //       ? Icons
                                                //           .keyboard_arrow_up_outlined
                                                //       : Icons
                                                //           .keyboard_arrow_down_outlined,
                                                //   color: Colors.white,
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      controller.isOtherExpanded.value
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Wrap(
                                                // height: 300,
                                                children: [
                                                  Obx(() =>
                                                      ValueListenableBuilder(
                                                          valueListenable:
                                                              controller
                                                                  .playerBox
                                                                  .value!
                                                                  .listenable(),
                                                          builder: (context,
                                                              Box<PlayerStatus>
                                                                  playerData,
                                                              widget) {
                                                            bool show = false;
                                                            if (playerData
                                                                    .isNotEmpty &&
                                                                playerData
                                                                        .values
                                                                        .first
                                                                        .musicName ==
                                                                    entity
                                                                        .musicName) {
                                                              show = true;
                                                            } else {
                                                              show = false;
                                                            }
                                                            return ValueListenableBuilder(
                                                                valueListenable:
                                                                    controller
                                                                        .soundListingBox
                                                                        .value!
                                                                        .listenable(),
                                                                builder: (context,
                                                                    Box<SoundListingModel>
                                                                        data,
                                                                    widget) {
                                                                  // if (controller
                                                                  //     .soundAudioPlayers
                                                                  //     .isEmpty) {
                                                                  //   // controller
                                                                  //   //     .setSoundAudioPlayer(
                                                                  //   //         data.values
                                                                  //   //             .toList());
                                                                  // }
                                                                  var items = data
                                                                      .values
                                                                      .toSet()
                                                                      .toList();

                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            20.0),
                                                                    child: ListView
                                                                        .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      itemCount:
                                                                          items
                                                                              .length,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      itemBuilder: (BuildContext context, int index) => controller.soundListDataItem(
                                                                          index:
                                                                              index,
                                                                          model: items[
                                                                              index],
                                                                          show:
                                                                              show),
                                                                    ),
                                                                  );
                                                                });
                                                          }))
                                                ],
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Wrap(
                              children: [
                                AnimatedContainer(
                                  padding: const EdgeInsets.only(left: 8),
                                  color: Colors.transparent,
                                  // decoration: BoxDecoration(
                                  //     color: Colors.white.withOpacity(0.2),
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(12))),
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  // height: controller.isExpandedComposition.value
                                  //     ? MediaQuery.of(context).size.height * 0.4
                                  //     : 50,
                                  child: Column(
                                    mainAxisAlignment:
                                        controller.isExpandedMotion.value
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 28),
                                        child: InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            controller.changeExpandedMotion();
                                          },
                                          child: Container(
                                            height: 43,
                                            decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(12))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Image.asset(
                                                    "assets/images/motion-icon.png",
                                                    width: 25,
                                                    height: 40,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4.0),
                                                    child: Text(
                                                      "Motion",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .textColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  // Icon(
                                                  //   controller
                                                  //           .isExpandedMotion.value
                                                  //       ? Icons
                                                  //           .keyboard_arrow_up_outlined
                                                  //       : Icons
                                                  //           .keyboard_arrow_down_outlined,
                                                  //   color: Colors.white,
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      controller.isExpandedMotion.value
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                12))),
                                                child: Wrap(
                                                  // height: 300,
                                                  children: [
                                                    ValueListenableBuilder(
                                                        valueListenable:
                                                            controller
                                                                .motionGifBox
                                                                .value!
                                                                .listenable(),
                                                        builder: (context,
                                                            Box<MusicGifModel>
                                                                data,
                                                            widget) {
                                                          var items = data
                                                              .values
                                                              .toList();
                                                          prettyPrint(
                                                              msg:
                                                                  "items length ${items.length}");
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        15.0),
                                                            child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 150,
                                                              child: ListView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const BouncingScrollPhysics(),
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15),
                                                                itemCount: items
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                            index) =>
                                                                        Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          5.0),
                                                                  child:
                                                                      InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      // if (await IsProUser()) {
                                                                      prettyPrint(
                                                                          msg:
                                                                              "tapping");
                                                                      var box = await HiveService().getBox<
                                                                              PlayerStatus>(
                                                                          boxName:
                                                                              AppBoxNames.playerBox);
                                                                      var data = box
                                                                          .values
                                                                          .toList();
                                                                      prettyPrint(
                                                                          msg:
                                                                              "tapping length ${data.length}");
                                                                      if (data
                                                                          .isNotEmpty) {
                                                                        if (data.first.status ==
                                                                            AudioStatus.playing) {
                                                                          if (items[index].musicId ==
                                                                              "endOfFree") {
                                                                            var offerings =
                                                                                await Purchases.getOfferings();
                                                                            if (offerings.current !=
                                                                                null) {
                                                                              Get.to(() => PaymentScreen(
                                                                                    entity: controller.selectedMusic.value!,
                                                                                    offering: offerings.current!,
                                                                                  ));
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Somthing went wrong.")));
                                                                            }
                                                                          } else {
                                                                            Get.to(MotionImageScreen(
                                                                              videoUrl: items[index].mp4Url,
                                                                            ));
                                                                          }
                                                                        } else {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(const SnackBar(content: Text("Please play the audio to watch")));
                                                                        }
                                                                      } else {
                                                                        prettyPrint(
                                                                            msg:
                                                                                "this is wrking");
                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text("Please play the audio to watch")));
                                                                        // Get.dialog(Column(
                                                                        //   children: const [
                                                                        //     Text(
                                                                        //         "Please play th audio")
                                                                        //   ],
                                                                        // ));
                                                                      }
                                                                      // } else {
                                                                      //   ScaffoldMessenger.of(context)
                                                                      //       .showSnackBar(SnackBar(
                                                                      //     content:
                                                                      //         Text(
                                                                      //       "Unlock this by upgrading plan.",
                                                                      //     ),
                                                                      //     action: SnackBarAction(
                                                                      //         label: "Unlock",
                                                                      //         onPressed: () {
                                                                      //           Get.to(() => PaymentScreen(entity: entity));
                                                                      //         }),
                                                                      //   ));
                                                                      // }
                                                                    },
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          CachedNetworkImage(
                                                                            imageUrl:
                                                                                items[index].thumbImage,
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                150,
                                                                            // placeholder: (context, string) =>
                                                                            //     Image.asset(
                                                                            //   "assets/images/place_holder.jpg",
                                                                            //   fit: BoxFit.fill,
                                                                            // ),
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                    const SizedBox(
                                                      height: 20,
                                                    )
                                                  ],
                                                ),
                                              ),
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
                SizedBox(
                  height: 140,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
