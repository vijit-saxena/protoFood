import 'dart:html';

import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/modules/razorpay_payments.dart';

class PaymentsView extends StatefulWidget {
  final String orderId;
  final int amountInRs;

  const PaymentsView({
    required this.amountInRs,
    required this.orderId,
    super.key,
  });

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  late RazorpayPayment _razorpayPayment;

  @override
  void initState() {
    super.initState();
    _razorpayPayment = RazorpayPayment();
    _razorpayPayment.initializeRazorpay(
      widget.amountInRs,
      UserAction.taste,
      widget.orderId,
    );
  }

  @override
  void dispose() {
    _razorpayPayment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Screen'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            var currentUser = AuthService.firebase().currentUser!;
            _razorpayPayment.openCheckout(
              context,
              currentUser.phoneNumber!,
              currentUser.email!,
            );
          },
          child: const Text('Make Payment'),
        ),
      ),
    );
  }
}
