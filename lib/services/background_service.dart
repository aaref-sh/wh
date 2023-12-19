import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:wh/all.dart';

var pendingMessages = <MobileMessage>[];
Future<void> initBackgroundService() async {
  final service = FlutterBackgroundService();
  try {
    await service.configure(
        androidConfiguration: AndroidConfiguration(
          // this will be executed when app is in foreground or background in separated isolate
          onStart: onStart,
          // auto start service
          isForegroundMode: true,
          initialNotificationTitle: 'سلامة',
          initialNotificationContent: 'يعمل بالخلفية',
          foregroundServiceNotificationId: notificationId,
        ),
        iosConfiguration: IosConfiguration());
  } catch (e) {
    print(e);
  }
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  IsolateNameServer.removePortNameMapping(backgroundIsolate);

  await Future.wait([
    initToken(),
    loadSettings(),
    initLocation(),
    NotificationService.initializeNotification(),
  ]);

  var hubConnection = signalRConnection();

  var port = ReceivePort();
  IsolateNameServer.registerPortWithName(port.sendPort, backgroundIsolate);
  // if app is oppened ,this will turn of the messages notifications
  IsolateNameServer.lookupPortByName(mainIsolate)?.send(1);

  port.listen((message) {
    var msg = IsolateMessage.fromMap(message);

    switch (IsolateMessages.values[msg.message]) {
      case IsolateMessages.toggleNotifications:
        notifyOnNewMessage = msg.data == 1;
        break;
      case IsolateMessages.updateSettings:
        settings = Settings.fromMap(msg.data);
        break;
      case IsolateMessages.chatMessage:
        hubConnection.invoke("Chat", args: [msg.data]);
        break;
      case IsolateMessages.failedStatus:
        var message = MobileMessage.fromMap(msg.data);
        pendingMessages.add(message);
        break;
    }
  });

  while (true) {
    await signalRConnect(hubConnection);
    await Future.delayed(const Duration(seconds: 5));
    await resendFailedStatusMessages();
    IsolateNameServer.lookupPortByName(mainIsolate)
        ?.send(hubConnection.state == HubConnectionState.connected ? 3 : 4);
  }
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
        // network is not available yet - do nothing
      }
    }
  } catch (e) {}
}
