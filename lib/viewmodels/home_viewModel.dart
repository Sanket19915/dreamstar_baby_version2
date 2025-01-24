import 'package:flutter/material.dart';

import '../services/home_service.dart';

class HomeViewmodel extends ChangeNotifier{
  bool _loading = false;
  bool get loading => _loading;
  Future<Map<String, dynamic>?> activeUser({String? fcmToken, String? deviceId}) async {
    _loading = true;
    notifyListeners();

    final user = await HomeService.fetchActiveUser(deviceId: deviceId,fcmToken: fcmToken);

    _loading = false;
    notifyListeners();

    return user;
  }
}