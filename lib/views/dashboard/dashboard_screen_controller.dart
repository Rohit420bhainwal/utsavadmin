import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../services/secure_storage_service.dart';

class DashboardScreenController extends GetxController {
  final ApiService apiService = ApiService();

  final box = GetStorage();

  // 🔹 Bottom navigation state
  final selectedIndex = 0.obs;
  late String userId;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    final userData = await box.read("userProfile");
    print("userData: $userData");
    if (userData != null) {
      print("USER ROLE: ${userData["role"]}");
      userId = userData["id"];
    }
    getToken();
  }


  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> logout() async {
    await SecureStorageService.clearAll();
    await box.erase();
    Get.offAllNamed(AppRoutes.login);
  }


  Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    print("ADMIN FCM TOKEN: $token");
    final body = {"userId": userId, "fcmToken": token ?? ""};
    final response = await apiService.post(
      "auth/update-fcm-token",
      body,
      withAuth: true,
    );
    if (response["success"] == true) {
    //  Get.snackbar("Success", response["message"]);
    }else{
    //  Get.snackbar("Error", response["message"]);
    }
/*    final userData = box.read("userProfile");
    print("userData: $userData");
    if (userData != null) {
      userId = userData["id"];
    }*/


  }

}