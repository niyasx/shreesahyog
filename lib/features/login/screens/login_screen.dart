import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/utils/image_string.dart';

import '../controller/login_controller.dart';
import '../widgets/login_box.dart';
import '../widgets/login_box2.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginControl = Get.put(LoginController());

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
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => LoginControl.continue1.value
                  ? const LoginBox2()
                  : const LoginBox()),
            ],
          ),
        )
      ]),
    );
  }
}
