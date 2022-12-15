import 'package:flutter/cupertino.dart';
import 'package:mishi/mishi/presentation/utils/constants.dart';

void prettyPrint({required String msg}) {
  debugPrint("[${AppConstants.appName}]\t$msg");
}
