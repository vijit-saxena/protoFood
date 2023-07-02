import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/location_data_model.dart';
import 'package:protofood/data_models/user_data_model.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/views/add_building_marker_view.dart';
import 'package:protofood/views/login_view.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserDataModel userInfo;

  const UserDetailsScreen({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final ManagementService managementService = ManagementService();
  late List<LocationDataModel> _allUserLocations = [];

  @override
  void initState() {
    super.initState();
    // _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadData() async {
    _allUserLocations = await managementService.getUserAllLocations(widget.userInfo.contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              // backgroundImage: AssetImage('assets/profile_picture.jpg'),
            ),
            const SizedBox(height: 16.0),
            Text(
              "${widget.userInfo.firstName.capitalize()} ${widget.userInfo.lastName.capitalize()}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.userInfo.email,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            const Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.userInfo.contact,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            const Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            FutureBuilder(
              future: _loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _allUserLocations.length,
                      itemBuilder: (context, index) {
                        LocationDataModel location = _allUserLocations[index];
                        return Card(
                          child: ListTile(
                            title: Text(location.shortName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${location.roomNumber}, ${location.buildingName}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const AddBuildingMarkerView()));
              },
              child: const Text("3 - Add location"),
            ),
            const SizedBox(height: 8.0),
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
