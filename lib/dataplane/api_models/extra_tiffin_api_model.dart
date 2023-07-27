class ExtraTiffinApiModel {
  final String extraId;
  final String userId;
  final String tiffinId;
  final DateTime date;
  final String meal; //todo : ensure this value cannot be breakfast_lunch_dinner
  final int quantity;
  final DateTime timeCreated;
  // Payment Section
  final String paymentId;
  final int amountInRs;
  final String action;
  final String status;

  ExtraTiffinApiModel({
    required this.extraId,
    required this.userId,
    required this.tiffinId,
    required this.date,
    required this.meal,
    required this.quantity,
    required this.timeCreated,
    required this.paymentId,
    required this.amountInRs,
    required this.action,
    required this.status,
  });

  factory ExtraTiffinApiModel.fromJson(Map<String, dynamic> json) {
    return ExtraTiffinApiModel(
        extraId: json["extraId"],
        userId: json["userId"],
        tiffinId: json["tiffinId"],
        date: json["date"],
        meal: json["meal"],
        quantity: json["quantity"],
        timeCreated: json["timeCreated"],
        paymentId: json["paymentId"],
        amountInRs: json["amountInRs"],
        action: json["action"],
        status: json["status"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "extraId": extraId,
      "userId": userId,
      "tiffinId": tiffinId,
      "date": date.toString(),
      "meal": meal,
      "quantity": quantity,
      "timeCreated": timeCreated.toString(),
      "paymentId": paymentId,
      "amountInRs": amountInRs,
      "action": action,
      "status": status,
    };
  }
}
