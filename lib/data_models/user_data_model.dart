class UserDataModel {
  String firstName;
  String lastName;
  String gender;
  String contact;
  String email;
  DateTime timeCreated;

  UserDataModel({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.contact,
    required this.email,
    required this.timeCreated,
  });

  factory UserDataModel.fromMap(Map userMap) {
    return UserDataModel(
      firstName: userMap["firstName"],
      lastName: userMap["lastName"],
      gender: userMap["gender"],
      contact: userMap["contact"],
      email: userMap["email"],
      timeCreated: DateTime.parse(userMap["timeCreated"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "contact": contact,
      "email": email,
      "timeCreated": timeCreated.toString(),
    };
  }
}
