import 'dart:ui';
import 'package:signalr_core/signalr_core.dart';
import 'package:wh/all.dart';
import 'package:http/http.dart' as http;

var pendingMessages = <MobileMessage>[];
var stringifiedPendingMessages = '';
@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      IsolateNameServer.removePortNameMapping(backgroundIsolate);

      await Future.wait([
        initToken(),
        loadSettings(),
        initLocation(),
        NotificationService.initializeNotification(),
      ]);
      if (stringifiedPendingMessages.isNotEmpty) {
        pendingMessages = stringifiedPendingMessages
            .split(seperator)
            .map((e) => MobileMessage.fromMap(json.decode(e)))
            .toList();
      }

      var port = ReceivePort();
      IsolateNameServer.registerPortWithName(port.sendPort, backgroundIsolate);
      // if app is oppened ,this will turn of the messages notifications
      IsolateNameServer.lookupPortByName(mainIsolate)?.send(1);

      HubConnection hubConnection = signalRConnection();

      port.listen((msg) {
        if (msg is int) {
          notifyOnNewMessage = msg == 1;
        } else if (msg is Map<String, dynamic>) {
          var message = MobileMessage.fromMap(msg);
          pendingMessages.add(message);
        } else {
          hubConnection.invoke("Chat", args: [msg]);
        }
      });

      while (true) {
        try {
          await Future.wait([
            Future.delayed(const Duration(milliseconds: 100)),
            signalRConnect(hubConnection),
            resendFailedStatusMessages()
          ]);
        } catch (e) {
          hubConnection.stop();
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

          var stringifiedList = pendingMessages
              .map((e) => jsonEncode(e.toJson()))
              .join(seperator);

          await prefs.setString(pendingMessagesKey, stringifiedList);
        }
      } catch (e) {
        // network is not available yet - do nothing
      }
    }
  } catch (e) {}
}

Future<void> initWorkmanager() async {
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    "1",
    signalRTask,
    frequency: Duration(minutes: timeInterval),
    tag: "signalR",
  );
}
