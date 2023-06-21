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
import 'package:protofood/dataplane/dataplane_service.dart';
import 'package:protofood/service/maps.dart';
import 'package:uuid/uuid.dart';

class ManagementService {
  final DataplaneService _dataplaneService = DataplaneService();

  String generateUUID(String actionItem) {
    Uuid generator = const Uuid();

    return "$actionItem-${generator.v1()}";
  }

  String? fetchUserPhoneNumber() {
    String? phoneNumber = AuthService.firebase().currentUser!.phoneNumber;

    return phoneNumber;
  }

  Future<UserDataModel?> getUserInfo(String userPhoneNumber) async {
    UserDataModel? userInfo = await _dataplaneService.getUserWithPhoneNumber(userPhoneNumber);

    return userInfo;
  }

  Future<void> addNewUser(UserDataModel userModel) async {
    await _dataplaneService.addNewUser(userModel);
  }

  Future<LatLng> getUserCurrentLocationLatLng(String userPhoneNumber) async {
    GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
    var currentLocation = await Maps.getCurrentPosition(geolocatorPlatform);

    return currentLocation;
  }

  Future<LocationDataModel> loadClosestUserCurrentLocation(String userPhoneNumber) async {
    LatLng currentLatLng = await getUserCurrentLocationLatLng(userPhoneNumber);

    LocationDataModel currentLocation = await _dataplaneService.getUserClosestLocation(
        currentLatLng.latitude.toString(), currentLatLng.longitude.toString(), userPhoneNumber);

    return currentLocation;
  }

  Future<void> addNewLocation(LocationDataModel locationModel) async {
    await _dataplaneService.addNewLocation(locationModel);
  }

  Future<List<LocationDataModel>> getUserAllLocations(String userPhoneNumber) async {
    List<LocationDataModel> userAllLocations =
        await _dataplaneService.getUserAllLocations(userPhoneNumber);
    return userAllLocations;
  }

  Future<void> addNewTasteTiffinRecord(TasteTiffinDataModel tasteModel) async {
    await _dataplaneService.addNewTasteTiffinRecord(tasteModel);
  }

  Future<String?> getUserActiveTiffinId(String userPhoneNumber) async {
    String? tiffinId = await _dataplaneService.getUserActiveTiffinId(userPhoneNumber);

    return tiffinId;
  }

  Future<TiffinDataModel> getUserTiffinInfo(String userPhoneNumber) async {
    String? tiffinId = await getUserActiveTiffinId(userPhoneNumber);

    TiffinDataModel? tiffinInfo = await _dataplaneService.getTiffinInfo(tiffinId!);

    return tiffinInfo;
  }

  Future<void> createTiffinRecord(TiffinDataModel tiffinModel) async {
    await _dataplaneService.createTiffinRecord(tiffinModel);
  }

  Future<void> addNewExtraTiffinRecord(ExtraTiffinDataModel extraModel) async {
    await _dataplaneService.addNewExtraTiffinRecord(extraModel);
  }

  Future<void> addNewSkipTiffinRecord(SkipTiffinDataModel skipModel) async {
    await _dataplaneService.addNewSkipTiffinRecord(skipModel);
  }

  Future<List<SubscriptionDataModel>> listActiveSubscriptions() async {
    List<SubscriptionDataModel> activeSubscriptions =
        await _dataplaneService.listActiveSubscriptions();

    return activeSubscriptions;
  }

  Future<void> recordNewPayment(PaymentDataModel paymentModel) async {
    await _dataplaneService.recordNewPayment(paymentModel);
  }

  Future<void> addNewOrderRecord(OrderDataModel orderModel) async {
    await _dataplaneService.addNewOrderRecord(orderModel);
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
