import 'package:flutter/cupertino.dart';

class NumericTextEditingController extends TextEditingController {
  NumericTextEditingController({int? text}) : super(text: text?.toString()) {
    addNumericListener();
  }

  void addNumericListener() {
    addListener(() {
      // Filter out non-numeric input
      String text = this.text;
      if (text.isNotEmpty && int.tryParse(text) == null) {
        // Non-numeric input detected, clear the field

        clear();
      }
    });
  }
}
