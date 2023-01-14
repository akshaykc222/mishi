import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/domain/entities/categories.dart';
import 'package:mishi/mishi/domain/repositories/category_repository.dart';

import '../../../core/hive_service.dart';
import '../../presentation/utils/pretty_print.dart';

class TagListUseCase extends UseCase<List<CategoriesEntity?>, NoParams> {
  final CategoryRepository repository;
  final HiveService hiveService;

  TagListUseCase(this.repository, this.hiveService);

  @override
  Future<List<CategoriesEntity?>> call(NoParams params) async {
    prettyPrint(msg: "Calling repository");
    return repository.getAllTags();
  }
}
