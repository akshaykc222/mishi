import 'package:flutter/material.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';

var theme = ThemeData(
    primaryColor: AppColors.primaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black)),
    textTheme: const TextTheme(
        headlineLarge: TextStyle(
            color: AppColors.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18)));

class CustomScaffold extends StatelessWidget {
  final Widget child;
  const CustomScaffold({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill, image: AssetImage("assets/images/bg.png"))),
      child: child,
    );
  }
}
