// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/login/controller/login_controller.dart';
import 'package:shreecement/features/login/screens/login_screen.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import '../../../utils/image_string.dart';
import '../../../utils/styletextconstant.dart';
import 'custom_button.dart';
import 'package:http/http.dart' as http;

class ResetPassBox extends StatefulWidget {
  const ResetPassBox({super.key});

  @override
  State<ResetPassBox> createState() => _ResetPassBoxState();
}

class _ResetPassBoxState extends State<ResetPassBox> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordCOntroller = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final LoginControl = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    userNameController.text = (sp?.getString("email").toString()).toString();
  }

  Future<dynamic> savePassword() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/users/changepwd";
    var res = await http.put(Uri.parse(url),
        body: jsonEncode({
          "emailId": userNameController.text,
          "password": passwordCOntroller.text
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": "${sp?.getString("email")}",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          "Content-Type": "application/json",
          "Accept": "*/*"
        });
    final parsedJson = jsonDecode(res.body);
    if (parsedJson['responseMessage'].toString() == "Valid user") {
      // print("updated password");
      final loginControl = Get.put(LoginController());
      loginControl.toggle();
      Get.off(LoginScreen());
    } else {
      // print("reset password failed");
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(""),
          content: Text(parsedJson['responseMessage'].toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // print("updated password");
                final loginControl = Get.put(LoginController());
                loginControl.toggle();
                Get.off(LoginScreen());
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(14),
                child: const Text(
                  "okay",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }
    // print(res.body);
    return (res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 508,
      width: 484,
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  child: Image.asset(
                    Images.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Form(
                      key: form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Username'),
                          SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: userNameController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: 'Enter Username',
                                  hintStyle: StyleText.robotowbold,
                                  border: const OutlineInputBorder()),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Password'),
                          SizedBox(
                            height: 40,
                            child: TextFormField(
                              obscureText: true,
                              controller: passwordCOntroller,
                              decoration: InputDecoration(
                                  hintText: 'Enter Password',
                                  hintStyle: StyleText.robotowbold,
                                  border: const OutlineInputBorder()),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return "Enter Password";
                              //   }
                              //   if (value.length < 8) {
                              //     return "Password must be  8 digit ";
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Confirm password'),
                          SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                  hintText: 'Please Re-Enter New Password',
                                  hintStyle: StyleText.robotowbold,
                                  border: const OutlineInputBorder()),
                              // validator: (val) {
                              //   if (val!.isEmpty) {
                              //     showDialog(
                              //       context: context,
                              //       builder: (context) {
                              //         return AlertDialog(
                              //           title: const Text('Invalid Input'),
                              //           content: const Text('Please fill all fields.'),
                              //           actions: <Widget>[
                              //             TextButton(
                              //               onPressed: () {
                              //                 Navigator.of(context).pop();
                              //               },
                              //               child: const Text('OK'),
                              //             ),
                              //           ],
                              //         );
                              //       },
                              //     );
                              //   }
                              //   if (val != passwordCOntroller.text) {
                              //     showDialog(
                              //       context: context,
                              //       builder: (context) {
                              //         return AlertDialog(
                              //           title: const Text('Invalid Input'),
                              //           content: const Text('Passwords Do Not Match'),
                              //           actions: <Widget>[
                              //             TextButton(
                              //               onPressed: () {
                              //                 Navigator.of(context).pop();
                              //               },
                              //               child: const Text('OK'),
                              //             ),
                              //           ],
                              //         );
                              //       },
                              //     );
                              //
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 400,
                            child: CustomButton(
                              text: 'Continue',
                              ontap: () {
                                if (passwordCOntroller.value
                                        .toString()
                                        .isEmpty ||
                                    confirmPasswordController.value
                                        .toString()
                                        .isEmpty ||
                                    userNameController.value
                                        .toString()
                                        .isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Invalid Input'),
                                        content: const Text(
                                            'Please fill all fields'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                } else {
                                  if (form.currentState!.validate()) {
                                    savePassword();
                                  } else {
                                    // print("save password failed");
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
