import 'package:flutter/cupertino.dart';

class DoubleNumericTextEditingController extends TextEditingController {
  DoubleNumericTextEditingController({double? text})
      : super(text: text?.toString()) {
    addNumericListener();
  }

  void addNumericListener() {
    addListener(() {
      // Filter out non-numeric input and restrict to 10 digits
      String text = this.text;
      if (text.isNotEmpty) {
        double? parsed = double.tryParse(text);
        if (parsed == null || text.length > 12) {
          // Non-numeric input detected or length exceeds 10 digits
          // Remove last entered character
          this.text = text.substring(0, text.length - 1);
          // Set cursor to the end of the text
          selection = TextSelection.fromPosition(
              TextPosition(offset: this.text.length));
        } else {
          // Keep only two digits after the decimal point
          int dotIndex = text.indexOf('.');
          if (dotIndex != -1 && text.length - dotIndex > 3) {
            double rounded = double.parse(parsed.toStringAsFixed(2));
            this.text = rounded.toString();
            // Set cursor after the last digit
            selection = TextSelection.fromPosition(
                TextPosition(offset: this.text.length));
          }
        }
      }
    });
  }
}
