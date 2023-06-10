import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/skip_tiffin_data_model.dart';
import 'package:protofood/service/management_service.dart';
import 'package:uuid/uuid.dart';

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
    var now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedMeal = meals[0];
    _loadLocalData();
  }

  _loadLocalData() async {
    /*
    userId, locationId, orderId, 
    */
    Uuid orderGenerator = const Uuid();
    _userPhoneNumber = AuthService.firebase().currentUser!.phoneNumber!;
    _orderId = orderGenerator.v1();

    _tiffinId = await managementService.getUserActiveTiffinId(_userPhoneNumber);
    print("TIFFIN : $_tiffinId");
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
                SkipTiffinDataModel model = SkipTiffinDataModel(
                  skipId: _orderId,
                  userId: _userPhoneNumber,
                  tiffinId: _tiffinId!,
                  date: _selectedDate.toIso8601String(),
                  meal: _selectedMeal,
                  timeCreated: DateTime.now().toIso8601String(),
                );

                await managementService
                    .addNewSkipTiffinRecord(model)
                    .then((value) => Navigator.pop(context));

                print('EXTRA : Order submitted!');
              },
              child: const Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }
}
