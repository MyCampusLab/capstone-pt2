import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/family/controllers/family_controller.dart';

class FamilyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyController>(() => FamilyController());
  }
}
