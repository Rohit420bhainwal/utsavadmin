import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import 'all_users_controller.dart';

class AllUsersScreen extends StatelessWidget {
  AllUsersScreen({super.key});

  final controller = Get.put(AllUsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () => _openFilterSheet(context),
          ),
        ],
      ),

      body: Column(
        children: [

          /// 🔍 SEARCH BAR
          _searchBar(),

          /// 📋 LIST
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.users.isEmpty) {
                return const Center(child: Text("No Users Found"));
              }

              return ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  return _userTile(user);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// 🔍 SEARCH BAR
  /// =========================
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: (value) {
          controller.searchQuery.value = value;
          controller.fetchUsers();
        },
        decoration: InputDecoration(
          hintText: "Search users...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// =========================
  /// 📋 USER TILE (CLEAN)
  /// =========================
  Widget _userTile(dynamic user) {
    String name = (user["name"] ?? "").toString();
    return InkWell(
      onTap: () {
        // Navigate to details later
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [

            /// 👤 AVATAR
            CircleAvatar(
              radius: 22,
              backgroundColor: _roleColor(user["role"]).withOpacity(0.1),
              child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "A",
                style: TextStyle(
                  color: _roleColor(user["role"]),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// 📄 DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// NAME + ROLE
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      _roleBadge(user["role"]),
                    ],
                  ),

                  const SizedBox(height: 4),

                  /// EMAIL
                  Text(
                    user["email"],
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  /// PHONE
                  Text(
                    user["phone"] ?? "-",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            /// STATUS DOT
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: user["isActive"] ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// 🎯 FILTER BOTTOM SHEET
  /// =========================
  void _openFilterSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "Filters",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 16),

            /// ROLE FILTER
            DropdownButtonFormField<String>(
              value: controller.selectedRole.value,
              decoration: const InputDecoration(labelText: "Role"),
              items: ["all", "admin", "vendor", "customer"]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toUpperCase()),
              ))
                  .toList(),
              onChanged: (value) {
                controller.selectedRole.value = value!;
              },
            ),

            const SizedBox(height: 12),

            /// CITY FILTER
            DropdownButtonFormField<String>(
              value: controller.selectedCity.value,
              decoration: const InputDecoration(labelText: "City"),
              items: controller.cities
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toUpperCase()),
              ))
                  .toList(),
              onChanged: (value) {
                controller.selectedCity.value = value!;
              },
            ),

            const SizedBox(height: 16),

            /// APPLY BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.fetchUsers();
                  Get.back();
                },
                child: const Text("Apply Filters"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 ROLE COLOR
  Color _roleColor(String role) {
    switch (role) {
      case "admin":
        return Colors.red;
      case "vendor":
        return Colors.blue;
      case "customer":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// 🏷 ROLE BADGE
  Widget _roleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _roleColor(role).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _roleColor(role),
        ),
      ),
    );
  }
}