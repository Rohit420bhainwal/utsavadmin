import 'package:get/get.dart';
import '../../services/api_service.dart';

class ServiceController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var services = <dynamic>[].obs; // 🔥 ADD THIS

  @override
  void onInit() {
    super.onInit();
    fetchAllServices();
  }

  Future<void> fetchAllServices() async {
    try {
      isLoading(true);

      final response = await apiService.get(
        "services",
        withAuth: true,
      );

      if (response["success"] == true) {
        services.value = response["data"]; // 🔥 STORE DATA
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}