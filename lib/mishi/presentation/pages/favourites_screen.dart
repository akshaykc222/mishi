import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

import '../../data/models/music_model.dart';
import '../manager/controllers/music_list_controller.dart';
import '../utils/app_colors.dart';
import 'home.dart';
import 'music_detail.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MusicListController>();
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        AppColors.primaryColor,
        AppColors.primaryColor.withOpacity(0.6),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 26.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // SizedBox(
                    //   width: 5,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 27.0),
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 184,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    //     // Builder(builder: (context) {
                    //     //   return InkWell(
                    //     //     onTap: () {
                    //     //       Scaffold.of(context).openEndDrawer();
                    //     //     },
                    //     //     child: Padding(
                    //     //       padding: const EdgeInsets.all(8.0),
                    //     //       child: Image.asset(
                    //     //         "assets/images/settings.png",
                    //     //         fit: BoxFit.cover,
                    //     //         width: 35,
                    //     //         height: 35,
                    //     //       ),
                    //     //     ),
                    //     //   );
                    //     // })
                  ],
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 27, bottom: 17),
                    child: Text(
                      "Favourites",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "assets/images/heart_filled.png",
                    width: 28,
                    height: 24,
                  )
                ]),
                Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('favourites')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            var items = snapshot.data?.docs.where((element) =>
                                element.id.contains(
                                    "${FirebaseAuth.instance.currentUser?.uid}-"));
                            // items?.forEach((element) {
                            //   prettyPrint(msg: "item $element");
                            //   prettyPrint(msg: element.toString());
                            // });
                            var filterItems = items?.where(
                                (element) => element.get('favourite') == true);
                            prettyPrint(msg: "items leng ${items!.length}");

                            return ListView.builder(
                                padding: const EdgeInsets.only(left: 27),
                                itemCount: filterItems?.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var model = MusicModel.fromJson(filterItems!
                                      .toList()[index]
                                      .get('model'));
                                  return HomeListItem(
                                    thumbnail: model.smallImageUrl,
                                    description: model.musicDescription,
                                    onTap: () => Get.to(() => MusicDetail(
                                          musicEntity: model,
                                        )),
                                    title: model.musicName,
                                    paid: model.musicPremium ?? false,
                                    musicNew: model.musicNew ?? false,
                                    id: model.musicId,
                                  );
                                });
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
