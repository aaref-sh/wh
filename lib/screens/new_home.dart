import '../all.dart';
import 'package:http/http.dart' as http;

class NewMyStatus extends StatefulWidget {
  const NewMyStatus({super.key});

  @override
  State<NewMyStatus> createState() => _NewMyStatusState();
}

class _NewMyStatusState extends State<NewMyStatus> {
  var state = States.ok;
  bool loading = false;
  var tfcomment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AsyncBody(
      appBar: AppBar(title: Text(resHome)),
      loading: loading,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () {
          sendStatus();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: tfcomment,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 2,
              enabled: state != States.ok,
              readOnly: state == States.ok,
              decoration: InputDecoration(
                labelText: resTypeMessage,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.message),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            state == States.ok ? Colors.white : Colors.green,
                        backgroundColor:
                            state == States.ok ? Colors.green : Colors.white,
                        minimumSize: Size(size.width * .35, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: const BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                        elevation: state == States.ok ? 10 : 0,
                      ),
                      child: Text(
                        resImOK,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        setState(() {
                          state = States.ok;
                          tfcomment.text = '';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        foregroundColor: state == States.emergency
                            ? Colors.white
                            : Colors.red,
                        backgroundColor: state == States.emergency
                            ? Colors.red
                            : Colors.white,
                        minimumSize: Size(size.width * .55, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        elevation: state == States.emergency ? 10 : 0,
                      ),
                      child: Text(
                        resEmergencyState,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        setState(() {
                          state = States.emergency;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        state == States.needHelp ? Colors.white : Colors.orange,
                    backgroundColor:
                        state == States.needHelp ? Colors.orange : Colors.white,
                    minimumSize: Size(size.width * .9, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                    elevation: state == States.needHelp ? 10 : 0,
                  ),
                  child: Text(
                    resINeedHelp,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    setState(() {
                      state = States.needHelp;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendStatus() async {
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
      setState(() {
        loading = true;
      });
      var response = await http.post(
        Uri.parse('$serverURI/API/Mobile/Send'),
        headers: httpHeader(),
        body: body,
      );
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        tfcomment.clear();
        showErrorMessage(context, resStatusSent);
      } else {
        handleResponseError(context, response);
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      showErrorMessage(context, resUnexpectedError);
    }
  }
}
