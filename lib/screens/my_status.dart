import '../all.dart';
import 'package:http/http.dart' as http;

class MyStatus extends StatefulWidget {
  const MyStatus({super.key});

  @override
  State<MyStatus> createState() => _MyStatusState();
}

class _MyStatusState extends State<MyStatus> {
  var tfcomment = TextEditingController();
  var state = States.ok;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(resHome),
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
                      sendStatus();
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

  Future<void> sendStatus() async {
    showLoadingPnal(context);
    if (state == States.needHelp && tfcomment.text.trim() == '') {
      showErrorMessage(context, resCommentIsRequiredMsg);
      return;
    }
    var loc = GeoLocation(lastLocation?.latitude?.toString() ?? '',
        lastLocation?.longitude?.toString() ?? '');
    var message =
        MobileMessage(DateTime.now().toUtc(), tfcomment.text, loc, state);

    try {
      var body = jsonEncode(message);
      var response = await http.post(
        Uri.parse('$protocol://$host$port/API/Mobile/Send'),
        headers: httpHeader(),
        body: body,
      );
      // Navigator.of(context).pop();

      if (response.statusCode == 200) {
        showErrorMessage(context, resStatusSent);
      }
      handleResponseError(context, response);
    } catch (e) {
      Navigator.of(context).pop();
      showErrorMessage(context, resUnexpectedError);
    }
    // getAllMessages(context);
  }
}
