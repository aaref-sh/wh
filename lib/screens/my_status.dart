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
              Expanded(child: Container()),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: resTypeMessage,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 6,
                      enabled: state != States.ok,
                      readOnly: state == States.ok,
                      controller: tfcomment,
                    ),
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
                          minimumSize: Size(20, 70),
                          side: BorderSide(
                              strokeAlign: BorderSide.strokeAlignOutside,
                              width: state == States.ok ? 5 : 0,
                              color: Color.fromARGB(255, 142, 204, 255)),
                          backgroundColor: Colors.green[900]),
                      child: Text(resImOK,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900)),
                      onPressed: () {
                        setState(() {
                          state = States.ok;
                          tfcomment.text = '';
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(20, 70),
                        side: BorderSide(
                            strokeAlign: BorderSide.strokeAlignOutside,
                            width: state == States.needHelp ? 5 : 0,
                            color: Color.fromARGB(255, 142, 204, 255)),
                        backgroundColor: Colors.yellow[900],
                      ),
                      child: Text(resINeedHelp,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900)),
                      onPressed: () {
                        setState(() {
                          state = States.needHelp;
                        });
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(20, 70),
                          side: BorderSide(
                              strokeAlign: BorderSide.strokeAlignOutside,
                              width: state == States.emergency ? 5 : 0,
                              color: Color.fromARGB(255, 142, 204, 255)),
                          backgroundColor: Colors.red[900]),
                      child: Text(resEmergencyState,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900)),
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
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(resSend, style: const TextStyle(fontSize: 25)),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.send),
                    )
                  ],
                ),
                onPressed: () {
                  sendStatus();
                },
              ),
              Expanded(child: Container()),
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
    var loc = GeoLocation(
      lastLocation?.latitude?.toString() ?? '',
      lastLocation?.longitude?.toString() ?? '',
    );
    var message = MobileMessage(
      DateTime.now().toUtc(),
      tfcomment.text,
      loc,
      state,
    );

    try {
      var body = jsonEncode(message);
      var response = await http.post(
        Uri.parse('$serverURI/API/Mobile/Send'),
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
