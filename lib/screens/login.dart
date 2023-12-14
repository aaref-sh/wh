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
    if (token?.isNotEmpty ?? false) navigateTo(context);

    var size = MediaQuery.of(context).size;
    return AsyncBody(
      // appBar: AppBar(title: Text(resLoginBtn)),
      loading: loading,
      child: Stack(
        children: [
          Positioned(
            top: 50,
            child: Image.asset(
              'assets/Splash.png',
              width: size.width,
              fit: BoxFit.fitWidth,
              opacity: const AlwaysStoppedAnimation(0.1),
            ),
          ),
          Center(
            child: Container(
              width: size.width * .85,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Color.fromARGB(255, 173, 173, 173))
                        // color: Colors.white,
                        ),
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 2, bottom: 2),
                    padding: EdgeInsets.only(left: 10, right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(deviceId, style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 5),
                            IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: deviceId));

                                  Fluttertoast.showToast(msg: resCopied);
                                }),
                          ],
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: const Color.fromARGB(255, 173, 173, 173),
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            textDirection: TextDirection.ltr,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            controller: tfpass,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: resSecretCode,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            tryLogin(context);
                          },
                          child: Text(resLoginBtn),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
