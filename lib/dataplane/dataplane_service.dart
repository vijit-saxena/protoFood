import "dart:convert";

import "package:protofood/config/constants.dart";
import "package:protofood/data_models/user_data_model";
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

    print("Response status is : ${response.statusCode}");
    // Map responseMap = jsonDecode(response.body);

    // print("response body is : $responseMap");

    // UserDataModel user = UserDataModel.fromMap(responseMap);
    // return user;
  }

  static String getAddUserApiEndpoint() {
    return "$baseUrl/user";
  }
}
