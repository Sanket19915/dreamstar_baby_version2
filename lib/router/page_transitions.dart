import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Platform-adaptive page — [CupertinoPage] on iOS enables native swipe-back.
Page<T> adaptivePage<T>({
  required GoRouterState state,
  required Widget child,
  bool fullscreenDialog = false,
}) {
  if (!kIsWeb && Platform.isIOS) {
    return CupertinoPage<T>(
      key: state.pageKey,
      fullscreenDialog: fullscreenDialog,
      child: child,
    );
  }
  return MaterialPage<T>(
    key: state.pageKey,
    fullscreenDialog: fullscreenDialog,
    child: child,
  );
}
