import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/data_models/consolidated_order_data_model.dart';
import 'package:protofood/service/management_service.dart';

class TransactionHistoryView extends StatefulWidget {
  const TransactionHistoryView({super.key});

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> {
  ManagementService managementService = ManagementService();

  late String _userPhoneNumber;
  List consolidatedOrders = [];

  @override
  void initState() {
    super.initState();
    _loadConsolidatedOrderData(0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadConsolidatedOrderData(int pageNumber) async {
    _userPhoneNumber = AuthService.firebase().currentUser!.phoneNumber!;
    await managementService.getUserAllConsolidatedOrders(_userPhoneNumber, pageNumber).then((list) {
      setState(() {
        consolidatedOrders = consolidatedOrders + list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: ListView.builder(
        itemCount: consolidatedOrders.length,
        itemBuilder: (context, index) {
          ConsolidatedOrder order = consolidatedOrders[index];
          var val = order.skip?.meal ?? "bad-value";
          return Card(
            child: ListTile(
              title: Text('Order ID: $val'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Amount: \${order.paymentAmount.toStringAsFixed(2)}'),
                  Text('Payment Status: {order.paymentStatus}'),
                  Text('Date: {order.date}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
