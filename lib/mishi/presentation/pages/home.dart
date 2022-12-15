import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mishi/core/response_classify.dart';
import 'package:mishi/mishi/data/models/music_model.dart';
import 'package:mishi/mishi/domain/entities/categories.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/presentation/manager/controllers/login_controller.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_detail_controller.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_list_controller.dart';
import 'package:mishi/mishi/presentation/manager/controllers/web_music_detail_controller.dart';
import 'package:mishi/mishi/presentation/pages/category_description.dart';
import 'package:mishi/mishi/presentation/pages/intro_screen.dart';
import 'package:mishi/mishi/presentation/pages/payment_page.dart';
import 'package:mishi/mishi/presentation/pages/web/music_detail_web.dart';
import 'package:mishi/mishi/presentation/pages/web_view.dart';
import 'package:mishi/mishi/presentation/routes/app_pages.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';
import 'package:mishi/mishi/presentation/widgets/no_connection_widget.dart';

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

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  final controller = Get.find<MusicListController>();
  final musicController = Get.find<MusicDetailController>();
  @override
  void initState() {
    addProUser();
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

  @override
  void dispose() async {
    // var d = await HiveService().getBox(boxName: AppBoxNames.playerBox);
    // d.clear();
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
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: const Text(
                              "Timer/Fader",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          Row(
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
                                  value: musicController.toogleFader.value,
                                  onChanged: (val) {
                                    musicController.changeToogleFader(val);
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
                                musicController.startTimer(
                                    musicController.getTimerinSeconds());
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
    return Container(
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
                    loginController.getCurrentUser() == ""
                        ? Container()
                        : SizedBox(
                            height: 40,
                            child: ListTile(
                              title: Text(
                                loginController.getCurrentUser(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                    !loginController.checkLogin()
                        ? SizedBox(
                            height: 40,
                            child: ListTile(
                              onTap: () {
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
                            height: 40,
                            child: ListTile(
                              onTap: () async {
                                try {
                                  await GoogleSignIn().signOut();
                                } catch (e) {}
                                await FirebaseAuth.instance.signOut();
                                var box = GetStorage();
                                box.write("isLogin", false);
                                Get.offAllNamed(AppPages.login);
                              },
                              // leading: const Icon(
                              //   Icons.logout,
                              //   color: Colors.white,
                              // ),
                              title: const Text(
                                "Logout",
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
                    SizedBox(
                      height: 40,
                      child: ListTile(
                        onTap: () {
                          Get.dialog(timerDialog());
                        },
                        // leading: const Icon(
                        //   Icons.timer,
                        //   color: Colors.white,
                        // ),
                        title: const Text(
                          "Timer/Fader",
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
                        onTap: () {},
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
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller
                                        .staticPagesResponse.value.data?.length,
                                    itemBuilder: (context, index) => SizedBox(
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
                                              controller.staticPagesResponse
                                                  .value.data![index].pageTitle,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
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
                                              : Image.asset(
                                                  "assets/images/heart_unfilled.png",
                                                  width: 33,
                                                  height: 29,
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
                              child: ListView.builder(
                                  // padding: const EdgeInsets.only(top: 20),
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: data.values.length,
                                  itemBuilder: (context, index) => HomeItem(
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
      final detailController = Get.find<MusicDetailControllerWeb>();
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
                  .where((element) => element.tag1 == categoriesEntity.tagName)
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
                                    : 240,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 27, bottom: 17),
                                  child: Text(
                                    categoriesEntity.displayName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
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
                                          margin: EdgeInsets.only(bottom: 6),
                                          decoration: BoxDecoration(
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
                                              Get.to(() => PaymentScreen(
                                                    entity: items[index],
                                                  ));
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
                                            : Image.asset(
                                                'assets/images/free.png',
                                                width: 45,
                                                height: 24,
                                                fit: BoxFit.fill,
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
                            decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 2),
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
