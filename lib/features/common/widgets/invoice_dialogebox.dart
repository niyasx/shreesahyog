import 'package:flutter/material.dart';

import '../../../utils/color_constant.dart';

class InvoicePopup extends StatelessWidget {
  final double? width;
  final double? height;
  final List<Widget>? columnChildrens;
  final List<Widget>? buttons;

  final String title;

  const InvoicePopup({
    super.key,
    this.columnChildrens,
    required this.title,
    this.width,
    this.height,
    required this.buttons,
  });

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

        constraints:
            const BoxConstraints(maxWidth: 913, minHeight: 380, minWidth: 360),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                      iconSize: 20,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Column(
                children: columnChildrens ?? [],
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: buttons ?? []),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
