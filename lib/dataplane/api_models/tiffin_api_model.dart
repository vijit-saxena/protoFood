class TiffinApiDataModel {
  final String tiffinId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String subscriptionId;
  final String locationId;
  final String meal;
  final DateTime timeCreated;
  final DateTime timeUpdated;
  final List<String> extras;
  final List<String> skips;
  final String paymentId;
  final int amountInRs;
  final String action;
  final String status;

  TiffinApiDataModel({
    required this.tiffinId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.subscriptionId,
    required this.locationId,
    required this.meal,
    required this.timeCreated,
    required this.timeUpdated,
    required this.extras,
    required this.skips,
    required this.paymentId,
    required this.amountInRs,
    required this.action,
    required this.status,
  });

  factory TiffinApiDataModel.fromJson(Map<String, dynamic> json) {
    return TiffinApiDataModel(
      tiffinId: json["tiffinId"],
      userId: json["userId"],
      startDate: DateTime.parse(json["startDate"]),
      endDate: DateTime.parse(json["endDate"]),
      subscriptionId: json["subscriptionId"],
      locationId: json["locationId"],
      meal: json["meal"],
      timeCreated: DateTime.parse(json["timeCreated"]),
      timeUpdated: DateTime.parse(json["timeUpdated"]),
      extras: List<String>.from(json["extras"]),
      skips: List<String>.from(json["skips"]),
      paymentId: json["paymentId"],
      amountInRs: json["amountInRs"],
      action: json["action"],
      status: json["status"],
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
      "timeCreated": timeCreated.toString(),
      "timeUpdated": timeUpdated.toString(),
      "extras": extras,
      "skips": skips,
      "paymentId": paymentId,
      "amountInRs": amountInRs,
      "action": action,
      "status": status
    };
  }
}
