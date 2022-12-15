import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/presentation/manager/controllers/login_controller.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_detail_controller.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

class Heart extends StatefulWidget {
  final MusicEntity data;
  const Heart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  // final controller = Get.find<ProductController>();
  bool isFavourite = false;
  final authController = Get.find<LoginController>();
  final musicController = Get.find<MusicDetailController>();
  // addFavourite(bool value) async {
  //   var user = FirebaseAuth.instance.currentUser;
  //   var instance = FirebaseFirestore.instance;
  //   final data = instance
  //       .collection('favourites')
  //       .doc("${user?.uid}-${widget.data.id}")
  //       .snapshots();
  //   var len = await data;
  //
  //   prettyPrint(msg: len.toString());
  //   // if (data != 0) {
  //   instance
  //       .collection('favourites')
  //       .doc("${user?.uid}-${widget.data.id}")
  //       .set({'favourite': value});
  //   // } else {
  //   //   instance
  //   //       .collection('favourites')
  //   //       .doc("${user?.uid}-${widget.data.id}")
  //   //       .update({'favourite': value});
  //   // }
  // }

  @override
  void initState() {
    // prettyPrint(msg: "${Timing}");
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _colorAnimation =
        ColorTween(begin: Colors.white70, end: Colors.red).animate(_controller);

    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 30, end: 50),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 50, end: 30),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isFavourite = true;
        // setState(() {});
      }
      if (status == AnimationStatus.dismissed) {
        // setState(() {
        //   isFavourite = false;
        //   prettyPrint(msg: "DISMISSED");
        // });
      }
    });
  }

  // dismiss the animation when widgit exits screen
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favourites')
            .doc(
                "${FirebaseAuth.instance.currentUser?.uid}-${widget.data.musicId}")
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            try {
              final dat = snapshot.data?.data();
              if (dat != null) {
                prettyPrint(msg: "fav ${dat['favourite']}");
                isFavourite = dat['favourite'];
                isFavourite == false
                    ? _controller.reverse()
                    : _controller.forward();
              }
            } catch (e) {
              prettyPrint(msg: e.toString());
            }
          }
          return AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, _) {
                return GestureDetector(
                  child: isFavourite
                      ? Image.asset(
                          "assets/images/heart_filled.png",
                          width: 27,
                          height: 27,
                        )
                      : Image.asset("assets/images/heart_unfilled.png",
                          width: 27, height: 27),
                  onTap: () async {
                    // addFavourite(isFavourite);
                    try {
                      // if (FirebaseAuth.instance.currentUser?.isAnonymous ==
                      //     true)
                      if (false) {
                        Get.snackbar("Login to add favourites",
                            "Login required to access this function",
                            backgroundColor: Colors.black87,
                            colorText: AppColors.textColor,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(15),
                            duration: const Duration(seconds: 5),
                            mainButton: TextButton(
                                onPressed: () async {
                                  Get.closeCurrentSnackbar();

                                  var storage = GetStorage();
                                  storage.write("login_return", true);
                                  storage.write(
                                      "login_data", widget.data.toJson());
                                  await musicController.stopAllPlayers();
                                  await authController.logout();
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )));
                      } else {
                        var user = FirebaseAuth.instance.currentUser;

                        var instance = FirebaseFirestore.instance;
                        prettyPrint(msg: "user uid ${user?.uid}");
                        final data = await instance
                            .collection('favourites')
                            .doc("${user?.uid}-${widget.data.musicId}")
                            .get();
                        if (data.exists) {
                          instance
                              .collection('favourites')
                              .doc("${user?.uid}-${widget.data.musicId}")
                              .update({
                            'favourite': !isFavourite,
                            'model': widget.data.toJson()
                          });
                        } else {
                          instance
                              .collection('favourites')
                              .doc("${user?.uid}-${widget.data.musicId}")
                              .set({
                            'favourite': !isFavourite,
                            'model': widget.data.toJson()
                          });
                        }

                        isFavourite == true
                            ? _controller.reverse()
                            : _controller.forward();
                        setState(() {});
                      }
                    } catch (e) {
                      Get.snackbar("Login to add favourites",
                          "Login required to access this function",
                          backgroundColor: Colors.black87,
                          colorText: AppColors.textColor,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(15),
                          duration: const Duration(seconds: 5),
                          mainButton: TextButton(
                              onPressed: () async {
                                Get.closeCurrentSnackbar();

                                var storage = GetStorage();
                                storage.write("login_return", true);
                                storage.write(
                                    "login_data", widget.data.toJson());
                                await musicController.stopAllPlayers();
                                await authController.logout();
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )));
                    }
                  },
                );
              });
        });
  }
}
