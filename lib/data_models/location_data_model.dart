class LocationDataModel {
  final String locationId;
  final String buildingName;
  final String roomNumber;
  final String latitude;
  final String longitude;
  final String landmark;
  final String shortName;
  final String userId;

  LocationDataModel({
    required this.locationId,
    required this.buildingName,
    required this.roomNumber,
    required this.latitude,
    required this.longitude,
    required this.landmark,
    required this.shortName,
    required this.userId,
  });

  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    return LocationDataModel(
      locationId: json["locationId"],
      buildingName: json["buildingName"],
      roomNumber: json["roomNumber"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      landmark: json["landmark"],
      shortName: json["shortName"],
      userId: json["userId"],
    );
  }
}
