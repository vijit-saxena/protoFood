import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/views/add_user_datails.dart';
import 'package:protofood/views/login_view.dart';

import '../google_maps/add_building_marker_view.dart';

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
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddUserDetailsView()));
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddBuildingMarkerView()));
              },
              child: const Text("3 - Add location"),
            ),
            TextButton(
              onPressed: () {
                AuthService.firebase().logOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreenView()),
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
