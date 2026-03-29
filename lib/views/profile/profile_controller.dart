import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../services/secure_storage_service.dart';

class ProfileController extends GetxController {
  final ApiService apiService = ApiService();
  final box = GetStorage();

  var isLoading = false.obs;

  var name = "".obs;
  var email = "".obs;
  var phone = "".obs;
  var role = "".obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      isLoading(true);

      final response = await apiService.get(
        "users/profile",
        withAuth: true,
      );

      if (response["success"] == true) {
        final data = response["data"];

        name.value = data["name"] ?? "";
        email.value = data["email"] ?? "";
        phone.value = data["phone"] ?? "";
        role.value = data["role"] ?? "";
      }
    } catch (e) {
      print("Profile Error: $e");
    } finally {
      isLoading(false);
    }
  }


  Future<void> logout() async {
    await SecureStorageService.clearAll();
    await box.erase();
    Get.offAllNamed(AppRoutes.login);
  }

}