class GeoLocation {
  String? latitude;
  String? longitude;

  GeoLocation(this.latitude, this.longitude);

  Map<String, dynamic> toJson() =>
      {'Latitude': latitude, 'Longitude': longitude};

  static GeoLocation fromMap(Map<String, dynamic> m) {
    return GeoLocation(m['latitude'], m['longitude']);
  }
}
