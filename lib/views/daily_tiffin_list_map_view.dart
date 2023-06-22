import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/daily_tiffin_model.dart';
import 'package:protofood/service/computation_service.dart';
import 'package:protofood/service/management_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  ManagementService managementService = ManagementService();

  List<DailyTiffinModel> dailyTiffinList = [];

  Future<void> _loadDailyTiffinData(String date, String meal) async {
    await managementService.generateDailyTiffinData(date, meal).then((list) {
      // setState(() {
      //   dailyTiffinList += list;
      // });
      dailyTiffinList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Tiffin List : ${Calculator.parseDateTimeToDateString(DateTime.now())}, ${Meal.Lunch.name}'),
      ),
      body: FutureBuilder(
        future: _loadDailyTiffinData(
            Calculator.parseDateTimeToDateString(DateTime.now()), Meal.Lunch.name),
        builder: (contex, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(dailyTiffinList.first.latitude),
                    double.parse(dailyTiffinList.first.longitude)),
                zoom: 10,
              ),
              markers: dailyTiffinList.map(
                (DailyTiffinModel model) {
                  LatLng latLng =
                      LatLng(double.parse(model.latitude), double.parse(model.longitude));
                  return Marker(
                    markerId: MarkerId(latLng.toString()),
                    position: latLng,
                    infoWindow: InfoWindow(
                      title: 'Marker Details',
                      snippet: model.userName,
                    ),
                  );
                },
              ).toSet(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
