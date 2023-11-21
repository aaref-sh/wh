import 'package:wh/all.dart';

const String hub = 'messageHub';
String serverURI = 'https://salama.somee.com';
// String serverURI = 'https://salama.bsite.net';
// String serverURI = 'https://10.0.2.2:5000';

String? deviceId;
String? token;
String? username;
LocationData? lastLocation;

int pageIndex = 0;

List<Message> messages = [];
int page = 1;
bool morePages = true;

const chatPageSize = 100;
