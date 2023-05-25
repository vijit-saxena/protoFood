import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

class AddBuildingMarkerView extends StatefulWidget {
  const AddBuildingMarkerView({Key? key}) : super(key: key);

  @override
  State<AddBuildingMarkerView> createState() => _CurrentLocationViewState();
}

class _CurrentLocationViewState extends State<AddBuildingMarkerView> {
  late GoogleMapController googleMapController;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController buildingNameController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController shortNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder<LatLng>(
          future: _getCurrentPosition(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.75,
                    child: Stack(
                      children: [
                        SizedBox(
                          child: _getGoogleMap(context, snapshot),
                          // _getCustomPin(),
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
                  SizedBox(
                    height: screenHeight * 0.25,
                    child: _getDetailsSection(
                        roomNumberController,
                        buildingNameController,
                        landmarkController,
                        shortNameController),
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget _getDetailsSection(
      TextEditingController roomNumberController,
      TextEditingController buildingNameController,
      TextEditingController landmarkController,
      TextEditingController shortNameController) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: roomNumberController,
          ),
          TextField(
            controller: buildingNameController,
          ),
          TextField(
            controller: landmarkController,
          ),
          TextField(
            controller: shortNameController,
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.fork_right),
            label: const Text("Submit"),
          )
        ],
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

  GoogleMap _getGoogleMap(
      BuildContext context, AsyncSnapshot<LatLng> snapshot) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
            snapshot.requireData.latitude, snapshot.requireData.longitude),
        zoom: 18,
      ),
      zoomControlsEnabled: true,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        googleMapController = controller;
      },
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

  Future _gotoSpecficLocation(LatLng latlng) async {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 18),
      ),
    );
  }
}
