import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/dataplane/dataplane_service.dart';
import 'package:protofood/google_maps/maps.dart';

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
        future: Maps.getCurrentPosition(_geolocatorPlatform),
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
                            _gotoSpecficLocation(await Maps.getCurrentPosition(
                                _geolocatorPlatform));
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
}
