import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF6364A1);
  static const thumbColor = Color(0xFF8688bd);
  static const trackColor = Color(0xFF8b7a94);
  static const secondaryColor = Color(0xFFB98AD2);
  Color dimYellow = const Color(0xFFFED000).withOpacity(0.8);

  static const textColor = Colors.white;
  static const backGround = Color(0xFFF5F5F5);

  get gradientColor => LinearGradient(colors: [
        primaryColor.withOpacity(0.6),
        primaryColor,
      ], begin: Alignment.topLeft, end: Alignment.bottomCenter);
}
