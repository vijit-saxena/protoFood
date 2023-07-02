import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/data_models/location_data_model.dart';
import 'package:protofood/data_models/subscription_data_model.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/views/subscription_options_view.dart';
import 'package:protofood/views/taste_view.dart';

class NewUserHomeScreen extends StatefulWidget {
  const NewUserHomeScreen({super.key});

  @override
  State<NewUserHomeScreen> createState() => _NewUserHomeScreenState();
}

class _NewUserHomeScreenState extends State<NewUserHomeScreen> {
  ManagementService managementService = ManagementService();

  ScrollController subscriptionListViewController = ScrollController();
  List<SubscriptionDataModel> activeSubscriptionList = [];

  late String _userPhoneNumber;
  late LocationDataModel? closestUserLocation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    subscriptionListViewController.dispose();
    activeSubscriptionList = [];
    closestUserLocation = null;
    _userPhoneNumber = "";

    super.dispose();
  }

  Future<void> _loadPageData() async {
    _userPhoneNumber = AuthService.firebase().currentUser!.phoneNumber!;
    activeSubscriptionList = await managementService.listActiveSubscriptions();

    closestUserLocation = await managementService.loadClosestUserCurrentLocation(_userPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1.  get location
      // 2. get user details
      // 3. Taste button
      // 4. Subscriptions ListView
      body: FutureBuilder(
        future: _loadPageData(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Text("Location : ${closestUserLocation?.roomNumber}"),
                      Text("User : ${AuthService.firebase().currentUser?.phoneNumber}"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => const TasteView()));
                        },
                        child: const Text("6 - Taste"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => SubscriptionOptionsView()));
                        },
                        child: const Text("Subscription Options"),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        }),
      ),
    );
  }
}
