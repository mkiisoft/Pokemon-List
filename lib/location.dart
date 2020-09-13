class Location {
  final String countryName;
  final String countryCode;
  final String city;
  final double latitude;
  final double longitude;

  Location._(this.countryName, this.countryCode, this.city, this.latitude,
      this.longitude);

  factory Location.fromJson(Map<String, dynamic> json) => Location._(
        json['country_name'],
        json['country_code'],
        json['city'],
        json['latitude'],
        json['longitude'],
      );
}
