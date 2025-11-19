import 'package:flutter/material.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/utils/color_constant.dart';

class CustomPopup1 extends StatelessWidget {
  final double? width;
  final double? height;
  final List<Widget>? columnChildrens;
  final String buttonLabel1;
  final String buttonLabel2;
  final String title;
  final VoidCallback ontap1;
  final VoidCallback ontap2;
  const CustomPopup1(
      {super.key,
      this.columnChildrens,
      required this.buttonLabel1,
      required this.buttonLabel2,
      required this.title,
      this.width,
      this.height,
      required this.ontap1,
      required this.ontap2});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        width: width,
        decoration: BoxDecoration(
            border: Border.all(color: ColorConstant.redbar),
            color: Colors.white),
        constraints: const BoxConstraints(maxWidth: 913),
        height: height,
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              color: ColorConstant.redbar,
              height: 32,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              child: Column(
                children: columnChildrens ?? [],
              ),
            ),
            const Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                button(btnText: buttonLabel1, tapFunction: ontap1),
                const SizedBox(width: 8.0),
                button(
                    btnClr: Colors.white,
                    btnTxtClr: ColorConstant.redbar,
                    btnText: buttonLabel2,
                    tapFunction: ontap2),
                const SizedBox(width: 8.0),
              ],
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
