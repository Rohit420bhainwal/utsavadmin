import 'package:get/get.dart';
import '../../services/api_service.dart';

class CityListController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var cities = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCities();
  }

  // ================= FETCH CITIES =================
  Future<void> fetchCities() async {
    try {
      isLoading.value = true;

      final response = await apiService.get("cities");

      if (response["success"] == true) {
        cities.value = List<Map<String, dynamic>>.from(response["data"]);
      } else {
        cities.clear();
      }
    } catch (e) {
      print("City error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= DELETE CITY =================
  Future<void> deleteCity(String id) async {
    try {
      await apiService.post("cities/delete/$id", {}, withAuth: true);

      fetchCities();

      Get.snackbar("Success", "City deleted");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}