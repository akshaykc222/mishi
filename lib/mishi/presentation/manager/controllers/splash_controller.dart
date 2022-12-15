import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mishi/core/hive_service.dart';
import 'package:mishi/mishi/data/app_remote_routes.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  final HiveService hiveService;

  SplashController(this.hiveService);

  void splash() async {
    final InAppPurchase _inAppPurchase = InAppPurchase.instance;
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    purchaseUpdated.listen(
        (List<PurchaseDetails> purchaseDetailsList) async {
          var last_payment = await purchaseUpdated.first;
          // last_payment
        },
        onDone: () {},
        onError: (Object error) {
          // handle error here.
        });
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
