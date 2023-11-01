import 'package:wh/all.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var tfpass = TextEditingController();
  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    if (token != null) {
      navigateToHome(context);
    }
    return Scaffold(
      appBar: AppBar(title: Text(resLoginBtn)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text("$resDeviceId: "),
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: deviceId));

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
        ),
      ),
    );
  }

  Future<void> tryLogin(BuildContext context) async {
    var body = LoginVM('1.0', deviceId!, tfpass.text);

    try {
      showLoadingPnal(context);
      var response = await http.post(
        Uri.parse('$protocol://$host$port/API/Mobile/Login'),
        headers: httpHeader(withAuthorization: false),
        body: jsonEncode(body),
      );
      Navigator.pop(context);
      if (response.statusCode == 200) {
        var map = jsonDecode(response.body) as Map<String, dynamic>;
        var loginResponse = LoginResponse.fromMap(map);
        saveToken(loginResponse);
        token = loginResponse.Token;
        initNotificationAndSignalr();
        navigateToHome(context);
      }
      handleResponseError(context, response);
    } catch (e) {
      showErrorMessage(context, resUnexpectedError);
    }
  }

  void navigateToHome(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }
}
