import 'package:get/get.dart';
import 'package:utsavadmin/views/category/add_category_screen.dart';
import 'package:utsavadmin/views/city/add_city_screen.dart';
import 'package:utsavadmin/views/dashboard/dashboard_screen.dart';
import 'package:utsavadmin/views/login/login_screen.dart';
import 'package:utsavadmin/views/profile/profile_screen.dart';
import 'package:utsavadmin/views/services/service_screen.dart';
import 'package:utsavadmin/views/users/all_users_screen.dart';
import 'package:utsavadmin/views/vendors/add_vendor_screen.dart';
import 'package:utsavadmin/views/vendors/vendor_details_screen.dart';
import '../views/city/city_list_screen.dart';
import '../views/leads/lead_details_screen.dart';
import '../views/splash/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.addVendors,
      page: () => AddVendorScreen(),
    ),
    GetPage(
      name: AppRoutes.leadDetails,
      page: () => LeadDetailsScreen(
        leadId: Get.arguments, // 🔥 receiving ID
      ),
    ),
    GetPage(
      name: AppRoutes.vendorDetails,
      page: () => VendorDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.services,
      page: () => ServiceScreen(),
    ),
    GetPage(
      name: AppRoutes.users,
      page: () => AllUsersScreen(),
    ),
    GetPage(
      name: AppRoutes.addCategory,
      page: () => AddCategoryScreen(),
    ),

    GetPage(
      name: AppRoutes.cities,
      page: () => CityListScreen(),
    ),

    GetPage(
      name: AppRoutes.addCities,
      page: () => AddCityScreen(),
    ),
  ];
}
