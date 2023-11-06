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
  hubConnection ??= HubConnectionBuilder()
      .withUrl('$serverURI/$hub?access_token=${token ?? ''}')
      .withAutomaticReconnect()
      .build();

  if (!states.contains(hubConnection?.state)) {
    try {
      await hubConnection?.start();
      bindEvents(hubConnection);
    } catch (e) {
      notify('Connecting failed $serverURI/$hub');
      print(e);
    }
  }
}

Future<HubConnection> backgroundSignalR() async {
  final hubConnection = HubConnectionBuilder()
      .withUrl('$serverURI/$hub?access_token=${token ?? ''}')
      .withAutomaticReconnect()
      .build();

  // Start the connection
  await hubConnection.start();
  bindEvents(hubConnection);
  return hubConnection;
}

void bindEvents(HubConnection? hubConnection) {
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
