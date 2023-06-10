class OrderDataModel {
  final String orderId;
  final String userPhoneNumber;
  final String timeCreated;

  OrderDataModel({
    required this.orderId,
    required this.userPhoneNumber,
    required this.timeCreated,
  });

  factory OrderDataModel.fromJson(Map<String, dynamic> json) {
    return OrderDataModel(
      orderId: json["orderId"],
      userPhoneNumber: json["userPhoneNumber"],
      timeCreated: json["timeCreated"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "userPhoneNumber": userPhoneNumber,
      "timeCreated": timeCreated,
    };
  }
}
