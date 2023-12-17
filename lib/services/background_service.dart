import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:flutter_background_service/flutter_background_service.dart';
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
    await signalRConnect(hubConnection);
    await Future.delayed(const Duration(seconds: 10));
    await resendFailedStatusMessages();
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
