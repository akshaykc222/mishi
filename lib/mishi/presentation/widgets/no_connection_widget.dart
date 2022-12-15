import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.red),
      child: const Center(
        child: Text(
          "Please check your internet connection",
          style: TextStyle(color: AppColors.textColor, fontSize: 15),
        ),
      ),
    );
  }
}
