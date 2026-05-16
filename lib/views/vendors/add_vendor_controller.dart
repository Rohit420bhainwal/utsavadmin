import 'package:get/get.dart';
import '../../services/api_service.dart';

class AddVendorsController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var isCreatingUser = true.obs;

  var vendorUsers = [].obs;
  var selectedUserId = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchVendorUsers();
  }

  /// =========================
  /// 🔥 FETCH EXISTING VENDOR USERS
  /// =========================
  Future<void> fetchVendorUsers() async {
    try {
      final response = await apiService.get(
        "users/admin?role=vendor",
        withAuth: true,
      );

      if (response["success"] == true) {
        vendorUsers.value = response["data"];
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  /// =========================
  /// 🔥 CREATE VENDOR
  /// =========================
  Future<void> createVendor({
    required String userName,
    required String email,
    required String phone,
    required String password,
    required String businessName,
    required String city,
    required String state,
    required String address,
    required String description,
  }) async {
    try {
      isLoading(true);

      String userId = selectedUserId.value;

      /// 🔹 STEP 1: CREATE USER (IF NEEDED)
      if (isCreatingUser.value) {
        final userRes = await apiService.post(
          "auth/admin-create-vendor",
          {
            "name": userName,
            "email": email,
            "phone": phone,
            "password": password,
            "role": "vendor",
          },
        );

        print("userRes: $userRes");

        if (userRes["success"] != true) {
          throw Exception(userRes["message"] ?? "User creation failed");
        }

        userId = userRes["data"]?["_id"] ?? "";
      }

      /// ❌ SAFETY CHECK
      if (userId.isEmpty) {
        throw Exception("User ID missing");
      }

      /// 🔹 STEP 2: CREATE VENDOR
      final vendorRes = await apiService.post(
        "vendors",
        {
          "userId": userId,
          "businessName": businessName,
          "description": description,
          "city": city,
          "state": state,
          "address": address,
        },
        withAuth: true,
      );

      if (vendorRes["success"] == true) {
        Get.snackbar("Success", "Vendor Created Successfully");

        Future.delayed(const Duration(seconds: 1), () {
          Get.back(result: true);
        });
      } else {
        throw Exception(vendorRes["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}