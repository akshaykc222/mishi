import 'package:mishi/mishi/data/data_sources/remote/music_tag_data_source.dart';
import 'package:mishi/mishi/domain/entities/categories.dart';
import 'package:mishi/mishi/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final MusicTagDataSource dataSource;

  CategoryRepositoryImpl(this.dataSource);

  @override
  Future<List<CategoriesEntity>> getAllTags() {
    return dataSource.getAllTags();
  }
}
