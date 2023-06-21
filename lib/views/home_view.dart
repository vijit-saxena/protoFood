import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/views/add_building_marker_view.dart';
import 'package:protofood/views/add_user_datails.dart';
import 'package:protofood/views/daily_tiffin_list_view.dart';
import 'package:protofood/views/extra_tiffin_view.dart';
import 'package:protofood/views/login_view.dart';
import 'package:protofood/views/new_user_home_screen.dart';
import 'package:protofood/views/skip_tiffin_view.dart';
import 'package:protofood/views/subscriber_home_screen_view.dart';
import 'package:protofood/views/subscription_options_view.dart';
import 'package:protofood/views/taste_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Text(uid!),
            ),
            TextButton(
              child: const Text("2 - Enter User Details Page"),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const AddUserDetailsView()));
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const AddBuildingMarkerView()));
              },
              child: const Text("3 - Add location"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const NewUserHomeScreen()));
              },
              child: const Text("4 - New User Home Screen"),
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const PaymentsView(
            //           amountInRs: 100,
            //           orderId: "coolId",
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Text("5 - Accept Payments"),
            // ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const TasteView()));
              },
              child: const Text("6 - Taste"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const SubscriptionOptionsView()));
              },
              child: const Text("7 - Subscription Options"),
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
                    .push(MaterialPageRoute(builder: (context) => const ExtraTiffinView()));
              },
              child: const Text("9 - Extra Tiffin"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const SkipTiffinView()));
              },
              child: const Text("10 - Skip Tiffin"),
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
                AuthService.firebase().logOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreenView()),
                      (route) => false);
                });
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
