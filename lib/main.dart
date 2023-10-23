import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wh/globals/variables.dart';
import 'package:wh/services/awesome_notification.dart';
import 'package:wh/screens/login.dart';
import 'package:wh/services/lifecycle_manager.dart';
import 'package:wh/services/signalr_netcore.dart';
import 'package:wh/services/workmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Configure the plugin
  initEverything();
  if (kDebugMode) {
    Wakelock.enable();
    // The following statement enables the wakelock.
    Wakelock.toggle(enable: true);
  }
  // Run your app
  runApp(const MyApp());
}

initEverything() async {
  await NotificationService.initializeNotification();

  try {
    deviceId = await PlatformDeviceId.getDeviceId;
  } on PlatformException {
    deviceId = 'Failed to get deviceId.';
  }

  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
  initSignalRConnection();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: const Login(),
    );
  }
}
