import "dart:convert";

import "package:protofood/config/constants.dart";
import "package:http/http.dart" as http;
import "package:protofood/data_models/location_data_model.dart";
import "package:protofood/data_models/payment_data_model.dart";
import "package:protofood/data_models/subscription_data_model.dart";
import "package:protofood/data_models/taste_tiffin_data_model.dart";
import "package:protofood/data_models/tiffin_data_model.dart";

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
    var endpoint = Uri.parse(_getAddUserApiEndpoint());

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
    var endpoint = Uri.parse(_getAddNewLocationApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Add Location response status is : ${response.statusCode}");
  }

  // todo : This should actually be listAllActiveSubscriptions, so only subscriptions
  // falling b/w current date are displayed.
  static Future<void> listAllSubscriptions() async {
    var endpoint = Uri.parse(_getListAllSubscriptionsApiEndpoint());

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );
    print("All Subscriptions Response body is : ${response.body}");
  }

  static Future<List<SubscriptionDataModel>> listActiveSubscriptions() async {
    var endpoint = Uri.parse(_getListActiveSubscriptionsApiEndpoint());

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    List<dynamic> jsonList = jsonDecode(response.body);
    List<SubscriptionDataModel> subscriptions = [];

    for (var json in jsonList) {
      subscriptions.add(SubscriptionDataModel.fromJson(json));
    }
    return subscriptions;
  }

  static Future<LocationDataModel> getUserClosestLocation(
      String latitude, String longitude, String userPhoneNumber) async {
    var endpoint = Uri.parse(_getClosestUserLocationApiEndpoint(
        latitude, longitude, userPhoneNumber));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );
    var location = jsonDecode(response.body);

    print(location);

    return LocationDataModel.fromJson(location);
  }

  static Future<void> recordNewPayment(PaymentDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddNewPaymentApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Record Payment response status is : ${response.statusCode}");
  }

  static Future<void> addNewTasteTiffinRecord(
      TasteTiffinDataModel tasteModel) async {
    var body = json.encode(tasteModel.toJson());
    var endpoint = Uri.parse(_getAddTasteTiffinRecordApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Added Taste Tiffin response status is : ${response.statusCode}");
  }

  static Future<void> createTiffinRecord(TiffinDataModel tiffinModel) async {
    var body = json.encode(tiffinModel.toJson());
    var endpoint = Uri.parse(_getAddTiffinRecordApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Added Tiffin response status is : ${response.statusCode}");
  }

  static String _getAddTiffinRecordApiEndpoint() {
    return "$baseUrl/addTiffinRecord";
  }

  static String _getAddTasteTiffinRecordApiEndpoint() {
    return "$baseUrl/addTasteTiffinRecord";
  }

  static String _getAddNewPaymentApiEndpoint() {
    return "$baseUrl/recordNewPayment";
  }

  static String _getClosestUserLocationApiEndpoint(
      String latitude, String longitude, String userPhoneNumber) {
    // http://localhost:8080/protofood/v1/fetchUserClosestLocation?latitude=22&longitude=33&userPhoneNumber=+919799236336
    return "$baseUrl/fetchUserClosestLocation?latitude=$latitude&longitude=$longitude&userPhoneNumber=$userPhoneNumber";
  }

  static String _getListActiveSubscriptionsApiEndpoint() {
    return "$baseUrl/listActiveSubscriptions";
  }

  static String _getListAllSubscriptionsApiEndpoint() {
    return "$baseUrl/listAllSubscriptions";
  }

  static String _getAddNewLocationApiEndpoint() {
    return "$baseUrl/addLocation";
  }

  static String _getAddUserApiEndpoint() {
    return "$baseUrl/user";
  }
}
