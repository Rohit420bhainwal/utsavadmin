import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import 'vendors_controller.dart';

class VendorsScreen extends StatelessWidget {
  VendorsScreen({super.key});

  final VendorsController controller = Get.put(VendorsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vendors"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchVendors(),
          )
        ],
      ),

      // ✅ Better FAB (with label)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.addVendors);

          if (result == true) {
            controller.fetchVendors();
          }
        },
        icon: const Icon(Icons.storefront_outlined),
        label: const Text("Add Vendor"),
      ),

      body: Obx(() {
        if (controller.vendors.isEmpty) {
          // ✅ Empty State UI
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store_mall_directory_outlined,
                    size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  "No Vendors Found",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  "Tap + to add your first vendor",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.vendors.length,
          itemBuilder: (context, index) {
            final vendor = controller.vendors[index];

            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRoutes.vendorDetails,
                  arguments: vendor,
                );
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // ✅ Leading Icon Avatar
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.store,
                          color: AppColors.primary,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // ✅ Vendor Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vendor["businessName"] ?? "No Name",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),

                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  vendor["city"] ?? "Unknown City",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ✅ Arrow Icon
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}