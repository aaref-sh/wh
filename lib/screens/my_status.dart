import 'dart:math';
import 'dart:ui';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

  var timerIntervalEditBoxctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    timerIntervalEditBoxctrl.text = timeInterval.toString();
    var size = MediaQuery.of(context).size;
    return AsyncBody(
      drawer: mainPageDrawer(context),
      appBar: AppBar(title: Text(resHome)),
      loading: loading,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
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

  Drawer mainPageDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(mainColor),
            ),
            child: Center(
                child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white54,
                  border: Border.all(
                    color: const Color.fromARGB(255, 173, 173, 173),
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.settings,
                        size: 22,
                        color: Colors.black87,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'الإعدادات',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),
            )),
          ),
          ListTile(
            title: const Text(resTitleAppColor),
            trailing: IconButton(
                onPressed: () {
                  changeAppColorDialog(context);
                },
                icon: Icon(
                  Icons.color_lens,
                  color: Color(mainColor),
                )),
          ),
          ExpansionTile(
            title: const Text(resTimerIntervalOptionTitle),
            trailing: SizedBox(
                width: 70,
                child: TextField(
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  controller: timerIntervalEditBoxctrl,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                    var val = int.tryParse(timerIntervalEditBoxctrl.text) ?? 30;
                    val = min(val, 600);
                    timeInterval = val;
                    prefs.set('timeInterval', val);
                  },
                  onChanged: (value) {
                    var x = int.tryParse(value) ?? 30;
                    x = min(x, 600);
                  },
                  autocorrect: false,
                )),
            children: const [Text(resTimerIntervalOptionDesc)],
          ),
          ExpansionTile(
            title: const Text(resSignalRNotificationsOptionTitle),
            trailing: Switch(
                value: signalRConnectionNotifications,
                onChanged: (value) {
                  changeSignalRNotifications(value);
                }),
            children: const [Text(resSignalRNotificationsOptionDesc)],
          ),
          ExpansionTile(
            title: const Text(resChatsNotificationsOptionTitle),
            trailing: Switch(
                value: chatsNotifications,
                onChanged: (value) {
                  changeChatsNotifications(value);
                }),
            children: const [Text(resChatsNotificationsOptionDesc)],
          ),
          ExpansionTile(
              title: const Text(resResendNotificationsOptionTitle),
              trailing: Switch(
                  value: resendFailedStatusNotifications,
                  onChanged: (value) {
                    changeResendNotifications(value);
                  }),
              children: const [Text(resResendNotificationsOptionDesc)]),
        ],
      ),
    );
  }

  Future<void> changeSignalRNotifications(bool value) async {
    if (await prefs.set('signalrnotifications', value)) {
      setState(() => signalRConnectionNotifications = value);
    }
  }

  Future<void> changeResendNotifications(bool value) async {
    if (await prefs.set('resendnotifications', value)) {
      setState(() => resendFailedStatusNotifications = value);
    }
  }

  Future<void> changeChatsNotifications(bool value) async {
    if (await prefs.set('chatsnotifications', value)) {
      setState(() => chatsNotifications = value);
    }
  }

  Future<dynamic> changeAppColorDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        Color pickerColor = appColor();
        return AlertDialog(
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) => setState(() => pickerColor = color),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text(resConfirm),
              onPressed: () {
                setAppColor(pickerColor);
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text(resCancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> setAppColor(Color pickerColor) async {
    if (await prefs.set('color', mainColor)) {
      mainColor = pickerColor.value;
    }
    mainPageState!(() {});
    setState(() {});
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
