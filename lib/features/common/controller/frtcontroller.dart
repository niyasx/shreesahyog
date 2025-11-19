// import 'package:flutter/cupertino.dart';
//
// class FrtNumericTextEditingController extends TextEditingController {
//   final bool isTogglePlus; // Add this line
//
//   FrtNumericTextEditingController({
//     double? text,
//     required this.isTogglePlus, // Add this line
//   }) : super(text: text?.toString()) {
//     addNumericListener();
//   }
//
//   void addNumericListener() {
//     addListener(() {
//       // Filter out non-numeric input
//       final text = this.text;
//       isTogglePlus=getincdec(index);
//       if (text.isNotEmpty) {
//         final numericValue = double.tryParse(text);
//         if (numericValue == null ||
//             (isTogglePlus && (numericValue <= 250.0 || numericValue >= 300.0)) ||
//             (!isTogglePlus && (numericValue != 250.0))) {
//           // Non-numeric or invalid input detected, clear the field
//           clear();
//         }
//       }
//     });
//   }
// }
