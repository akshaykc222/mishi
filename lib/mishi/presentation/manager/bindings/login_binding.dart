import 'package:get/get.dart';
import 'package:mishi/mishi/presentation/manager/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(), fenix: true);
  }
}
