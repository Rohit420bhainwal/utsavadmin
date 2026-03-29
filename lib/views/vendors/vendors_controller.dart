import 'package:get/get.dart';

import '../../services/api_service.dart';


class VendorsController extends GetxController {

  final ApiService _apiService = ApiService();

  var vendors = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVendors();
  }

  Future<void> fetchVendors() async {

    final response = await _apiService.get("vendors");

    print("vendors: $response");

    if(response["success"] == true) {
      vendors.value = response["data"];
    }

  }

}