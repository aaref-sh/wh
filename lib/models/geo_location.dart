class GeoLocation {
  String? latitude;
  String? longitude;

  GeoLocation(this.latitude, this.longitude);

  Map<String, dynamic> toJson() =>
      {'Latitude': latitude, 'Longitude': longitude};

  static GeoLocation fromMap(Map<String, dynamic> m) {
    return GeoLocation(m['latitude']?.toString(), m['longitude']?.toString());
  }

  static GeoLocation fromMap2(Map<String, dynamic> m) {
    return GeoLocation(m['Latitude']?.toString(), m['Longitude']?.toString());
  }
}
