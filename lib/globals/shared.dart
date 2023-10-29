import 'package:http/http.dart';

import '../all.dart';

handleResponseError(BuildContext context, Response response) {
  var message = resErrorHappend;
  switch (response.statusCode) {
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
