class LoginVM {
  final String ClientVersion;
  final String AndroidId;
  final String SecureCode;

  LoginVM(this.ClientVersion, this.AndroidId, this.SecureCode);

  Map<String, String> toJson() => {
        'ClientVersion': ClientVersion,
        'AndroidId': AndroidId,
        'SecureCode': SecureCode
      };
}
