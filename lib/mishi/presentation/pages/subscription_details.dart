import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mishi/mishi/presentation/manager/controllers/login_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../routes/app_pages.dart';
import '../utils/constants.dart';
import '../utils/pretty_print.dart';

class SubscriptionDetails extends StatefulWidget {
  const SubscriptionDetails({Key? key}) : super(key: key);

  @override
  State<SubscriptionDetails> createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<SubscriptionDetails> {
  String plan = "Free";
  String subScribedDate = "N/a";
  String expiringOn = "N/a";
  getCustomerDetail() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    // var d = customerInfo.activeSubscriptions.first;
    // prettyPrint(msg: d);
    prettyPrint(
        msg: customerInfo.entitlements.all[AppConstants.entitlementID]
            .toString());
    if (customerInfo.entitlements.all[AppConstants.entitlementID] != null &&
        customerInfo.entitlements.all[AppConstants.entitlementID]?.isActive ==
            true) {
      if (customerInfo
          .entitlements.all[AppConstants.entitlementID]!.productIdentifier
          .contains("annual_plan")) {
        setState(() {
          plan = "Premium";
          try {
            var ex = customerInfo.entitlements.all[AppConstants.entitlementID]!
                    .expirationDate ??
                "";
            if (ex != "") {
              DateTime dt = DateTime.parse(ex);
              expiringOn = DateFormat.yMMMMd().format(dt);
            }
            var exp = customerInfo.entitlements.all[AppConstants.entitlementID]!
                    .originalPurchaseDate ??
                "";
            if (exp != "") {
              DateTime d = DateTime.parse(exp);
              subScribedDate = DateFormat.yMMMMd().format(d);
            }
          } catch (e) {}
        });
      } else {
        setState(() {
          plan = "Premium";
          try {
            var ex = customerInfo.entitlements.all[AppConstants.entitlementID]!
                    .expirationDate ??
                "";
            if (ex != "") {
              DateTime dt = DateTime.parse(ex);
              expiringOn = DateFormat.yMMMMd().format(dt);
            }
            var exp = customerInfo.entitlements.all[AppConstants.entitlementID]!
                    .originalPurchaseDate ??
                "";
            if (exp != "") {
              DateTime d = DateTime.parse(exp);
              subScribedDate = DateFormat.yMMMMd().format(d);
            }
          } catch (e) {}
        });
      }
    }
  }

  @override
  void initState() {
    getCustomerDetail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/background.png"))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 90),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 0),
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 184,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        body: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 27, bottom: 17),
                child: Text(
                  "Profile",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          loginController.getCurrentUser() == ""
                              ? SizedBox()
                              : const Icon(
                                  Icons.account_circle_sharp,
                                  size: 30,
                                  color: Colors.white,
                                ),
                          Text(
                            loginController.getCurrentUser(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: loginController.checkLogin()
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  try {
                                    await GoogleSignIn().signOut();
                                  } catch (e) {}
                                  await FirebaseAuth.instance.signOut();
                                  var box = GetStorage();
                                  box.write("isLogin", false);
                                  Get.toNamed(AppPages.login);
                                },
                                // leading: const Icon(
                                //   Icons.logout,
                                //   color: Colors.white,
                                // ),
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Plan ",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            plan,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subscribed date ",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            subScribedDate,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Expring on ",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            expiringOn,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () async {
                            try {
                              var restoredInfo =
                                  await Purchases.restorePurchases();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Purchase restored.")));
                              // ... check restored purchaserInfo to see if entitlement is now active
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          child: Text(
                            "Restore Purchase",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
