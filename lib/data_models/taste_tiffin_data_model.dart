class TasteTiffinDataModel {
  final String orderId;
  final String userId;
  final DateTime date;
  final String meal;
  final String quantity;
  final String paymentId;
  final String locationId;
  final DateTime timeCreated;

  TasteTiffinDataModel({
    required this.orderId,
    required this.userId,
    required this.date,
    required this.meal,
    required this.quantity,
    required this.paymentId,
    required this.locationId,
    required this.timeCreated,
  });

  factory TasteTiffinDataModel.fromJson(Map<String, dynamic> json) {
    return TasteTiffinDataModel(
      orderId: json["orderId"],
      userId: json["userId"],
      date: DateTime.parse(json["date"]),
      meal: json["meal"],
      quantity: json["quantity"],
      paymentId: json["paymentId"],
      locationId: json["locationId"],
      timeCreated: DateTime.parse(json["timeCreated"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "userId": userId,
      "date": date.toString(),
      "meal": meal,
      "quantity": quantity,
      "paymentId": paymentId,
      "locationId": locationId,
      "timeCreated": timeCreated.toString(),
    };
  }
}
