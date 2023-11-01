import 'package:wh/all.dart';

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter
void callbackDispatcher() => Workmanager().executeTask((task, inputData) async {
      try {
        WidgetsFlutterBinding.ensureInitialized();
        await initSharedPreferences();

        var pref = getToken();
        token = pref?.Token;
        username = pref?.Owner;

        await NotificationService.initializeNotification();
        print("Native called background task: $task");
        notify('msg'); //simpleTask will be emitted.
        initSignalRConnection();
      } on Exception catch (e) {
        print(e);
      }
      return Future.value(true);
    });

Future<void> initWorkmanager() async {
  await hubConnection?.stop();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask("task-identifier", "simpleTask");
}

Future<void> cancelWorkmanager() async {
  await hubConnection?.stop();
  Workmanager().cancelAll();
  initSignalRConnection();
}
