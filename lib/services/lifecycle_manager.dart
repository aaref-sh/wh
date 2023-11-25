import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wh/services/workmanager.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler();

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        await detachedCallBack();
        break;
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
      case AppLifecycleState.paused:
    }
  }
}

resumeCallBack() {
  tougleNotifications(0);
}

detachedCallBack() {
  tougleNotifications(1);
}

void tougleNotifications(int n) {
  IsolateNameServer.lookupPortByName(backgroundIsolate)?.send(n);
}
