class Message {
  String sender;
  String text;
  DateTime time;
  Message(this.sender, this.text, this.time);

  static fromMap(Map<String, dynamic> m) =>
      Message(m['sender'], m['message'], DateTime.parse(m['sendTime']));
}
