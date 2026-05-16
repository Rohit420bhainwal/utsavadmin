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

  var isLoading = false.obs;


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

  Future<void> addOrUpdateService({
    required String title,
    required String description,
    required String price,
    required String serviceType,
    required String pricingModel,
  }) async {
    try {
      isLoading.value = true;
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

      isLoading.value = false;

      if (response["success"]) {

        /// 🔥 If backend returns updated service, use it
        final updatedService = response["data"] ?? {
          ...service ?? {},
          "title": title,
          "description": description,
          "price": price,
          "serviceType": serviceType,
          "pricingModel": pricingModel,
          "categoryId": {
            "_id": selectedCategoryId.value,
          },
          "images": existingImages, // updated list
        };

        /// 🔥 update local reference
        service = updatedService;

        /// 🔥 return updated data to previous screen
        Get.back(result: updatedService);

        Get.snackbar(
          "Success",
          isEdit.value ? "Service updated" : "Service added",
        );
      }
    } catch (e) {
      isLoading.value = false;
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
}