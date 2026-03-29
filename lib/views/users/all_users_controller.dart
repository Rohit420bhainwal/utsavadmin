import 'package:get/get.dart';
import '../../services/api_service.dart';

class AllUsersController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var users = [].obs;

  /// 🔥 ADD THESE
  var selectedRole = "all".obs;
  var selectedCity = "all".obs;
  var searchQuery = "".obs;

  /// Optional city list (you can make dynamic later)
  var cities = ["all", "Pune", "Mumbai", "Delhi"].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading(true);

      String url = "users/admin?";

      /// 🔥 ROLE FILTER
      if (selectedRole.value != "all") {
        url += "role=${selectedRole.value}&";
      }

      /// 🔥 CITY FILTER
      if (selectedCity.value != "all") {
        url += "city=${selectedCity.value}&";
      }

      /// 🔥 SEARCH FILTER
      if (searchQuery.value.isNotEmpty) {
        url += "search=${searchQuery.value}&";
      }

      final response = await apiService.get(url, withAuth: true);

      if (response["success"] == true) {
        users.value = response["data"];
      }

    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}