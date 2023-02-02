import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mishi/mishi/presentation/routes/app_pages.dart';
import 'package:mishi/mishi/presentation/utils/app_data.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../injecter.dart';

class AppConstants {
  static const appName = "mishi";
  static const cacheDays = 30;
  static const entitlementID = 'premium';
  static const footerText =
      """A purchase will be applied to your account upon confirmation of the amount selected. Subscriptions will automatically renew unless canceled within 24 hours of the end of the current period. You can cancel any time using your account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription.""";
  static const publicGoogleId = 'goog_QTavDeowRSIjfvCUZFpHSnnPhiw';
  static const notificationId = "music_player_mini";
  static const notificationChannel = "music_player_mini";
  static const kSilverSubscriptionId = '01_monthly_plan';
  static const kGoldSubscriptionId = '02_annual_plan';
  static const revenueCatAppId = "app68785b9bce";
  static const rsaPrivateKey =
      "MIICWwIBAAKBgQCW6G6bKrEaU9azz8TRIEqplfaF16YJKDUApJp+jYOGpQrmSk4NSPp0/Icz8Z8U7cxmY/vpc09datB+431R9DFLlHNWLbHf7wqyuaUEa8C0EwRBr8CWnB8nnL0Q9SiN5X1+Pgb5IQsw1Iyrn//M4G2rZM3Wke7BI++DjahzsnDeFQIDAQABAoGAY6Rbi/cXc4PSK25PzandwrYzTdLDXh5/SMpm/JLiOqB1XvPHL7x1K5OmjmTHHqGZqi3wowexasRhoLcDA38SoId06kyJwCBixFLLbXa7hGIGDdU5sUEpoZ3Ac+UFesC6lgaTqLCsgBS79lJUNVofPq+b5z9Vnt4DsMNRmYwVmc0CQQDk2sEA5GSiIWge87i/MuFSF8sD0dhja1bRxEcj6nBVP/pIn0FrWU+cyaQFn7pBJcZYax2Ij/sKEv8DavqwHk2bAkEAqM7NvAnxxaNnANmtG8MBvBZ5MjEFtFuav6Lxw8skBz/AzZAv2TUAeehXVI1nCN1kMcPQ3VOvqf/tBu8WYW0WDwJAEkGRG+0cSgK4N5/hoP8CEnZrb4aR6HxrlJg/xJGzHFnaMWji4xlgzHUZbIltZj0JMYx58qbps8gIJ9Gk5d/E+QJAEAbCRY30JD1lNBF2e+JBsee4TemVjw/7WyJPLbWFkCKfXWTJBiggCXLjh6V9GLxcHNVoaPre/JbNnBDq4QkIRQJACamtpgIAB3lAN2+u6DgyLOIFm7rIuSMmPWKNeuuRyJPk0Fkcc5Gl/J1j1YVShcjZhp+O7U0yTE/tElZgLUZtGg==";
}

Future<bool> IsProUser() async {
  AppData appData = sl();

  if (appData.isPro == false) {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      if (customerInfo.entitlements.all[AppConstants.entitlementID] != null &&
          customerInfo.entitlements.all[AppConstants.entitlementID]?.isActive ==
              true) {
        appData.isPro = true;
      } else {
        appData.isPro = false;
      }
    } catch (e) {}
  }
  return appData.isPro;
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

class CustomTile extends StatelessWidget {
  final Widget title;
  final Function onTap;
  const CustomTile({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Row(
          children: [
            title,
          ],
        ),
      ),
    );
  }
}
