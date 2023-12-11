import 'package:wh/all.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var tfpass = TextEditingController();
  bool loading = true;

  Future<void> initEveryThing(context) async {
    WidgetsFlutterBinding.ensureInitialized();
    await initToken();
    // Configure the plugin
    try {
      deviceId = await PlatformDeviceId.getDeviceId ?? deviceId;
    } catch (e) {}
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    initEveryThing(context);
  }

  @override
  Widget build(BuildContext context) {
    if (token != null) {
      navigateTo(context);
    }
    var size = MediaQuery.of(context).size;
    return AsyncBody(
      appBar: AppBar(title: Text(resLoginBtn)),
      loading: loading,
      child: SingleChildScrollView(
          child: Center(
        child: Container(
          width: size.width * .85,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: size.height * .2),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: deviceId),
                      textAlign: TextAlign.center,
                      readOnly: true,
                      enabled: false,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: deviceId));

                        Fluttertoast.showToast(msg: resCopied);
                      },
                      icon: const Icon(Icons.copy)),
                ],
              ),
              TextField(
                controller: tfpass,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: resSecretCode,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  tryLogin(context);
                },
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(resLoginBtn),
                      const SizedBox(width: 8),
                      const Icon(Icons.login),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> tryLogin(BuildContext context) async {
    setState(() => loading = true);
    try {
      var body = LoginVM('1.0', deviceId, tfpass.text);
      var response = await http.post(
        Uri.parse('$serverURI/API/Mobile/Login'),
        headers: httpHeader(withAuthorization: false),
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        var map = jsonDecode(response.body) as Map<String, dynamic>;
        var loginResponse = LoginResponse.fromMap(map);
        saveToken(loginResponse);
        token = loginResponse.Token;
      }
      handleResponseError(context, response);
    } catch (e) {
      showErrorMessage(context, resUnexpectedError);
    }
    setState(() => loading = false);
  }
}

void navigateTo(context, {Widget? to}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => to ?? const HomePage()));
  });
}
