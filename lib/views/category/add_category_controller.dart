import 'package:get/get.dart';
import '../../services/api_service.dart';
import 'package:flutter/material.dart';

class AddCategoryController extends GetxController {
  final ApiService apiService = ApiService();

  var isLoading = false.obs;
  var categories = <dynamic>[].obs;
  var selectedParentId = RxnString();

  final nameController = TextEditingController();
  final iconController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// Fetch existing categories for parent dropdown
  Future<void> fetchCategories() async {
    try {
      final res = await apiService.get("categories", withAuth: true);
      if (res['success'] == true) {
        categories.value = res['data'];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch categories");
    }
  }

  /// Add new category
  Future<void> addCategory() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Category name is required");
      return;
    }

    isLoading.value = true;

    final payload = {
      "name": nameController.text.trim()??"",
      "parentId": selectedParentId.value??"",
      "icon": iconController.text.trim()??"",
    };

    try {
      final res = await apiService.post("categories", payload, withAuth: true);
      if (res['success'] == true) {
        Get.snackbar("Success", "Category added successfully");
        nameController.clear();
        iconController.clear();
        selectedParentId.value = null;
        // Optionally refresh categories
        fetchCategories();
      } else {
        Get.snackbar("Error", "Failed to add category");
      }
    } catch (e) {
      print("exception: ${e.toString()}");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}