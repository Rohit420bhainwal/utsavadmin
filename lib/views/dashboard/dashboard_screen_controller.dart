import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';
import '../../services/secure_storage_service.dart';

class DashboardScreenController extends GetxController {

  final box = GetStorage();

  // 🔹 Bottom navigation state
  final selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> logout() async {
    await SecureStorageService.clearAll();
    await box.erase();
    Get.offAllNamed(AppRoutes.login);
  }

}