class TiffinDataModel {
  final String tiffinId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String subscriptionId;
  final String locationId;
  final String meal;
  final String paymentId;
  final DateTime timeCreated;
  final DateTime timeUpdated;
  final List<String> extras;
  final List<String> skips;

  TiffinDataModel({
    required this.tiffinId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.subscriptionId,
    required this.locationId,
    required this.meal,
    required this.paymentId,
    required this.timeCreated,
    required this.timeUpdated,
    required this.extras,
    required this.skips,
  });

  factory TiffinDataModel.fromJson(Map<String, dynamic> json) {
    return TiffinDataModel(
      tiffinId: json["tiffinId"],
      userId: json["userId"],
      startDate: DateTime.parse(json["startDate"]),
      endDate: DateTime.parse(json["endDate"]),
      subscriptionId: json["subscriptionId"],
      locationId: json["locationId"],
      meal: json["meal"],
      paymentId: json["paymentId"],
      timeCreated: DateTime.parse(json["timeCreated"]),
      timeUpdated: DateTime.parse(json["timeUpdated"]),
      extras: List<String>.from(json["extras"]),
      skips: List<String>.from(json["skips"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tiffinId": tiffinId,
      "userId": userId,
      "startDate": startDate.toString(),
      "endDate": endDate.toString(),
      "subscriptionId": subscriptionId,
      "locationId": locationId,
      "meal": meal,
      "paymentId": paymentId,
      "timeCreated": timeCreated.toString(),
      "timeUpdated": timeUpdated.toString(),
      "extras": extras,
      "skips": skips
    };
  }
}
