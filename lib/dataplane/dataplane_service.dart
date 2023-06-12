import "dart:convert";

import "package:protofood/config/constants.dart";
import "package:http/http.dart" as http;
import "package:protofood/data_models/consolidated_order_data_model.dart";
import "package:protofood/data_models/extra_tiffin_data_model.dart";
import "package:protofood/data_models/location_data_model.dart";
import "package:protofood/data_models/order_data_model.dart";
import "package:protofood/data_models/payment_data_model.dart";
import "package:protofood/data_models/skip_tiffin_data_model.dart";
import "package:protofood/data_models/subscription_data_model.dart";
import "package:protofood/data_models/taste_tiffin_data_model.dart";
import "package:protofood/data_models/tiffin_data_model.dart";
import "package:protofood/data_models/user_data_model.dart";

class DataplaneService {
  Future<void> addNewUser(UserDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddUserApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Add User response status is : ${response.statusCode}");
  }

  Future<String> getUserActiveTiffinId(String userPhoneNumber) async {
    var endpoint = Uri.parse(_getFetchUserActiveTiffinApiEndpoint(userPhoneNumber));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    print("User-Tiffin-Id response status is : ${response.statusCode}");
    return response.body;
  }

  Future<UserDataModel?> getUserWithPhoneNumber(String userPhoneNumber) async {
    var endpoint = Uri.parse(_getFetchUserApiEndpoint(userPhoneNumber));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );
    print("Fetch User response body is : ${response.body}");

    return UserDataModel.fromMap(json.decode(response.body));
  }

  Future<void> addNewLocation(LocationDataModel model) async {
    var body = json.encode(model.toJson());
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
  Future<void> listAllSubscriptions() async {
    var endpoint = Uri.parse(_getListAllSubscriptionsApiEndpoint());

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );
    print("All Subscriptions Response body is : ${response.body}");
  }

  Future<List<SubscriptionDataModel>> listActiveSubscriptions() async {
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

  Future<LocationDataModel> getUserClosestLocation(
      String latitude, String longitude, String userPhoneNumber) async {
    var endpoint =
        Uri.parse(_getClosestUserLocationApiEndpoint(latitude, longitude, userPhoneNumber));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );
    var location = jsonDecode(response.body);

    print(location);

    return LocationDataModel.fromJson(location);
  }

  Future<void> recordNewPayment(PaymentDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddNewPaymentApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Record Payment response status is : ${response.statusCode}");
  }

  Future<void> addNewTasteTiffinRecord(TasteTiffinDataModel tasteModel) async {
    var body = json.encode(tasteModel.toJson());
    var endpoint = Uri.parse(_getAddTasteTiffinRecordApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Added Taste Tiffin response status is : ${response.statusCode}");
  }

  Future<void> createTiffinRecord(TiffinDataModel tiffinModel) async {
    var body = json.encode(tiffinModel.toJson());
    var endpoint = Uri.parse(_getAddTiffinRecordApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Added Tiffin response status is : ${response.statusCode}");
  }

  Future<TiffinDataModel> getTiffinInfo(String tiffinId) async {
    var endpoint = Uri.parse(__getTiffinInfoApiEndpoint(tiffinId));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    return TiffinDataModel.fromJson(json.decode(response.body));
  }

  Future<void> addNewExtraTiffinRecord(ExtraTiffinDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddExtraTiffinRecordApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Added Extra-Tiffin response status is : ${response.statusCode}");
  }

  Future<void> addNewSkipTiffinRecord(SkipTiffinDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddSkipTiffinRecordApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Added Skip-Tiffin response status is : ${response.statusCode}");
  }

  Future<void> addNewOrderRecord(OrderDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddSkipTiffinRecordApiEndpoint());

    http.Response response = await http.post(
      endpoint,
      headers: baseHeaders,
      body: body,
    );

    print("Added order details to Order collection : ${model.orderId}");
  }

  Future<List<ConsolidatedOrder>> getUserAllConsolidatedOrders(
      String userPhoneNumber, int pageNumber) async {
    List<ConsolidatedOrder> listConsolidatedOrder = [];
    var endpoint = Uri.parse(_getUserConsolidatedOrders(userPhoneNumber, pageNumber));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    var jsonResponse = json.decode(response.body);
    for (var json in jsonResponse) {
      ConsolidatedOrder consolidatedOrder = ConsolidatedOrder.fromJson(json);
      if (json['taste'] != null) {
        consolidatedOrder.setTaste(json['skip']);
      } else if (json['tiffin'] != null) {
        consolidatedOrder.setTiffin(json['tiffin']);
      } else if (json['extra'] != null) {
        consolidatedOrder.setExtra(json['extra']);
      } else if (json['skip'] != null) {
        consolidatedOrder.setSkip(json['skip']);
      }

      if (json['payment'] != null) {
        consolidatedOrder.setPayment(json['payment']);
      }

      listConsolidatedOrder.add(consolidatedOrder);
    }

    return listConsolidatedOrder;
  }

  String _getUserConsolidatedOrders(String userPhoneNumber, int pageNumber) {
    return "$baseUrl/getUserAllOrders/$userPhoneNumber?pageNumber=$pageNumber";
  }

  String _getAddNewOrderRecordApiEndpoint() {
    return "$baseUrl/addNewOrderRecord";
  }

  String __getTiffinInfoApiEndpoint(String tiffinId) {
    return "$baseUrl/getTiffinInfo?tiffinId=$tiffinId";
  }

  String _getAddSkipTiffinRecordApiEndpoint() {
    return "$baseUrl/addSkipTiffinRecord";
  }

  String _getAddExtraTiffinRecordApiEndpoint() {
    return "$baseUrl/addExtraTiffinRecord";
  }

  String _getAddTiffinRecordApiEndpoint() {
    return "$baseUrl/addTiffinRecord";
  }

  String _getAddTasteTiffinRecordApiEndpoint() {
    return "$baseUrl/addTasteTiffinRecord";
  }

  String _getAddNewPaymentApiEndpoint() {
    return "$baseUrl/recordNewPayment";
  }

  String _getClosestUserLocationApiEndpoint(
      String latitude, String longitude, String userPhoneNumber) {
    // http://localhost:8080/protofood/v1/fetchUserClosestLocation?latitude=22&longitude=33&userPhoneNumber=+919799236336
    return "$baseUrl/fetchUserClosestLocation?latitude=$latitude&longitude=$longitude&userPhoneNumber=$userPhoneNumber";
  }

  String _getListActiveSubscriptionsApiEndpoint() {
    return "$baseUrl/listActiveSubscriptions";
  }

  String _getListAllSubscriptionsApiEndpoint() {
    return "$baseUrl/listAllSubscriptions";
  }

  String _getAddNewLocationApiEndpoint() {
    return "$baseUrl/addLocation";
  }

  String _getAddUserApiEndpoint() {
    return "$baseUrl/user";
  }

  String _getFetchUserApiEndpoint(String userPhoneNumber) {
    return "$baseUrl/getUser?userPhoneNumber=$userPhoneNumber";
  }

  String _getFetchUserActiveTiffinApiEndpoint(String userPhoneNumber) {
    return "$baseUrl/getUserActiveTiffin?userPhoneNumber=$userPhoneNumber";
  }
}
