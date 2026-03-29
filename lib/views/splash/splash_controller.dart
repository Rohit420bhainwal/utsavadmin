import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/secure_storage_service.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    final token = await SecureStorageService.getToken();

    if (token != null && token.isNotEmpty) {
      // ✅ User already logged in
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      // ❌ Not logged in
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
