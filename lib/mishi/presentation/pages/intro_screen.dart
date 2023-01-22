import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:get/get.dart';
import 'package:mishi/core/response_classify.dart';
import 'package:mishi/mishi/presentation/manager/controllers/intro_controller.dart';
import 'package:mishi/mishi/presentation/manager/controllers/login_controller.dart';
import 'package:mishi/mishi/presentation/pages/web_view.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

class IntroScreen extends StatefulWidget {
  final bool? fromSettings;
  const IntroScreen({Key? key, this.fromSettings}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final pageController = PageController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int previousPageViewIndex = 0;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  void launchEmailSubmission() async {
    isLoading.value = true;

    // final Uri params = Uri(
    //     scheme: 'info@getmishi.com',
    //     path: emailController.text,
    //     queryParameters: {
    //       'subject': 'Support',
    //       'body': 'please add your query'
    //     });
    // String url = params.toString();
    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url));
    // } else {
    //   print('Could not launch $url');
    // }
    await FirebaseAuth.instance.signInAnonymously();
    FirebaseFirestore.instance
        .collection("emails")
        .add({'email': emailController.text}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(" "
              "Thank you for subscribing.")));
      isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IntroController>();
    return Scaffold(
      body: SafeArea(
        child: Obx(() => controller.response.value.status == Status.LOADING
            ? const Center(
                child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ))
            : controller.response.value.status == Status.ERROR
                ? const Center(
                    child: Text("No internet connection"),
                  )
                : SwipeDetector(
                    onSwipeLeft: (offset) {
                      if (!controller.indicatorVisible.value) {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);
                      }
                    },
                    onSwipeRight: (offset) {
                      pageController.previousPage(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeIn);
                    },
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: PageView.builder(
                            controller: pageController,
                            onPageChanged: (index) {
                              // if (!controller.indicatorVisible.value) {
                              //  pageController.
                              // }
                              // previousPageViewIndex = index;
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            // physics: !controller.indicatorVisible.value
                            //     ? const NeverScrollableScrollPhysics()
                            //     : const ClampingScrollPhysics(),
                            itemCount: widget.fromSettings == true
                                ? (controller.response.value.data?.length ??
                                        2) -
                                    2
                                : controller.response.value.data?.length,
                            itemBuilder: (context, position) {
                              prettyPrint(
                                  msg:
                                      "${controller.response.value.data!.length - 2}>$position");
                              if (controller.response.value.data!.length - 2 >
                                  position) {
                                // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                controller.changeIndicatorVisible(false);
                                // });
                              } else {
                                // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                controller.changeIndicatorVisible(true);
                                // pageController.
                                // });
                              }

                              var item =
                                  controller.response.value.data![position];
                              return Stack(
                                children: [
                                  SwipeDetector(
                                    onSwipeLeft: (offset) {
                                      if (!controller.indicatorVisible.value) {
                                        pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 400),
                                            curve: Curves.easeIn);
                                      }
                                    },
                                    onSwipeRight: (offset) {
                                      pageController.previousPage(
                                          duration:
                                              const Duration(milliseconds: 800),
                                          curve: Curves.easeIn);
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.35,
                                          color: Colors.greenAccent,
                                          child: CachedNetworkImage(
                                            imageUrl: item.image,
                                            progressIndicatorBuilder:
                                                (context, str, progress) =>
                                                    Center(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  value: progress.progress,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16,
                                              left: 16,
                                              right: 16,
                                              bottom: 10),
                                          child: Text(
                                            item.text,
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        item.name.toLowerCase() ==
                                                "Terms".toLowerCase()
                                            ? Column(
                                                children: [
                                                  const Text(
                                                      "To continue please agree to our",
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 16)),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          const WebViewCustom(
                                                              url:
                                                                  "https://www.getmishi.com/terms"));
                                                    },
                                                    child: const Text(
                                                      "terms and conditions",
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 16,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 18,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      pageController.nextPage(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      400),
                                                          curve: Curves.easeIn);
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25)),
                                                      child: const Center(
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        item.name.toLowerCase() ==
                                                "CaptureEmail".toLowerCase()
                                            ? Form(
                                                key: formKey,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 300,
                                                      height: 50,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .primaryColor),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          20))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Expanded(
                                                              child:
                                                                  TextFormField(
                                                            validator: (val) {
                                                              if (!GetUtils
                                                                  .isEmail(
                                                                      val ??
                                                                          "")) {
                                                                return "Please enter valid email";
                                                              }
                                                              return null;
                                                            },
                                                            controller:
                                                                emailController,
                                                            decoration:
                                                                const InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none),
                                                          )),
                                                          InkWell(
                                                            onTap: () {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                launchEmailSubmission();
                                                              }
                                                            },
                                                            child:
                                                                ValueListenableBuilder(
                                                                    valueListenable:
                                                                        isLoading,
                                                                    builder: (context,
                                                                        value,
                                                                        child) {
                                                                      return isLoading
                                                                              .value
                                                                          ? const Center(
                                                                              child: CircularProgressIndicator(),
                                                                            )
                                                                          : Container(
                                                                              width: 70,
                                                                              height: 50,
                                                                              decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(20)),
                                                                              child: const Center(
                                                                                child: Text(
                                                                                  "Send",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                                                                ),
                                                                              ),
                                                                            );
                                                                    }),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Text(
                                                      "...or continue to the music",
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 16),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        var loginController =
                                                            Get.find<
                                                                LoginController>();
                                                        loginController.skip(
                                                            first: true);
                                                      },
                                                      child: Container(
                                                        width: 100,
                                                        height: 45,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                        child: const Center(
                                                          child: Text(
                                                            "Continue",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                  // PageIndicatorContainer(child: child, length: length)
                                  !controller.indicatorVisible.value
                                      ? Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 99,
                                          child: DotsIndicator(
                                            dotsCount:
                                                widget.fromSettings == true
                                                    ? 3
                                                    : controller.response.value
                                                            .data!.length -
                                                        2,
                                            position: position.toDouble(),
                                            decorator: const DotsDecorator(
                                              color:
                                                  Colors.grey, // Inactive color
                                              activeColor:
                                                  AppColors.primaryColor,
                                            ),
                                          ))
                                      : Container(),
                                  position == 0 ||
                                          position == 1 ||
                                          position == 2
                                      ? Positioned(
                                          bottom: 62,
                                          left: 0,
                                          right: 0,
                                          child: TextButton(
                                            onPressed: () {
                                              if (widget.fromSettings == true) {
                                                Get.back();
                                              } else {
                                                pageController.jumpToPage(
                                                    controller.response.value
                                                            .data!.length -
                                                        2);
                                              }
                                            },
                                            child: const Text(
                                              "Skip",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ))
                                      : Container(),
                                  //todo add no internet connection
                                ],
                              );
                            }),
                      ),
                    ),
                  )),
      ),
    );
  }
}
