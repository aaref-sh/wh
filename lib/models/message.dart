import 'package:wh/all.dart';

class Message {
  String sender;
  String message;
  DateTime sendTime;
  Message(this.sender, this.message, this.sendTime);

  static Message fromMap(Map<String, dynamic> m) => Message(
      fixText(m['sender']),
      fixText(m['message']),
      DateTime.parse(m['sendTime']));

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'message': message,
        'sendTime': sendTime.toIso8601String()
      };
}
