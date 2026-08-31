import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import 'edit_vendor_controller.dart';


class EditVendorScreen extends StatelessWidget {
  EditVendorScreen({super.key});

  final EditVendorController controller =
  Get.put(EditVendorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Vendor"),
        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientStart,
                        AppColors.gradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Edit Vendor Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// BUSINESS NAME
                TextFormField(
                  controller:
                  controller.businessNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Business Name",
                    hintText: "Enter business name",
                    prefixIcon: Icon(Icons.business),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Business name is required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// DESCRIPTION
                TextFormField(
                  controller:
                  controller.descriptionController,
                  maxLines: 4,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    hintText: "Enter vendor description",
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 16),

                /// ADDRESS
                TextFormField(
                  controller:
                  controller.addressController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    hintText: "Enter complete address",
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                /// CITY
                TextFormField(
                  controller:
                  controller.cityController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "City",
                    hintText: "Enter city",
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                /// STATE
                TextFormField(
                  controller:
                  controller.stateController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: "State",
                    hintText: "Enter state",
                    prefixIcon: Icon(Icons.map),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                /// UPDATE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Obx(
                        () => ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                      controller.isUpdating.value
                          ? null
                          : controller.updateVendor,
                      icon: controller.isUpdating.value
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.save),
                      label: Text(
                        controller.isUpdating.value
                            ? "Updating..."
                            : "Update Vendor",
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}