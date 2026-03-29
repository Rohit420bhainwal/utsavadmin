import 'package:get/get.dart';
import '../../model/lead_model.dart';
import '../../services/api_service.dart';


class LeadsController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var leads = <LeadModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllLeads();
  }

  Future<void> fetchAllLeads() async {
    try {
      isLoading(true);

      final response = await apiService.get(
        "leads/admin",
        withAuth: true,
      );

      print("leads_admin: ${response}");

      if (response["success"] == true) {
        final List data = response["data"];
        leads.value = data.map((e) => LeadModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}