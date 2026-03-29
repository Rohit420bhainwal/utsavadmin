import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsavadmin/views/home/home_screen.dart';
import 'package:utsavadmin/views/leads/leads_screen.dart';
import 'package:utsavadmin/views/more/more_screen.dart';
import 'package:utsavadmin/views/services/service_screen.dart';
import 'package:utsavadmin/views/users/all_users_screen.dart';
import 'package:utsavadmin/views/vendors/vendors_screen.dart';


import '../../utils/app_colors.dart';

import 'dashboard_screen_controller.dart';

class DashboardScreen extends StatelessWidget {
   DashboardScreen({super.key});

   final DashboardScreenController controller = Get.put(DashboardScreenController());

  final List<Widget> pages = [
    HomeScreen(),
    LeadsScreen(),
    VendorsScreen(),
    MoreScreen(), // 👈 NEW
  ];

   @override
   Widget build(BuildContext context) {
     final textTheme = Theme.of(context).textTheme;

     return Obx(
           () => Scaffold(
         body: IndexedStack(
           index: controller.selectedIndex.value,
           children: pages,
         ),
             bottomNavigationBar: BottomNavigationBar(
               currentIndex: controller.selectedIndex.value,
               onTap: controller.changeTab,
               type: BottomNavigationBarType.fixed,

               selectedItemColor: AppColors.primary,
               unselectedItemColor: AppColors.textSecondary,

               items: const [
                 BottomNavigationBarItem(
                   icon: Icon(Icons.home_rounded),
                   label: "Home",
                 ),
                 BottomNavigationBarItem(
                   icon: Icon(Icons.analytics_outlined),
                   label: "Leads",
                 ),
                 BottomNavigationBarItem(
                   icon: Icon(Icons.storefront_outlined),
                   label: "Vendors",
                 ),
                 BottomNavigationBarItem(
                   icon: Icon(Icons.grid_view_rounded), // 👈 More
                   label: "More",
                 ),
               ],
             ),
       ),
     );
   }
}
