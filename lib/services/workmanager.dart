import 'dart:io';

import 'package:wh/all.dart';

const signalRTask = "signalRTask";

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await initToken();
    await NotificationService.initializeNotification();
    // Create a SignalR client
    try {
      var hubConnection = await backgroundSignalR();

      while (true) {
        try {
          await Future.delayed(const Duration(milliseconds: 100));
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          await hubConnection.stop();
          break;
        }
      }
    } on Exception catch (e) {
      print(e);
    }
    return Future.value(true);
  });
}

Future<void> initToken() async {
  await initSharedPreferences();

  var pref = getToken();
  token = pref?.Token;
  username = pref?.Owner;
}

Future<void> initWorkmanager() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  Workmanager().registerPeriodicTask(
    "1",
    signalRTask,
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 2),
    tag: "signalR",
  );
}

Future<void> cancelWorkmanager() async {
  // await hubConnection?.stop();
  Workmanager().cancelAll();
  initSignalRConnection();
}
