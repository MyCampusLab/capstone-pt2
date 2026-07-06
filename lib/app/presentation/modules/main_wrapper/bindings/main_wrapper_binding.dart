import 'package:get/get.dart';
import '../controllers/main_wrapper_controller.dart';
import 'package:visionsafe/app/data/providers/vision_service_provider.dart';

/// MainWrapperBinding: Pusat Dependency Injection untuk Tab Utama.
/// Memastikan semua controller tersedia saat navigasi IndexedStack.
class MainWrapperBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan provider secara permanen
    Get.put(VisionServiceProvider(), permanent: true); 
    
    // Inisialisasi MainWrapperController
    Get.put(MainWrapperController());
  }
}
