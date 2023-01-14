import 'dart:io' show Platform;

import 'package:mishi/core/custom_exception.dart';
import 'package:mishi/mishi/presentation/utils/constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AppData {
  bool isPro = false;
}

Future<void> initPlatformState() async {
  await Purchases.setDebugLogsEnabled(true);

  late PurchasesConfiguration configuration;
  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration(AppConstants.publicGoogleId);
  } else {
    throw BadRequestException();
  }
  await Purchases.configure(configuration);
}
