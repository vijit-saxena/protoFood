class SkipTiffinApiModel {
  final String skipId;
  final String userId;
  final DateTime date;
  final String meal; // ensure this value cannot be breakfast_lunch_dinner
  final String tiffinId;
  final DateTime timeCreated;

  SkipTiffinApiModel({
    required this.skipId,
    required this.userId,
    required this.date,
    required this.meal,
    required this.tiffinId,
    required this.timeCreated,
  });

  factory SkipTiffinApiModel.fromJson(Map<String, dynamic> json) {
    return SkipTiffinApiModel(
      skipId: json["skipId"],
      userId: json["userId"],
      date: DateTime.parse(json["date"]),
      meal: json["meal"],
      tiffinId: json["tiffinId"],
      timeCreated: DateTime.parse(json["timeCreated"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "skipId": skipId,
      "userId": userId,
      "date": date.toString(),
      "meal": meal,
      "tiffinId": tiffinId,
      "timeCreated": timeCreated.toString(),
    };
  }
}
