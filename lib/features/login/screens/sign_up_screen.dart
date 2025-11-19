import 'package:flutter/material.dart';
import 'package:shreecement/features/login/widgets/sign_up_box.dart';
import 'package:shreecement/utils/image_string.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [SignUpBox()],
          ),
        )
      ]),
    );
  }
}
