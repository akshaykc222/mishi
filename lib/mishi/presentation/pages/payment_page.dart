import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/presentation/pages/web_view.dart';
import 'package:mishi/mishi/presentation/routes/app_pages.dart';
import 'package:mishi/mishi/presentation/utils/app_data.dart';
import 'package:mishi/mishi/presentation/utils/constants.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../injecter.dart';
import 'music_detail.dart';

class PaymentScreen extends StatefulWidget {
  final MusicEntity entity;
  final Offering offering;
  const PaymentScreen({Key? key, required this.entity, required this.offering})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/background.png"))
          //     gradient: LinearGradient(colors: [
          //   AppColors.primaryColor,
          //   AppColors.primaryColor.withOpacity(0.6),
          // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
          ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 180,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 47.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Unlock all content",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "•\tAccess 70+ customisable music \n\tcompositions and sound therapies",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "•\tAccess 50+ self-guided meditation motion \n\t visuals",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "•\tMore content added regularly",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "•\tCancel anytime",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "7 days free trial",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: widget.offering.availablePackages.length,
                        itemBuilder: (context, index) {
                          var myProductList = widget.offering.availablePackages;
                          prettyPrint(
                              msg: "offering length ${myProductList.length}");
                          return GestureDetector(
                            onTap: () async {
                              try {
                                AppData appData = sl();
                                CustomerInfo customerInfo =
                                    await Purchases.purchasePackage(
                                        myProductList[index]);
                                if (customerInfo.entitlements
                                            .all[AppConstants.entitlementID] !=
                                        null &&
                                    customerInfo
                                            .entitlements
                                            .all[AppConstants.entitlementID]
                                            ?.isActive ==
                                        true) {
                                  appData.isPro = true;

                                  // Get.to();
                                  Get.off(() =>
                                      MusicDetail(musicEntity: widget.entity));
                                } else {
                                  appData.isPro = false;
                                }
                              } catch (e) {
                                Get.showSnackbar(GetSnackBar(
                                  title: "Error",
                                  message: e.toString(),
                                ));
                              }
                            },
                            child: Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: const Color(0xFFB9BAE0)
                                      .withOpacity(0.55)),
                              child: SizedBox(
                                width: 90,
                                child: Center(
                                  child: Text(
                                    "${myProductList[index].storeProduct.priceString} / ${index == 0 ? "month" : "year"}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 150 / 50,
                                crossAxisSpacing: 5),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const WebViewCustom(
                          url: "https://www.getmishi.com/terms"));
                    },
                    child: const Text("Terms and privacy |",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        var restoredInfo = await Purchases.restorePurchases();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Purchase restored.")));
                        // ... check restored purchaserInfo to see if entitlement is now active
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    },
                    child: const Text(" Restore purchases",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppPages.profile);
                  },
                  child: const Text(
                    "| Subscription details",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
