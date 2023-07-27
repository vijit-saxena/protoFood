import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/data_models/location_data_model.dart';
import 'package:protofood/data_models/tiffin_data_model.dart';
import 'package:protofood/data_models/user_data_model.dart';
import 'package:protofood/service/computation_service.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/views/extra_tiffin_view.dart';
import 'package:protofood/views/skip_tiffin_view.dart';
import 'package:protofood/views/subscription_options_view.dart';
import 'package:protofood/views/user_details_view.dart';
import 'package:protofood/views/view_transaction_history.dart';

class SubscriberHomeScreenView extends StatefulWidget {
  const SubscriberHomeScreenView({super.key});

  @override
  State<SubscriberHomeScreenView> createState() => _SubscriberHomeScreenViewState();
}

class _SubscriberHomeScreenViewState extends State<SubscriberHomeScreenView> {
  ManagementService managementService = ManagementService();

  late final String _userPhoneNumber;
  late final UserDataModel? _userInfo;
  late final TiffinDataModel? _userTiffinInfo;
  late final LocationDataModel? _userCurrentLocation;

  bool _showSubscriptionRenewalBanner = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /* 
    1. Get user tiffin info
    2. Get user info
    3. Get user location info
  */
  _loadData() async {
    try {
      _userPhoneNumber = AuthService.firebase().currentUser!.phoneNumber!;

      _userInfo = await managementService.getUserInfo(_userPhoneNumber);

      _userCurrentLocation =
          await managementService.loadClosestUserCurrentLocation(_userPhoneNumber);

      _userTiffinInfo = await managementService.getUserActiveTiffinInfo(_userPhoneNumber);
    } catch (e) {}
  }

  Future<void> _checkSubscriptionRenewalBanner() async {
    TiffinDataModel? futureUserTiffin =
        await managementService.getUserFutureTiffinInfo(_userPhoneNumber);

    if (futureUserTiffin == null) {
      _showSubscriptionRenewalBanner = true;
    } else {
      _showSubscriptionRenewalBanner = false;
    }

    await Future.delayed(const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Text(
                                _userCurrentLocation!.shortName,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                ),
                                items: const [],
                                onChanged: (value) => print(value),
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Text(
                            "${_userCurrentLocation!.roomNumber}, ${_userCurrentLocation!.buildingName}",
                            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserDetailsScreen(
                                  userInfo: _userInfo!,
                                )));
                      },
                      iconSize: 35,
                      color: Colors.blue,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: 5,
                          child: CircularProgressIndicator(
                            value: Calculator.getActiveTiffinDaysRemaining(_userTiffinInfo!) /
                                Calculator.getActiveTiffinTotalDays(_userTiffinInfo!),
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                            strokeWidth: 5,
                          ),
                        ),
                        Text(
                          "${Calculator.getActiveTiffinDaysRemaining(_userTiffinInfo!).toString()} Days", // Replace with your dynamic value
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                  future: _checkSubscriptionRenewalBanner(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return _showSubscriptionRenewalBanner
                          ? Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SubscriptionOptionsView(
                                        initialDate: _userTiffinInfo!.endDate.add(
                                          const Duration(days: 1),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("Renew membership!"),
                              ),
                            )
                          : const SizedBox.shrink();
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => const ExtraTiffinView()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      child: const Text('Extra'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => const SkipTiffinView()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      child: const Text('Skip'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    6, // Replace with your total number of food icons
                    (index) {
                      return Image(
                        // radius: 200,
                        image: AssetImage('assets/Food${index % 3 + 1}.jpeg'),
                      );
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 1,
              onTap: (index) {
                // Handle bottom navigation bar button press
                if (index == 0) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TransactionHistoryView()));
                  // Records icon pressed
                } else if (index == 1) {
                  // Home icon pressed
                } else if (index == 2) {
                  // Customer support icon pressed
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Records',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.headset_mic),
                  label: 'Support',
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
