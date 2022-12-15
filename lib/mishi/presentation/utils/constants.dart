import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mishi/mishi/presentation/routes/app_pages.dart';

class AppConstants {
  static const appName = "mishi";
  static const cacheDays = 30;
  static const notificationId = "music_player_mini";
  static const notificationChannel = "music_player_mini";
  static const kSilverSubscriptionId = '01_monthly_plan';
  static const kGoldSubscriptionId = '02_annual_plan';
  static const rsaPrivateKey =
      "MIICWwIBAAKBgQCW6G6bKrEaU9azz8TRIEqplfaF16YJKDUApJp+jYOGpQrmSk4NSPp0/Icz8Z8U7cxmY/vpc09datB+431R9DFLlHNWLbHf7wqyuaUEa8C0EwRBr8CWnB8nnL0Q9SiN5X1+Pgb5IQsw1Iyrn//M4G2rZM3Wke7BI++DjahzsnDeFQIDAQABAoGAY6Rbi/cXc4PSK25PzandwrYzTdLDXh5/SMpm/JLiOqB1XvPHL7x1K5OmjmTHHqGZqi3wowexasRhoLcDA38SoId06kyJwCBixFLLbXa7hGIGDdU5sUEpoZ3Ac+UFesC6lgaTqLCsgBS79lJUNVofPq+b5z9Vnt4DsMNRmYwVmc0CQQDk2sEA5GSiIWge87i/MuFSF8sD0dhja1bRxEcj6nBVP/pIn0FrWU+cyaQFn7pBJcZYax2Ij/sKEv8DavqwHk2bAkEAqM7NvAnxxaNnANmtG8MBvBZ5MjEFtFuav6Lxw8skBz/AzZAv2TUAeehXVI1nCN1kMcPQ3VOvqf/tBu8WYW0WDwJAEkGRG+0cSgK4N5/hoP8CEnZrb4aR6HxrlJg/xJGzHFnaMWji4xlgzHUZbIltZj0JMYx58qbps8gIJ9Gk5d/E+QJAEAbCRY30JD1lNBF2e+JBsee4TemVjw/7WyJPLbWFkCKfXWTJBiggCXLjh6V9GLxcHNVoaPre/JbNnBDq4QkIRQJACamtpgIAB3lAN2+u6DgyLOIFm7rIuSMmPWKNeuuRyJPk0Fkcc5Gl/J1j1YVShcjZhp+O7U0yTE/tElZgLUZtGg==";
}

Future<bool> IsProUser() async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    var instance = FirebaseFirestore.instance;
    var pro = await instance.collection("users").doc(user?.uid ?? "").get();
    bool? proUser = pro.get('pro_user') as bool?;

    return proUser ?? false;
  } catch (e) {
    return false;
  }
}

addProUser() {
  final List<String> _kProductIds = <String>[
    "01_monthly_plan",
    "02_annual_plan",
  ];
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  bool _isAvailable = false;
  final Stream<List<PurchaseDetails>> purchaseUpdated =
      _inAppPurchase.purchaseStream;

  _subscription =
      purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          var user = FirebaseAuth.instance.currentUser;
          var instance = FirebaseFirestore.instance;
          instance
              .collection("users")
              .doc(user?.uid ?? "")
              .set({'pro_user': true});
          Get.offAllNamed(AppPages.home);
        }
      }
    }
  }, onDone: () {
    _subscription.cancel();
  }, onError: (Object error) {
    // handle error here.
  });
}
