import 'package:get/get.dart';
import '../controllers/stats_controller.dart';

class StatsBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final tag = (args != null && args is Map && args.containsKey('targetUserId'))
        ? args['targetUserId'] as String
        : null;
        
    Get.lazyPut<StatsController>(() => StatsController(), tag: tag);
  }
}
