import 'package:wh/all.dart';

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter
void callbackDispatcher() => Workmanager().executeTask((task, inputData) async {
      try {
        await NotificationService.initializeNotification();
        print(
            "Native called background task: $task"); //simpleTask will be emitted.
        initSignalRConnection();
      } on Exception catch (e) {
        print(e);
      }
      return Future.value(true);
    });

void initWorkmanager() {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask("task-identifier", "simpleTask");
}

void cancelWorkmanager() {
  Workmanager().cancelAll();
  initSignalRConnection();
}
