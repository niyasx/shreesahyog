import 'package:flutter/material.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/table/user_data.dart';

import '../../../utils/color_constant.dart';

class UserTable extends StatelessWidget {
  const UserTable({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffE2E2E2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tableHeading(heading: "Users List"),
          vSpace(20),
          searchBar(size: size.width),
          vSpace(20),
          Row(
            children: [
              column(
                  columnTitle: "Sr. No.",
                  dropdownVis: false,
                  flx: 1,
                  colColor: const Color(0xffF6F6F6)),
              column(
                  columnTitle: "Name",
                  dropdownVis: true,
                  flx: 3,
                  colColor: const Color(0xffF6F6F6)),
              column(
                  columnTitle: "Role",
                  dropdownVis: true,
                  flx: 3,
                  colColor: const Color(0xffF6F6F6)),
              column(
                  columnTitle: "Organization",
                  dropdownVis: true,
                  flx: 3,
                  colColor: const Color(0xffF6F6F6)),
              column(
                  columnTitle: "Geography",
                  dropdownVis: true,
                  flx: 3,
                  colColor: const Color(0xffF6F6F6)),
              column(
                  columnTitle: "Status",
                  dropdownVis: true,
                  flx: 3,
                  colColor: const Color(0xffF6F6F6)),
              column(
                  columnTitle: "Actions",
                  dropdownVis: false,
                  flx: 3,
                  colColor: const Color(0xffF6F6F6)),
            ],
          ),
          ListView.builder(
              itemCount: 10,
              itemBuilder: (_, index) {
                Color clr;
                index % 2 != 0
                    ? clr = const Color(0xffF6F6F6)
                    : clr = Colors.white;
                return Row(
                  children: [
                    userRow(
                      userCellClr: clr,
                      sno: UserData().userData[index]["sno"],
                      name: UserData().userData[index]["name"],
                      role: UserData().userData[index]["role"],
                      org: UserData().userData[index]["org"],
                      geo: UserData().userData[index]["geo"],
                      status: UserData().userData[index]["status"],
                    ),
                  ],
                );
              }),
          Container(
            color: Colors.grey.shade200,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                          "Showing 1 to 10 of ${UserData().userData.length} entries",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Roboto")),
                    ),
                    Row(
                      children: [
                        navBox(boxWidth: 70, text: "Previous"),
                        navBox(
                            boxWidth: 25,
                            text: "1",
                            txtClr: Colors.white,
                            bgClr: ColorConstant.redbar),
                        navBox(
                            boxWidth: 25,
                            text: "2",
                            txtClr: ColorConstant.redbar),
                        navBox(
                            boxWidth: 25,
                            text: "3",
                            txtClr: ColorConstant.redbar),
                        navBox(
                            boxWidth: 50,
                            text: "Next",
                            txtClr: ColorConstant.redbar),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
