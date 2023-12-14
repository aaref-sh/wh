import 'package:shared_preferences/shared_preferences.dart';

import '../all.dart';
import 'package:http/http.dart' as http;

handleResponseError(BuildContext context, Response response) {
  var message = resErrorHappend;
  switch (response.statusCode) {
    case 200:
      return;
    case 505:
    case 403:
    case 400:
      message = response.body;
      break;
    case 401:
      message = resUnAuthorized;
      break;
  }

  showErrorMessage(context, message);
}

Map<String, String> httpHeader({bool withAuthorization = true}) {
  var headers = {'Content-Type': 'application/json; charset=UTF-8'};
  if (withAuthorization) headers['Authorization'] = 'Bearer ${token!}';
  return headers;
}

String timeAgo(DateTime date) {
  final now = DateTime.now(); // get the current date
  final diff = now.difference(date);
  if (diff.inDays > 365) {
    return '${(diff.inDays / 365).floor()}$resYearShortcut';
  } else if (diff.inDays > 30) {
    return '${(diff.inDays / 30).floor()}$resMonthShortcut';
  } else if (diff.inDays > 0) {
    return '${diff.inDays}$resDayShortcut';
  } else if (diff.inHours > 0) {
    return '${diff.inHours}$resHourShortcut';
  } else if (diff.inMinutes > 0) {
    return '${diff.inMinutes}$resMinuteShortcut';
  } else {
    return resNowShortcut;
  }
}

getAllMessages(context) async {
  var response = await http.get(
    Uri.parse('$serverURI/API/Mobile/GetAllMessages'),
    headers: httpHeader(),
  );
  // Navigator.pop(context);
  if (response.statusCode == 200) {
    var map = jsonDecode(response.body) as Map<String, dynamic>;
    var msgs = map['messages'];
    msgs?.forEach((element) {
      messages.add(Message.fromMap(element));
    });
  }
  handleResponseError(context, response);
}

String fixText(String text) {
  try {
    return utf8.decode(text.codeUnits);
  } catch (e) {
    return text;
  }
}

Future<void> initToken() async {
  await initSharedPreferences();
  var pref = getToken();
  token = pref?.Token;
  username = pref?.Owner;
}

var rtlRegex = RegExp(r'[\u0591-\u07FF]');
bool isRtl(String text) {
  return rtlRegex.hasMatch(text);
}

int timeInterval = 35;
int mainColor = 0xFF2196F3;
bool signalRConnectionNotifications = true;
bool resendFailedStatusNotifications = true;
bool chatsNotifications = true;

Future<void> loadSettings() async {
  mainColor = await getOrSet('color', mainColor);
  timeInterval = await getOrSet('timeInterval', timeInterval);
  signalRConnectionNotifications = await getOrSet('signalrnotifications', true);
  resendFailedStatusNotifications = await getOrSet('resendnotifications', true);
  chatsNotifications = await getOrSet('chatsnotifications', true);
}

Future<dynamic> getOrSet(String key, defaultValue) async {
  var res = prefs.get(key);
  if (res == null) {
    await prefs.set(key, defaultValue);
    res = getOrSet(key, defaultValue);
  }
  return res;
}

extension SharedPreferencesExt on SharedPreferences {
  Future<bool> set(String key, value) async {
    await initSharedPreferences();
    if (value is String) {
      return await prefs.setString(key, value);
    } else if (value is int) {
      return await prefs.setInt(key, value);
    } else if (value is double) {
      return await prefs.setDouble(key, value);
    } else if (value is bool) {
      return await prefs.setBool(key, value);
    } else if (value is List<String>) {
      return await prefs.setStringList(key, value);
    }
    return false;
  }
}

extension ColorsExt on Color {
  MaterialColor toMaterialColor() {
    final int red = this.red;
    final int green = this.green;
    final int blue = this.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(value, shades);
  }
}

Color appColor() => Color(mainColor);
