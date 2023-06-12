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

  bool _isLoadingMore = false;
  int _pageNumber = 0;
  final ScrollController _scrollController = ScrollController();

  late String _userPhoneNumber;
  List consolidatedOrders = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListner);
    _loadConsolidatedOrderData(_pageNumber);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadConsolidatedOrderData(int pageNumber) async {
    _userPhoneNumber = AuthService.firebase().currentUser!.phoneNumber!;
    await managementService.getUserAllConsolidatedOrders(_userPhoneNumber, pageNumber).then((list) {
      setState(() {
        consolidatedOrders += list;
      });
    });
  }

  _scrollListner() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
      });

      _pageNumber++;
      _loadConsolidatedOrderData(_pageNumber);

      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        controller: _scrollController,
        itemCount: _isLoadingMore ? consolidatedOrders.length + 1 : consolidatedOrders.length,
        itemBuilder: (context, index) {
          if (index < consolidatedOrders.length) {
            ConsolidatedOrder order = consolidatedOrders[index];
            var orderId = order.orderId;
            var paymentAmountInRs = order.payment?.amountInRs ?? 0.0;
            var paymentStatus = order.payment?.status ?? "Not Required";
            var date = order.timeCreated;
            var action = order.action;
            return Card(
              child: ListTile(
                title: Text('Action: $action'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('OrderId: $orderId'),
                    Text('Payment Amount: $paymentAmountInRs'),
                    Text('Payment Status: $paymentStatus'),
                    Text('Date: $date'),
                  ],
                ),
              ),
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
