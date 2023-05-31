import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/data_models/location_data_model.dart';
import 'package:protofood/data_models/subscription_data_model.dart';
import 'package:protofood/dataplane/dataplane_service.dart';
import 'package:protofood/google_maps/maps.dart';

class NewUserHomeScreen extends StatefulWidget {
  const NewUserHomeScreen({super.key});

  @override
  State<NewUserHomeScreen> createState() => _NewUserHomeScreenState();
}

class _NewUserHomeScreenState extends State<NewUserHomeScreen> {
  ScrollController subscriptionListViewController = ScrollController();
  List<SubscriptionDataModel> activeSubscriptionList = [];

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  late LocationDataModel closestUserLocation;

  _loadPageData() async {
    String? currentUserPhoneNumber =
        AuthService.firebase().currentUser?.phoneNumber;
    activeSubscriptionList = await DataplaneService.listActiveSubscriptions();

    LatLng currentLocation = await Maps.getCurrentPosition(_geolocatorPlatform);
    closestUserLocation = await DataplaneService.getUserClosestLocation(
      currentLocation.latitude.toString(),
      currentLocation.longitude.toString(),
      currentUserPhoneNumber!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadPageData(),
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              // 1.  get location
              // 2. get user details
              // 3. Taste button
              // 4. Subscriptions ListView
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Location : ${closestUserLocation.roomNumber}"),
                    Text(
                        "User : ${AuthService.firebase().currentUser?.phoneNumber}"),
                    TextButton(
                      onPressed: () {},
                      child: const Text("TASTE"),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: subscriptionListViewController,
                        scrollDirection: Axis.vertical,
                        itemCount: activeSubscriptionList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: TextButton(
                              onPressed: () {},
                              child: Text(
                                  "${activeSubscriptionList[index].subscriptionId} -- ${activeSubscriptionList[index].mealType}"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          default:
            return const CircularProgressIndicator();
        }
      }),
    );
  }
}
