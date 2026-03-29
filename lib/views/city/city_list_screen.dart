import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsavadmin/routes/app_routes.dart';
import '../../utils/app_colors.dart';
import 'city_list_controller.dart';

class CityListScreen extends StatelessWidget {
  CityListScreen({super.key});

  final CityListController controller = Get.put(CityListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Cities"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cities.isEmpty) {
          return const Center(child: Text("No cities found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.cities.length,
          itemBuilder: (context, index) {
            final city = controller.cities[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                children: [
                  /// ICON
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_city),
                  ),

                  const SizedBox(width: 12),

                  /// TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city["name"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (city["state"] != null)
                          Text(
                            city["state"],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),

                  /// ACTIONS
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.addCities,
                            arguments: city,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            size: 20, color: Colors.red),
                        onPressed: () {
                          controller.deleteCity(city["_id"]);
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      }),

      /// ➕ ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Get.toNamed(AppRoutes.addCities);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}