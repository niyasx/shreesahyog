import 'package:flutter/material.dart';

import '../../../global.dart';

class LimitedLengthTextController extends TextEditingController {
  LimitedLengthTextController(
      {String? text, int maxLength = character_length}) {
    this.text = text ?? '';

    addListener(() {
      // Trim the text if it exceeds the maximum length
      if (value.text.length > maxLength) {
        value = value.copyWith(
          text: value.text.substring(0, maxLength),
          selection: TextSelection.collapsed(offset: maxLength),
          composing: TextRange.empty,
        );
      }
    });
  }
}

class LimitedLengthTextController100 extends TextEditingController {
  LimitedLengthTextController100({String? text, int maxLength = 100}) {
    this.text = text ?? '';

    addListener(() {
      // Trim the text if it exceeds the maximum length
      if (value.text.length > maxLength) {
        value = value.copyWith(
          text: value.text.substring(0, maxLength),
          selection: TextSelection.collapsed(offset: maxLength),
          composing: TextRange.empty,
        );
      }
    });
  }
}
