import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  NotificationService();

  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<bool> checkPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    } else {
      // Retry asking permission
      var status = await Permission.notification.request();
      if (status == PermissionStatus.granted) {
        return true;
      }
      return false;
    }
  }
}
