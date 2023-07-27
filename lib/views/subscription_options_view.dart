import 'package:flutter/material.dart';
import 'package:protofood/data_models/subscription_data_model.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/views/subscription_summary_view.dart';

class SubscriptionOptionsView extends StatefulWidget {
  final DateTime? initialDate;

  const SubscriptionOptionsView({Key? key, this.initialDate}) : super(key: key);

  @override
  State<SubscriptionOptionsView> createState() => _SubscriptionOptionsViewState();
}

class _SubscriptionOptionsViewState extends State<SubscriptionOptionsView> {
  ManagementService managementService = ManagementService();

  List<SubscriptionDataModel> _activeSubscriptions = [];

  @override
  void initState() {
    super.initState();
    _loadActiveSubscriptionsData();
  }

  @override
  void dispose() {
    super.dispose();
    _activeSubscriptions = [];
  }

  _loadActiveSubscriptionsData() async {
    await managementService.listActiveSubscriptions().then((response) {
      setState(() {
        _activeSubscriptions = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _activeSubscriptions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_activeSubscriptions[index].mealType.toString()),
            subtitle: Text('Discount: ${_activeSubscriptions[index].discountInPercent}%'),
            trailing: Text('Duration: ${_activeSubscriptions[index].durationInDays} Days'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionSummaryView(
                    subscriptionData: _activeSubscriptions[index],
                    initialDate: widget.initialDate,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
