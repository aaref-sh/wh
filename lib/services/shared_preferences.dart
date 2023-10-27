import 'package:shared_preferences/shared_preferences.dart';
import 'package:wh/models/login_response.dart';

late SharedPreferences prefs;

Future<void> initSharedPreferences() async {
  prefs = await SharedPreferences.getInstance();
}

Future<void> saveToken(LoginResponse response) async {
  await prefs.setString('owner', response.Owner);
  await prefs.setString('token', response.Token);
}

LoginResponse? getToken() {
  final String? token = prefs.getString('token');
  final String? owner = prefs.getString('owner');

  if (token != null && owner != null) {
    return LoginResponse(owner, token);
  }
  return null;
}
