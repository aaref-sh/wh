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

void initListinPort() {
  ReceivePort port = ReceivePort();
  IsolateNameServer.registerPortWithName(port.sendPort, mainIsolate);
  // Listen for messages from the background isolate
  port.listen((msg) {
    if (msg == 1) tougleNotifications(0);
    ChatScreenState.addMessage(Message.fromMap(msg));
  });
}

Future<void> initBackgroundAndLocation() async {
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
  initLocation();
  await initWorkmanager();
  resumeCallBack();
}

class _NavigationExampleState extends State<NavigationExample> {
  @override
  void initState() {
    super.initState();
    initBackgroundAndLocation();
    getAdminMessagesFromServer(context).then((value) {
      if (value?.isNotEmpty ?? false) setState(() => pageIndex = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
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
    );
  }
}
