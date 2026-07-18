import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class LeadDetailsController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var lead = Rxn<Map<String, dynamic>>();
  final TextEditingController noteController = TextEditingController();

  var notes = <Map<String, dynamic>>[].obs;

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
      } else {
        Get.snackbar("Error", "Failed to load lead");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
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

  Future<void> addNote() async {
    final note = noteController.text.trim();

    if (note.isEmpty) {
      Get.snackbar("Error", "Please enter note");
      return;
    }

    try {
      isLoading(true);

      /// 🔥 TODO: CALL API HERE
      ///
      /// final response = await apiService.post(
      ///   "leads/admin/$leadId/notes",
      ///   {
      ///     "note": note,
      ///   },
      ///   withAuth: true,
      /// );

      /// ✅ TEMP LOCAL ADD
      notes.insert(0, {
        "note": note,
        "createdAt": DateTime.now().toString(),
      });

      noteController.clear();

      Get.back();

      Get.snackbar("Success", "Note added successfully");

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}