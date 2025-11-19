import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/color_constant.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.text, required this.ontap})
      : super(key: key);

  final String text;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          ontap();
        }
      },
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.redbar,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            // Adjust the value as needed
          ),
        ),
        onPressed: ontap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
    );
  }
}
