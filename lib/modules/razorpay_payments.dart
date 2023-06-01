import 'package:flutter/material.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/dataplane/dataplane_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPayment {
  late Razorpay _razorpay;
  late final int amountInRs;
  late final UserAction action;
  late final String orderId;

  void openCheckout(
    BuildContext context,
    String userPhoneNumber,
    String userEmailAddress,
  ) {
    var options = {
      'key': paymentKey,
      'name': 'ProtoFood',
      'description': 'Test Payment',
      'prefill': {'contact': userPhoneNumber, 'email': userEmailAddress},
      'amount': amountInRs * 100, // amount in paise (1 Rupee = 100 paise)
      'order_id': orderId,
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  void initializeRazorpay(int amountInRs, UserAction action, String orderId) {
    _razorpay = Razorpay();
    this.amountInRs = amountInRs;
    this.action = action;
    this.orderId = orderId;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Successful: ${response.paymentId}');
    debugPrint('Payment Successful: ${response.orderId}');
    // Handle successful payment here
    DataplaneService.recordNewPayment(
      response.paymentId!,
      amountInRs.toString(),
      response.orderId!,
      action.toString(),
      DateTime.now().toString(),
      PaymentStatus.success.toString(),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    // Handle payment error here
  }

  void dispose() {
    _razorpay.clear();
  }
}
