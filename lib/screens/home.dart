import 'package:wh/screens/management_messages.dart';

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

int pageIndex = 0;

class _NavigationExampleState extends State<NavigationExample> {
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
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: resMyStatus,
          ),
          NavigationDestination(
            icon: Icon(Icons.notification_important_outlined),
            selectedIcon: Icon(Icons.notification_important_rounded),
            label: resManagementMessages,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.chat),
            icon: Icon(Icons.chat_outlined),
            label: resChat,
          ),
        ],
      ),
      body: <Widget>[
        const MyStatus(),
        const ManagementMessages(),
        const ChatScreen(),
      ][pageIndex],
    );
  }
}
