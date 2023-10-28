import 'package:wh/all.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var tfcomment = TextEditingController();
  var state = States.ok;
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
                      child: TextField(
                        enabled: state != States.ok,
                        readOnly: state == States.ok,
                        controller: tfcomment,
                      )),
                  ElevatedButton(
                    child: Text(resSend),
                    onPressed: () {
                      sendStatus(context);
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                              width: state == States.ok ? 5 : 0,
                              color: Color.fromARGB(255, 142, 204, 255)),
                          backgroundColor: Colors.green[900]),
                      child: Text(resImOK),
                      onPressed: () {
                        setState(() {
                          state = States.ok;
                          tfcomment.text = '';
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                            width: state == States.needHelp ? 5 : 0,
                            color: Color.fromARGB(255, 142, 204, 255)),
                        backgroundColor: Colors.yellow[900],
                      ),
                      child: Text(resINeedHelp),
                      onPressed: () {
                        setState(() {
                          state = States.needHelp;
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                              width: state == States.emergency ? 5 : 0,
                              color: Color.fromARGB(255, 142, 204, 255)),
                          backgroundColor: Colors.red[900]),
                      child: Text(resEmergencyState),
                      onPressed: () {
                        setState(() {
                          state = States.emergency;
                        });
                        // need help functionality
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void sendStatus(BuildContext context) {
    if (state == States.needHelp && tfcomment.text.trim() == '') {
      showErrorMessage(context, resCommentIsRequiredMsg);
      return;
    }
  }
}
