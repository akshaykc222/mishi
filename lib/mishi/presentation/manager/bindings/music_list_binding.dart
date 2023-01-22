import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_detail_controller.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_list_controller.dart';

import '../../../../injecter.dart';

class MusicListBinding extends Bindings {
  @override
  void dependencies() {
    if (kIsWeb) {
      Get.lazyPut(() => MusicListController(sl(), sl(), sl(), sl()),
          fenix: true);
    } else {
      Get.lazyPut(
          () => MusicListController(sl(), sl(), sl(), sl(),
              connectionCheckUseCase: sl()),
          fenix: true);
    }
    if (kIsWeb) {
      // Get.lazyPut(() => MusicDetailControllerWeb(sl(), sl(), sl()),
      //     fenix: true);
    } else {
      Get.lazyPut(() => MusicDetailController(sl(), sl(), sl(), sl(), sl()),
          fenix: true);
    }
  }
}
