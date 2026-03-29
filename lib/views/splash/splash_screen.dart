import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsavadmin/views/splash/splash_controller.dart';
import '../../utils/app_colors.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset('assets/images/app_icon_6.png',
                width: 135,
                height: 135,
                fit: BoxFit.fitWidth,
                scale: 2.0),
            /*Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 80,
            ),*/
            const SizedBox(height: 16),
            /*const Text(
              'Utsav',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),*/
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
