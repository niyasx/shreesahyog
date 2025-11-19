import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/screens/dashboard_screen2.dart';
import 'package:shreecement/features/common/screens/home_screen_mis.dart';
import 'package:shreecement/features/common/screens/homesc3.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/login/controller/login_controller.dart';
import 'package:shreecement/features/login/widgets/inbound_outbound_screen.dart';
import 'package:shreecement/features/login/widgets/otp_box.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/features/common/screens/home_screen.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/image_string.dart';

class LoginBox2 extends StatefulWidget {
  const LoginBox2({super.key});

  @override
  State<LoginBox2> createState() => _LoginBox2State();
}

class _LoginBox2State extends State<LoginBox2> {
  bool isButtonVisible = false;
  bool loading = false;
  final userNameController = TextEditingController();
  // final userNameController = TextEditingController(text: "Sarabjeet.Singh@shreecement.com");
  final passwordCOntroller = TextEditingController();
  // final passwordCOntroller = TextEditingController(text: "Password@123");
  Future<void> showResetPasswordDialog(String title, String message) async {
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
                Get.to(Otpbox());
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showAlertDialog(String title, String message) async {
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

  Future<dynamic> authenticateUser() async {
    try {
      String url = "$baseUrl/users/login/authenticate";
      var res = await http.post(Uri.parse(url),
          body: jsonEncode({
            "emailId": userNameController.text,
            "password": passwordCOntroller.text
          }),
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": "true",
            "Content-Type": "application/json",
            "Accept": "*/*"
          });
      final parsedJson = jsonDecode(res.body);

       if (parsedJson['responseCode'].toString() ==
          "403 FORBIDDEN") {
        showAlertDialog("Try again", "${parsedJson['responseMessage']}");
      } else if (parsedJson['responseMessage'].toString() ==
          "Password Expired. Please reset the password to continue") {
        showResetPasswordDialog(
            "Reset Password", "${parsedJson['responseMessage']}");
      } else if (parsedJson['responseMessage'].toString() == "User not found") {
        showAlertDialog("Try again", "${parsedJson['responseMessage']}");
      } else if (parsedJson['responseMessage'].toString() == "null") {

        await secureStorage.write("token", parsedJson['serviceDTO']['authToken']);

        // sp?.setString("token", parsedJson['serviceDTO']['authToken']);
        sp?.setString("employeeCode", parsedJson['employeeCode']);
        sp?.setString("emailId", parsedJson['emailId'].toString());
        sp?.setString("roleId", parsedJson['roleId'].toString());
        sp?.setString("roleName", parsedJson['roleName'].toString());
        sp?.setString("userName", parsedJson['userName'].toString());
        sp?.setString("reportAccess",parsedJson['reportAccess'].toString());
        sp?.setString("mobileNo", (parsedJson["userMobileNo"] ?? "").toString());
        sp?.setString("name", parsedJson["employeeName"]);
        sp?.setString("staffCode", (parsedJson["staffCode"] ?? "").toString());

         String? token = await secureStorage.read("token");
      debugPrint("Token saved to secure storage: $token");


          sp?.remove("transportType");
        if (parsedJson['firstTimeLogin'].toString() == "false") {
          if (parsedJson['roleId'] == 3 || parsedJson['roleId'] == 5) {
            //transporter and transporter staff
              Get.off(() => const TransportOptionScreen());
          } else if (parsedJson['roleId'] == 2||parsedJson['roleId'] == 1) {
            //admin and super admin
            Get.off(() => const HomeScreen3());
          } else if(parsedJson['roleId'] == 6){
            //MIS User
            Get.off(() => const HomeScreen4());
          }else {
            //logistics persona
            Get.off(() => HomeScreen());
          }
        }
        return (res.body);
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    userNameController.text = (sp?.getString("email").toString()).toString();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            constraints: const BoxConstraints(minHeight: 380, minWidth: 360),
            height: screenSize.width > screenSize.height
                ? screenSize.height * 0.7
                : screenSize.height * 0.3,
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(
                  //   height: 20,
                  // ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Form(
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
                                height: 34,
                                width: 286,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: userNameController,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 8, top: 8, bottom: 5),
                                      hintText: 'Entered Username',
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
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
                                height: 32,
                                width: 286,
                                child: TextFormField(
                                    obscureText: true,
                                    controller: passwordCOntroller,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 8, top: 8, bottom: 6),
                                        hintText: 'Enter Password',
                                        hintStyle: TextStyle(
                                          color: Color(0xFF727272),
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          height: 0.09,
                                        ),
                                        border: OutlineInputBorder()),
                                    onChanged: (text) {
                                      setState(() {
                                        isButtonVisible = text.isNotEmpty;
                                      });
                                    },
                                    onFieldSubmitted:loading? (text){} : (value) async {
                                      setState(() {
                                        loading=true;
                                      });
                                      await authenticateUser();

                                      setState(() {
                                        loading=false;
                                      });
                                    }),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: !sp!
                                    .getString("email")
                                    .toString()
                                    .contains("shreecement.com"),
                                child: InkWell(
                                  onTap: () {
                                    // Get.to(() => const OTPVerificationScreen());
                                    Get.to(() => Otpbox());
                                  },
                                  child: Text(
                                    'To reset your password, click here?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.color1,
                                        decoration: TextDecoration.underline,
                                        decorationColor: ColorConstant.color1),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Visibility(
                                    visible: isButtonVisible,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorConstant.redbar,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          // Adjust the value as needed
                                        ),
                                      ),
                                      onPressed:loading?(){}: () async {
                                        setState(() {
                                          loading = true;
                                        });
                                        await authenticateUser();

                                        setState(() {
                                          loading = false;
                                        });
                                      },
                                      child: loading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            ) // Show loader while loading
                                          : const Text(
                                              'Login',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w100,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !isButtonVisible,
                                    child: button(
                                        btnText: "Login",
                                        btnClr: const Color.fromARGB(
                                            255, 211, 216, 239),
                                        tapFunction: () async {}),
                                  ),
                                  wSpace(10),
                                  button(
                                      btnText: "Clear",
                                      btnClr: Colors.white,
                                      btnTxtClr: ColorConstant.redbar,
                                      tapFunction: () {
                                        // Get.to(const SignupScreen());
                                        final LoginControl =
                                            Get.put(LoginController());
                                        LoginControl.toggle();
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
