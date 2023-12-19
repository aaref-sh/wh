import 'dart:ui';
import '../all.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

late void Function(void Function()) mainPageState;

Future<void> initBackgroundAndLocation() async {
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
  initLocation();
  resumeCallBack();
  await initBackgroundService();
}

class _NavigationExampleState extends State<NavigationExample> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    initListinPort();
    mainPageState = setState;
    checkNewAlerts();
    initBackgroundAndLocation();
  }

  void initListinPort() {
    IsolateNameServer.removePortNameMapping(mainIsolate);
    ReceivePort port = ReceivePort();
    IsolateNameServer.registerPortWithName(port.sendPort, mainIsolate);
    // Listen for messages from the background isolate
    port.listen((msg) {
      if (msg is int) {
        if (msg == 1) tougleNotifications(0);
        if (msg == 2) checkNewAlerts();
      } else {
        ChatScreenState.addMessage(Message.fromMap(msg));
      }
    });
  }

  void checkNewAlerts() {
    getAdminMessagesFromServer(context).then((value) {
      if (value?.isNotEmpty ?? false) setState(() => pageIndex = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سلامة',
      theme: ThemeData(
        primarySwatch: appColor().toMaterialColor(),
      ),
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) =>
              setState(() => pageIndex = index),
          // indicatorColor: Colors.amber[800],
          selectedIndex: pageIndex,
          destinations: <Widget>[
            NavigationDestination(
              selectedIcon: const Icon(Icons.home),
              icon: const Icon(Icons.home_outlined),
              label: resMyStatus,
            ),
            NavigationDestination(
              icon: const Icon(Icons.notification_important_outlined),
              selectedIcon: const Icon(Icons.notification_important_rounded),
              label: resManagementMessages,
            ),
            NavigationDestination(
              selectedIcon: const Icon(Icons.chat),
              icon: const Icon(Icons.chat_outlined),
              label: resChat,
            ),
          ],
        ),
        body: <Widget>[
          const NewMyStatus(),
          const ManagementMessages(),
          const ChatScreen(),
        ][pageIndex],
      ),
    );
  }
}
