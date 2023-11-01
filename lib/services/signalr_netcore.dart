import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../all.dart';

HubConnection? hubConnection;
var states = [
  HubConnectionState.Connected,
  HubConnectionState.Reconnecting,
  HubConnectionState.Connecting
];
Future<void> initSignalRConnection() async {
  if (hubConnection == null) {
    final defaultHeaders = MessageHeaders();
    defaultHeaders.setHeaderValue("Authorization", "Bearer ${token ?? ''}");

    final httpConnectionOptions = HttpConnectionOptions(
      accessTokenFactory: () => Future.value(token ?? ''),
      headers: defaultHeaders,
    );

    hubConnection = HubConnectionBuilder()
        .withUrl(
          '$serverURI/$hub',
          options: httpConnectionOptions,
        )
        .withAutomaticReconnect()
        .build();
    hubConnection?.on("NotifyWeb", _notify);
    hubConnection?.on("NotifyChat", _notifyChat);
    hubConnection?.onclose(({error}) {
      notify('Connection closed');
    });
    hubConnection?.onreconnected(({connectionId}) {
      notify('Connection restored');
    });
    hubConnection?.onreconnecting(({error}) {
      notify('Reconnecting');
    });
  }
  if (!states.contains(hubConnection?.state)) {
    try {
      await hubConnection?.start();
    } catch (e) {
      notify('Connecting failed $serverURI/$hub');
    }
  }
}

void _notify(List<Object?>? args) {
  notify('test');
}

void _notifyChat(List<Object?>? args) {
  var messageMap = args![0] as Map<String, dynamic>;
  var msg = Message.fromMap(messageMap);

  ChatScreenState.addMessage(msg);
  if (pageIndex != 2) notifyChat(msg);
}
