import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/data_models/consolidated_order_data_model.dart';
import 'package:protofood/data_models/daily_tiffin_model.dart';
import 'package:protofood/data_models/extra_tiffin_data_model.dart';
import 'package:protofood/data_models/location_data_model.dart';
import 'package:protofood/data_models/order_data_model.dart';
import 'package:protofood/data_models/payment_data_model.dart';
import 'package:protofood/data_models/skip_tiffin_data_model.dart';
import 'package:protofood/data_models/subscription_data_model.dart';
import 'package:protofood/data_models/taste_tiffin_data_model.dart';
import 'package:protofood/data_models/tiffin_data_model.dart';
import 'package:protofood/data_models/user_data_model.dart';
import 'package:protofood/dataplane/api_models/taste_tiffin_api_model.dart';
import 'package:protofood/dataplane/api_models/extra_tiffin_api_model.dart';
import 'package:protofood/dataplane/api_models/skip_tiffin_api_model.dart';
import 'package:protofood/dataplane/api_models/tiffin_api_model.dart';
import 'package:protofood/dataplane/dataplane_service.dart';
import 'package:protofood/service/maps.dart';

class ManagementService {
  final DataplaneService _dataplaneService = DataplaneService();

  String? fetchUserPhoneNumber() {
    String? phoneNumber = AuthService.firebase().currentUser!.phoneNumber;

    return phoneNumber;
  }

  Future<UserDataModel?> getUserInfo(String userPhoneNumber) async {
    UserDataModel? userInfo = await _dataplaneService.getUserWithPhoneNumber(userPhoneNumber);

    return userInfo;
  }

  Future<bool> addNewUser(UserDataModel userModel) async {
    return await _dataplaneService.addNewUser(userModel);
  }

  Future<LatLng> getUserCurrentLocationLatLng() async {
    GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
    var currentLocation = await Maps.getCurrentPosition(geolocatorPlatform);

    return currentLocation;
  }

  Future<LocationDataModel?> loadClosestUserCurrentLocation(String userPhoneNumber) async {
    LatLng currentLatLng = await getUserCurrentLocationLatLng();

    LocationDataModel? currentLocation = await _dataplaneService.getUserClosestLocation(
        currentLatLng.latitude.toString(), currentLatLng.longitude.toString(), userPhoneNumber);

    return currentLocation;
  }

  Future<bool> addNewLocation(LocationDataModel locationModel) async {
    return await _dataplaneService.addNewLocation(locationModel);
  }

  Future<List<LocationDataModel>> getUserAllLocations(String userPhoneNumber) async {
    List<LocationDataModel> userAllLocations =
        await _dataplaneService.getUserAllLocations(userPhoneNumber);
    return userAllLocations;
  }

  Future<bool> addNewTasteTiffinRecord(TasteTiffinApiModel tasteModel) async {
    return await _dataplaneService.addNewTasteTiffinRecord(tasteModel);
  }

  Future<TiffinDataModel?> getUserActiveTiffinInfo(String userPhoneNumber) async {
    TiffinDataModel? tiffinInfo = await _dataplaneService.getUserActiveTiffin(
      userPhoneNumber,
      DateTime.now().toString(),
    );

    return tiffinInfo;
  }

  Future<TiffinDataModel?> getUserFutureTiffinInfo(String userPhoneNumber) async {
    TiffinDataModel? futureTiffinInfo = await _dataplaneService.getUserFutureTiffin(
      userPhoneNumber,
      DateTime.now().toString(),
    );

    return futureTiffinInfo;
  }

  Future<String?> getUserActiveTiffinId(String userPhoneNumber) async {
    TiffinDataModel? tiffinModel = await getUserActiveTiffinInfo(userPhoneNumber);

    return tiffinModel?.tiffinId;
  }

  Future<bool> createTiffinRecord(TiffinDataModel tiffinModel) async {
    return await _dataplaneService.createTiffinRecord(tiffinModel);
  }

  Future<bool> processTiffinSubscription(TiffinApiDataModel model) async {
    return await _dataplaneService.processTiffinSubscription(model);
  }

  Future<bool> addNewExtraTiffinRecord(ExtraTiffinApiModel extraModel) async {
    return await _dataplaneService.addNewExtraTiffinRecord(extraModel);
  }

  Future<bool> addNewSkipTiffinRecord(SkipTiffinApiModel skipModel) async {
    return await _dataplaneService.addNewSkipTiffinRecord(skipModel);
  }

  Future<List<SubscriptionDataModel>> listActiveSubscriptions() async {
    List<SubscriptionDataModel> activeSubscriptions =
        await _dataplaneService.listActiveSubscriptions();

    return activeSubscriptions;
  }

  Future<bool> recordNewPayment(PaymentDataModel paymentModel) async {
    return await _dataplaneService.recordNewPayment(paymentModel);
  }

  Future<bool> addNewOrderRecord(OrderDataModel orderModel) async {
    return await _dataplaneService.addNewOrderRecord(orderModel);
  }

  Future<List<ConsolidatedOrder>> getUserAllConsolidatedOrders(
    String userPhoneNumber,
    int pageNumber,
  ) async {
    return _dataplaneService.getUserAllConsolidatedOrders(userPhoneNumber, pageNumber);
  }

  Future<List<DailyTiffinModel>> generateDailyTiffinData(
    String date,
    String meal,
  ) async {
    return _dataplaneService.generateDailyTiffinData(date, meal);
  }
}
