import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../services/secure_storage_service.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final ApiService _apiService = ApiService();
  final box = GetStorage();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }



  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and password are required');
      return;
    }

    try {
      isLoading.value = true;
      final body = {
        "email": email.trim(),
        "password":password.trim(),
        "appType": "admin"

      };
      final response = await _apiService.post("auth/login", body,withAuth: false);
      print("response: $response");

      if (response["success"] == true) {
        final data = response["data"];
        await SecureStorageService.saveToken(data["token"]);
        await box.write("userProfile", data["user"]);
        Get.snackbar('Success', 'Login successful');
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(AppRoutes.dashboard);
      }else{
        final message = response["message"];
        Get.snackbar('Error', '$message');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }
}
