import 'package:wh/all.dart';

const String hub = 'messageHub';
// String serverURI = 'https://salama.somee.com';
String serverURI = 'https://salama2.bsite.net';
// String serverURI = 'http://10.0.2.2:5000';

String deviceId = "Unknown";
String? token;
String? username;
Position? lastLocation;

int pageIndex = 0;

List<Message> messages = [];
bool morePages = true;

const chatPageSize = 100;
const messagesPageSize = 20;
const mainIsolate = "mainIsolate";
const signalRTask = "signalRTask";
const backgroundIsolate = "backgroundIsolate";

const seperator = "\$#\$";
const mapSmoothRate = 30;
const mapDefaultZoom = 16;

int timeInterval = 35;
int mainColor = 0xFF2196F3;
bool signalRConnectionNotifications = true;
bool resendFailedStatusNotifications = true;
bool chatsNotifications = true;
const pendingMessagesKey = 'pendingMessages';
const notificationId = 888;
