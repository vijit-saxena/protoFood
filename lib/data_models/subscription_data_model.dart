class SubscriptionDataModel {
  final String subscriptionId;
  final double discountInPercent;
  final String startDateTime;
  final String endDateTime;
  final int durationInDays;
  final String timeCreated;
  final String timeUpdated;
  final String mealType;

  SubscriptionDataModel({
    required this.subscriptionId,
    required this.discountInPercent,
    required this.startDateTime,
    required this.endDateTime,
    required this.durationInDays,
    required this.timeCreated,
    required this.timeUpdated,
    required this.mealType,
  });

  factory SubscriptionDataModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionDataModel(
      subscriptionId: json['subscriptionId'],
      discountInPercent: json['discountInPercent'],
      startDateTime: json['startDateTime'],
      endDateTime: json['endDateTime'],
      durationInDays: json['durationInDays'],
      timeCreated: json['timeCreated'],
      timeUpdated: json['timeUpdated'],
      mealType: json['mealType'],
    );
  }
}
