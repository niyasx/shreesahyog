// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shreecement/features/common/widgets/customdrawer.dart';
import 'package:shreecement/features/login/widgets/custom_button.dart';
import 'package:shreecement/global.dart';
import '../../../utils/image_string.dart';
import '../../login/screens/login_screen.dart';

class TokenExpire extends StatelessWidget {
  const TokenExpire({super.key});

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
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints:
                        const BoxConstraints(minHeight: 303, minWidth: 360),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Center(
                                child: Text(
                                  'Sorry!, your session has expired.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              // const SizedBox(height: 8,),

                              const SizedBox(height: 12),
                              const Text(
                                'Please log in again to continue using our services.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: 284,
                                        height: 31,
                                        child: CustomButton(
                                            text: 'Login',
                                            ontap: () {
                                              logoutUser();
                                              logout();

                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()),
                                              );
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// vijay.lata@shreecement.com
/// Password@123
