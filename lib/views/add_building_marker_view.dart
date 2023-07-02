import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/location_data_model.dart';
import 'package:protofood/service/computation_service.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/service/maps.dart';

class AddBuildingMarkerView extends StatefulWidget {
  const AddBuildingMarkerView({Key? key}) : super(key: key);

  @override
  State<AddBuildingMarkerView> createState() => _CurrentLocationViewState();
}

class _CurrentLocationViewState extends State<AddBuildingMarkerView> {
  ManagementService managementService = ManagementService();

  late String? _userPhoneNumber;
  late String _locationId;

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

    _userPhoneNumber = managementService.fetchUserPhoneNumber();
    _locationId = Calculator.generateUUID(UuidTag.Location);
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
        future: managementService.getUserCurrentLocationLatLng(),
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
                            _gotoSpecficLocation(
                                await Maps.getCurrentPosition(_geolocatorPlatform));
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
                            LocationDataModel locationModel = LocationDataModel(
                                locationId: _locationId,
                                buildingName: buildingNameController.text,
                                roomNumber: roomNumberController.text,
                                latitude: _draggedLocation.latitude.toString(),
                                longitude: _draggedLocation.longitude.toString(),
                                landmark: landmarkController.text,
                                shortName: shortNameController.text,
                                userId: _userPhoneNumber!);

                            await managementService.addNewLocation(locationModel).then((isSuccess) {
                              if (isSuccess) {
                                Navigator.of(context).pop();
                              }
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
