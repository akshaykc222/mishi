import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class MotionImageScreen extends StatefulWidget {
  final String videoUrl;
  const MotionImageScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<MotionImageScreen> createState() => _MotionImageScreenState();
}

class _MotionImageScreenState extends State<MotionImageScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _controller = VideoPlayerController.network(widget.videoUrl,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..setLooping(true);
    // _controller.

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();

    _controller.setVolume(0);

    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text("Double tap any where to exit")));
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onDoubleTap: () {
                Get.back();
              },
              onTap: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Double tap anywhere to exit")));
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }
        },
      ),
    );
  }
}
