class TasteTiffinApiModel {
  final String tasteId;
  final String userId;
  final DateTime date;
  final String meal;
  final int quantity;
  final String locationId;
  final DateTime timeCreated;
  // Payments Section
  final String paymentId;
  final int amountInRs;
  final String action;
  final String status;

  TasteTiffinApiModel({
    required this.tasteId,
    required this.userId,
    required this.date,
    required this.meal,
    required this.quantity,
    required this.locationId,
    required this.timeCreated,
    required this.paymentId,
    required this.amountInRs,
    required this.action,
    required this.status,
  });

  factory TasteTiffinApiModel.fromJson(Map<String, dynamic> json) {
    return TasteTiffinApiModel(
      tasteId: json["tasteId"],
      userId: json["userId"],
      date: DateTime.parse(json["date"]),
      meal: json["meal"],
      quantity: json["quantity"],
      locationId: json["locationId"],
      timeCreated: DateTime.parse(json["timeCreated"]),
      paymentId: json["paymentId"],
      amountInRs: json["amountInRs"],
      action: json["action"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tasteId": tasteId,
      "userId": userId,
      "date": date.toString(),
      "meal": meal,
      "quantity": quantity,
      "locationId": locationId,
      "timeCreated": timeCreated.toString(),
      "paymentId": paymentId,
      "amountInRs": amountInRs,
      "action": action,
      "status": status,
    };
  }
}
