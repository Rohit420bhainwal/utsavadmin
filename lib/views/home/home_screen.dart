  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import '../../utils/app_colors.dart';
  import 'home_controller.dart';


  class HomeScreen extends StatelessWidget {
    HomeScreen({super.key});

    final controller = Get.put(HomeController());

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,

          /// 👤 PROFILE ICON
          actions: [
            Obx(() => GestureDetector(
              onTap: () {
                _showProfileSheet(context);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.surface,
                  child: Text(
                    controller.userName.isNotEmpty
                        ? controller.userName.value[0].toUpperCase()
                        : "A",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),

        body: Obx(() {
          if (controller.isDashboardLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 👋 WELCOME
                Text(
                  "Welcome, ${controller.userName.value}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// 📊 STATS GRID
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                  children: [
                    _statCard("Leads", controller.totalLeads.value, Icons.leaderboard, Colors.blue),
                    _statCard("Vendors", controller.totalVendors.value, Icons.storefront, Colors.orange),
                    _statCard("Services", controller.totalServices.value, Icons.design_services, Colors.green),
                    _statCard("Customers", controller.totalCustomers.value, Icons.people, Colors.purple),
                  ],
                ),

                const SizedBox(height: 24),

                /// ⚡ QUICK ACTIONS
                const Text(
                  "Quick Actions",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    /*_actionCard("Add Vendor", Icons.add_business, () {
                      Get.toNamed("/addVendor");
                    }),
                    const SizedBox(width: 10),*/
                    _actionCard("Add Category", Icons.add_box, () {
                      Get.toNamed("/addCategory");
                    }),
                  ],
                ),
                const SizedBox(height: 12),

                const Text(
                  "All Categories",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 12),

                Obx(() {
                  if (controller.categories.isEmpty) {
                    return const Center(child: Text("No categories found"));
                  }

                  return SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 1),
                      itemBuilder: (context, index) {
                        final category = controller.categories[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // shrink to fit
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                category['icon'] != null && category['icon'].isNotEmpty
                                    ? Image.network(
                                  category['icon'],
                                  width: 32,
                                  height: 32,
                                  errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.category, color: Colors.grey),
                                )
                                    : const Icon(Icons.category, color: Colors.grey),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 100, // optional: max width
                                  child: Text(
                                    category['name'] ?? "",
                                    textAlign: TextAlign.center,
                                    /*maxLines: 1,*/
                                    /*overflow: TextOverflow.ellipsis,*/
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                if (category['parentId'] != null)
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      category['parentId']['name'] ?? "",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      );
    }

    /// 📊 STAT CARD
    Widget _statCard(String title, int value, IconData icon, Color color) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const Spacer(),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title),
          ],
        ),
      );
    }

    /// ⚡ ACTION CARD
    Widget _actionCard(String title, IconData icon, VoidCallback onTap) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      );
    }

    /// 👤 PROFILE BOTTOM SHEET
    void _showProfileSheet(BuildContext context) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: GetX<HomeController>(
            builder: (c) {
              final name = c.userName.value;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// HANDLE
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  /// PROFILE HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : "A",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              c.userEmail.value,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ACTIONS
                  _profileTile(
                    icon: Icons.person_outline,
                    title: "View Profile",
                    onTap: () {
                      Get.back();
                      Get.toNamed("/profile");
                    },
                  ),

                  _profileTile(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    onTap: () {},
                  ),

                  /*_profileTile(
                    icon: Icons.logout,
                    title: "Logout",
                    isDanger: true,
                    onTap: () {
                      // TODO: logout logic
                    },
                  ),*/

                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      );
    }

    Widget _profileTile({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
      bool isDanger = false,
    }) {
      return ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isDanger ? Colors.red : Colors.black87,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDanger ? Colors.red : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }