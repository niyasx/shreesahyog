import 'package:flutter/material.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/utils/styletextconstant.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: ColorConstant.lightgrey,
      height: 40,
      child: Center(
        child: Text(
          'Copyright\u00A9  |  Contact Us',
          style: StyleText.robotow40012.copyWith(color: ColorConstant.redbar),
        ),
      ),
    );
  }
}
