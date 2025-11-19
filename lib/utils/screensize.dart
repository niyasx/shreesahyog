import 'package:flutter/material.dart';

class ScreenSize {
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;

  static init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}
