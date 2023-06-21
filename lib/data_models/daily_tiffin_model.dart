class DailyTiffinModel {
  final String userId;
  final String userName;
  final int quantity;
  final String address;
  final String latitude;
  final String longitude;
  final bool isTaste;

  DailyTiffinModel({
    required this.userId,
    required this.userName,
    required this.quantity,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isTaste,
  });

  factory DailyTiffinModel.fromJson(Map<String, dynamic> json) {
    return DailyTiffinModel(
      userId: json["userId"],
      userName: json["userName"],
      quantity: json["quantity"],
      address: json["address"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      isTaste: json["isTaste"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "quantity": quantity,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "isTaste": isTaste,
    };
  }
}
