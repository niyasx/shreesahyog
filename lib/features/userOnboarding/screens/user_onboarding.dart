import 'package:flutter/material.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/userOnboarding/widgets/usertable.dart';

class UserOnBoarding extends StatelessWidget {
  const UserOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage Users',
            style: TextStyle(
                fontSize: 21,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w100),
          ),
          vSpace(20),
          const UserTable(),
        ],
      ),
    ));
  }
}
