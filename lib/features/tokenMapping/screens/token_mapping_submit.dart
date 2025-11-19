import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';

import '../../../utils/color_constant.dart';
import '../../common/controller/controller.dart';

class TokenMappingSubmit extends StatefulWidget {
  const TokenMappingSubmit({super.key});

  @override
  State<TokenMappingSubmit> createState() => _TokenMappingSubmitState();
}

class _TokenMappingSubmitState extends State<TokenMappingSubmit> {
  final control = Get.put(Controller());
  ValueNotifier switchState = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Token Mapping'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tableHeading(heading: "Search DI"),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          labelledCustomDD(
                            label: "State",
                            selVal: "All",
                            list: [
                              "All",
                              "Rajasthan",
                              "Gujarat",
                              "Punjab",
                              "Haryana"
                            ],
                          ),
                          wSpace(20),
                          labelledCustomDD(
                            label: "District",
                            selVal: "All",
                            list: [
                              "All",
                              "Jodhpur",
                              "Jaipur",
                              "Ajmer",
                              "Bikaner"
                            ],
                          ),
                          wSpace(20),
                          labelledCustomDD(
                            label: "City",
                            selVal: "All",
                            list: ["All", "City 2", "City 3", "City 4"],
                          ),
                          wSpace(20),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: ValueListenableBuilder(
                                valueListenable: switchState,
                                builder: (BuildContext context, value,
                                    Widget? child) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: labelledSwitch2(
                                      label: "Show Linked DI",
                                      function: (value) {
                                        switchState.value = value;
                                      },
                                      switchStatus: switchState.value,
                                    ),
                                  );
                                },
                              )),
                        ],
                      ),
                      vSpace(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          button(btnText: "Search", tapFunction: () {}),
                          wSpace(10),
                          button(
                              btnText: "Reset",
                              btnClr: Colors.white,
                              btnTxtClr: ColorConstant.redbar,
                              tapFunction: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              vSpace(20),
              tableHeading(heading: "Deliveries for Bidding"),
              searchBar(size: size.width),
              Container(
                color: Colors.grey.shade200,
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "Sr.",
                                flx: 1,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "City",
                                flx: 3,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "District",
                                flx: 3,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "Consignee",
                                flx: 5,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "DI No.",
                                flx: 3,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "Product",
                                flx: 3,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "Qty",
                                flx: 2,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "Frt. Amt",
                                flx: 3,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "Remarks",
                                flx: 3,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "Taluka",
                                flx: 3,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "State",
                                flx: 3,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "SO Remark",
                                flx: 3,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "Remaining Time",
                                flx: 5,
                                dropdownVis: true,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                            column(
                                colColor: const Color(0xffF6F6F6),
                                columnTitle: "Link",
                                flx: 2,
                                clr: const Color(0xff727272),
                                fntWeight: FontWeight.bold),
                          ],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (_, index) {
                              Color clr;
                              index % 2 != 0
                                  ? clr = const Color(0xffF6F6F6)
                                  : clr = Colors.white;
                              return Row(
                                children: [
                                  column(
                                    colColor: clr,
                                    columnTitle: (index + 1).toString(),
                                    flx: 1,
                                    fntSize: 11,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "Fatehabad",
                                    flx: 3,
                                    fntSize: 11,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "Fatehabad",
                                    flx: 3,
                                    fntSize: 11,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "B20:Bangur Fatehabad",
                                    flx: 5,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "32115645",
                                    flx: 3,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "PPC_ROO",
                                    flx: 3,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "20",
                                    flx: 2,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "699",
                                    flx: 3,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "OPP Gain",
                                    flx: 3,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "Fatehabad",
                                    flx: 3,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "Haryana",
                                    flx: 3,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "PPC+Power",
                                    flx: 3,
                                    clr: const Color(0xff727272),
                                  ),
                                  column(
                                    colColor: clr,
                                    columnTitle: "03:10:00",
                                    flx: 5,
                                    clr: const Color(0xff727272),
                                  ),
                                  iconCell(
                                      colColor: clr,
                                      iconData: index == 0
                                          ? Icons.thumb_up_alt_outlined
                                          : Icons.fire_truck,
                                      icnClr: index == 0
                                          ? Colors.blue
                                          : Colors.green,
                                      icnSize: 18,
                                      flx: 2)
                                ],
                              );
                            }),
                        vSpace(15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 7),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Text("Showing 1 to 10 of 23 entries",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal)),
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
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
