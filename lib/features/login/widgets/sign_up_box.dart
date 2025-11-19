// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/widgets/snackbar.dart';
import 'package:shreecement/features/login/screens/login_screen.dart';
import 'package:shreecement/features/login/widgets/custom_button.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:http/http.dart' as http;
import '../../../utils/image_string.dart';

class SignUpBox extends StatefulWidget {
  const SignUpBox({super.key});

  @override
  State<SignUpBox> createState() => _SignUpBoxState();
}

class _SignUpBoxState extends State<SignUpBox> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordCOntroller = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  // final LoginControl = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    userNameController.text = (sp?.getString("email").toString()).toString();
  }

  Future<dynamic> savePassword() async {
    String url = "$baseUrl/users/changepwd";
    var res = await http.put(Uri.parse(url),
        body: jsonEncode({
          "emailId": userNameController.text,
          "password": passwordCOntroller.text
        }),
        headers: {
          "Authorization": sp?.getString("firstTimeLogin") != "true"
              ? "Bearer ${(sp?.getString("otpAuth")).toString()}"
              : "Bearer ${(sp?.getString("firstTimeToken")).toString()}",
          "username": "${sp?.getString("email")}",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          "Content-Type": "application/json",
          "Accept": "*/*"
        });
    final parsedJson = jsonDecode(res.body);
    if (parsedJson['responseMessage'].toString() == "Valid user") {
      // print("updated password");
      logout();
      Get.offAll(LoginScreen());
    } else {
      // print("reset password failed");
      // ignore: use_build_context_synchronously
      buildSnackBarSuccess("Success", "Password Updated");
    }
    logout();
    Get.offAll(() => LoginScreen());

    return (res.body);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(minHeight: 444, minWidth: 360),
          height: screenSize.width > screenSize.height
              ? screenSize.height * 0.9
              : screenSize.height * 0.7,
          width: screenSize.width > screenSize.height
              ? screenSize.width * 0.35
              : screenSize.width * 0.6,
          decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(114, 114, 114, 1),
              ),
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(255, 255, 255, .80)),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    screenSize.width >= 500
                        ? SizedBox(
                            width: screenSize.width * 0.3,
                            child: Image.asset(
                              Images.logo,
                              fit: BoxFit.scaleDown,
                            ),
                          )
                        : SizedBox(
                            width: screenSize.width * 0.75,
                            child: Image.asset(
                              Images.logo,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 50),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Form(
                          key: form,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Username',
                                style: TextStyle(
                                  color: Color(0xFF606060),
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              SizedBox(
                                width: 286,
                                height: 32,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: userNameController,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 8, top: 8, bottom: 8),
                                      hintText: 'Enter Username',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF727272),
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        height: 0.09,
                                      ),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              const Text(
                                'Password',
                                style: TextStyle(
                                  color: Color(0xFF606060),
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              SizedBox(
                                width: 286,
                                height: 32,
                                child: TextFormField(
                                  controller: passwordCOntroller,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter New  Password',
                                      contentPadding: EdgeInsets.only(
                                          left: 8, top: 8, bottom: 8),
                                      hintStyle: TextStyle(
                                        color: Color(0xFF727272),
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        height: 0.09,
                                      ),
                                      border: OutlineInputBorder()),
                                  //       validator: (value) {
                                  //   if (value!.isEmpty) {
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
                                  //   if (value.length < 8) {
                                  //     showDialog(
                                  //       context: context,
                                  //       builder: (context) {
                                  //         return AlertDialog(
                                  //           title: const Text('Invalid Input'),
                                  //           content: const Text('Password must be  8 digit'),
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
                                height: 24,
                              ),
                              const Text(
                                'Confirm password',
                                style: TextStyle(
                                  color: Color(0xFF606060),
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              SizedBox(
                                width: 286,
                                height: 32,
                                child: TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      hintText: 'Pleas Re-enter New Password',
                                      contentPadding: EdgeInsets.only(
                                          left: 8, top: 8, bottom: 8),
                                      hintStyle: TextStyle(
                                        color: Color(0xFF727272),
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        height: 0.09,
                                      ),
                                      border: OutlineInputBorder()),
                                  //       validator: (val) {
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
                                  //     return;
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
                                  //     return;
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                  width: 286,
                                  height: 31,
                                  child: CustomButton(
                                      text: 'Continue',
                                      ontap: () async {
                                        try {
                                          if (passwordCOntroller.value.text
                                                  .toString()
                                                  .isEmpty ||
                                              confirmPasswordController
                                                  .value.text
                                                  .toString()
                                                  .isEmpty ||
                                              userNameController.value.text
                                                  .toString()
                                                  .isEmpty) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Invalid Input'),
                                                  content: const Text(
                                                      'Please fill all fields'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else if (passwordCOntroller
                                                  .value.text.length <
                                              8) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Invalid Input'),
                                                  content: const Text(
                                                      'Password length should be greater than or equal to 8 characters'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else if (passwordCOntroller
                                                  .value.text
                                                  .compareTo(
                                                      confirmPasswordController
                                                          .value.text) !=
                                              0) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Invalid Input'),
                                                  content: const Text(
                                                      'Password And Confirm Password Does Not Matched'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            if (form.currentState!.validate()) {
                                              await savePassword();
                                            } else {
                                              // print("save password failed");
                                            }
                                          }
                                        } catch (e) {
                                          // print("error on save password $e");
                                        }
                                      }))
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
        ),
      ),
    );
  }
}
