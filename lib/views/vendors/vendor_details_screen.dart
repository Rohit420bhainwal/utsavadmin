import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsavadmin/views/vendors/add_vendor_service_screen.dart';
import '../../utils/app_colors.dart';
import 'vendor_details_controller.dart';

class VendorDetailsScreen extends StatelessWidget {
  VendorDetailsScreen({super.key});

  final controller = Get.put(VendorDetailsController());

  @override
  Widget build(BuildContext context) {
    final vendor = controller.vendor;

    return Scaffold(
      appBar: AppBar(
        title: Text(vendor["businessName"] ?? "Vendor Details"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 HEADER CARD (UPGRADED)
              _vendorHeader(vendor),

              const SizedBox(height: 20),

              /// 📦 SERVICES TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Services",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "${controller.services.length} items",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// 📋 SERVICES LIST / EMPTY STATE
              controller.services.isEmpty
                  ? _emptyServices()
                  : Column(
                children: controller.services.map((service) {
                  return _serviceCard(service);
                }).toList(),
              ),
            ],
          ),
        );
      }),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Get.to(
                () => AddVendorServiceScreen(),
            arguments: {
              "vendor": vendor,
              "service": null, // ✅ important
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Service"),
      ),
    );
  }

  /// 🔥 HEADER (LIKE PROFILE CARD)
  Widget _vendorHeader(dynamic vendor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// 🧑‍💼 Avatar
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.store, color: Colors.white, size: 28),
          ),

          const SizedBox(width: 12),

          /// 📄 Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor["businessName"] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),

                if (vendor["description"] != null)
                  Text(
                    vendor["description"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      "${vendor["city"]}, ${vendor["state"] ?? ""}",
                      style: const TextStyle(color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ❌ EMPTY SERVICES
  Widget _emptyServices() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          const Text("No Services Added"),
          const SizedBox(height: 4),
          const Text(
            "This vendor has no services yet",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// 🔹 MODERN SERVICE CARD
  Widget _serviceCard(dynamic service) {
    return GestureDetector(
      onTap: () {
        Get.to(
              () => AddVendorServiceScreen(),
          arguments: {
            "vendor": controller.vendor,
            "service": service, // ✅ pass service
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 TITLE + PRICE
              Row(
                children: [
                  const Icon(Icons.miscellaneous_services,
                      size: 18, color: AppColors.primary),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      service["title"] ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "₹${service["price"]}",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// 📝 DESCRIPTION
              Text(
                service["description"] ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}