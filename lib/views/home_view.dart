// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:protofood/data_models/tiffin_data_model.dart';
import 'package:protofood/data_models/user_data_model.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/views/add_user_datails.dart';
import 'package:protofood/views/new_user_home_screen.dart';
import 'package:protofood/views/subscriber_home_screen_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ManagementService managementService = ManagementService();

  late String userPhoneNumber;
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
    checkSubscriptionStatus(context);
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
  void checkSubscriptionStatus(BuildContext cc) async {
    if (await _checkUserDetailsPresent() == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AddUserDetailsView()));
    } else {
      _userIsSubscriber = await _checkUserIsSubscriber();

      _userIsFutureSubscriber = await _checkUserIsFutureSubscriber();

      if (_userIsSubscriber || _userIsFutureSubscriber) {
        Navigator.pushReplacement(
            cc, MaterialPageRoute(builder: (cc) => const SubscriberHomeScreenView()));
      } else {
        Navigator.pushReplacement(
            cc, MaterialPageRoute(builder: (cc) => const NewUserHomeScreen()));
      }
    }
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
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
