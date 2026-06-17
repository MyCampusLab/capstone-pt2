import 'package:get/get.dart';
import '../controllers/health_quiz_controller.dart';

class HealthQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthQuizController>(() => HealthQuizController());
  }
}
