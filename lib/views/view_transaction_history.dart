import 'package:flutter/material.dart';

class TransactionHistoryView extends StatefulWidget {
  const TransactionHistoryView({super.key});

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          // final order = orderHistory[index];
          return ListTile(
            title: Text('Order ID: {order.orderId}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Amount: \${order.paymentAmount.toStringAsFixed(2)}'),
                Text('Payment Status: {order.paymentStatus}'),
                Text('Date: {order.date}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
