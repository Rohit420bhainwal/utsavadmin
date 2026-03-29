import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsavadmin/routes/app_routes.dart';
import '../../utils/app_colors.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(14),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [

            /// 🛠 SERVICES
            _menuCard(
              title: "Services",
              icon: Icons.design_services,
              color: Colors.green,
              onTap: () {
                Get.toNamed("/services");
              },
            ),

            /// 👥 USERS
            _menuCard(
              title: "Users",
              icon: Icons.people_alt,
              color: Colors.blue,
              onTap: () {
                Get.toNamed("/users");
              },
            ),

            /// 👤 PROFILE
            _menuCard(
              title: "Profile",
              icon: Icons.person,
              color: Colors.orange,
              onTap: () {
                Get.toNamed("/profile");
              },
            ),

            /// 🚪 LOGOUT
            _menuCard(
              title: "Logout",
              icon: Icons.logout,
              color: Colors.red,
              onTap: () {
                _showLogoutDialog();
              },
            ),
            /// 🏙 CITIES (NEW)
            _menuCard(
              title: "Cities",
              icon: Icons.location_city,
              color: Colors.purple,
              onTap: () {
                Get.toNamed(AppRoutes.cities); // 👉 create this route
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 MENU CARD
  Widget _menuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// ICON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),

            const SizedBox(height: 10),

            /// TITLE
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 🔥 LOGOUT DIALOG (reuse your improved one)
  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout, color: Colors.red, size: 30),
              ),

              const SizedBox(height: 16),

              const Text(
                "Logout",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.offAllNamed("/login");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}