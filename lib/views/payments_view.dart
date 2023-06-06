import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/payment_data_model.dart';
import 'package:protofood/dataplane/dataplane_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentsView extends StatefulWidget {
  final String orderId;
  final int amountInRs;
  final UserAction action;

  const PaymentsView({
    required this.amountInRs,
    required this.orderId,
    super.key,
    required this.action,
  });

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  late Razorpay _razorpay;
  late String _userPhoneNumber;
  late String _userEmailId;

  @override
  void initState() {
    super.initState();

    var user = AuthService.firebase().currentUser!;
    _userPhoneNumber = user.phoneNumber!;
    _userEmailId = user.email!;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint('Payment Successful: ${response.paymentId}');

    PaymentDataModel paymentDataModel = PaymentDataModel(
      paymentId: response.paymentId!,
      userId: _userPhoneNumber,
      amountInRs: widget.amountInRs.toString(),
      orderId: widget.orderId,
      action: widget.action.name,
      timeCreatedInEpochMilli: DateTime.now().millisecondsSinceEpoch.toString(),
      status: PaymentStatus.Success.name,
    );

    await DataplaneService.recordNewPayment(paymentDataModel).then((value) {
      Navigator.pop(context, paymentDataModel);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    debugPrint('Payment Error: ${response.code} - ${response.message}');

    PaymentDataModel paymentDataModel = PaymentDataModel(
      paymentId: "",
      userId: _userPhoneNumber,
      amountInRs: widget.amountInRs.toString(),
      orderId: widget.orderId,
      action: widget.action.name,
      timeCreatedInEpochMilli: DateTime.now().millisecondsSinceEpoch.toString(),
      status: PaymentStatus.Failed.name,
    );

    await DataplaneService.recordNewPayment(paymentDataModel).then((value) {
      Navigator.pop(context, paymentDataModel);
    });
  }

  void _startPayment() {
    var options = {
      'key': paymentKey,
      'amount': (widget.amountInRs * 100).toInt(),
      'name': 'ProtoFood',
      'description': 'Payment for Meal',
      'prefill': {
        'contact': _userPhoneNumber,
        'email': _userEmailId,
      },
    };

    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Screen'),
      ),
      body: Center(
        child: TextButton(
          onPressed: _startPayment,
          child: const Text('Make Payment'),
        ),
      ),
    );
  }
}
