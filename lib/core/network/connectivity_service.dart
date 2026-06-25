import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  final ValueNotifier<bool> isOnline = ValueNotifier(true);

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> init() async {
    final results = await _connectivity.checkConnectivity();
    isOnline.value = _hasConnection(results);
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      isOnline.value = _hasConnection(results);
    });
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn,
    );
  }

  Future<bool> checkOnline() async {
    final results = await _connectivity.checkConnectivity();
    final online = _hasConnection(results);
    isOnline.value = online;
    return online;
  }

  void dispose() {
    _subscription?.cancel();
  }
}

final connectivityService = ConnectivityService.instance;
