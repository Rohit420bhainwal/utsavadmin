import 'package:get/get.dart';
import '../../services/api_service.dart';

class LeadDetailsController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var lead = Rxn<Map<String, dynamic>>();

  final String leadId;

  LeadDetailsController(this.leadId);

  @override
  void onInit() {
    super.onInit();
    fetchLeadDetails();
  }

  Future<void> fetchLeadDetails() async {
    try {
      isLoading(true);

      final response = await apiService.get(
        "leads/admin/$leadId",
        withAuth: true,
      );

      if (response["success"] == true) {
        lead.value = response["data"];
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// 🔥 Update Status
  Future<void> updateStatus(String status) async {
    try {
      isLoading(true);

      final response = await apiService.put(
        "leads/admin/$leadId/status",
        {"status": status},
        withAuth: true,
      );

      if (response["success"] == true) {
        await fetchLeadDetails();
        Get.snackbar("Success", "Status updated");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}