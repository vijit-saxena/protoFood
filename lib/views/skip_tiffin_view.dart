import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/order_data_model.dart';
import 'package:protofood/data_models/skip_tiffin_data_model.dart';
import 'package:protofood/dataplane/api_models/skip_tiffin_api_model.dart';
import 'package:protofood/service/computation_service.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/views/home_view.dart';

class SkipTiffinView extends StatefulWidget {
  const SkipTiffinView({super.key});

  @override
  State<SkipTiffinView> createState() => _SkipTiffinViewState();
}

class _SkipTiffinViewState extends State<SkipTiffinView> {
  ManagementService managementService = ManagementService();

  late DateTime _selectedDate;
  late String _selectedMeal;

  late final String _userPhoneNumber;
  late final String _orderId;
  late final String? _tiffinId;

  final List<String> meals = [Meal.Lunch.name, Meal.Dinner.name];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: DateTime.daysPerWeek)),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedMeal = meals[0];
    _loadLocalData();
  }

  _loadLocalData() async {
    /*
    userId, locationId, orderId, 
    */
    _userPhoneNumber = AuthService.firebase().currentUser!.phoneNumber!;
    _orderId = Calculator.generateUUID(UuidTag.SkipTiffin);

    _tiffinId = await managementService.getUserActiveTiffinId(_userPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Selected Date: ${_selectedDate.toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text('Select Meal:', style: TextStyle(fontSize: 16.0)),
            DropdownButton<String>(
              value: _selectedMeal,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMeal = newValue!;
                });
              },
              items: meals.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                DateTime currentTime = DateTime.now();

                SkipTiffinApiModel model = SkipTiffinApiModel(
                    skipId: _orderId,
                    userId: _userPhoneNumber,
                    date: _selectedDate,
                    meal: _selectedMeal,
                    tiffinId: _tiffinId!,
                    timeCreated: currentTime);

                await managementService.addNewSkipTiffinRecord(model).then((isSuccess) async {
                  if (isSuccess) {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => const HomeView()));
                  }
                });
              },
              child: const Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }
}
