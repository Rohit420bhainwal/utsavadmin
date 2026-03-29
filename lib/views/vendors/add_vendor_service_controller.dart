import 'dart:io';

import 'package:get/get.dart';
import '../../services/api_service.dart';
import 'package:image_picker/image_picker.dart';

class AddVendorServiceController extends GetxController {
  final ApiService apiService = ApiService();

  var categories = [].obs;
  var selectedCategoryId = "".obs;

  late String vendorId;
  dynamic service;
  var isEdit = false.obs;


  var selectedImages = <File>[].obs;
  final ImagePicker picker = ImagePicker();

  var existingImages = <String>[].obs;

  @override
  void onInit() {
    final args = Get.arguments;

    vendorId = args["vendor"]["_id"];

    if (args["service"] != null) {
      service = args["service"];
      isEdit.value = true;

      selectedCategoryId.value = service["categoryId"]?["_id"] ?? "";

      /// 🔥 SET EXISTING IMAGES
      if (service["images"] != null) {
        existingImages.value = List<String>.from(service["images"]);
      }
    }

    fetchCategories();
    super.onInit();
  }

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

/*  Future<void> addOrUpdateService({
    required String title,
    required String description,
    required String price,
    required String serviceType,
    required String pricingModel,
    List<File>? images, // 🔥 for create
  }) async {
    try {
      dynamic response;

      if (isEdit.value) {
        /// ✅ UPDATE (JSON)
        final body = {
          "vendorId": vendorId,
          "categoryId": selectedCategoryId.value,
          "title": title,
          "description": description,
          "serviceType": serviceType,
          "pricingModel": pricingModel,
          "price": int.parse(price),
        };

        response = await apiService.put(
          "services/${service["_id"]}",
          body,withAuth: true
        );

      } else {
        /// ✅ CREATE (MULTIPART)
        response = await apiService.multipartPost(
          "services",
          fields: {
            "vendorId": vendorId,
            "categoryId": selectedCategoryId.value,
            "title": title,
            "description": description,
            "serviceType": serviceType,
            "pricingModel": pricingModel,
            "price": price,
          },
          files: images ?? [],
          fileKey: "images", // must match backend
        );
      }

      if (response["success"]) {
        Get.back();
        Get.snackbar(
          "Success",
          isEdit.value ? "Service updated" : "Service added",
        );
      } else {
        print("Error: ${response['message']}");
        Get.snackbar("Error", response["message"]);
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      Get.snackbar("Error", e.toString());
    }
  }*/

  Future<void> addOrUpdateService({
    required String title,
    required String description,
    required String price,
    required String serviceType,
    required String pricingModel,
  }) async {
    try {
      dynamic response;

      if (isEdit.value) {
        /// ✅ UPDATE WITH MULTIPART
        response = await apiService.multipartPut(
          "services/${service["_id"]}", // 👈 SAME API
          fields: {
            "vendorId": vendorId,
            "categoryId": selectedCategoryId.value,
            "title": title,
            "description": description,
            "serviceType": serviceType,
            "pricingModel": pricingModel,
            "price": price,

            /// 🔥 VERY IMPORTANT
            "existingImages": existingImages.join(","),
          },
          files: selectedImages, // 👈 NEW IMAGES
          fileKey: "images",
        );
      } else {
        /// ✅ CREATE
        response = await apiService.multipartPost(
          "services",
          fields: {
            "vendorId": vendorId,
            "categoryId": selectedCategoryId.value,
            "title": title,
            "description": description,
            "serviceType": serviceType,
            "pricingModel": pricingModel,
            "price": price,
          },
          files: selectedImages,
          fileKey: "images",
        );
      }

      if (response["success"]) {
        Get.back();
        Get.snackbar(
          "Success",
          isEdit.value ? "Service updated" : "Service added",
        );
      } else {
        Get.snackbar("Error", response["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }


  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      selectedImages.value =
          images.map((img) => File(img.path)).toList();
    }
  }

  void removeExistingImage(int index) {
    existingImages.removeAt(index);
  }

  void removeNewImage(int index) {
    selectedImages.removeAt(index);
  }

/*  Future<void> addService({
    required String title,
    required String description,
    required String price,
    required String serviceType,
    required String pricingModel,
  }) async {
    try {
      final body = {
        "vendorId": vendorId,
        "categoryId": selectedCategoryId.value, // ✅ from dropdown
        "title": title,
        "description": description,
        "serviceType": serviceType,
        "pricingModel": pricingModel,
        "price": int.parse(price),
      };

      final response = await apiService.post("services", body,withAuth: true);

      if (response["success"]) {
        Get.back();
        Get.snackbar("Success", "Service added successfully");
      } else {
        Get.snackbar("Error", response["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }*/
}