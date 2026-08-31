import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_service.dart';

class VendorDetailsController extends GetxController {
  final ApiService apiService = ApiService();

// =====================================================
// LOADING
// =====================================================

  final isLoading = false.obs;

// =====================================================
// SERVICES
//
// Contains BOTH active and inactive services
// =====================================================

  final services = <dynamic>[].obs;

// =====================================================
// VENDOR
// =====================================================

  final vendor = <String, dynamic>{}.obs;

// =====================================================
// SERVICE STATUS LOADING
// =====================================================

  final updatingServiceIds = <String>{}.obs;

// =====================================================
// VENDOR STATUS LOADING
// =====================================================

  final isUpdatingVendorStatus = false.obs;

// =====================================================
// ON INIT
// =====================================================

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments != null) {
      vendor.value = Map<String, dynamic>.from(
        arguments,
      );
    }

    print(
      "Vendor ID: ${vendor["_id"]}",
    );

    print(
      "Vendor Status: ${vendor["isActive"]}",
    );

    fetchVendorServices();
  }

// =====================================================
// UPDATE VENDOR DATA
// =====================================================

  void updateVendorData(
    Map<String, dynamic> updatedVendor,
  ) {
    vendor.value = Map<String, dynamic>.from(
      updatedVendor,
    );

    print(
      "Updated vendor: ${vendor["_id"]}",
    );

    print(
      "Updated vendor status: ${vendor["isActive"]}",
    );
  }

// =====================================================
// FETCH ALL SERVICES
//
// GET:
// services/admin/vendor/:vendorId
// =====================================================

  Future<void> fetchVendorServices() async {
    try {
      isLoading(true);

      final vendorId = vendor["_id"];

      if (vendorId == null || vendorId.toString().isEmpty) {
        print(
          "Vendor ID is null or empty",
        );

        return;
      }

      final endpoint = "services/admin/vendor/$vendorId";

      print(
        "======================================",
      );

      print(
        "Fetching Vendor Services",
      );

      print(
        "Vendor ID: $vendorId",
      );

      print(
        "API Endpoint: $endpoint",
      );

      print(
        "======================================",
      );

      final response = await apiService.get(
        endpoint,
        withAuth: true,
      );

      print(
        "Admin vendor services response: $response",
      );

      if (response["success"] == true) {
        services.value = response["data"] ?? [];

        print(
          "Total vendor services: ${services.length}",
        );
      } else {
        services.clear();

        Get.snackbar(
          "Error",
          response["message"]?.toString() ?? "Unable to fetch services",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print(
        "Error fetching vendor services: $e",
      );

      services.clear();

      Get.snackbar(
        "Error",
        e.toString().replaceFirst(
              "Exception: ",
              "",
            ),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

// =====================================================
// UPDATE VENDOR STATUS
//
// PATCH:
// vendors/:vendorId/status
//
// BODY:
// {
//   "isActive": true
// }
//
// IMPORTANT:
//
// When vendor becomes inactive:
// Backend automatically deactivates ALL services.
//
// When vendor becomes active:
// Services remain in their current backend state.
// Since deactivation makes them inactive, they remain
// inactive until manually activated.
// =====================================================

  Future<void> updateVendorStatus(
    bool newStatus,
  ) async {
    try {
      final vendorId = vendor["_id"]?.toString();

      if (vendorId == null || vendorId.isEmpty) {
        Get.snackbar(
          "Error",
          "Vendor ID not found",
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

// ===============================================
// PREVENT MULTIPLE REQUESTS
// ===============================================

      if (isUpdatingVendorStatus.value) {
        return;
      }

      isUpdatingVendorStatus(true);

// ===============================================
// API
// ===============================================

      final endpoint = "vendors/$vendorId/status";

      print(
        "======================================",
      );

      print(
        "Updating Vendor Status",
      );

      print(
        "Vendor ID: $vendorId",
      );

      print(
        "New Status: $newStatus",
      );

      print(
        "Endpoint: $endpoint",
      );

      print(
        "======================================",
      );

      final response = await apiService.patch(
        endpoint,
        {
          "isActive": newStatus,
        },
        withAuth: true,
      );

      print(
        "Vendor status response: $response",
      );

// ===============================================
// SUCCESS
// ===============================================

      if (response["success"] == true) {
// =============================================
// UPDATE VENDOR STATUS LOCALLY
// =============================================

        vendor["isActive"] = newStatus;

        vendor.refresh();

// =============================================
// IF VENDOR WAS DEACTIVATED
//
// Backend deactivates all services.
//
// So fetch services again.
// =============================================

        if (!newStatus) {
          await fetchVendorServices();
        }

// =============================================
// SUCCESS MESSAGE
// =============================================

        Get.snackbar(
          newStatus ? "Vendor Activated" : "Vendor Deactivated",
          response["message"]?.toString() ??
              (newStatus
                  ? "Vendor activated successfully"
                  : "Vendor and all services deactivated successfully"),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print(
        "UPDATE VENDOR STATUS ERROR: $e",
      );

// ===============================================
// SHOW ACTUAL BACKEND MESSAGE
// ===============================================

      final errorMessage = e.toString().replaceFirst(
            "Exception: ",
            "",
          );

      Get.snackbar(
        "Unable to Update Vendor",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isUpdatingVendorStatus(false);
    }
  }

// =====================================================
// ACTIVATE / DEACTIVATE SERVICE
//
// PATCH:
// services/:serviceId/status
//
// BODY:
// {
//   "isActive": true
// }
//
// BACKEND PROTECTION:
//
// If vendor is inactive and admin tries to activate
// service, backend returns:
//
// Cannot activate service because the vendor is inactive
// =====================================================

  Future<void> updateServiceStatus(
    dynamic service,
    bool newStatus,
  ) async {
    try {
      final serviceId = service["_id"]?.toString();

      if (serviceId == null || serviceId.isEmpty) {
        Get.snackbar(
          "Error",
          "Service ID not found",
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

// ===============================================
// PREVENT MULTIPLE REQUESTS
// ===============================================

      if (updatingServiceIds.contains(
        serviceId,
      )) {
        return;
      }

      updatingServiceIds.add(
        serviceId,
      );

// ===============================================
// API
// ===============================================

      final endpoint = "services/$serviceId/status";

      print(
        "======================================",
      );

      print(
        "Updating Service Status",
      );

      print(
        "Service ID: $serviceId",
      );

      print(
        "New Status: $newStatus",
      );

      print(
        "Endpoint: $endpoint",
      );

      print(
        "======================================",
      );

      final response = await apiService.patch(
        endpoint,
        {
          "isActive": newStatus,
        },
        withAuth: true,
      );

      print(
        "Service status response: $response",
      );

// ===============================================
// SUCCESS
// ===============================================

      if (response["success"] == true) {
        service["isActive"] = newStatus;

        services.refresh();

        Get.snackbar(
          newStatus ? "Service Activated" : "Service Deactivated",
          response["message"]?.toString() ??
              (newStatus
                  ? "Service activated successfully"
                  : "Service deactivated successfully"),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print(
        "UPDATE SERVICE STATUS ERROR: $e",
      );

// ===============================================
// IMPORTANT
//
// This catches backend response:
//
// Exception:
// Cannot activate service because the vendor
// is inactive
// ===============================================

      final errorMessage = e.toString().replaceFirst(
            "Exception: ",
            "",
          );

      Get.snackbar(
        "Unable to Update Service",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } finally {
// ===============================================
// REMOVE LOADING STATE
// ===============================================

      final serviceId = service["_id"]?.toString();

      if (serviceId != null) {
        updatingServiceIds.remove(
          serviceId,
        );
      }
    }
  }

// =====================================================
// CHECK SERVICE UPDATING
// =====================================================

  bool isUpdatingService(
    dynamic service,
  ) {
    final serviceId = service["_id"]?.toString();

    if (serviceId == null) {
      return false;
    }

    return updatingServiceIds.contains(
      serviceId,
    );
  }

// =====================================================
// REFRESH SERVICES
// =====================================================

  Future<void> refreshServices() async {
    await fetchVendorServices();
  }
}
