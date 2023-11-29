import 'dart:isolate';
import 'dart:ui';

import 'package:wh/all.dart';
import 'package:wh/main.dart';

const signalRTask = "signalRTask";
const backgroundIsolate = "backgroundIsolate";

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      IsolateNameServer.removePortNameMapping(backgroundIsolate);
      await initToken();
      await NotificationService.initializeNotification();
      var hubConnection = await signalRConnection();

      var port = ReceivePort();
      IsolateNameServer.registerPortWithName(port.sendPort, backgroundIsolate);
      // Listen for messages from the background isolate
      port.listen((msg) {
        if (msg == 1) {
          notifyOnNewMessage = true;
        } else if (msg == 0) {
          notifyOnNewMessage = false;
        } else {
          hubConnection.invoke("Chat", args: [msg]);
        }
      });

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

Future<void> initWorkmanager() async {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  Workmanager().registerPeriodicTask(
    "1",
    signalRTask,
    frequency: const Duration(minutes: 30),
    tag: "signalR",
  );
}
