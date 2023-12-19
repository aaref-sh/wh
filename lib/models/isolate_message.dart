class IsolateMessage {
  final int message;
  final dynamic data;

  IsolateMessage(this.message, this.data);

  Map<String, dynamic> toJson() => {'message': message, 'data': data};

  static IsolateMessage fromMap(Map<String, dynamic> m) {
    return IsolateMessage(m['message'], m['data']);
  }
}
