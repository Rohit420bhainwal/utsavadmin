import 'package:get/get.dart';
import '../../services/api_service.dart';

class VendorDetailsController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var services = [].obs;

  late dynamic vendor;

  @override
  void onInit() {
    super.onInit();

    vendor = Get.arguments;

    print("vendor: ${vendor["_id"]}");
    fetchVendorServices();
  }

  Future<void> fetchVendorServices() async {
    try {
      isLoading(true);

      final response = await apiService.get(
        "services?vendorId=${vendor["_id"]}",
        withAuth: true,
      );

      if (response["success"] == true) {
        services.value = response["data"];
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}