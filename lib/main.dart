import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsavadmin/themes/app_theme.dart';
import 'package:utsavadmin/routes/app_pages.dart';
import 'package:utsavadmin/routes/app_routes.dart';

void main() {
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




