class TiffinDataModel {
  final String orderId;
  final String userId;
  final String startDate;
  final String endDate;
  final String subscriptionId;
  final String locationId;
  final String meal;
  final String paymentId;
  final String timeCreated;
  final String timeUpdated;
  final List<String> extras;
  final List<String> skips;

  TiffinDataModel({
    required this.orderId,
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
      orderId: json["orderId"],
      userId: json["userId"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      subscriptionId: json["subscriptionId"],
      locationId: json["locationId"],
      meal: json["meal"],
      paymentId: json["paymentId"],
      timeCreated: json["timeCreated"],
      timeUpdated: json["timeUpdated"],
      extras: json["extras"],
      skips: json["skips"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "userId": userId,
      "startDate": startDate,
      "endDate": endDate,
      "subscriptionId": subscriptionId,
      "locationId": locationId,
      "meal": meal,
      "paymentId": paymentId,
      "timeCreated": timeCreated,
      "timeUpdated": timeUpdated,
      "extras": extras,
      "skips": skips
    };
  }
}
