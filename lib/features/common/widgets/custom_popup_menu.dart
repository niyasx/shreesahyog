import 'package:flutter/material.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';

import '../../../utils/color_constant.dart';

class CustomPopup extends StatelessWidget {
  final double? width;
  final double? height;
  final List<Widget>? columnChildrens;
  final Widget buttonWidget;
  final String buttonLabel2;
  final String title;
  const CustomPopup(
      {super.key,
      this.columnChildrens,
      required this.buttonWidget,
      required this.buttonLabel2,
      required this.title,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SingleChildScrollView(
        child: Container(
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: ColorConstant.redbar),
            color: Colors.white,
          ),
          constraints: const BoxConstraints(
              maxWidth: 913, minHeight: 380, minWidth: 360),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buttonWidget,
                    const SizedBox(width: 8.0),
                    button(
                        btnText: buttonLabel2,
                        tapFunction: () {
                          Navigator.pop(context);
                        }),
                    const SizedBox(width: 8.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class CustomPopupAdmin extends StatelessWidget {
  final double? width;
  final double? height;
  final List<Widget>? columnChildrens;
  final Widget buttonWidget;
  final String buttonLabel2;
  final String title;
  const CustomPopupAdmin(
      {super.key,
        this.columnChildrens,
        required this.buttonWidget,
        required this.buttonLabel2,
        required this.title,
        this.width,
        this.height});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SingleChildScrollView(
        child: Container(
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: ColorConstant.redbar),
            color: Colors.white,
          ),
          constraints: const BoxConstraints(
              maxWidth: 913, minHeight: 380, minWidth: 360),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttonWidget,
                    const SizedBox(width: 8.0),
                    button(
                        btnText: buttonLabel2,
                        tapFunction: () {
                          Navigator.pop(context);
                        }),
                    const SizedBox(width: 8.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}