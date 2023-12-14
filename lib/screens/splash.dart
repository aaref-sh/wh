import 'package:wh/all.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var loaded = false;

  Future<void> loadToken() async {
    await initToken();
    await loadSettings();
    setState(() => loaded = true);
  }

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (loaded) {
      if (token?.isEmpty ?? true) {
        navigateTo(context, to: const Login());
      } else {
        navigateTo(context);
      }
    }
    return Scaffold(
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: Image.asset(
            'assets/Splash.png',
            fit: BoxFit.fitWidth,
            width: size.width,
            height: size.height,
          )),
    );
  }
}
