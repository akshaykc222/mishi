import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mishi/core/notification.dart';
import 'package:mishi/mishi/presentation/routes/app_pages.dart';
import 'package:mishi/mishi/presentation/routes/app_routes.dart';
import 'package:mishi/mishi/presentation/utils/app_data.dart';
import 'package:mishi/mishi/presentation/utils/constants.dart';
import 'package:mishi/mishi/presentation/utils/theme.dart';

import 'firebase_options.dart';
import 'injecter.dart' as dl;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  var notification = NotificationService();
  notification.init();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });
  await dl.init();
  // if(K)
  // await AppPathProvider.initPath();

  // bool success =
  //     await FlutterBackground.initialize(androidConfig: androidConfig);
  await initPlatformState();

  runApp(const Mishi());
}

class Mishi extends StatefulWidget {
  const Mishi({Key? key}) : super(key: key);

  @override
  State<Mishi> createState() => _MishiState();
}

class _MishiState extends State<Mishi> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: AppColors.primaryColor));
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: theme,
      getPages: appRoutes,
      initialRoute: AppPages.splash,
    );
  }
}
