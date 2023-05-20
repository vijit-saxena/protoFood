import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:protofood/auth/auth_service.dart';

import 'home.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  const OTPScreen(this.phone, {super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late String _verificationCode;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  @override
  void dispose() {
    super.dispose();
    _verificationCode = "";
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Center(
          child: Text("Verifying +91-${widget.phone}"),
        ),
        Directionality(
          // Specify direction if desired
          textDirection: TextDirection.ltr,
          child: Pinput(
            length: 6,
            controller: pinController,
            focusNode: focusNode,
            androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
            listenForMultipleSmsOnAndroid: true,
            defaultPinTheme: defaultPinTheme,
            onClipboardFound: (value) {
              debugPrint('onClipboardFound: $value');
              pinController.setText(value);
            },
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            onCompleted: (pin) async {
              try {
                debugPrint('onCompleteds: $pin');
                await AuthService.firebase()
                    .logIn(
                        phoneAuthCredential: PhoneAuthProvider.credential(
                            verificationId: _verificationCode, smsCode: pin))
                    .then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                      (route) => false);
                });
              } catch (e) {
                FocusScope.of(context).unfocus();
              }
            },
            cursor: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  width: 22,
                  height: 1,
                  color: focusedBorderColor,
                ),
              ],
            ),
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: focusedBorderColor),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: fillColor,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: focusedBorderColor),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyBorderWith(
              border: Border.all(color: Colors.redAccent),
            ),
          ),
        ),
      ]),
    );
  }

  _verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${widget.phone}",
      verificationCompleted: (PhoneAuthCredential cred) async {
        await AuthService.firebase()
            .logIn(phoneAuthCredential: cred)
            .then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
              (route) => false);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationCode, int? resendToken) {
        setState(() {
          _verificationCode = verificationCode;
        });
      },
      codeAutoRetrievalTimeout: (String verificationCode) {
        setState(() {
          _verificationCode = verificationCode;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }
}
