import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/payment_data_model.dart';
import 'package:protofood/data_models/subscription_data_model.dart';
import 'package:protofood/dataplane/api_models/tiffin_api_model.dart';
import 'package:protofood/service/computation_service.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/views/home_view.dart';
import 'package:protofood/views/payments_view.dart';

class SubscriptionSummaryView extends StatefulWidget {
  final SubscriptionDataModel subscriptionData;
  final DateTime? initialDate;

  const SubscriptionSummaryView({
    Key? key,
    required this.subscriptionData,
    this.initialDate,
  }) : super(key: key);

  @override
  State<SubscriptionSummaryView> createState() => _SubscriptionSummaryViewState();
}

class _SubscriptionSummaryViewState extends State<SubscriptionSummaryView> {
  ManagementService managementService = ManagementService();

  late DateTime _selectedDate;
  late final String _userPhoneNumber;
  late final String _orderId;
  late final String _finalLocationId;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _loadLocalData();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime firstDate = widget.initialDate ?? DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: firstDate.add(const Duration(days: 2 * DateTime.daysPerWeek)),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  _loadLocalData() async {
    /*
    userId, locationId, orderId, 
    */
    _userPhoneNumber = AuthService.firebase().currentUser!.phoneNumber!;

    _orderId = Calculator.generateUUID(UuidTag.Tiffin);

    await managementService.loadClosestUserCurrentLocation(_userPhoneNumber).then((location) {
      _finalLocationId = location!.locationId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subscription ID: ${widget.subscriptionData.subscriptionId}'),
            const SizedBox(height: 16.0),
            Text('Discount: ${widget.subscriptionData.discountInPercent}%'),
            const SizedBox(height: 16.0),
            Text('Duration: ${widget.subscriptionData.durationInDays} days'),
            const SizedBox(height: 16.0),
            Text('Start Date & Time: ${widget.subscriptionData.startDateTime.toString()}'),
            const SizedBox(height: 16.0),
            Text('End Date & Time: ${widget.subscriptionData.endDateTime.toString()}'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
            Text(
              'Selected Date: ${_selectedDate.toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Completer<PaymentDataModel?> completer = Completer<PaymentDataModel?>();
                  _showExpandablePaymentScreen(
                    context,
                    3000,
                    completer,
                  );
                },
                child: const Text("Proceed to payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExpandablePaymentScreen(
    BuildContext context,
    int amountInRs,
    Completer<PaymentDataModel?> completer,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: PaymentsView(
            amountInRs: amountInRs,
            orderId: _orderId,
            action: UserAction.ExtraTiffin,
            completer: completer,
          ),
        );
      },
    ).then((_) {
      // This block will be executed when the bottom sheet is dismissed
      print("Expandable screen dismissed");

      completer.future.then((response) async {
        if (response != null) {
          if (response.status == PaymentStatus.Success.name) {
            TiffinApiDataModel tiffinApiModel = TiffinApiDataModel(
              tiffinId: _orderId,
              userId: _userPhoneNumber,
              startDate: _selectedDate,
              endDate: _selectedDate.add(
                Duration(days: widget.subscriptionData.durationInDays),
              ),
              subscriptionId: widget.subscriptionData.subscriptionId,
              locationId: _finalLocationId,
              meal: widget.subscriptionData.mealType,
              timeCreated: response.timeCreated,
              timeUpdated: response.timeCreated,
              extras: List.empty(),
              skips: List.empty(),
              paymentId: response.paymentId,
              amountInRs: int.parse(response.amountInRs),
              action: response.action,
              status: response.status,
            );

            await managementService
                .processTiffinSubscription(tiffinApiModel)
                .then((isSuccess) async {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const HomeView()));
            });
          } else {}
        } else {
          print("It is null");
        }
      });
    });
  }
}
