import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'all.dart';

const String mainIsolate = "workmanager";
ReceivePort _port = ReceivePort();

Future<void> main() async {
  await initEverything();

  // Run your app
  runApp(const MyApp());
}

initEverything() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initToken();
  // Configure the plugin
  try {
    deviceId = await PlatformDeviceId.getDeviceId;
  } catch (e) {}
  if (kDebugMode) Wakelock.enable();

  if (token?.isEmpty ?? true) return;
  initListinPort();

  initBackgroundAndLocation();
}

void initListinPort() {
  IsolateNameServer.registerPortWithName(_port.sendPort, mainIsolate);
  // Listen for messages from the background isolate
  _port.listen((msg) {
    ChatScreenState.addMessage(msg);
  });
}

void initBackgroundAndLocation() {
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
  initLocation();
  initWorkmanager();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سلامة',
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
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}
