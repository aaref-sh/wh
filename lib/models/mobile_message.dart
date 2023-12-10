import '../all.dart';

class MobileMessage {
  DateTime sendTime;
  String? message;
  GeoLocation location;
  States status;

  MobileMessage(this.sendTime, this.message, this.location, this.status);

  Map<String, dynamic> toJson() {
    return {
      "SendDate": sendTime.toIso8601String(),
      "Message": message,
      "Location": location.toJson(),
      "Status": status.index
    };
  }

  static MobileMessage fromMap(Map<String, dynamic> m) {
    return MobileMessage(
      DateTime.parse(m['SendDate']),
      m['Message'],
      GeoLocation.fromMap2(m['Location']),
      States.values[m['Status']],
    );
  }
}
