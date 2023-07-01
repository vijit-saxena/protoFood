import "dart:convert";

import "package:protofood/config/constants.dart";
import "package:http/http.dart" as http;
import "package:protofood/data_models/consolidated_order_data_model.dart";
import "package:protofood/data_models/daily_tiffin_model.dart";
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
  Future<bool> addNewUser(UserDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddUserApiEndpoint());

    await http.post(endpoint, headers: baseHeaders, body: body).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  Future<TiffinDataModel?> getUserActiveTiffin(String userPhoneNumber, String dateTime) async {
    var endpoint = Uri.parse(_getFetchUserActiveTiffinApiEndpoint(userPhoneNumber, dateTime));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    return response.statusCode == 200 ? TiffinDataModel.fromJson(json.decode(response.body)) : null;
  }

  Future<TiffinDataModel?> getUserFutureTiffin(String userPhoneNumber, String dateTime) async {
    var endpoint = Uri.parse(_getFetchUserFutureTiffinApiEndpoint(userPhoneNumber, dateTime));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    return response.statusCode == 200 ? TiffinDataModel.fromJson(json.decode(response.body)) : null;
  }

  Future<UserDataModel?> getUserWithPhoneNumber(String userPhoneNumber) async {
    var endpoint = Uri.parse(_getFetchUserApiEndpoint(userPhoneNumber));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    return response.statusCode == 200 ? UserDataModel.fromMap(json.decode(response.body)) : null;
  }

  Future<bool> addNewLocation(LocationDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddNewLocationApiEndpoint());

    await http.post(endpoint, headers: baseHeaders, body: body).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  Future<List<LocationDataModel>> getUserAllLocations(String userPhoneNumber) async {
    var endpoint = Uri.parse(_getUserAllLocationsApiEndpoint(userPhoneNumber));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    List<dynamic> jsonList = json.decode(response.body);

    List<LocationDataModel> userAllLocations = [];

    for (var json in jsonList) {
      userAllLocations.add(LocationDataModel.fromJson(json));
    }

    return userAllLocations;
  }

  Future<void> listAllSubscriptions() async {
    var endpoint = Uri.parse(_getListAllSubscriptionsApiEndpoint());

    await http.get(
      endpoint,
      headers: baseHeaders,
    );
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

  Future<LocationDataModel?> getUserClosestLocation(
      String latitude, String longitude, String userPhoneNumber) async {
    var endpoint = Uri.parse(_getClosestUserLocationApiEndpoint(
      latitude,
      longitude,
      userPhoneNumber,
    ));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    if (response.statusCode != 200) {
      return null;
    }

    var location = jsonDecode(response.body);
    return LocationDataModel.fromJson(location);
  }

  Future<bool> recordNewPayment(PaymentDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddNewPaymentApiEndpoint());

    await http.post(endpoint, headers: baseHeaders, body: body).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  Future<bool> addNewTasteTiffinRecord(TasteTiffinDataModel tasteModel) async {
    var body = json.encode(tasteModel.toJson());
    var endpoint = Uri.parse(_getAddTasteTiffinRecordApiEndpoint());

    await http.post(endpoint, headers: baseHeaders, body: body).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  Future<bool> createTiffinRecord(TiffinDataModel tiffinModel) async {
    var body = json.encode(tiffinModel.toJson());
    var endpoint = Uri.parse(_getAddTiffinRecordApiEndpoint());

    await http.post(endpoint, headers: baseHeaders, body: body).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  Future<TiffinDataModel?> getTiffinInfo(String tiffinId) async {
    var endpoint = Uri.parse(__getTiffinInfoApiEndpoint(tiffinId));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    return response.statusCode == 200 ? TiffinDataModel.fromJson(json.decode(response.body)) : null;
  }

  Future<bool> addNewExtraTiffinRecord(ExtraTiffinDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddExtraTiffinRecordApiEndpoint());

    await http.post(endpoint, headers: baseHeaders, body: body).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  Future<bool> addNewSkipTiffinRecord(SkipTiffinDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddSkipTiffinRecordApiEndpoint());

    await http.post(endpoint, headers: baseHeaders, body: body).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  Future<bool> addNewOrderRecord(OrderDataModel model) async {
    var body = json.encode(model.toJson());
    var endpoint = Uri.parse(_getAddNewOrderRecordApiEndpoint());

    await http.post(endpoint, headers: baseHeaders, body: body).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    return false;
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
        consolidatedOrder.setTaste(json['taste']);
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

  Future<List<DailyTiffinModel>> generateDailyTiffinData(String date, String meal) async {
    var endpoint = Uri.parse(_getGenerateDailyTiffinDataApiEndpoint(date, meal));

    http.Response response = await http.get(
      endpoint,
      headers: baseHeaders,
    );

    List<dynamic> jsonList = json.decode(response.body);
    List<DailyTiffinModel> dailyTiffinModelList = [];

    for (var json in jsonList) {
      dailyTiffinModelList.add(DailyTiffinModel.fromJson(json));
    }

    return dailyTiffinModelList;
  }

  String _getGenerateDailyTiffinDataApiEndpoint(String date, String meal) {
    return "$baseUrl/generateDailyTiffinReport?date=$date&meal=$meal";
  }

  String _getUserAllLocationsApiEndpoint(String userPhoneNumber) {
    return "$baseUrl/fetchUserAllLocations/$userPhoneNumber";
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

  String _getFetchUserActiveTiffinApiEndpoint(String userPhoneNumber, String dateTime) {
    return "$baseUrl/getUserActiveTiffin?userPhoneNumber=$userPhoneNumber&dateTime=$dateTime";
  }

  String _getFetchUserFutureTiffinApiEndpoint(String userPhoneNumber, String dateTime) {
    return "$baseUrl/getUserFutureTiffin?userPhoneNumber=$userPhoneNumber&dateTime=$dateTime";
  }
}
