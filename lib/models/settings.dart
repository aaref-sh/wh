class Settings {
  int mainColor;
  bool signalRConnectionNotifications;
  bool resendFailedStatusNotifications;
  bool chatsNotifications;

  Settings(this.mainColor, this.signalRConnectionNotifications,
      this.resendFailedStatusNotifications, this.chatsNotifications);

  static Settings empty() {
    return Settings(0xFF2196F3, true, true, true);
  }

  Map<String, dynamic> toJson() => {
        'mainColor': mainColor,
        'signalRConnectionNotifications': signalRConnectionNotifications,
        'chatsNotifications': chatsNotifications,
        'resendFailedStatusNotifications': resendFailedStatusNotifications,
      };

  static Settings fromMap(Map<String, dynamic> m) {
    return Settings(
      m['mainColor'],
      m['signalRConnectionNotifications'],
      m['chatsNotifications'],
      m['resendFailedStatusNotifications'],
    );
  }
}
