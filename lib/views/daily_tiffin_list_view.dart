// ignore: import_of_legacy_library_into_null_safe
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/daily_tiffin_model.dart';
import 'dart:io';

import 'package:protofood/service/computation_service.dart';
import 'package:protofood/service/management_service.dart';

class DailyTiffinListView extends StatefulWidget {
  const DailyTiffinListView({super.key});

  @override
  State<DailyTiffinListView> createState() => _DailyTiffinListViewState();
}

class _DailyTiffinListViewState extends State<DailyTiffinListView> {
  ManagementService managementService = ManagementService();

  List<DailyTiffinModel> dailyTiffinList = [];

  @override
  void initState() {
    super.initState();
    _loadDailyTiffinData(Calculator.parseDateTimeToDateString(DateTime.now()), Meal.Lunch.name);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadDailyTiffinData(String date, String meal) async {
    await managementService.generateDailyTiffinData(date, meal).then((list) {
      setState(() {
        dailyTiffinList += list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Tiffin List : ${Calculator.parseDateTimeToDateString(DateTime.now())}, ${Meal.Lunch.name}'),
      ),
      body: ListView.builder(
        itemCount: dailyTiffinList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(dailyTiffinList[index].userName),
            subtitle: Text(
                'Address: ${dailyTiffinList[index].address}\nTiffin Count: ${dailyTiffinList[index].quantity}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downloadDataAsCSV,
        child: const Icon(Icons.file_download),
      ),
    );
  }

  // todo : implement this method to actually download the data
  Future<void> _downloadDataAsCSV() async {
    List<List<dynamic>> csvData = [];
    for (var tiffin in dailyTiffinList) {
      csvData.add([tiffin.userName, tiffin.address, tiffin.quantity]);
    }

    String csv = const ListToCsvConverter().convert(csvData);

    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/customer_data.csv');
    await file.writeAsString(csv);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data downloaded successfully.'),
      ),
    );
  }
}
