import 'package:get/get.dart';
import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/domain/entities/intro_entity.dart';
import 'package:mishi/mishi/domain/use_cases/intro_use_case.dart';

import '../../../../core/response_classify.dart';

class IntroController extends GetxController {
  final IntroUseCase useCase;

  IntroController(this.useCase) {
    get();
  }
  final response = ResponseClassify<List<IntroEntity>>.loading().obs;
  get() async {
    try {
      response.value = ResponseClassify<List<IntroEntity>>.completed(
          await useCase.call(NoParams()));
    } catch (e) {
      response.value = ResponseClassify.error(e.toString());
    }
  }

  final indicatorVisible = false.obs;
  changeIndicatorVisible(bool val) {
    indicatorVisible.value = val;
  }
}
