import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import 'add_vendor_service_controller.dart';

class AddVendorServiceScreen extends StatelessWidget {
  AddVendorServiceScreen({super.key});

  final controller = Get.put(AddVendorServiceController());

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  final RxString serviceType = "individual".obs;
  final RxString pricingModel = "package".obs;

  @override
  Widget build(BuildContext context) {
    if (controller.isEdit.value) {
      titleController.text = controller.service["title"] ?? "";
      descController.text = controller.service["description"] ?? "";
      priceController.text = controller.service["price"].toString();

      serviceType.value = controller.service["serviceType"] ?? "individual";
      pricingModel.value = controller.service["pricingModel"] ?? "package";
    }

    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(controller.isEdit.value ? "Edit Service" : "Add Service"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 BASIC INFO
            _sectionTitle("Basic Info"),
            const SizedBox(height: 10),

            _fieldCard(
              child: Column(
                children: [
                  _textField("Service Title", titleController),
                  const SizedBox(height: 12),

                  Obx(() {
                    if (controller.categories.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return DropdownButtonFormField(
                      decoration: _inputDecoration("Select Category"),
                      value: controller.selectedCategoryId.value.isEmpty
                          ? null
                          : controller.selectedCategoryId.value,
                      items: controller.categories
                          .map<DropdownMenuItem<String>>((cat) {
                        return DropdownMenuItem<String>(
                          value: cat["_id"],
                          child: Text(cat["name"]),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.selectedCategoryId.value = val!;
                      },
                    );
                  }),

                  const SizedBox(height: 12),
                  _textField("Price", priceController,
                      inputType: TextInputType.number),

                  const SizedBox(height: 12),
                  _textField("Description", descController, maxLines: 3),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 SERVICE SETTINGS
            _sectionTitle("Service Settings"),
            const SizedBox(height: 10),

            _fieldCard(
              child: Column(
                children: [
                  Obx(() => DropdownButtonFormField(
                    value: serviceType.value,
                    decoration: _inputDecoration("Service Type"),
                    items: const [
                      DropdownMenuItem(value: "venue", child: Text("Venue")),
                      DropdownMenuItem(value: "individual", child: Text("Individual")),
                    ],
                    onChanged: (val) => serviceType.value = val!,
                  )),

                  const SizedBox(height: 12),

                  Obx(() => DropdownButtonFormField(
                    value: pricingModel.value,
                    decoration: _inputDecoration("Pricing Model"),
                    items: const [
                      DropdownMenuItem(value: "per_plate", child: Text("Per Plate")),
                      DropdownMenuItem(value: "per_day", child: Text("Per Day")),
                      DropdownMenuItem(value: "per_hour", child: Text("Per Hour")),
                      DropdownMenuItem(value: "package", child: Text("Package")),
                    ],
                    onChanged: (val) => pricingModel.value = val!,
                  )),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 IMAGES
            _sectionTitle("Images"),
            const SizedBox(height: 10),

            _fieldCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: controller.pickImages,
                    child: Container(
                      height: 110,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.cloud_upload_outlined, size: 30),
                          SizedBox(height: 6),
                          Text("Tap to upload images"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Obx(() {
                    final allImages = [
                      ...controller.existingImages,
                      ...controller.selectedImages.map((e) => e.path)
                    ];

                    if (allImages.isEmpty) {
                      return const SizedBox();
                    }

                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(allImages.length, (index) {
                        final isNetwork = index < controller.existingImages.length;

                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                onTap: () {
                                  final networkImages = controller.existingImages
                                      .map((e) => "http://192.168.27.50:5000/${e.replaceAll("\\", "/")}")
                                      .toList();

                                  final localImages =
                                  controller.selectedImages.map((e) => e.path).toList();

                                  final allImages = [...networkImages, ...localImages];

                                  Get.to(() => FullScreenImageViewer(
                                    images: allImages,
                                    initialIndex: index,
                                    isNetwork: index < networkImages.length,
                                  ));
                                },
                                child: isNetwork
                                    ? Image.network(
                                  controller.apiService.getImageUrl(allImages[index]),
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                )
                                    : Image.file(
                                  File(allImages[index]),
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  if (isNetwork) {
                                    controller.removeExistingImage(index);
                                  } else {
                                    controller.removeNewImage(index - controller.existingImages.length);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                    );
                  })
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  controller.addOrUpdateService(
                    title: titleController.text,
                    description: descController.text,
                    price: priceController.text,
                    serviceType: serviceType.value,
                    pricingModel: pricingModel.value,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  controller.isEdit.value ? "Update Service" : "Add Service",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _fieldCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _textField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF2F3F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}



class FullScreenImageViewer extends StatelessWidget {
  final List<String> images;
  final int initialIndex;
  final bool isNetwork;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.isNetwork,
  });

  @override
  Widget build(BuildContext context) {
    final PageController pageController =
    PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          /// 🔥 SWIPE + ZOOM
          PageView.builder(
            controller: pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];

              return InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: isNetwork
                      ? Image.network(
                    image,
                    fit: BoxFit.contain,
                  )
                      : Image.file(
                    File(image),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          /// ❌ CLOSE BUTTON
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
