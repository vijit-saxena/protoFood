import 'package:protofood/config/constants.dart';

class SubscriptionDataModel {
  final String subscriptionId;
  final double discountInPercent;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int durationInDays;
  final DateTime timeCreated;
  final DateTime timeUpdated;
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
      startDateTime: DateTime.parse(json['startDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      durationInDays: json['durationInDays'],
      timeCreated: DateTime.parse(json['timeCreated']),
      timeUpdated: DateTime.parse(json['timeUpdated']),
      mealType: json['mealType'],
    );
  }
}
