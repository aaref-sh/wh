import 'package:flutter/material.dart';
import 'package:wh/services/workmanager.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler();

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      // case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await detachedCallBack();
        break;
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
    }
  }
}

resumeCallBack() {
  cancelWorkmanager();
}

detachedCallBack() {
  initWorkmanager();
}
