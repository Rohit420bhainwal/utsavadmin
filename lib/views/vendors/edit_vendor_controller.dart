import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_service.dart';

class EditVendorController extends GetxController {
  final ApiService apiService = ApiService();

  final formKey = GlobalKey<FormState>();

  final businessNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  final isLoading = false.obs;
  final isUpdating = false.obs;

  late Map<String, dynamic> vendor;

  @override
  void onInit() {
    super.onInit();


    final arguments = Get.arguments;

    if (arguments == null) {
    print("Edit Vendor: No vendor data received");
    return;
    }

    vendor = Map<String, dynamic>.from(arguments);

    print("Edit Vendor ID: ${vendor["_id"]}");

    /// Fill existing data
    businessNameController.text =
    vendor["businessName"]?.toString() ?? "";

    descriptionController.text =
    vendor["description"]?.toString() ?? "";

    addressController.text =
    vendor["address"]?.toString() ?? "";

    cityController.text =
    vendor["city"]?.toString() ?? "";

    stateController.text =
    vendor["state"]?.toString() ?? "";


  }

  Future<void> updateVendor() async {
    /// Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }


    try {
    isUpdating(true);

    final vendorId = vendor["_id"];

    if (vendorId == null) {
    Get.snackbar(
    "Error",
    "Vendor ID not found",
    snackPosition: SnackPosition.BOTTOM,
    );
    return;
    }

    final body = {
    "businessName": businessNameController.text.trim(),
    "description": descriptionController.text.trim(),
    "address": addressController.text.trim(),
    "city": cityController.text.trim(),
    "state": stateController.text.trim(),
    };

    print("Updating vendor: $vendorId");
    print("Request body: $body");

    final response = await apiService.put(
    "vendors/$vendorId",
    body,
    withAuth: true,
    );

    print("Update vendor response: $response");

    /// Check response
    if (response == null) {
    Get.snackbar(
    "Error",
    "No response received from server",
    snackPosition: SnackPosition.BOTTOM,
    );
    return;
    }

    /// Convert response to Map
    final updatedVendor =
    Map<String, dynamic>.from(response);

    print("Updated Vendor: $updatedVendor");

    /// Close edit screen and return updated vendor
    Get.back(
    result: updatedVendor,
    );

    /// Show success message AFTER returning
    Future.delayed(
    const Duration(milliseconds: 300),
    () {
    Get.snackbar(
    "Success",
    "Vendor updated successfully",
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    );
    },
    );
    } catch (e) {
    print("Update Vendor Error: $e");

    Get.snackbar(
    "Error",
    e.toString(),
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
    );
    } finally {
    isUpdating(false);
    }


  }

  @override
  void onClose() {
    businessNameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();


    super.onClose();

  }
}
