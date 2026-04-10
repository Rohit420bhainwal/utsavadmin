import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:utsavadmin/routes/app_routes.dart';

class NotificationController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    initFCM();
  }

  void initFCM() async {

    /// 🔹 Request permission (IMPORTANT for Android 13+)
    await FirebaseMessaging.instance.requestPermission();

    /// 🔹 Get FCM token (optional debug)
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔥 ADMIN FCM TOKEN (INIT): $token");

    /// 🔹 Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 FOREGROUND MESSAGE: ${message.notification?.title}");
      print("🔔 DATA_MYMESSAGE: ${message.data}");
      print("🔔 NON_DATA_MYMESSAGE: ${message.notification}");

      Get.snackbar(
        message.notification?.title ?? "Notification",
        message.notification?.body ?? "",
        snackPosition: SnackPosition.TOP,
      );
    });

    /// 🔹 When user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔔 Notification clicked");

      final leadId = message.data["leadId"];

      if (leadId != null) {
        Get.toNamed(AppRoutes.leadDetails, arguments: leadId);
      }
    });
  }
}