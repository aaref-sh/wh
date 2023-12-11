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
            transport: HttpTransportType.webSockets,
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
      notify(resConnectingToServerFailed);
      print(e);
      return await signalRConnection();
    }
  }
  return hubConnection;
}

void bindEvents(HubConnection? hubConnection) {
  hubConnection?.on("Test", _test);
  hubConnection?.on("NotifyChat", _notifyChat);
  hubConnection?.onclose((error) {
    try {
      hubConnection.start();
    } catch (e) {}
    // notify('Connection closed');
  });
  hubConnection?.onreconnected((connectionId) {
    notify(resConnectionRestored);
  });
  hubConnection?.onreconnecting((error) {
    // notify(resReconnecting);
  });
}

void _test(List<Object?>? args) {
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
