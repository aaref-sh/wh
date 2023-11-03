import '../all.dart';

class AdminMessage {
  final int id;
  final DateTime sendTime;
  final String text;
  final GeoLocation location;
  final String sender;

  AdminMessage(this.id, this.sendTime, this.text, this.location, this.sender);

  static AdminMessage fromMap(Map<String, dynamic> m) {
    return AdminMessage(
      m['id'],
      DateTime.parse(m['sendTime']),
      m['text'],
      GeoLocation.fromMap(m['location']),
      m['sender'],
    );
  }
}
