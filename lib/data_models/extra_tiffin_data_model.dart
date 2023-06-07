class ExtraTiffinDataModel {
  final String extraId;
  final String userId;
  final String tiffinId;
  final String date;
  final String meal;
  final int quantity;
  final String paymentId;
  final String timeCreated;

  ExtraTiffinDataModel({
    required this.extraId,
    required this.userId,
    required this.tiffinId,
    required this.date,
    required this.meal,
    required this.quantity,
    required this.paymentId,
    required this.timeCreated,
  });

  factory ExtraTiffinDataModel.fromJson(Map<String, dynamic> json) {
    return ExtraTiffinDataModel(
        extraId: json["extraId"],
        userId: json["userId"],
        tiffinId: json["tiffinId"],
        date: json["date"],
        meal: json["meal"],
        quantity: json["quantity"],
        paymentId: json["paymentId"],
        timeCreated: json["timeCreated"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "extraId": extraId,
      "userId": userId,
      "tiffinId": tiffinId,
      "date": date,
      "meal": meal,
      "quantity": quantity,
      "paymentId": paymentId,
      "timeCreated": timeCreated,
    };
  }
}
