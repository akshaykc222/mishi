import 'package:mishi/mishi/domain/entities/categories.dart';

abstract class CategoryRepository{
  Future<List<CategoriesEntity>> getAllTags();
}