import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/extra_tiffin_data_model.dart';
import 'package:protofood/data_models/order_data_model.dart';
import 'package:protofood/data_models/payment_data_model.dart';
import 'package:protofood/dataplane/api_models/extra_tiffin_api_model.dart';
import 'package:protofood/dataplane/dataplane_service.dart';
import 'package:protofood/service/computation_service.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/views/home_view.dart';
import 'package:protofood/views/payments_view.dart';
import 'package:uuid/uuid.dart';

class ExtraTiffinView extends StatefulWidget {
  const ExtraTiffinView({super.key});

  @override
  State<ExtraTiffinView> createState() => _ExtraTiffinViewState();
}

class _ExtraTiffinViewState extends State<ExtraTiffinView> {
  ManagementService managementService = ManagementService();

  late DateTime _selectedDate;
  late String _selectedMeal;
  late int _quantity;

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
    _quantity = 1;
    _loadLocalData();
  }

  _loadLocalData() async {
    /*
    userId, locationId, orderId, 
    */
    _userPhoneNumber = AuthService.firebase().currentUser!.phoneNumber!;
    _orderId = Calculator.generateUUID(UuidTag.ExtraTiffin);

    _tiffinId = await managementService.getUserActiveTiffinId(_userPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Form'),
      ),
      body: Center(
        child: Padding(
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
              const Text('Quantity:', style: TextStyle(fontSize: 16.0)),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (_quantity > 1) {
                          _quantity--;
                        }
                      });
                    },
                  ),
                  Text('$_quantity', style: const TextStyle(fontSize: 16.0)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  /*
                    1. Generate local data (userId, locationId, date, meal, quantity)
                    2. Redirect to Payments Flow (orderId, amount)
                    3. Save Taste data (orderId, userId, date, meal, quantity, paymentId, locationId, timeCreated)
                    4. Save Taste orderId in User
                    */
                  var amountInRs = 70 * _quantity;

                  PaymentDataModel response = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentsView(
                        amountInRs: amountInRs,
                        orderId: _orderId,
                        action: UserAction.ExtraTiffin,
                      ),
                    ),
                  );

                  if (response.status == PaymentStatus.Success.name) {
                    // ExtraTiffinDataModel model = ExtraTiffinDataModel(
                    //     extraId: _orderId,
                    //     userId: _userPhoneNumber,
                    //     tiffinId: _tiffinId!,
                    //     date: _selectedDate,
                    //     meal: _selectedMeal,
                    //     quantity: _quantity,
                    //     paymentId: response.paymentId,
                    //     timeCreated: response.timeCreated);

                    ExtraTiffinApiModel model = ExtraTiffinApiModel(
                      extraId: _orderId,
                      userId: _userPhoneNumber,
                      tiffinId: _tiffinId!,
                      date: _selectedDate,
                      meal: _selectedMeal,
                      quantity: _quantity,
                      timeCreated: response.timeCreated,
                      paymentId: response.paymentId,
                      amountInRs: amountInRs,
                      action: response.action,
                      status: response.status,
                    );

                    await managementService.addNewExtraTiffinRecord(model).then((isSuccess) async {
                      if (isSuccess) {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const HomeView()));
                      }
                    });
                  } else {
                    // In case payment fails
                    /*
                    1. Log error message
                    */
                  }
                },
                child: const Text('Submit Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
