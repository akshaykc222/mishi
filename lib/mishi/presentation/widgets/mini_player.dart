// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_detail_controller.dart';
import 'package:mishi/mishi/presentation/pages/music_detail.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:mishi/mishi/presentation/utils/enums.dart';

import '../utils/pretty_print.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController iconAnimationController;
  @override
  void initState() {
    iconAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    super.initState();
  }

  bool hide = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MusicDetailController>();
    return controller.playerBox.value == null
        ? Container()
        : ValueListenableBuilder(
            valueListenable: controller.playerBox.value!.listenable(),
            builder: (context, Box<PlayerStatus> data, widget) {
              var item = data.values.toList();
              prettyPrint(msg: "mini player i ${item.length}");
              if (item.isNotEmpty) {
                if (item.first.status == AudioStatus.playing) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      hide = false;
                    });
                  });
                  iconAnimationController.forward();
                } else {
                  iconAnimationController.reverse();
                }
              }
              return item.isEmpty
                  ? Container()
                  : hide
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            // padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => MusicDetail(
                                        musicEntity:
                                            controller.selectedMusic.value!));
                                  },
                                  child: Container(
                                    width: 85,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        // shape: BoxShape.circle,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: CachedNetworkImageProvider(
                                                item.first.image))),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => MusicDetail(
                                          musicEntity:
                                              controller.selectedMusic.value!));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        // width: MediaQuery.of(context).size.width *
                                        //     0.32,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.first.musicName,
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              item.first.description,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    var items = data.values.toList();
                                    if (items.isNotEmpty) {
                                      prettyPrint(msg: "not playing audio");

                                      switch (items.first.status) {
                                        case AudioStatus.downloading:
                                          break;
                                        case AudioStatus.canPlay:
                                          break;
                                        case AudioStatus.playing:
                                          iconAnimationController.reverse();
                                          controller.pauseAllPlayer(
                                              controller.selectedMusic.value!);

                                          break;
                                        case AudioStatus.pause:
                                          iconAnimationController.forward();
                                          controller.resumeAllPlayers(
                                              controller.selectedMusic.value!);

                                          break;
                                        case AudioStatus.stop:
                                          break;
                                      }
                                    }
                                  },
                                  child: Container(
                                    // width: 40,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: controller.waitingPlayers.value
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: AppColors.primaryColor,
                                            ),
                                          )
                                        : Center(
                                            child: AnimatedIcon(
                                              icon: AnimatedIcons.play_pause,
                                              progress: iconAnimationController,
                                              size: 40,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        hide = true;
                                        controller.pauseAllPlayer(
                                            controller.selectedMusic.value!);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 30,
                                      color: AppColors.primaryColor,
                                    ))
                              ],
                            ),
                          ),
                        );
            });
  }
}
