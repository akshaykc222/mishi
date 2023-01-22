import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';

import '../manager/controllers/login_controller.dart';
import '../routes/app_pages.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final MusicEntity? entity;
  const EmailVerificationScreen({Key? key, required this.email, this.entity})
      : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with WidgetsBindingObserver {
  final controller = Get.find<LoginController>();
  @override
  void initState() {
    FirebaseAuth.instance.userChanges().listen((event) {
      if (event != null) {
        if (event.email != null) {
          var box = GetStorage();
          box.write("isLogin", true);

          // Get.offAndToNamed(AppPages.home);
          Get.until((route) => Get.currentRoute == AppPages.home);
        }
      }
    });
    controller.signInWithGoogle();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(gradient: AppColors().gradientColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() => controller.haveException.value == ""
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Waiting to be verified",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      controller.haveException.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Go Back")),
                  )
                ],
              )),
      ),
    );
  }
}
