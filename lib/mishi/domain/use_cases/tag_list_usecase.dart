import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/data/models/categories_model.dart';
import 'package:mishi/mishi/domain/entities/categories.dart';
import 'package:mishi/mishi/domain/repositories/category_repository.dart';

import '../../../core/hive_service.dart';
import '../../data/app_remote_routes.dart';
import '../../presentation/utils/pretty_print.dart';

class TagListUseCase extends UseCase<Stream<CategoriesEntity?>, NoParams> {
  final CategoryRepository repository;
  final HiveService hiveService;

  TagListUseCase(this.repository, this.hiveService);

  @override
  Future<Stream<CategoriesEntity?>> call(NoParams params) async {
    prettyPrint(msg: "Calling repository");
    repository.getAllTags();
    var box = await hiveService.getBox<CategoryModel>(
        boxName: AppBoxNames.categoryBox);
    prettyPrint(msg: "saved item length  tag ${box.values.length.toString()}");
    return Future.value(box.watch().map((event) {
      prettyPrint(msg: "getting value event");
      return event.value as CategoriesEntity?;
    }));
  }
}
