import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_list_controller.dart';
import 'package:mishi/mishi/presentation/pages/web/music_list_web.dart';

import '../../../domain/entities/categories.dart';
import '../../utils/app_colors.dart';
import '../../utils/pretty_print.dart';
import '../../widgets/bottom_app_bar.dart';
import '../../widgets/mini_player.dart';
import '../home.dart';

class WebHome extends StatelessWidget {
  const WebHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MusicListController>();
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        AppColors.primaryColor,
        AppColors.primaryColor.withOpacity(0.6),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: width > 800 ? null : const CustomBottomAppBar(),
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 150,
                    height: 60,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SvgPicture.asset(
                  //     "assets/svg/menu.svg",
                  //     fit: BoxFit.cover,
                  //   ),
                  // )
                ],
              ),
            ],
          ),
        ),
        body: width > 800
            ? Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: const CustomBottomAppBarWeb()),
                  const Expanded(child: MusicListWeb())
                ],
              )
            : Obx(
                () => Stack(
                  children: [
                    if (controller.categoryBox.value != null)
                      ValueListenableBuilder(
                          valueListenable:
                              controller.categoryBox.value!.listenable(),
                          builder: (context, Box<CategoriesEntity> data, _) {
                            prettyPrint(
                                msg: "value builder size ${data.length}");
                            return ListView.builder(
                                // padding: const EdgeInsets.only(top: 20),
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: data.values.length,
                                itemBuilder: (context, index) => HomeItem(
                                      categoriesEntity:
                                          data.values.toList()[index],
                                      index: index,
                                    ));
                          }),
                    // Positioned(
                    //     top: 0,
                    //     left: 0,
                    //     right: 0,
                    //     child: controller.haveInternetConnection.value == false
                    //         ? const NoConnectionWidget()
                    //         : Container()),
                    Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: controller.playerBox.value == null
                            ? Container()
                            : const MiniPlayer()),
                  ],
                ),
              ),
      ),
    );
  }
}
