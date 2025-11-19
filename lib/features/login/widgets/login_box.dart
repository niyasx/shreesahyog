import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/controller/limitedtextcontroller.dart';
import 'package:shreecement/features/common/screens/home_screen_mis.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/login/controller/login_controller.dart';
import 'package:shreecement/features/login/widgets/inbound_outbound_screen.dart';
import 'package:shreecement/features/login/widgets/otp_box.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

import '../../../utils/color_constant.dart';
import '../../../utils/image_string.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../common/screens/dashboard_screen2.dart';
import '../../common/screens/home_screen.dart';
import '../../common/screens/homesc3.dart';

// ignore: must_be_immutable
class LoginBox extends StatefulWidget {
  const LoginBox({super.key});

  @override
  State<LoginBox> createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  bool loading = false;
  bool isButtonVisible = false;
  final userNameController = LimitedLengthTextController();
  // final userNameController =      TextEditingController(text: "Sarabjeet.Singh@shreecement.co");
  // final error_controller = TextEditingController(); Need to remove
  final LoginControl = Get.put(LoginController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static final Config config = Config(
    tenant: "4e337c10-c06f-4f31-bb24-933689c1056b",
    clientId: "a6d99437-29d9-4910-9b1b-7a362a345e08",
    scope: "openid profile email",
    // redirectUri is Optional as a default is calculated based on app type/web location
    // redirectUri: "your redirect url available in azure portal",
    navigatorKey: navigatorKey,
    webUseRedirect:
        false, // default is false - on web only, forces a redirect flow instead of popup auth
    //Optional parameter: Centered CircularProgressIndicator while rendering web page in WebView
    loader: const Center(child: CircularProgressIndicator()),
    // postLogoutRedirectUri: 'http://your_base_url/logout', //optional
  );

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

  Future<dynamic> validateUser() async {
    String url = "$baseUrl/users/login/user";
    var res = await http.post(Uri.parse(url),
        body: jsonEncode({"emailId": userNameController.text}),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          "Content-Type": "application/json",
          "Accept": "*/*"
        });
    final parsedJson = jsonDecode(res.body);

    if (parsedJson['responseMessage'].toString() == "Valid user") {
      sp?.setString("email", userNameController.text);

      if (parsedJson['firstTimeLogin'].toString() == "true") {
        sp?.setString("firstTimeToken", parsedJson['serviceDTO']['authToken']);
        sp?.setString(
            "firstTimeLogin", parsedJson['firstTimeLogin'].toString());
        sp?.setString("otpToken", parsedJson['serviceDTO']['authToken']);
        Get.to(Otpbox());
      } else {
        LoginControl.toggle();
      }
    } else {
      showAlertDialog("Try again", "${parsedJson['responseMessage']}");
      // error_controller.text = "User id invalid, Please check.";
    }
    return (res.body);
  }



  Future<dynamic> validateUserSSO(
      String? getIdToken, String? getAccessToken) async {
    try {
        String url = "$baseUrl/users/login/authenticatesso";
        var res = await http.post(Uri.parse(url),
            body: jsonEncode({
              "emailId": userNameController.text,
              "authToken": getAccessToken
            }),
            headers: {
              "Authorization": "Bearer $getIdToken",
              "Access-Control-Allow-Origin": "*",
              "Access-Control-Allow-Credentials": "true",
              "Content-Type": "application/json",
              "Accept": "*/*"
            });

        final parsedJson = jsonDecode(res.body);

        if (parsedJson['responseMessage'] == "Valid User") {

           await secureStorage.write("token", parsedJson['serviceDTO']['authToken']);

          // sp?.setString("token", parsedJson['serviceDTO']['authToken']);
          sp?.setString("employeeCode", parsedJson['employeeCode']);
          sp?.setString("roleId", parsedJson['roleId'].toString());
          sp?.setString("roleName", parsedJson['roleName'].toString());
          sp?.setString("email", parsedJson['userName']);
          sp?.setString("userName", parsedJson['userName']);
          sp?.setString("mobileNo", parsedJson["userMobileNo"]);
          sp?.setString("name", parsedJson["employeeName"]);
          sp?.setString("reportAccess",parsedJson['reportAccess'].toString());
          sp?.setString("staffCode", (parsedJson["staffCode"] ?? "").toString());

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
        } else if (parsedJson["responseCode"] == "401 UNAUTHORIZED" ||
            res.statusCode == 401) {
          final AadOAuth oauth = AadOAuth(config);

          oauth.logout();
        } else if (parsedJson["responseCode"] == "404 NOT_FOUND") {
          showAlertDialog("Error", parsedJson['responseMessage'].toString());
        }

      
    } catch (e) {
      // print("Error: $e");
      // showAlertDialog("Error", "An unexpected error occurred.");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final RegExp emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

  @override
  Widget build(BuildContext context) {
    // getUserData();
    Size screenSize = MediaQuery.of(context).size;

    // Request landscape orientation if screenWidth is less than 600
    /* if (screenWidth < 600) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }*/
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(minHeight: 303, minWidth: 360),
            height: screenSize.width > screenSize.height
                ? screenSize.height * 0.6
                : screenSize.height * 0.35,
            width: screenSize.width > screenSize.height
                ? screenSize.width * 0.35
                : screenSize.width * 0.5,
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(114, 114, 114, 1),
                ),
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(255, 255, 255, .80)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Username',
                            style: (TextStyle(
                                color: Color.fromRGBO(97, 97, 97, 1),
                                fontSize: 13,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400)),
                          ),
                          vSpace(2),
                          SizedBox(
                            /* height: 48,*/
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: userNameController,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      constraints: const BoxConstraints(
                                        minHeight: 32,
                                        maxHeight: 32,
                                        minWidth: 286,
                                        maxWidth: 286,
                                      ),
                                      hintText: 'Enter Username',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF727272),
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                      focusColor: ColorConstant.redbar,
                                      border: const OutlineInputBorder()),
                                  onChanged:loading?(text){}:  (text) {
                                    setState(() {
                                      isButtonVisible = text.isNotEmpty;
                                    });
                                  },

                                  ///Code of Enter key in the keyboard 

                                  onFieldSubmitted:loading?null: (value) async {
                                    setState(() {
                                      loading = true;
                                    });
                                    if (formKey.currentState!.validate()) {
                                      //Comment for DEV

                                      // //START
                                      // //sso for both logistics and transporter
                                      if ((userNameController.text.endsWith("@shreecement.com"))||emailRegex.hasMatch(userNameController.text)) {

                                      // // sso for logistics persona only
                                      // if ((userNameController.text.endsWith("@shreecement.com"))) {

                                       ssoAuth();

                                      }
                                      else{
                                        //comment for all user sso
                                      //uncomment if its only for logistics person sso

                                      // await validateUser();

                                      //uncomment for all user sso
                                      //comment if its only for logistics person sso

                                      showAlertDialog("Invalid User",   "Please try again");
                                      }

                                      //END

                                      // Comment for production and QA
                                      //only uncomment when desabling the sso for every user
                                      //START
                                      // await validateUser();
                                      //END
                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          vSpace(25),
                          Visibility(
                            visible: isButtonVisible,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstant.redbar,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  // Adjust the value as needed
                                ),
                              ),


                              /// onpressed code of button ontap
                              onPressed:loading?(){}: () async {
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  if (formKey.currentState!.validate()) {
                                    //Comment for DEV

                                    //START

                                    // //sso for both logistics and transporter
                                    if ((userNameController.text.endsWith("@shreecement.com"))||emailRegex.hasMatch(userNameController.text)) {

                                      // sso for logistics persona only
                                      // if ((userNameController.text.endsWith("@shreecement.com"))) {

                                     ssoAuth();

                                    }
                                    else{
                                      //comment for all user sso
                                      //uncomment if its only for logistics person sso

                                      // await validateUser();

                                      //uncomment for all user sso
                                      //comment if its only for logistics person sso

                                      showAlertDialog("Invalid User",   "Please try again");

                                    }

                                    //END

                                    // Comment for production and QA
                                    //START
                                   //only uncomment when desabling the sso for every user

                                    // await validateUser();

                                    //END
                                  }
                                } finally {
                                  setState(() {
                                    loading = false;
                                  });
                                }
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
                                      'Continue',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                            ),
                          ),

                          //Button for disabled
                          Visibility(
                            visible: !isButtonVisible,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 211, 221, 239),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  // Adjust the value as needed
                                ),
                              ),
                              onPressed: () async {},
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
                                      'Continue',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ssoAuth() async {
    try {
      final AadOAuth oauth = AadOAuth(config);
      final result = await oauth.login();
      result.fold(
        (failure) =>
            showAlertDialog("Oops! something went wrong", "Please try again"),
        (token) => {},
      );

      String? idToken = await oauth.getIdToken();

      String? accessToken = await oauth.getAccessToken();
      await validateUserSSO(idToken, accessToken);
    } catch (e) {
      showAlertDialog("Oops! something went wrong", "Please try again");
    }
  }
}
