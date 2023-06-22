class ExtraTiffinDataModel {
  final String extraId;
  final String userId;
  final String tiffinId;
  final DateTime date;
  final String meal;
  final int quantity;
  final String paymentId;
  final DateTime timeCreated;

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
        date: DateTime.parse(json["date"]),
        meal: json["meal"],
        quantity: json["quantity"],
        paymentId: json["paymentId"],
        timeCreated: DateTime.parse(json["timeCreated"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "extraId": extraId,
      "userId": userId,
      "tiffinId": tiffinId,
      "date": date.toString(),
      "meal": meal,
      "quantity": quantity,
      "paymentId": paymentId,
      "timeCreated": timeCreated.toString(),
    };
  }
}
