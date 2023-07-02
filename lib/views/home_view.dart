import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/data_models/tiffin_data_model.dart';
import 'package:protofood/data_models/user_data_model.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/views/add_building_marker_view.dart';
import 'package:protofood/views/add_user_datails.dart';
import 'package:protofood/views/daily_tiffin_list_map_view.dart';
import 'package:protofood/views/daily_tiffin_list_view.dart';
import 'package:protofood/views/login_view.dart';
import 'package:protofood/views/new_user_home_screen.dart';
import 'package:protofood/views/subscriber_home_screen_view.dart';
import 'package:protofood/views/subscription_options_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ManagementService managementService = ManagementService();

  late String userPhoneNumber;
  late bool _userDetailsPresent = false;
  late bool _userIsSubscriber = false;
  late bool _userIsFutureSubscriber = false;

  var log = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
    ),
  );

  @override
  void initState() {
    super.initState();
    userPhoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;
  }

  /*
    1. If user details not present : 
      a. Force user to enter details
    2. If user details present : 
      a. If user is not a subscriber :
        i. Show newUserScreen
      b. If user is a subscriber :
        i. Current subscriber or future subscriber?
        ii. Show userSubscriberScreen
  */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _checkUserDetailsPresent().then((bool userDetailsPresent) {
      setState(() {
        _userDetailsPresent = userDetailsPresent;
      });

      if (!_userDetailsPresent) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AddUserDetailsView()), (route) => false);
      }
    });

    _checkUserIsSubscriber().then((bool userIsSubscriber) {
      setState(() {
        _userIsSubscriber = userIsSubscriber;
      });
    });

    _checkUserIsFutureSubscriber().then((bool userIsFutureSubscriber) {
      setState(() {
        _userIsFutureSubscriber = userIsFutureSubscriber;
      });
    });

    if (_userIsSubscriber || _userIsFutureSubscriber) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SubscriberHomeScreenView()),
          (route) => false);
    }

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => const NewUserHomeScreen()), (route) => false);
  }

  Future<bool> _checkUserDetailsPresent() async {
    UserDataModel? response = await managementService.getUserInfo(userPhoneNumber);
    return response != null ? true : false;
  }

  Future<bool> _checkUserIsSubscriber() async {
    TiffinDataModel? response = await managementService.getUserActiveTiffinInfo(userPhoneNumber);
    return response != null ? true : false;
  }

  Future<bool> _checkUserIsFutureSubscriber() async {
    TiffinDataModel? response = await managementService.getUserFutureTiffinInfo(userPhoneNumber);
    return response != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Text(userPhoneNumber),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const NewUserHomeScreen()));
              },
              child: const Text("4 - New User Home Screen"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SubscriberHomeScreenView()),
                    (route) => false);
              },
              child: const Text("8 - Subscriber Home Screen"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const DailyTiffinListView()));
              },
              child: const Text("11 - Daily Tiffin Report List"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const MapScreen()));
              },
              child: const Text("11 - Daily Tiffin Report List - Map View"),
            ),
          ],
        ),
      ),
    );
  }
}
