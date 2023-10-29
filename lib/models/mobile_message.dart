import '../all.dart';

class MobileMessage {
  DateTime sendTime;
  String? message;
  GeoLocation location;
  States status;

  MobileMessage(this.sendTime, this.message, this.location, this.status);

  Map<String, dynamic> toJson() {
    return {
      "SendTime": sendTime.toString(),
      "Message": message,
      "Location": location,
      "Status": status.index
    };
  }
}
