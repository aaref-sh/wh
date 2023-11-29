import 'package:wh/all.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

Future<String> initEveryThing(context) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initToken();
  // Configure the plugin
  try {
    deviceId = await PlatformDeviceId.getDeviceId ?? deviceId;
  } catch (e) {}
  if (token != null) {
    navigateToHome(context);
  }
  return "";
}

class _LoginState extends State<Login> {
  var tfpass = TextEditingController();
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(title: Text(resLoginBtn)),
            body: SingleChildScrollView(
              child: FutureBuilder(
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("$resDeviceId: "),
                              IconButton(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: deviceId));

                                    Fluttertoast.showToast(msg: resCopied);
                                  },
                                  icon: const Icon(Icons.copy)),
                            ],
                          ),
                          TextField(
                            controller: TextEditingController(text: deviceId),
                            textAlign: TextAlign.center,
                            readOnly: true,
                          ),
                          TextField(
                            controller: tfpass,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              tryLogin(context);
                            },
                            child: Row(
                              children: [
                                Text(resLoginBtn),
                                const Icon(Icons.login),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(resPleaseWait)),
                      ),
                      Container()
                    ],
                  ));
                },
                future: initEveryThing(context),
              ),
            ),
          );
        });
  }

  Future<void> tryLogin(BuildContext context) async {
    var body = LoginVM('1.0', deviceId!, tfpass.text);

    showErrorMessage(context, resPleaseWait, loading: true);
    try {
      var response = await http.post(
        Uri.parse('$serverURI/API/Mobile/Login'),
        headers: httpHeader(withAuthorization: false),
        body: jsonEncode(body),
      );
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        var map = jsonDecode(response.body) as Map<String, dynamic>;
        var loginResponse = LoginResponse.fromMap(map);
        saveToken(loginResponse);
        token = loginResponse.Token;
        setState(() {});
      } else {
        handleResponseError(context, response);
      }
    } catch (e) {
      Navigator.of(context).pop();
      showErrorMessage(context, resUnexpectedError);
    }
  }
}

void navigateToHome(context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => const Directionality(
                textDirection: TextDirection.rtl, child: HomePage())));
  });
}
