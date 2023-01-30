import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:mishi/core/response_classify.dart';
import 'package:mishi/mishi/data/models/music_model.dart';
import 'package:mishi/mishi/domain/entities/categories.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/presentation/manager/controllers/login_controller.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_detail_controller.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_list_controller.dart';
import 'package:mishi/mishi/presentation/pages/category_description.dart';
import 'package:mishi/mishi/presentation/pages/intro_screen.dart';
import 'package:mishi/mishi/presentation/pages/payment_page.dart';
import 'package:mishi/mishi/presentation/pages/web/music_detail_web.dart';
import 'package:mishi/mishi/presentation/pages/web_view.dart';
import 'package:mishi/mishi/presentation/routes/app_pages.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';
import 'package:mishi/mishi/presentation/widgets/no_connection_widget.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/hive_service.dart';
import '../../data/app_remote_routes.dart';
import '../../domain/entities/player_status.dart';
import '../manager/bindings/intro_binding.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../widgets/mini_player.dart';
import 'favourites_screen.dart';
import 'music_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  final controller = Get.find<MusicListController>();
  final musicController = Get.find<MusicDetailController>();
  AppLifecycleState? state;
  @override
  void initState() {
    // addProUser();
    // Future.delayed(const Duration(seconds: 5), () {
    //   if (AssetsAudioPlayer.allPlayers().isNotEmpty) {
    //     AssetsAudioPlayer.allPlayers()
    //         .values
    //         .first
    //         .realtimePlayingInfos
    //         .listen((event) {
    //       if (event.isPlaying == false && state == AppLifecycleState.paused) {
    //         musicController
    //             .pauseAllPlayer(musicController.selectedMusic.value!);
    //       }
    //     });
    //   }
    // });
    WidgetsBinding.instance.addObserver(this);
    updateApp();
    var box = GetStorage();
    if (box.hasData("login_data")) {
      MusicEntity entity = MusicModel.fromJson(box.read("login_data"));
      box.remove("login_data");
      Get.to(() => MusicDetail(musicEntity: entity));
    }
    // MediaNotificationx.showNotificationManager(
    //     title: "title", author: "author", isPlaying: true);
    super.initState();
  }

  updateApp() {
    try {
      InAppUpdate.checkForUpdate().then((updateInfo) {
        if (updateInfo.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          if (updateInfo.immediateUpdateAllowed) {
            // Perform immediate update
            InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
              if (appUpdateResult == AppUpdateResult.success) {
                //App Update successful
              }
            });
          } else if (updateInfo.flexibleUpdateAllowed) {
            //Perform flexible update
            InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
              if (appUpdateResult == AppUpdateResult.success) {
                //App Update successful
                InAppUpdate.completeFlexibleUpdate();
              }
            });
          }
        }
      });
    } catch (e) {}
  }

  ValueNotifier<AppLifecycleState> listenable =
      ValueNotifier(AppLifecycleState.resumed);
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        state = AppLifecycleState.resumed;
        listenable.value = AppLifecycleState.resumed;
        break;
      case AppLifecycleState.inactive:
        state = AppLifecycleState.inactive;
        listenable.value = AppLifecycleState.inactive;
        break;
      case AppLifecycleState.paused:
        state = AppLifecycleState.paused;
        listenable.value = AppLifecycleState.paused;
        break;
      case AppLifecycleState.detached:
        state = AppLifecycleState.detached;
        listenable.value = AppLifecycleState.detached;
        break;
    }
    listenable.notifyListeners();
  }

  @override
  void dispose() async {
    // var d = await HiveService().getBox(boxName: AppBoxNames.playerBox);
    // d.clear();
    FlutterForegroundTask.stopService();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
                          musicController.timingValue.value == "infinite"
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
                                        value:
                                            musicController.toogleFader.value,
                                        onChanged: (val) {
                                          musicController
                                              .changeToogleFader(val);
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
                                await musicController
                                    .writeTiming(timingList[index]);
                                if (timingList[index] == "infinite") {
                                  musicController.pauseTimer();
                                  musicController.start.value = 0;
                                } else {
                                  var hiveService = HiveService();
                                  var t =
                                      await hiveService.getBox<PlayerStatus>(
                                          boxName: AppBoxNames.playerBox);
                                  if (t.values.isEmpty) {
                                    musicController.getTimerinSeconds();
                                  } else {
                                    var td = t.values.first;
                                    if (td.status == AudioStatus.playing) {
                                      prettyPrint(msg: "Restoring values");
                                      musicController.startTimer(
                                          musicController.getTimerinSeconds());
                                    } else {
                                      prettyPrint(msg: "Not Restoring values");
                                      musicController.getTimerinSeconds();
                                    }
                                  }
                                }

                                Get.back();
                              },
                              child: Text(
                                timingList[index],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: musicController.timingValue.value ==
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
  Widget build(BuildContext context) {
    try {
      final loginController = Get.find<LoginController>();
    } catch (e) {
      Get.lazyPut(() => LoginController());
    }
    final loginController = Get.find<LoginController>();
    return WillStartForegroundTask(
      onWillStart: () async {
        var values = await HiveService()
            .getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);

        return values.isNotEmpty
            ? values.values.first.status == AudioStatus.playing
                ? true
                : false
            : false;
      },
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: false,
        allowWifiLock: false,
      ),
      notificationTitle: musicController.selectedTitle,
      notificationText: "",
      callback: startCallback,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/background.png"))
            //     gradient: LinearGradient(colors: [
            //   AppColors.primaryColor,
            //   AppColors.primaryColor.withOpacity(0.6),
            // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
            ),
        child: Scaffold(
          endDrawer: Drawer(
            key: drawerKey,
            backgroundColor: AppColors.primaryColor,
            child: Obx(() => Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50.0, left: 8),
                        child: SizedBox(
                          width: 120,
                          height: 90,
                          child: Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.cover,
                            // width: 50,
                          ),
                        ),
                      ),
                      // loginController.getCurrentUser() == ""
                      //     ? Container()
                      //     : SizedBox(
                      //         height: 40,
                      //         child: ListTile(
                      //           title: Text(
                      //             loginController.getCurrentUser(),
                      //             style: const TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w400),
                      //           ),
                      //         ),
                      //       ),
                      !loginController.checkLogin()
                          ? SizedBox(
                              height: 40,
                              child: ListTile(
                                onTap: () {
                                  if (musicController.selectedMusic.value !=
                                      null) {
                                    // musicController.pauseAllPlayer(
                                    //     musicController.selectedMusic.value!);
                                  }

                                  Get.toNamed(AppPages.login);
                                },
                                // leading: const Icon(
                                //   Icons.login,
                                //   color: Colors.white,
                                // ),
                                title: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          : SizedBox(
                              // height: 40,
                              // child: ListTile(
                              //   onTap: () async {
                              //     try {
                              //       await GoogleSignIn().signOut();
                              //     } catch (e) {}
                              //     await FirebaseAuth.instance.signOut();
                              //     var box = GetStorage();
                              //     box.write("isLogin", false);
                              //     Get.offAllNamed(AppPages.login);
                              //   },
                              //   // leading: const Icon(
                              //   //   Icons.logout,
                              //   //   color: Colors.white,
                              //   // ),
                              //   title: const Text(
                              //     "Logout",
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w400),
                              //   ),
                              // ),
                              ),
                      SizedBox(
                        height: 40,
                        child: ListTile(
                          onTap: () async {
                            Get.toNamed(AppPages.profile);

                            // Get.snackbar("Cleared", "All cache files cleared");
                          },
                          // leading: const Icon(
                          //   Icons.delete_outline,
                          //   color: Colors.white,
                          // ),
                          title: const Text(
                            "Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: ListTile(
                          onTap: () async {
                            Get.toNamed(AppPages.clear_chache);

                            // Get.snackbar("Cleared", "All cache files cleared");
                          },
                          // leading: const Icon(
                          //   Icons.delete_outline,
                          //   color: Colors.white,
                          // ),
                          title: const Text(
                            "Clear Cache",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 40,
                      //   child: ListTile(
                      //     onTap: () {
                      //       Get.dialog(timerDialog());
                      //     },
                      //     // leading: const Icon(
                      //     //   Icons.timer,
                      //     //   color: Colors.white,
                      //     // ),
                      //     title: const Text(
                      //       "Timer/Fader",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w400),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 40,
                        child: ListTile(
                          onTap: () async {
                            final InAppReview inAppReview =
                                InAppReview.instance;

                            if (await inAppReview.isAvailable()) {
                              inAppReview.requestReview();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please try after sometimes")));
                            }
                          },
                          // leading: const Icon(
                          //   Icons.timer,
                          //   color: Colors.white,
                          // ),
                          title: const Text(
                            "Rate App",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: ListTile(
                          onTap: () {
                            Get.to(
                                () => const IntroScreen(
                                      fromSettings: true,
                                    ),
                                binding: IntroBinding());
                          },
                          // leading: const Icon(
                          //   Icons.timer,
                          //   color: Colors.white,
                          // ),
                          title: const Text(
                            "Intro Screens",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                      controller.staticPagesResponse.value.status ==
                              Status.LOADING
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Wrap(
                              children: [
                                MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: controller
                                              .staticPagesResponse.value.data ==
                                          null
                                      ? const SizedBox()
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: controller
                                              .staticPagesResponse
                                              .value
                                              .data
                                              ?.length,
                                          itemBuilder: (context, index) =>
                                              SizedBox(
                                                height: 40,
                                                child: ListTile(
                                                  onTap: () => Get.to(() =>
                                                      WebViewCustom(
                                                          url: controller
                                                              .staticPagesResponse
                                                              .value
                                                              .data![index]
                                                              .pageUrl)),
                                                  title: Text(
                                                    controller
                                                        .staticPagesResponse
                                                        .value
                                                        .data![index]
                                                        .pageTitle,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              )),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            )
                    ],
                  ),
                )),
          ),
          backgroundColor: Colors.transparent,
          drawerEnableOpenDragGesture: false,
          // appBar: PreferredSize(
          //   preferredSize: Size(MediaQuery.of(context).size.width, 55),
          //   child: Builder(builder: (context) {
          //     return Column(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //
          //       ],
          //     );
          //   }),
          // ),
          body: Obx(
            () => SafeArea(
              child: Stack(
                children: [
                  if (controller.categoryBox.value != null)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 26.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SizedBox(
                              //   width: 5,
                              // ),

                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  width: 184,
                                  // height: 100,
                                  // fit: BoxFit.c,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 28,
                                    height: 24,
                                    child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('favourites')
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            var items = snapshot.data?.docs.where(
                                                (element) => element.id.contains(
                                                    "${FirebaseAuth.instance.currentUser?.uid}-"));
                                            var filterItems = items?.where(
                                                (element) =>
                                                    element.get('favourite') ==
                                                    true);
                                            return filterItems != null &&
                                                    filterItems.isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      // Scaffold.of(context).openEndDrawer();
                                                      prettyPrint(
                                                          msg: "clicking");
                                                      // Navigator.of(context).push(
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             const FavouritesScreen()));
                                                      Get.to(() =>
                                                          const FavouritesScreen());
                                                    },
                                                    child: Image.asset(
                                                      "assets/images/heart_filled.png",
                                                      width: 33,
                                                      height: 29,
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          const FavouritesScreen());
                                                    },
                                                    child: Image.asset(
                                                      "assets/images/heart_unfilled.png",
                                                      width: 33,
                                                      height: 29,
                                                    ),
                                                  );
                                          }
                                          return GestureDetector(
                                            onTap: () => Get.to(
                                                () => const FavouritesScreen()),
                                            child: Image.asset(
                                              "assets/images/heart_unfilled.png",
                                              width: 33,
                                              height: 29,
                                            ),
                                          );
                                        }),
                                  ),
                                  Builder(builder: (context) {
                                    return InkWell(
                                      onTap: () {
                                        Scaffold.of(context).openEndDrawer();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          "assets/images/settings.png",
                                          fit: BoxFit.cover,
                                          width: 35,
                                          height: 35,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              )
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable:
                                controller.categoryBox.value!.listenable(),
                            builder: (context, Box<CategoriesEntity> data, _) {
                              prettyPrint(
                                  msg: "value builder size ${data.length}");
                              data.values.toList().sort(
                                  (a, b) => a.tagOrder.compareTo(b.tagOrder));
                              return Expanded(
                                child: data.values.isEmpty
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        // padding: const EdgeInsets.only(top: 20),
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: data.values.length,
                                        itemBuilder: (context, index) =>
                                            HomeItem(
                                              categoriesEntity:
                                                  data.values.toList()[index],
                                              index: index,
                                            )),
                              );
                            }),
                      ],
                    ),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: controller.haveInternetConnection.value == false
                          ? const NoConnectionWidget()
                          : Container()),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: controller.playerBox.value == null
                          ? Container()
                          : const MiniPlayer()),
                ],
              ),
            ),
          ),
          // bottomNavigationBar: Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 60,
          //   decoration: BoxDecoration(
          //       color: AppColors.primaryColor.withOpacity(0.6),
          //       borderRadius: const BorderRadius.only(
          //           topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          //   child: const Center(child: CustomBottomAppBar()),
          // ),
        ),
      ),
    );
  }
}

class HomeItem extends StatelessWidget {
  final CategoriesEntity categoriesEntity;
  final bool? description;
  final int index;
  const HomeItem(
      {Key? key,
      required this.categoriesEntity,
      this.description,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MusicListController>();

    // pre initializing controllers before navigation
    if (kIsWeb) {
      // final detailController = Get.find<MusicDetailControllerWeb>();
    } else {
      final detailController = Get.find<MusicDetailController>();
    }

    return Obx(() => controller.musicListBox.value == null
        ? Container()
        : ValueListenableBuilder(
            valueListenable: controller.musicListBox.value!.listenable(),
            builder:
                (BuildContext context, Box<MusicEntity> data, Widget? child) {
              var items = data.values
                  .where((element) =>
                      element.tag1 == categoriesEntity.tagName ||
                      element.tag2 == categoriesEntity.tagName ||
                      element.tag3 == categoriesEntity.tagName ||
                      element.tag6 == categoriesEntity.tagName)
                  .toList();
              items.sort((a, b) => a.priority.compareTo(b.priority));
              return items.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: index == 0 ? 0 : 10.0, bottom: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height:
                            kIsWeb && MediaQuery.of(context).size.width > 800
                                ? description == true
                                    ? null
                                    : 260
                                : description == true
                                    ? null
                                    : 248,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 27, bottom: 17),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Padding(

                                  Text(
                                    categoriesEntity.displayName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  description == null
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.to(() => CategoryDescription(
                                                  displayName: categoriesEntity
                                                      .displayName,
                                                ));
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            // padding: EdgeInsets.only(bottom: 2),
                                            // margin: EdgeInsets.only(bottom: 6),
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                              "assets/svg/info.png",

                                              // color: AppColors.primaryColor,
                                            ))),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            description == true
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Text(
                                      categoriesEntity.tagDescription,
                                      // maxLines: 5,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  )
                                : Container(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 27.0),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return HomeListItem(
                                        paid:
                                            items[index].musicPremium ?? false,
                                        thumbnail: items[index].smallImageUrl,
                                        description:
                                            items[index].musicDescription,
                                        onTap: () async {
                                          if (items[index].musicPremium ==
                                              true) {
                                            if (await IsProUser()) {
                                              Get.to(
                                                () => kIsWeb
                                                    ? MusicDetailWeb(
                                                        musicEntity:
                                                            items[index])
                                                    : MusicDetail(
                                                        musicEntity:
                                                            items[index]),
                                              );
                                            } else {
                                              var offerings = await Purchases
                                                  .getOfferings();
                                              if (offerings.current != null) {
                                                Get.to(() => PaymentScreen(
                                                      entity: items[index],
                                                      offering:
                                                          offerings.current!,
                                                    ));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Somthing went wrong.")));
                                              }
                                            }
                                          } else {
                                            Get.to(
                                              () => kIsWeb
                                                  ? MusicDetailWeb(
                                                      musicEntity: items[index])
                                                  : MusicDetail(
                                                      musicEntity:
                                                          items[index]),
                                            );
                                          }
                                        },
                                        title: items[index].musicName,
                                        musicNew:
                                            items[index].musicNew ?? false,
                                        id: items[index].musicId,
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
          ));
  }
}

class HomeListItem extends StatelessWidget {
  final String thumbnail;
  final String title;
  final String description;
  final Function onTap;
  final bool musicNew;
  final bool paid;
  final String id;
  const HomeListItem(
      {Key? key,
      required this.thumbnail,
      required this.description,
      required this.onTap,
      required this.title,
      required this.paid,
      required this.musicNew,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: SizedBox(
          width: kIsWeb && MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width * 0.2
              : MediaQuery.of(context).size.width * 0.47,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: title,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: thumbnail,
                        fit: BoxFit.fill,
                        placeholder: (context, val) => const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                              child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator())),
                        ),
                        width: kIsWeb && MediaQuery.of(context).size.width > 800
                            ? MediaQuery.of(context).size.width * 0.2
                            : MediaQuery.of(context).size.width * 0.47,
                        height:
                            kIsWeb && MediaQuery.of(context).size.width > 800
                                ? 150
                                : 120,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('favourites')
                              .doc(
                                  "${FirebaseAuth.instance.currentUser?.uid}-$id")
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data?.exists ?? false) {
                                if ((snapshot.data?.get('favourite') as bool) ==
                                    true) {
                                  return Image.asset(
                                    "assets/images/heart_filled.png",
                                    width: 28,
                                    height: 24,
                                  );
                                } else {
                                  return Image.asset(
                                    "assets/images/heart_unfilled.png",
                                    width: 28,
                                    height: 24,
                                  );
                                }
                              } else {
                                return Image.asset(
                                  "assets/images/heart_unfilled.png",
                                  width: 28,
                                  height: 24,
                                );
                              }
                            }
                            return Image.asset(
                              "assets/images/heart_unfilled.png",
                              width: 28,
                              height: 24,
                            );
                          })),
                  Positioned(
                      top: 5,
                      right: 10,
                      child: FutureBuilder(
                          future: IsProUser(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return snap.data as bool
                                  ? Container()
                                  : Container(
                                      decoration: BoxDecoration(
                                          // color: Colors.red.shade300,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0, vertical: 2),
                                        child: paid
                                            ? Image.asset(
                                                'assets/images/padlock.png',
                                                width: 20,
                                                height: 20,
                                              )
                                            : Container(
                                                width: 40,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: const Center(
                                                  child: Text(
                                                    "Free",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    );
                            }
                            return Container();
                          })),
                  musicNew
                      ? Positioned(
                          top: 5,
                          left: 10,
                          child: Container(
                            width: 40,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Center(
                              child: Text(
                                "New",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ))
                      : Container(),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textColor),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: AppColors.textColor, fontSize: 12),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
