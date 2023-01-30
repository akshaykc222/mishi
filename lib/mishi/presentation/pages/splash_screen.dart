import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_detail_controller.dart';
import 'package:mishi/mishi/presentation/manager/controllers/splash_controller.dart';
import 'package:mishi/mishi/presentation/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;
  closeApp() async {
    if (await FlutterForegroundTask.isRunningService) {
      FlutterForegroundTask.stopService();
    }
  }

  @override
  void initState() {
    AssetsAudioPlayer.allPlayers().values.forEach((element) {
      element.dispose();
    });
    closeApp();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0, end: 1200).animate(_controller);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();
    final musicController = Get.find<MusicDetailController>();
    musicController.getSoundListing();
    controller.splash();

    return Scaffold(
      body: CustomScaffold(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 49.0, right: 49, top: 120),
              child: Image.asset(
                "assets/images/logo.png",
                // width: 262,
                // height: 100,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
