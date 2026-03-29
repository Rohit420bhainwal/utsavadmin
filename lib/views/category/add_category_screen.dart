import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import 'add_category_controller.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({super.key});

  final controller = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // 📌 Category Name
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 📌 Parent Category Dropdown
            DropdownButtonFormField<String>(
              value: controller.selectedParentId.value,
              decoration: InputDecoration(
                labelText: "Parent Category (Optional)",
                prefixIcon: const Icon(Icons.subdirectory_arrow_right),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: controller.categories
                  .map((c) => DropdownMenuItem<String>(
                value: c['_id'].toString(),
                child: Text(c['name']),
              ))
                  .toList(),
              onChanged: (value) {
                controller.selectedParentId.value = value;
              },
            ),

              const SizedBox(height: 16),

              // 📌 Icon URL
              TextFormField(
                controller: controller.iconController,
                decoration: InputDecoration(
                  labelText: "Icon URL",
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 💾 Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.addCategory(),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text("Add Category"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}