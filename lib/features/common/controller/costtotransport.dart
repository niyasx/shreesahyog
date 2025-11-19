import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CtPNumericTextEditingController extends TextEditingController {
  final double? initialValue;
  final double? maxValue;

  CtPNumericTextEditingController({this.initialValue, required this.maxValue})
      : super(text: initialValue?.toString()) {
    addNumericListener();
  }

  void addNumericListener() {
    addListener(() {
      // Filter out non-numeric input
      var text = this.text;

      if (text.isNotEmpty && double.tryParse(text) == null) {
        // Non-numeric input detected, clear the field
        clear();
      } else {
        // Numeric input detected, check against the maxValue
        final double? numericValue = double.tryParse(text);

        if (numericValue != null && numericValue > maxValue!) {
          // Exceeds the maximum value, set to the maximum value
          text = maxValue.toString();
          value = TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
          // buildSnackBar("Input is not valid", "Cost to Transport can not be greater than Freight amount");
          Get.defaultDialog(
            title: "Invalid Input",
            content: Text("Cost to Transport can not be greater than $text"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: const Text("OK"),
              ),
            ],
          );
        }
      }
    });
  }
}
