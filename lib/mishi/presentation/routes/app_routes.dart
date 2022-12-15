import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mishi/mishi/presentation/manager/bindings/intro_binding.dart';
import 'package:mishi/mishi/presentation/manager/bindings/login_binding.dart';
import 'package:mishi/mishi/presentation/manager/bindings/music_list_binding.dart';
import 'package:mishi/mishi/presentation/manager/bindings/splash_binder.dart';
import 'package:mishi/mishi/presentation/pages/clear_cache_screen.dart';
import 'package:mishi/mishi/presentation/pages/favourites_screen.dart';
import 'package:mishi/mishi/presentation/pages/home.dart';
import 'package:mishi/mishi/presentation/pages/intro_screen.dart';
import 'package:mishi/mishi/presentation/pages/login.dart';
import 'package:mishi/mishi/presentation/pages/splash_screen.dart';
import 'package:mishi/mishi/presentation/pages/web/web_home.dart';
import 'package:mishi/mishi/presentation/routes/app_pages.dart';

var appRoutes = [
  GetPage(
      name: AppPages.splash,
      page: () => const SplashScreen(),
      bindings: [SplashBinder(), MusicListBinding()]),
  GetPage(
      name: AppPages.home,
      page: () => kIsWeb ? const WebHome() : const HomeScreen(),
      bindings: [MusicListBinding(), LoginBinding()]),
  GetPage(
      name: AppPages.login,
      page: () => const LoginScreen(),
      binding: LoginBinding()),
  GetPage(
      name: AppPages.intro,
      page: () => const IntroScreen(),
      binding: IntroBinding()),
  // GetPage(
  //   name: AppPages.payment,
  //   page: () =>  PaymentScreen(),
  // ),
  GetPage(
    name: AppPages.clear_chache,
    page: () => const ClearCache(),
  ),
  GetPage(
      name: AppPages.favourites,
      page: () => const FavouritesScreen(),
      bindings: [MusicListBinding()]),
  // GetPage(
  //     name: AppPages.musicDetail,
  //     page: () => MusicDetail(musicEntity: musicEntity))
];
