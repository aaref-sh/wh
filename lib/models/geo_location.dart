class GeoLocation {
  String latitude;
  String longitude;

  GeoLocation(this.latitude, this.longitude);

  Map<String, dynamic> toJson() =>
      {'Latitude': latitude, 'Longitude': longitude};
}
