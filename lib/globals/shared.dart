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
