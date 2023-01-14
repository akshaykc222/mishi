import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mishi/core/response_classify.dart';
import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/data/models/categories_model.dart';
import 'package:mishi/mishi/data/models/music_model.dart';
import 'package:mishi/mishi/data/models/static_pages.dart';
import 'package:mishi/mishi/domain/entities/categories.dart';
import 'package:mishi/mishi/domain/entities/home_entity.dart';
import 'package:mishi/mishi/domain/entities/music_entity.dart';
import 'package:mishi/mishi/domain/entities/player_status.dart';
import 'package:mishi/mishi/domain/use_cases/conncetion_check_usecase.dart';
import 'package:mishi/mishi/domain/use_cases/intro_use_case.dart';
import 'package:mishi/mishi/domain/use_cases/music_list_usecase.dart';
import 'package:mishi/mishi/domain/use_cases/tag_list_usecase.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';

import '../../../../core/hive_service.dart';
import '../../../data/app_remote_routes.dart';

class MusicListController extends GetxController {
  final MusicListUseCase musicListUseCase;
  final TagListUseCase tagListUseCase;
  final HiveService hiveService;
  final StaticPageUseCase staticPageUseCase;
  ConnectionCheckUseCase? connectionCheckUseCase;

  MusicListController(this.musicListUseCase, this.tagListUseCase,
      this.hiveService, this.staticPageUseCase,
      {this.connectionCheckUseCase}) {
    if (!kIsWeb) {
      checkConnection();
    }

    getALlMusic();
  }
  final haveInternetConnection = true.obs;

  final isLoading = false.obs;
  final responseData = ResponseClassify<List<MusicEntity?>>.loading().obs;
  final responseList = <MusicEntity>[].obs;
  final tempData = Rxn<List<HomeMusic>>();
  final homeData = Rxn<List<HomeMusic>>();
  final tagList = <CategoriesEntity>[].obs;
  final tagResponseData =
      ResponseClassify<List<CategoriesEntity?>>.loading().obs;
  processData(List<HomeMusic> data) {
    homeData.value = [];
    for (var element in data) {
      var tempList = responseList
          .where((e) =>
              element.tag == e.tag1 ||
              element.tag == e.tag2 ||
              element.tag == e.tag3 ||
              element.tag == e.tag6)
          .toList();
      // debugPrint("tag count ${tagResponseData.value.data?.length}");
      List<CategoriesEntity>? displayName =
          tagList.where((e) => e.tagName == element.tag).toList();
      prettyPrint(msg: "request data ${element.tag} data ${tempList.length}");
      if (displayName.isNotEmpty) {
        homeData.value?.add(
            HomeMusic(tag: displayName.first.displayName, data: tempList));
      } else {
        homeData.value?.add(HomeMusic(tag: element.tag, data: tempList));
      }
      debugPrint("home data length ${homeData.value?.length}");
    }

    //this part is for delete

    homeData.value?.forEach((element) {
      prettyPrint(msg: "#1010 ${element.tag} ${element.data.length}");
    });
  }

  getAllTags() async {
    tagResponseData.value = ResponseClassify.loading();
    try {
      tagResponseData.value =
          ResponseClassify.completed(await tagListUseCase.call(NoParams()));

      // tagResponseData.value.data?.listen((data) {
      //   prettyPrint(msg: "getting tag list $data");
      //   if (data != null) {
      //     if (tagList.contains(data)) {
      //       tagList.remove(data);
      //       tagList.add(data);
      //     } else {
      //       tagList.add(data);
      //     }
      //   }
      // });
    } catch (e) {
      prettyPrint(msg: "error =>$e");
      tagResponseData.value = ResponseClassify.error(e.toString());
    }
  }

  final categoryBox = Rxn<Box<CategoryModel>>();
  final musicListBox = Rxn<Box<MusicModel>>();
  final playerBox = Rxn<Box<PlayerStatus>>();
  getALlMusic({String? tag}) async {
    isLoading.value = true;
    await getAllTags();
    tempData.value = [];
    responseData.value = ResponseClassify<List<MusicEntity?>>.loading();
    if (tag == null) {
      try {
        responseData.value = ResponseClassify<List<MusicEntity?>>.completed(
            await musicListUseCase.call("All"));
        // responseData.value.data?.listen((data) {
        //   prettyPrint(msg: "music List $data");
        //   if (data != null) {
        //     if (responseList.contains(data)) {
        //       responseList.remove(data);
        //       responseList.add(data);
        //     } else {
        //       responseList.add(data);
        //     }
        //     List<String> tempTags = data.allTags.split(",");
        //
        //     for (var element in tempTags) {
        //       prettyPrint(msg: "TagUnique $element");
        //       if (!tempData.value!.contains(HomeMusic(
        //         tag: element,
        //         data: const [],
        //       ))) {
        //         tempData.value?.add(HomeMusic(tag: element, data: const []));
        //       }
        //     }
        //   }
        //
        //   processData(tempData.value ?? []);
        // });
      } catch (e) {
        // print(e);
        responseData.value = ResponseClassify.error(e.toString());
      }
    } else {
      try {
        responseData.value =
            ResponseClassify.completed(await musicListUseCase.call(tag));
        responseData.value.data?.forEach((i) {
          if (!tempData.value!.contains(HomeMusic(
            tag: i?.tag1,
            data: const [],
          ))) {
            tempData.value?.add(HomeMusic(tag: i?.tag1, data: const []));
          }
        });
      } catch (e) {
        responseData.value = ResponseClassify.error(e.toString());
      }
    }
    isLoading.value = false;
  }

  checkConnection() {
    if (connectionCheckUseCase != null) {
      var data = connectionCheckUseCase!.call(NoParams());
      data.listen((result) {
        // print("result $result");
        if (result == InternetConnectionStatus.disconnected) {
          // Get.snackbar("No Internet", "Please check your connection",
          //     isDismissible: false, snackPosition: SnackPosition.TOP);
          haveInternetConnection.value = false;
        } else {
          haveInternetConnection.value = true;
        }
      });
    }
  }

  final staticPagesResponse = ResponseClassify<List<StaticPages>>.loading().obs;
  getStaticPages() async {
    staticPagesResponse.value = ResponseClassify.loading();
    try {
      staticPagesResponse.value =
          ResponseClassify.completed(await staticPageUseCase.call(NoParams()));
    } catch (e) {
      staticPagesResponse.value = ResponseClassify.error(e.toString());
    }
  }

  @override
  Future<void> onInit() async {
    categoryBox.value = await hiveService.getBox<CategoryModel>(
        boxName: AppBoxNames.categoryBox);
    musicListBox.value =
        await hiveService.getBox(boxName: AppBoxNames.musicBox);
    playerBox.value = await hiveService.getBox(boxName: AppBoxNames.playerBox);
    getStaticPages();
    super.onInit();
  }
}
