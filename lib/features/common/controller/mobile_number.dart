import 'package:flutter/cupertino.dart';

class MobileTextEditingController extends TextEditingController {
  MobileTextEditingController({String? text}) : super(text: text?.toString()) {
    addNumericListener();
  }

  void addNumericListener() {
    addListener(() {
      // Filter out non-numeric input
      String text = this.text;

      // Check if the length exceeds 10 characters
      if (text.length > 10) {
        // Truncate the input to the first 10 characters
        text = text.substring(0, 10);

        // Update the controller's text
        value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }

      // Check for non-numeric input
      if (text.isNotEmpty && int.tryParse(text) == null) {
        // Non-numeric input detected, clear the field
        clear();
      }
    });
  }
}
