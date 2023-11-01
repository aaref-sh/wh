import 'all.dart';

Future<void> main() async {
  await initEverything();
  // Run your app
  runApp(const MyApp());
}

initEverything() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences();
  var pref = getToken();
  token = pref?.Token;
  username = pref?.Owner;
  initLocation();
  // Configure the plugin
  try {
    deviceId = await PlatformDeviceId.getDeviceId;
  } on PlatformException {
    deviceId = 'Failed to get deviceId.';
  }
  if (kDebugMode) {
    Wakelock.enable();
    Wakelock.toggle(enable: true);
  }

  NotificationService.initializeNotification().then((value) {
    WidgetsBinding.instance.addObserver(LifecycleEventHandler());
    initSignalRConnection();
  });
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
