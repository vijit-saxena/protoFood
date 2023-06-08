import 'dart:async';

import 'package:flutter/material.dart';
import 'package:protofood/views/extra_tiffin_view.dart';
import 'package:protofood/views/skip_tiffin_view.dart';

class SubscriberHomeScreenView extends StatefulWidget {
  const SubscriberHomeScreenView({super.key});

  @override
  State<SubscriberHomeScreenView> createState() =>
      _SubscriberHomeScreenViewState();
}

class _SubscriberHomeScreenViewState extends State<SubscriberHomeScreenView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              // Handle location details tile tap
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 50,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("Click on user");
                // Handle user details icon tap
              },
              child: const Icon(
                Icons.person,
                color: Colors.blue,
                size: 50,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 200,
                  color: Colors.primaries[index % Colors.primaries.length],
                  margin: const EdgeInsets.all(10),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ExtraTiffinView()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        'Extra',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SkipTiffinView()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    color: Colors.green,
                    child: const Center(
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Side Snacks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // const SizedBox(height: 10),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 150,
                  color: Colors.primaries[index % Colors.primaries.length],
                  margin: const EdgeInsets.all(10),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
