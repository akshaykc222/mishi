import 'package:flutter/foundation.dart';
import 'package:mishi/core/api_provider.dart';
import 'package:mishi/core/hive_service.dart';
import 'package:mishi/mishi/data/models/categories_model.dart';
import 'package:mishi/mishi/domain/entities/categories.dart';

import '../../app_remote_routes.dart';

abstract class MusicTagDataSource {
  Future<List<CategoriesEntity>> getAllTags();
}

class MusicTagDataSourceImpl extends MusicTagDataSource {
  final ApiProvider apiProvider;
  final HiveService hiveService;
  MusicTagDataSourceImpl(this.apiProvider, this.hiveService);

  @override
  Future<List<CategoriesEntity>> getAllTags() async {
    final data = await apiProvider
        .get("${AppRemoteRoutes.tags}platform=${kIsWeb ? "web" : "android"}");
    // prettyPrint(msg: data.toString());
    final items = List<CategoryModel>.from(
        data['tags'].map((x) => CategoryModel.fromJson(x)));
    // hiveService.addBoxes<MusicModel>(listItem, AppBoxNames.musicBox);
    await hiveService.clearAllValues<CategoryModel>(AppBoxNames.categoryBox);
    hiveService.addBoxes<CategoryModel>(items, AppBoxNames.categoryBox);
    return items;
  }
}
