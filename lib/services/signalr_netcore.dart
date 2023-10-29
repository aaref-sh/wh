import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:wh/services/awesome_notification.dart';
import '../globals/variables.dart';

HubConnection? hubConnection;
var states = [
  HubConnectionState.Connected,
  HubConnectionState.Reconnecting,
  HubConnectionState.Connecting
];
Future<void> initSignalRConnection() async {
  if (hubConnection == null) {
    final defaultHeaders = MessageHeaders();
    defaultHeaders.setHeaderValue("Authorization", "Bearer $token"); // method 1

    final httpConnectionOptions = HttpConnectionOptions(
      accessTokenFactory: () => Future.value(token), // method 2
      // headers: defaultHeaders,
    );

    hubConnection = HubConnectionBuilder()
        .withUrl('$serverURI/$hub?access_token=$token', // method 3
            options: httpConnectionOptions)
        .build();
    hubConnection?.on("NotifyWeb", _notify);
    hubConnection?.onclose(({error}) {
      notify('Connection closed', 'connections');
    });
    hubConnection?.onreconnected(({connectionId}) {
      notify('Connection restored', "connections");
    });
    hubConnection?.onreconnecting(({error}) {
      notify('Reconnecting', 'connections');
    });
  }
  if (!states.contains(hubConnection?.state)) {
    try {
      await hubConnection?.start();
    } catch (e) {
      notify('Connecting failed', 'connections');
    }
  }
}

void _notify(List<Object?>? args) {
  var urgent = args?[0];
  notify('test', 'connections');
}
