// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shreecement/features/common/controller/numeric.dart';
import 'package:shreecement/features/common/models/otpgenerationmodel.dart';
import 'package:shreecement/features/common/models/validate_otp_model.dart';
import 'package:shreecement/features/common/widgets/snackbar.dart';
import 'package:shreecement/features/login/screens/login_screen.dart';
import 'package:shreecement/features/login/screens/sign_up_screen.dart';
import 'package:shreecement/features/login/widgets/custom_button.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import '../../../utils/image_string.dart';
import '../authentication/otpgen.dart';
import 'package:http/http.dart' as http;

Future<void> showAlertDialog(
    String title, String message, BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
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
}

class Otpbox extends StatefulWidget {
  const Otpbox({super.key});

  @override
  State<Otpbox> createState() => _OtpboxState();
}

class _OtpboxState extends State<Otpbox> {
  final OTPGen otpGen = OTPGen();

  // Create an instance of the OTPGen class
  Future<void> _callAPI(BuildContext context) async {
    try {
      SharedPreferences? sp = await SharedPreferences.getInstance();
      String username = sp.getString("email") ?? "";
      String type = 'LOGIN';

      // Call the otpPostAPI method
      OTPGenerationResponseModel response =
          await otpGen.otpPostAPI(username: username, type: type);
      if (response.responseCode == "400 BAD_REQUEST") {
        // ignore: use_build_context_synchronously
        // showAlertDialog("Error",response.responseMessage??"",context);
        buildSnackBar("Error", response.responseMessage ?? "");
      }
      if (response.responseCode == "200 OK") {
        sp.setString("otpAuth", response.serviceDTO!.authToken.toString());
        return;
      }
      logout();
      Get.offAll(LoginScreen());
    } catch (e) {
      // Handle any exceptions that may occur during the API call
      // print('Error during API call: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    if (sp?.getString("firstTimeLogin") != "true") {
      _callAPI(context);
    }
  }

  Future<dynamic> validateOtp(
      {
      // required String type,
      required String otp,
      required BuildContext ctx}) async {
    try {
      String url = "$baseUrl/users/validate-otp";

      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": sp?.getString("firstTimeLogin") != "true"
                ? "Bearer ${(sp?.getString("otpAuth")).toString()}"
                : "Bearer ${(sp?.getString("firstTimeToken")).toString()}",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": "true",
            "Content-Type": "application/json",
            "Accept": "*/*",
            "userName": (sp?.getString("email").toString()).toString(),
          },
          body: jsonEncode({
            "userName": (sp?.getString("email").toString()).toString(),
            "type": "LOGIN",
            "otp": otp
          }));

      final result = jsonDecode(res.body);
      if (result['responseCode'].toString() == "200 OK") {
        // buildSnackBar("Message", result['responseMessage'] ?? "");

        // Navigator.pushReplacement(ctx, MaterialPageRoute(builder:(ctx) => const SignupScreen() ));
        Get.off(() => const SignupScreen());

        return ValidateOtpModel.fromJson(result);
      } else {
        buildSnackBar("Message", result['responseMessage'] ?? "");
        return ValidateOtpModel.fromJson(result);
      }
    } catch (e) {
      // print("error in validating otp api $e");
    }
  }

  NumericTextEditingController otpcontroller = NumericTextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                Images.loginbg,
                fit: BoxFit.cover,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints:
                          const BoxConstraints(minHeight: 373, minWidth: 360),
                      height: screenSize.width > screenSize.height
                          ? screenSize.height * 0.7
                          : screenSize.height * 0.6,
                      width: screenSize.width > screenSize.height
                          ? screenSize.width * 0.35
                          : screenSize.width * 0.6,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                            const SizedBox(
                              height: 49,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                screenSize.width > 600
                                    ? const Center(
                                        child: Text(
                                          'We have sent verification code to your registered mobile number',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 13,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Text(
                                          'We have sent verification code to your registered mobile number',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 9,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                // const SizedBox(height: 8,),

                                const SizedBox(height: 24),
                                SizedBox(
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Verification Code',
                                            style: TextStyle(
                                              color: Color(0xFF606060),
                                              fontSize: 13,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                              height: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      SizedBox(
                                        width: 286,
                                        child: PinCodeTextField(
                                          controller: otpcontroller,
                                          appContext: context,
                                          keyboardType: TextInputType.phone,
                                          length: 6,
                                          obscureText: true,
                                          obscuringWidget: const Text(
                                            "●",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          pinTheme: PinTheme(
                                              shape: PinCodeFieldShape.box,
                                              fieldHeight: 33,
                                              fieldWidth: 33,
                                              disabledBorderWidth: 1,
                                              activeBorderWidth: 1,
                                              borderWidth: 1,
                                              inactiveBorderWidth: 1,
                                              selectedBorderWidth: 1,
                                              inactiveColor:
                                                  const Color(0xFF727272),
                                              activeColor: ColorConstant.color1,
                                              selectedColor:
                                                  ColorConstant.color1,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          animationType: AnimationType.fade,
                                          onSubmitted: (String value) {
                                            // if (value == passcode) {
                                            //   Get.to(const ResetPassWordScreen());
                                            // }
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      SizedBox(
                                          width: 284,
                                          height: 31,
                                          child: CustomButton(
                                              text: 'Submit',
                                              ontap: () async {
                                                try {
                                                  if (otpcontroller
                                                      .text.isNotEmpty) {
                                                    validateOtp(
                                                        ctx: context,
                                                        otp: otpcontroller.text
                                                            .toString());
                                                  }
                                                } catch (e) {
                                                  // print("error validating $e");
                                                }
                                              })),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// vijay.lata@shreecement.com
/// Password@123
