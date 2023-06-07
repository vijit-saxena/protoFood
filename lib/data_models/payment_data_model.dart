class PaymentDataModel {
  final String paymentId;
  final String userId;
  final String amountInRs;
  final String orderId;
  final String action;
  final String timeCreated;
  final String status;

  PaymentDataModel({
    required this.userId,
    required this.paymentId,
    required this.amountInRs,
    required this.orderId,
    required this.action,
    required this.timeCreated,
    required this.status,
  });

  factory PaymentDataModel.fromJson(Map<String, dynamic> json) {
    return PaymentDataModel(
      paymentId: json['paymentId'],
      userId: json['userId'],
      amountInRs: json['amountInRs'],
      orderId: json['orderId'],
      action: json['action'],
      timeCreated: json['timeCreated'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'userId': userId,
      'amountInRs': amountInRs,
      'orderId': orderId,
      'action': action,
      'timeCreated': timeCreated,
      'status': status,
    };
  }
}
