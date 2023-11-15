import 'package:signalr_core/signalr_core.dart';
import '../all.dart';

HubConnection? hubConnection;
var states = [
  HubConnectionState.connected,
  HubConnectionState.reconnecting,
  HubConnectionState.connecting,
];

Future<void> initSignalRConnection() async {
  hubConnection ??= await signalRConnection();
}

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

  if (!states.contains(hubConnection?.state)) {
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

void _notifyChat(List<Object?>? args) {
  var messageMap = args![0] as Map<String, dynamic>;
  var msg = Message.fromMap(messageMap);
  DatabaseHelper.instance.insert(msg);
  ChatScreenState.addMessage(msg);
  if (pageIndex != 2) notifyChat(msg);
}
