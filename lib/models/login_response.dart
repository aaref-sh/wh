class LoginResponse {
  final String Owner;
  final String Token;

  LoginResponse(this.Owner, this.Token);

  static LoginResponse fromMap(Map<String, dynamic> m) =>
      LoginResponse(m['owner']!, m['token']!);
}
