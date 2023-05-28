import "dart:convert";

import "package:protofood/config/constants.dart";
import "package:http/http.dart" as http;

class DataplaneService {
  static Future<void> addNewUser(String firstName, String lastName,
      String gender, String contact, String email) async {
    Map data = {
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "contact": contact,
      "email": email
    };

    var body = jsonEncode(data);
    var endpoint = Uri.parse(getAddUserApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Add User response status is : ${response.statusCode}");
  }

  static Future<void> addNewLocation(
      String buildingName,
      String roomNumber,
      String latitude,
      String longitude,
      String landmark,
      String shortName,
      String userId) async {
    Map data = {
      "buildingName": buildingName,
      "roomNumber": roomNumber,
      "latitude": latitude,
      "longitude": longitude,
      "landmark": landmark,
      "shortName": shortName,
      "userId": userId
    };

    var body = jsonEncode(data);
    var endpoint = Uri.parse(getAddNewLocationApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Add Location response status is : ${response.statusCode}");
  }

  static String getAddNewLocationApiEndpoint() {
    return "$baseUrl/addLocation";
  }

  static String getAddUserApiEndpoint() {
    return "$baseUrl/user";
  }
}
