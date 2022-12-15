import 'package:get/get.dart';
import 'package:mishi/mishi/presentation/manager/controllers/splash_controller.dart';

import '../../../../injecter.dart';

class SplashBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(sl()));
  }
}
