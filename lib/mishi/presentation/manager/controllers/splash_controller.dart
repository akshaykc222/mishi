import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mishi/core/hive_service.dart';
import 'package:mishi/mishi/data/app_remote_routes.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/presentation/utils/app_data.dart';
import 'package:mishi/mishi/presentation/utils/constants.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../injecter.dart';
import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  final HiveService hiveService;

  SplashController(this.hiveService);

  void splash() async {
    AppData data = sl();
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      if (customerInfo.entitlements.all[AppConstants.entitlementID] != null &&
          customerInfo.entitlements.all[AppConstants.entitlementID]?.isActive ==
              true) {
        data.isPro = true;
        prettyPrint(msg: "cus01" + "true");
      } else {
        prettyPrint(msg: "cus01" + "false");
        data.isPro = false;
      }
    } catch (e) {}
    final box =
        await hiveService.getBox<PlayerStatus>(boxName: AppBoxNames.playerBox);
    box.clear();
    var user = FirebaseAuth.instance.currentUser;

    Future.delayed(const Duration(seconds: 2), () {
      if (user == null) {
        Get.offAllNamed(AppPages.intro);
      } else {
        Get.offAllNamed(AppPages.home);
        prettyPrint(msg: "going to favourites");
        // Get.offAllNamed(AppPages.favourites);
        // Get.to(() => const FavouritesScreen());
      }
    });
  }
}
