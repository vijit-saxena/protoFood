import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/dataplane/dataplane_service.dart';

class AddBuildingMarkerView extends StatefulWidget {
  const AddBuildingMarkerView({Key? key}) : super(key: key);

  @override
  State<AddBuildingMarkerView> createState() => _CurrentLocationViewState();
}

class _CurrentLocationViewState extends State<AddBuildingMarkerView> {
  late GoogleMapController mapController;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController buildingNameController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController shortNameController = TextEditingController();

  LatLng _draggedLocation = const LatLng(25.178409020688036, 75.92163739945082);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    roomNumberController.dispose();
    buildingNameController.dispose();
    landmarkController.dispose();
    shortNameController.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getCurrentPosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: snapshot.requireData,
                          zoom: 18.0,
                        ),
                        onCameraMove: (draggedPosition) {
                          _draggedLocation = draggedPosition.target;
                        },
                      ),
                      _getCustomPin(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            _gotoSpecficLocation(await _getCurrentPosition());
                          },
                          icon: const Icon(Icons.location_on),
                          label: const Text("Fetch current location"),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Room Number',
                          ),
                          controller: roomNumberController,
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Building Name',
                          ),
                          controller: buildingNameController,
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Landmark',
                          ),
                          controller: landmarkController,
                        ),
                        const SizedBox(height: 10.0),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Short Name',
                          ),
                          controller: shortNameController,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String? currentUserPhoneNumber =
                                AuthService.firebase().currentUser?.phoneNumber;
                            print(
                                "Location to add : ${snapshot.requireData.toJson()}");
                            await DataplaneService.addNewLocation(
                                    buildingNameController.text,
                                    roomNumberController.text,
                                    _draggedLocation.latitude.toString(),
                                    _draggedLocation.longitude.toString(),
                                    landmarkController.text,
                                    shortNameController.text,
                                    currentUserPhoneNumber!)
                                .then((value) {
                              Navigator.of(context).pop();
                            });
                          },
                          child: const Text("Submit"),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _getCustomPin() {
    return Center(
      child: SizedBox(
        width: 150,
        child: Lottie.asset("assets/customLocationPinRed.json"),
      ),
    );
  }

  Future _gotoSpecficLocation(LatLng latlng) async {
    _draggedLocation = latlng;

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 18),
      ),
    );
  }

  Future<LatLng> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return const LatLng(25.178409020688036, 75.92163739945082);
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
    // todo : implement hereforth
    // return const LatLng(25.178409020688036, 75.92163739945082);
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
}
