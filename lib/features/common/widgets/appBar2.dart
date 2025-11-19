import 'package:flutter/material.dart';

class MyCustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  String? text;
  Widget? refresh;
  MyCustomAppBar2({super.key, String appBarText = "", Widget? refreshButton}) {
    text = appBarText;
    refresh = refreshButton;
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(50.0); // Set the preferred height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text!,
            style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          refresh ?? const Text("")
        ],
      ),
      backgroundColor: const Color.fromRGBO(211, 216, 239, 1.0),
    );
  }
}
