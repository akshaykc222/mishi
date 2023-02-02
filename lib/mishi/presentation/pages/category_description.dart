import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mishi/mishi/presentation/pages/payment_page.dart';
import 'package:mishi/mishi/presentation/pages/web/music_detail_web.dart';
import 'package:mishi/mishi/presentation/pages/web_view.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/response_classify.dart';
import '../../domain/entities/categories.dart';
import '../../domain/entities/music_entity.dart';
import '../manager/bindings/intro_binding.dart';
import '../manager/controllers/login_controller.dart';
import '../manager/controllers/music_detail_controller.dart';
import '../manager/controllers/music_list_controller.dart';
import '../routes/app_pages.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/pretty_print.dart';
import '../widgets/no_connection_widget.dart';
import 'favourites_screen.dart';
import 'home.dart';
import 'intro_screen.dart';
import 'music_detail.dart';

class CategoryDescription extends StatelessWidget {
  final String displayName;
  const CategoryDescription({Key? key, required this.displayName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
    final controller = Get.find<MusicListController>();
    final musicController = Get.find<MusicDetailController>();
    try {
      final loginController = Get.find<LoginController>();
    } catch (e) {
      Get.lazyPut(() => LoginController());
    }
    final loginController = Get.find<LoginController>();
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
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
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
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 15),
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
                                      color:
                                          musicController.timingValue.value ==
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

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fill)
          //     gradient: LinearGradient(colors: [
          //   AppColors.primaryColor,
          //   AppColors.primaryColor.withOpacity(0.6),
          // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
          ),
      child: Scaffold(
        // endDrawer: Drawer(
        //   key: drawerKey,
        //   backgroundColor: AppColors.primaryColor,
        //   child: ListView(
        //     children: [
        //       UserAccountsDrawerHeader(
        //         accountName: Text(loginController.getCurrentUser()),
        //         accountEmail: const Text(""),
        //         currentAccountPicture: const CircleAvatar(
        //           backgroundColor: Colors.white,
        //           child: Icon(
        //             Icons.person,
        //             color: AppColors.primaryColor,
        //           ),
        //         ),
        //       ),
        //       !loginController.checkLogin()
        //           ? ListTile(
        //               onTap: () {
        //                 Get.toNamed(AppPages.login);
        //               },
        //               leading: const Icon(
        //                 Icons.login,
        //                 color: Colors.white,
        //               ),
        //               title: const Text(
        //                 "Login",
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //             )
        //           : ListTile(
        //               onTap: () async {
        //                 try {
        //                   await GoogleSignIn().signOut();
        //                 } catch (e) {}
        //                 await FirebaseAuth.instance.signOut();
        //                 var box = GetStorage();
        //                 box.write("isLogin", false);
        //                 Get.offAllNamed(AppPages.login);
        //               },
        //               leading: const Icon(
        //                 Icons.logout,
        //                 color: Colors.white,
        //               ),
        //               title: const Text(
        //                 "Logout",
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //             ),
        //       ListTile(
        //         onTap: () {},
        //         leading: const Icon(
        //           Icons.delete_outline,
        //           color: Colors.white,
        //         ),
        //         title: const Text(
        //           "Clear Cache",
        //           style: TextStyle(color: Colors.white, fontSize: 16),
        //         ),
        //       ),
        //       ListTile(
        //         onTap: () {},
        //         leading: const Icon(
        //           Icons.timer,
        //           color: Colors.white,
        //         ),
        //         title: const Text(
        //           "Timer/Fader",
        //           style: TextStyle(color: Colors.white, fontSize: 16),
        //         ),
        //       ),
        //       ListTile(
        //         onTap: () {},
        //         leading: const Icon(
        //           Icons.spatial_tracking_outlined,
        //           color: Colors.white,
        //         ),
        //         title: const Text(
        //           "Streaming(Casting)",
        //           style: TextStyle(color: Colors.white, fontSize: 16),
        //         ),
        //       ),
        //       ListTile(
        //         onTap: () {},
        //         leading: const Icon(
        //           Icons.timer,
        //           color: Colors.white,
        //         ),
        //         title: const Text(
        //           "Rate App",
        //           style: TextStyle(color: Colors.white, fontSize: 16),
        //         ),
        //       ),
        //       ListTile(
        //         onTap: () {},
        //         leading: const Icon(
        //           Icons.timer,
        //           color: Colors.white,
        //         ),
        //         title: const Text(
        //           "Intro Screens",
        //           style: TextStyle(color: Colors.white, fontSize: 16),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
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
                            child: CustomTile(
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
                      child: CustomTile(
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
                      child: CustomTile(
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
                      child: CustomTile(
                        onTap: () async {
                          final InAppReview inAppReview = InAppReview.instance;

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
                      child: CustomTile(
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
                      height: 5,
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
                                              child: CustomTile(
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
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: Obx(
          () => Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                // if (controller.categoryBox.value != null)
                ValueListenableBuilder(
                    valueListenable: controller.categoryBox.value!.listenable(),
                    builder: (context, Box<CategoriesEntity> data, _) {
                      var item = data.values.where(
                          (element) => element.displayName == displayName);
                      prettyPrint(msg: "item ${item.first.tagName}");
                      return ValueListenableBuilder(
                        valueListenable:
                            controller.musicListBox.value!.listenable(),
                        builder: (BuildContext context, Box<MusicEntity> data,
                            Widget? child) {
                          var items = data.values
                              .where((element) =>
                                  element.tag1 == item.toList().first.tagName ||
                                  element.tag2 == item.toList().first.tagName ||
                                  element.tag3 == item.toList().first.tagName ||
                                  element.tag6 == item.toList().first.tagName)
                              .toList();
                          return items.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 26.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // SizedBox(
                                            //   width: 5,
                                            // ),

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
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
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'favourites')
                                                          .snapshots(),
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasData) {
                                                          var items = snapshot
                                                              .data?.docs
                                                              .where((element) =>
                                                                  element.id
                                                                      .contains(
                                                                          "${FirebaseAuth.instance.currentUser?.uid}-"));

                                                          return items!
                                                                  .isNotEmpty
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    // Scaffold.of(context).openEndDrawer();
                                                                    prettyPrint(
                                                                        msg:
                                                                            "clicking");
                                                                    // Navigator.of(context).push(
                                                                    //     MaterialPageRoute(
                                                                    //         builder: (context) =>
                                                                    //             const FavouritesScreen()));
                                                                    Get.to(() =>
                                                                        const FavouritesScreen());
                                                                  },
                                                                  child: Image
                                                                      .asset(
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
                                                        return Container();
                                                      }),
                                                ),
                                                Builder(builder: (context) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Scaffold.of(context)
                                                          .openEndDrawer();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  left: 12,
                                                  bottom: 15),
                                              child: Text(
                                                item.first.displayName,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.32,
                                        child: Scrollbar(
                                          // isAlwaysShown: true,
                                          thumbVisibility: true,
                                          thickness: 5,
                                          radius: const Radius.circular(
                                              20), //corner radius of scrollbar
                                          scrollbarOrientation:
                                              ScrollbarOrientation.right,
                                          child: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 27.0, right: 12),
                                              child: Text(
                                                item.first.tagDescription,
                                                // maxLines: 5,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            padding:
                                                const EdgeInsets.only(left: 25),
                                            itemCount: items.length,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return HomeListItem(
                                                paid:
                                                    items[index].musicPremium ??
                                                        false,
                                                thumbnail:
                                                    items[index].smallImageUrl,
                                                description: items[index]
                                                    .musicDescription,
                                                onTap: () async {
                                                  if (items[index]
                                                          .musicPremium ==
                                                      true) {
                                                    if (await IsProUser()) {
                                                      Get.to(
                                                        () => kIsWeb
                                                            ? MusicDetailWeb(
                                                                musicEntity:
                                                                    items[
                                                                        index])
                                                            : MusicDetail(
                                                                musicEntity:
                                                                    items[
                                                                        index]),
                                                      );
                                                    } else {
                                                      var offerings =
                                                          await Purchases
                                                              .getOfferings();
                                                      if (offerings.current !=
                                                          null) {
                                                        Get.to(() =>
                                                            PaymentScreen(
                                                              entity:
                                                                  items[index],
                                                              offering:
                                                                  offerings
                                                                      .current!,
                                                            ));
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "Somthing went wrong.")));
                                                      }
                                                    }
                                                  } else {
                                                    Get.to(
                                                      () => kIsWeb
                                                          ? MusicDetailWeb(
                                                              musicEntity:
                                                                  items[index])
                                                          : MusicDetail(
                                                              musicEntity:
                                                                  items[index]),
                                                    );
                                                  }
                                                },
                                                title: items[index].musicName,
                                                musicNew:
                                                    items[index].musicNew ??
                                                        false,
                                                id: items[index].musicId,
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  child: Text("ERRor"),
                                );
                        },
                      );
                    }),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: controller.haveInternetConnection.value == false
                        ? const NoConnectionWidget()
                        : Container()),
                // Positioned(
                //     bottom: 10,
                //     left: 0,
                //     right: 0,
                //     child: controller.playerBox.value == null
                //         ? Container()
                //         : const MiniPlayer()),
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
