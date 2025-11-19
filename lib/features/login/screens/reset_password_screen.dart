import 'package:flutter/material.dart';
import 'package:shreecement/features/login/widgets/reset_pass_box.dart';
import '../../../utils/image_string.dart';

class ResetPassWordScreen extends StatelessWidget {
  const ResetPassWordScreen({super.key});

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
            )), //background image
        const Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ResetPassBox(),
            ],
          ),
        )
      ]),
    );
  }
}
