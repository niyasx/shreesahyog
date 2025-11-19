import 'package:flutter/material.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/utils/styletextconstant.dart';

import '../../../utils/image_string.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyCustomAppBar({required this.openDrawer, super.key});
  final VoidCallback openDrawer;

  @override
  Size get preferredSize =>
      const Size.fromHeight(60.0); // Set the preferred height

  @override
  Widget build(BuildContext context) {
    final username = sp?.getString("userName");
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      title: Image.asset(Images.logowhite),
      backgroundColor: ColorConstant.redbar,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Center(
                child: Text(
                  username![0].toUpperCase(),
                  style: StyleText.robotowbold.copyWith(fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              username,
              style: StyleText.robotow40012.copyWith(color: Colors.white),
            ),
            const SizedBox(
              width: 10,
            )
            // IconButton(
            //     onPressed: () {},
            //     icon: const Icon(
            //       Icons.arrow_drop_down_outlined,
            //       color: Colors.white,
            //     ))
          ],
        )
      ],
    );
  }
}
