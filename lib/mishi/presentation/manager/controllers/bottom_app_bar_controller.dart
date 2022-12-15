import 'package:get/get.dart';

import '../../utils/enums.dart';

class BottomAppBarController extends GetxController {
  final selectedBottom = BottomAppItems.home.obs;

  changeBottomItem(BottomAppItems value) {
    selectedBottom.value = value;
  }
}
