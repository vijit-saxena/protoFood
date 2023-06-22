class UserDataModel {
  String userId;
  String firstName;
  String lastName;
  String gender;
  String contact;
  String email;

  UserDataModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.contact,
    required this.email,
  });

  factory UserDataModel.fromMap(Map userMap) {
    return UserDataModel(
      userId: userMap["userId"],
      firstName: userMap["firstName"],
      lastName: userMap["lastName"],
      gender: userMap["gender"],
      contact: userMap["contact"],
      email: userMap["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "contact": contact,
      "email": email,
    };
  }
}
