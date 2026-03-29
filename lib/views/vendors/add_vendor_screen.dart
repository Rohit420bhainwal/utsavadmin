import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import 'add_vendor_controller.dart';

class AddVendorScreen extends StatelessWidget {
  AddVendorScreen({super.key});

  final controller = Get.put(AddVendorsController());

  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final addressController = TextEditingController();
  final descController = TextEditingController();

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Vendor"),
        centerTitle: true,
      ),

      /// SafeArea ensures content does not go under status bar / notch
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// ================= USER SECTION =================
              _sectionTitle("Vendor User"),

              Obx(() => Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: const Text("Create New Vendor User"),
                  subtitle: const Text("Toggle to create or select existing"),
                  value: controller.isCreatingUser.value,
                  onChanged: (val) {
                    controller.isCreatingUser.value = val;
                  },
                ),
              )),

              const SizedBox(height: 12),

              /// 🔹 CREATE OR SELECT USER
              Obx(() => controller.isCreatingUser.value
                  ? Column(
                children: [
                  _input(userNameController, "Name", Icons.person),
                  _input(emailController, "Email", Icons.email),
                  _input(phoneController, "Phone", Icons.phone),
                  _input(passwordController, "Password", Icons.lock, isPassword: true),
                ],
              )
                  : Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: controller.selectedUserId.value.isEmpty
                      ? null
                      : controller.selectedUserId.value,
                  hint: const Text("Select Vendor User"),
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: controller.vendorUsers
                      .map<DropdownMenuItem<String>>((u) {
                    return DropdownMenuItem<String>(
                      value: u["_id"].toString(),
                      child: Text(
                        "${u["name"]} (${u["email"]})",
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    controller.selectedUserId.value = val!;
                  },
                ),
              )),

              const SizedBox(height: 20),

              /// ================= VENDOR DETAILS =================
              _sectionTitle("Vendor Details"),

              _input(nameController, "Business Name", Icons.storefront),
              _input(cityController, "City", Icons.location_city),
              _input(stateController, "State", Icons.map),
              _input(addressController, "Address", Icons.home, maxLines: 2),
              _input(descController, "Description", Icons.description, maxLines: 3),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      /// ================= SUBMIT BUTTON FIX =================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() => SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check,color: AppColors.textWhite,),
              label: controller.isLoading.value
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  color: AppColors.textWhite,
                  strokeWidth: 2,
                ),
              )
                  : const Text("Create Vendor"),
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                controller.createVendor(
                  userName: userNameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  password: passwordController.text,
                  businessName: nameController.text,
                  city: cityController.text,
                  state: stateController.text,
                  address: addressController.text,
                  description: descController.text,
                );
              },
            ),
          )),
        ),
      ),
    );
  }

  /// 🔹 INPUT
  Widget _input(TextEditingController controller, String hint, IconData icon,
      {bool isPassword = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// 🔹 TITLE
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}