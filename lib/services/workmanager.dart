import 'dart:ui';
import 'package:signalr_core/signalr_core.dart';
import 'package:wh/all.dart';
import 'package:http/http.dart' as http;

var pendingMessages = <MobileMessage>[];

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      var startedAt = DateTime.now();
      String x = inputData?['pendingMessages'] ?? '';
      if (x.isNotEmpty) {
        pendingMessages = x
            .split(seperator)
            .map((e) => MobileMessage.fromMap(json.decode(e)))
            .toList();
      }

      WidgetsFlutterBinding.ensureInitialized();
      IsolateNameServer.removePortNameMapping(backgroundIsolate);
      await initToken();
      await initLocation();
      await NotificationService.initializeNotification();

      IsolateNameServer.lookupPortByName(mainIsolate)?.send(1);

      var port = ReceivePort();
      IsolateNameServer.registerPortWithName(port.sendPort, backgroundIsolate);
      late HubConnection? hubConnection;
      // Listen for messages from the background isolate
      port.listen((msg) {
        if (msg == 1) {
          notifyOnNewMessage = true;
        } else if (msg == 0) {
          notifyOnNewMessage = false;
        } else {
          if (msg is Map<String, dynamic>) {
            var message = MobileMessage.fromMap(msg);
            pendingMessages.add(message);
          } else {
            hubConnection?.invoke("Chat", args: [msg]);
          }
        }
      });
      hubConnection = await signalRConnection();
      while (true) {
        try {
          await Future.delayed(const Duration(milliseconds: 100));
          await resendFailedStatusMessages();
          if (DateTime.now().difference(startedAt).inMinutes > 30) {
            throw Exception("ReRunNewWorkManager");
          }
        } catch (e) {
          await hubConnection.stop();
          var stringifyedList = pendingMessages
              .map((e) => jsonEncode(e.toJson()))
              .join(seperator);
          await initNewWorkmanager(stringifyedList);
          break;
        }
      }
    } on Exception catch (e) {
      print(e);
    }
    return Future.value(true);
  });
}

Future<void> resendFailedStatusMessages() async {
  try {
    for (int i = 0; i < pendingMessages.length; i++) {
      var message = pendingMessages[i];
      if (lastLocation?.latitude != null) {
        message.location = GeoLocation(
          lastLocation?.latitude.toString() ?? '',
          lastLocation?.longitude.toString() ?? '',
        );
      }
      try {
        var response = await http.post(
          Uri.parse('$serverURI/API/Mobile/Send'),
          headers: httpHeader(),
          body: jsonEncode(message),
        );
        if (response.statusCode == 200) {
          notifyStatus();
          pendingMessages.remove(message);
          i--;
        }
      } catch (e) {
        // do nothing
      }
    }
  } catch (e) {}
}

Future<void> initWorkmanager() async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    "1",
    signalRTask,
    frequency: const Duration(minutes: 35),
    tag: "signalR",
    existingWorkPolicy: ExistingWorkPolicy.keep,
  );
}

Future<void> initNewWorkmanager(String pendingMessages) async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerOneOffTask(
    "1",
    signalRTask,
    inputData: {'pendingMessages': pendingMessages},
    tag: "signalR",
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );
}
