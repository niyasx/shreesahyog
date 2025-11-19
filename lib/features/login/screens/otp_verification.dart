import 'package:flutter/material.dart';
import 'package:shreecement/utils/image_string.dart';

import '../widgets/otp_box.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              Images.loginbg,
              fit: BoxFit.cover,
            )),
        Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Otpbox()],
          ),
        )
      ]),
    );
  }
}
