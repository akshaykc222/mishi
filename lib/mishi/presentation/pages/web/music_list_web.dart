import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../domain/entities/categories.dart';
import '../../manager/controllers/music_list_controller.dart';
import '../../utils/pretty_print.dart';
import '../home.dart';

class MusicListWeb extends StatelessWidget {
  const MusicListWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MusicListController>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(
        () => Stack(
          children: [
            if (controller.categoryBox.value != null)
              ValueListenableBuilder(
                  valueListenable: controller.categoryBox.value!.listenable(),
                  builder: (context, Box<CategoriesEntity> data, _) {
                    prettyPrint(msg: "value builder size ${data.length}");
                    return ListView.builder(
                        // padding: const EdgeInsets.only(top: 20),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.values.length,
                        itemBuilder: (context, index) => HomeItem(
                              categoriesEntity: data.values.toList()[index],
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
            // Positioned(
            //     bottom: 10,
            //     left: 0,
            //     right: 0,
            //     child: controller.playerBox.value == null
            //         ? Container()
            //         : const MiniPlayer()),
          ],
        ),
      ),
    );
  }
}
