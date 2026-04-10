import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:utsavadmin/themes/app_theme.dart';
import 'package:utsavadmin/routes/app_pages.dart';
import 'package:utsavadmin/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:utsavadmin/views/notification/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(NotificationController());
  await GetStorage.init();
  runApp(const Utsaveadmin());
}

class Utsaveadmin extends StatelessWidget {
  const Utsaveadmin({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTsav Admin',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}




