import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class AddCityController extends GetxController {
  final ApiService apiService = ApiService();

  final nameController = TextEditingController();
  final stateController = TextEditingController();

  var isLoading = false.obs;
  var isEdit = false.obs;
  String? cityId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args != null) {
      isEdit.value = true;
      cityId = args["_id"];

      nameController.text = args["name"] ?? "";
      stateController.text = args["state"] ?? "";
    }
  }

  // ================= SAVE CITY =================
  Future<void> saveCity() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "City name is required");
      return;
    }

    try {
      isLoading.value = true;

      final body = {
        "name": nameController.text.trim(),
        "state": stateController.text.trim(),
      };

      dynamic response;

      if (isEdit.value) {
        // UPDATE
        response = await apiService.put(
          "cities/$cityId",
          body,
          withAuth: true,
        );
      } else {
        // CREATE
        response = await apiService.post(
          "cities",
          body,
          withAuth: true,
        );
      }

      if (response["success"] == true) {
        Get.back(result: true);

        Get.snackbar(
          "Success",
          isEdit.value ? "City updated" : "City added",
        );
      } else {
        Get.snackbar("Error", response["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}