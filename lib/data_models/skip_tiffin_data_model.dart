class SkipTiffinDataModel {
  final String skipId;
  final String userId;
  final String tiffinId;
  final DateTime date;
  final String meal;
  final DateTime timeCreated;

  SkipTiffinDataModel({
    required this.skipId,
    required this.userId,
    required this.tiffinId,
    required this.date,
    required this.meal,
    required this.timeCreated,
  });

  factory SkipTiffinDataModel.fromJson(Map<String, dynamic> json) {
    return SkipTiffinDataModel(
        skipId: json["skipId"],
        userId: json["userId"],
        tiffinId: json["tiffinId"],
        date: DateTime.parse(json["date"]),
        meal: json["meal"],
        timeCreated: DateTime.parse(json["timeCreated"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "skipId": skipId,
      "userId": userId,
      "tiffinId": tiffinId,
      "date": date.toString(),
      "meal": meal,
      "timeCreated": timeCreated.toString(),
    };
  }
}
