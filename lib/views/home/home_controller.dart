import 'package:get/get.dart';
import '../../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService apiService = ApiService();

  var isDashboardLoading = false.obs;
  var isProfileLoading = false.obs;
  var isCategoriesLoading = false.obs;

  var isLoading = false.obs;

  var totalCustomers = 0.obs;
  var totalVendors = 0.obs;
  var totalServices = 0.obs;
  var totalLeads = 0.obs;

  /// Profile
  var userName = "".obs;
  var userEmail = "".obs;

  var categories = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();

  }

  Future<void> loadAllData() async {
    isLoading(true);

    try {
      await Future.wait([
        fetchDashboard(),
        fetchProfile(),
        fetchCategories(),
      ]);
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      isLoading(false);
    }
  }

  /// 🔥 DASHBOARD STATS
  Future<void> fetchDashboard() async {
    try {
      isDashboardLoading(true);

      final response = await apiService.get(
        "dashboard/admin",
        withAuth: true,
      );

      if (response["success"] == true) {
        final data = response["data"];

        totalCustomers.value = data["totalCustomers"] ?? 0;
        totalVendors.value = data["totalVendors"] ?? 0;
        totalServices.value = data["totalServices"] ?? 0;
        totalLeads.value = data["totalLeads"] ?? 0;
      }
    } catch (e) {
      print("Dashboard Error: $e");
    } finally {
      isDashboardLoading(false);
    }
  }

  /// 👤 PROFILE API
  Future<void> fetchProfile() async {
    try {
      final response = await apiService.get(
        "users/profile",
        withAuth: true,
      );

      if (response["success"] == true) {
        final data = response["data"];

        userName.value = data["name"] ?? "";
        userEmail.value = data["email"] ?? "";
      }
    } catch (e) {
      print("Profile Error: $e");
    }
  }

  Future<void> fetchCategories() async {
    try {
      final res = await apiService.get("categories", withAuth: true);
      if (res['success'] == true) {
        categories.value = res['data'];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch categories");
    }
  }
}