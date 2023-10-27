import 'package:wh/all.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField()),
                  ElevatedButton(
                    child: Text(resSend),
                    onPressed: () {
                      // ok functionality
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: Text(resImOK),
                    onPressed: () {
                      // ok functionality
                    },
                  ),
                  ElevatedButton(
                    child: Text(resINeedHelp),
                    onPressed: () {
                      // need help functionality
                    },
                  ),
                  ElevatedButton(
                    child: Text(resEmergencyState),
                    onPressed: () {
                      // need help functionality
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
