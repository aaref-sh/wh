import 'dart:ui';

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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    minimumSize: Size(size.width * .9, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    resImOK,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    state = States.ok;
                    sendStatus();
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    minimumSize: Size(size.width * .9, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    resEmergencyState,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    state = States.emergency;
                    sendStatus();
                  },
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    minimumSize: Size(size.width * .9, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    resINeedHelp,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    state = States.needHelp;
                    sendStatus();
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
      lastLocation?.latitude.toString() ?? '',
      lastLocation?.longitude.toString() ?? '',
    );
    MobileMessage? message =
        MobileMessage(DateTime.now().toUtc(), tfcomment.text, loc, state);

    try {
      var body = jsonEncode(message);
      setState(() => loading = true);
      var response = await http.post(
        Uri.parse('$serverURI/API/Mobile/Send'),
        headers: httpHeader(),
        body: body,
      );
      setState(() => loading = false);
      if (response.statusCode == 200) {
        tfcomment.clear();
        showErrorMessage(context, resStatusSent);
        message = null;
      }
      handleResponseError(context, response);
    } catch (e) {
      setState(() => loading = false);
      showErrorMessage(context, resUnexpectedError);
    }
    if (message != null) {
      IsolateNameServer.lookupPortByName(backgroundIsolate)
          ?.send(message.toJson());
    }
  }
}
