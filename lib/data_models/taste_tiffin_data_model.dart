class TasteTiffinDataModel {
  final String orderId;
  final String userId;
  final String date;
  final String meal;
  final String quantity;
  final String paymentId;
  final String locationId;
  final String timeCreated;

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
      date: json["date"],
      meal: json["meal"],
      quantity: json["quantity"],
      paymentId: json["paymentId"],
      locationId: json["locationId"],
      timeCreated: json["timeCreated"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "userId": userId,
      "date": date,
      "meal": meal,
      "quantity": quantity,
      "paymentId": paymentId,
      "locationId": locationId,
      "timeCreated": timeCreated,
    };
  }
}
