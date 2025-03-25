import 'package:dream_baby/features/auth/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/notification_services.dart';

class NotificationViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  Future<Map<String, dynamic>?> singleNotificationRead({required int notificationId}) async {
    try {
      final notification = await NotificationServices.singleNotificationRead(notificationId: notificationId);
      Fluttertoast.showToast(msg: "Notification mark as read");
      return notification;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }

  Future<NotificationData> getAllNotification() async {
    try {
      final notification = await NotificationServices.getAllNotification();

      return notification;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> readAllnotification() async {
    try {
      _loading = true;
      notifyListeners();

      final notification = await NotificationServices.readAllnotification();

      _loading = false;
      notifyListeners();

      return notification;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> unreadNotificationCount() async {
    try {
      final notification = await NotificationServices.unreadNotificationCount();

      return notification;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }
}
