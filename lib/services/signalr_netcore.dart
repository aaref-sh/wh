import 'dart:ui';
import 'package:signalr_core/signalr_core.dart';
import '../all.dart';

var states = [
  HubConnectionState.connected,
  HubConnectionState.reconnecting,
  HubConnectionState.connecting,
];

Future<HubConnection> signalRConnection() async {
  var hubConnection = HubConnectionBuilder()
      .withUrl(
          '$serverURI/$hub',
          HttpConnectionOptions(
            logMessageContent: true,
            transport: HttpTransportType.longPolling,
            accessTokenFactory: () async => token,
            logging: (level, message) => print(message),
          ))
      .withAutomaticReconnect()
      .build();

  if (!states.contains(hubConnection.state)) {
    try {
      await hubConnection.start();
      bindEvents(hubConnection);
    } catch (e) {
      notify('Connecting failed $serverURI/$hub');
      print(e);
    }
  }
  return hubConnection;
}

void bindEvents(HubConnection? hubConnection) {
  hubConnection?.on("NotifyWeb", _notify);
  hubConnection?.on("NotifyChat", _notifyChat);
  hubConnection?.onclose((error) {
    notify('Connection closed');
  });
  hubConnection?.onreconnected((connectionId) {
    notify('Connection restored');
  });
  hubConnection?.onreconnecting((error) {
    notify('Reconnecting');
  });
}

void _notify(List<Object?>? args) {
  notify('test');
}

bool notifyOnNewMessage = true;
void _notifyChat(List<Object?>? args) {
  var messageMap = args![0] as Map<String, dynamic>;
  var msg = Message.fromMap(messageMap);
  DatabaseHelper.instance.insert(msg);
  if (pageIndex != 2 && notifyOnNewMessage) notifyChat(msg);
  // Send a message to the main isolate
  IsolateNameServer.lookupPortByName(mainIsolate)?.send(msg.toJson());
}
