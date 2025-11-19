import 'package:flutter/material.dart';
import 'package:shreecement/features/common/widgets/bottombar.dart';

import 'appBar2.dart';

class CustomScaffold extends StatelessWidget {
  String? text;
  Widget? refresh;
  CustomScaffold(
      {super.key,
      required this.body,
      String appBarText = "",
      Widget? refreshButton}) {
    text = appBarText;
    refresh = refreshButton;
  }

  Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBar2(
        appBarText: text!,
        refreshButton: refresh,
      ),
      body: body,
      bottomNavigationBar: const BottomBar(),
    );
  }
}
