import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/home_service.dart';

class HomeViewmodel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  Future<Map<String, dynamic>?> activeUser({String? fcmToken, String? deviceId}) async {
    try {
      _loading = true;
      notifyListeners();

      final user = await HomeService.fetchActiveUser(deviceId: deviceId, fcmToken: fcmToken);

      _loading = false;
      notifyListeners();
      print(user);
      return user;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }
}
