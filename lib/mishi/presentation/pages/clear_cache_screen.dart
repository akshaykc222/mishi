import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mishi/core/hive_service.dart';
import 'package:mishi/mishi/data/app_remote_routes.dart';
import 'package:mishi/mishi/presentation/manager/controllers/music_detail_controller.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

import '../../../injecter.dart';
import '../../data/models/store_model.dart';

class ClearCache extends StatelessWidget {
  const ClearCache({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(MusicDetailController(sl(), sl(), sl(), sl(), sl()));
    controller.initCache();
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/background.png")),
      ),
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
        body: Obx(() => controller.cacheBox.value != null
            ? ValueListenableBuilder(
                builder: (context, Box<StoreModel> data, _) {
                  final d = data.values.toList();

                  final musicNames = d.map((e) => e.musicName).toList();
                  var uniqueNames = <String>{};
                  var uniqueList = musicNames
                      .where((element) => uniqueNames.add(element))
                      .toList();
                  List<Widget> widgets = [];
                  for (var element in uniqueList) {
                    var onlyOneMusicItems =
                        d.where((e) => e.musicName == element).toList();
                    double size = 0;
                    for (var element in onlyOneMusicItems) {
                      size = element.totSize + size;
                    }
                    var sizeInMb = size / 1048576;
                    widgets.add(CacheItem(
                        musicName: element,
                        locations:
                            onlyOneMusicItems.map((e) => e.storeLoc).toList(),
                        size: sizeInMb.toStringAsFixed(2)));
                  }
                  return widgets.isEmpty
                      ? const Center(
                          child: Text(
                            "No Items",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: widgets,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0, right: 20, bottom: 60),
                              child: Text(
                                "All music played is automatically stored on the device for offline use.clicking up on delete will remove a song and clear the space.",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        );
                },
                valueListenable: controller.cacheBox.value!.listenable(),
              )
            : Container(
                child: Center(
                  child: Text("some thing went wrong"),
                ),
              )),
      ),
    );
  }
}

class CacheItem extends StatelessWidget {
  final String musicName;
  final List<String> locations;
  final String size;
  const CacheItem({
    Key? key,
    required this.musicName,
    required this.locations,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Text(
              musicName,
              maxLines: 1,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              Text(
                "$size mb",
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  for (var value in locations) {
                    try {
                      File(value).delete();
                      var it = await HiveService()
                          .getBox<StoreModel>(boxName: AppBoxNames.cache_box);
                      it.values.toList().asMap().forEach((key, value) {
                        if (value.musicName == musicName) {
                          it.deleteAt(key);
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("File deleted")));
                    } catch (e) {
                      prettyPrint(msg: e.toString());
                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFc5eaf2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
