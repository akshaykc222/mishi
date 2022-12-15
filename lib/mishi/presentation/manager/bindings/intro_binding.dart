import 'package:get/get.dart';
import 'package:mishi/mishi/presentation/manager/controllers/intro_controller.dart';

import '../../../../injecter.dart';

class IntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IntroController(sl()));
  }
}
