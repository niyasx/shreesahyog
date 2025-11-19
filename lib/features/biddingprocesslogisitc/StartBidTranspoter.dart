import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/biddingProcess/api/transporter_apis.dart';
import 'package:shreecement/features/biddingProcess/models/startbid_transporter_model.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/main.dart';
import '../../utils/color_constant.dart';
import '../common/controller/controller.dart';
import '../common/table/table_widgets.dart';
import '../common/widgets/customdropdownprebid.dart';

class StartBidTransporter extends StatefulWidget {
  const StartBidTransporter({super.key});

  @override
  State<StartBidTransporter> createState() => _StartBidTransporterState();
}

class _StartBidTransporterState extends State<StartBidTransporter> {
  final control = Get.put(Controller());
  RxBool loaderScreen = false.obs;

  List<TransportResponseList> originaltransporterBidList = [];
  ValueNotifier<List<TransportResponseList>> transporterbidtResponseList =
      ValueNotifier([]);
  ValueNotifier<List<TransportResponseList>> transporterbidtResponseList1 =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    fetchPreBidList();
  }

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);

  List<TransportResponseList> getCurrentPageItems(
      List<TransportResponseList> items, int currentPage) {
    transporterbidtResponseList.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<TransportResponseList> a = items.sublist(startIndex, endIndex);

    return a;
  }

  fetchPreBidList() async {
    // loaderScreen.value = true;

    final StartBidTransporterModel response = 
    // getJsonMapStartBid();

        await TransporterApi().getTransporterBidData(context);
    originaltransporterBidList = response.responseList ?? [];
    // loaderScreen.value = false;
    transporterbidtResponseList1.value =
        getCurrentPageItems(originaltransporterBidList, currentPage);
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      transporterbidtResponseList1.value =
          getCurrentPageItems(originaltransporterBidList, currentPage);
      return;
    }

    List<TransportResponseList> filteredData = originaltransporterBidList
        .where((value) =>
            value.plantId
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.division
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.stateId
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.plantName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    transporterbidtResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 10) * (100 / 6)) / 100;

    return CustomScaffold(
      appBarText: "Bidding Process > View Bid ",
      refreshButton: IconButton(
        iconSize: 30,
        color: ColorConstant.redbar,
        tooltip: "Refresh",
        icon: const Icon(Icons.refresh_sharp),
        onPressed: () async {
          await fetchPreBidList();
        },
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'View Bid',
                    style: TextStyle(
                        fontSize: 21,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100),
                  ),
                  vSpace(20),
                  tableHeading(heading: "Organisation List"),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        color: const Color(0xffE2E2E2),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Row(
                                    children: [
                                      const Text("Display",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto')),
                                      wSpace(6),
                                      SizedBox(
                                          width: 65,
                                          height: 22,
                                          child: PreCustomDropdownMenu(
                                            selVal: selectedDropdownValue,
                                            list: const [
                                              "10",
                                              "20",
                                              "30",
                                              "50",
                                              "100"
                                            ],
                                            onChanged: (value) async {
                                              // Update the selected value when the dropdown changes
                                              setState(() {
                                                selectedDropdownValue = value;
                                                pageSize = int.parse(value);
                                                currentPage = 1;
                                              });
                                              await fetchPreBidList();
                                            },
                                          )),
                                      wSpace(6),
                                      size.width > 600
                                          ? const Text("records",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12))
                                          : Container(),
                                    ],
                                  ),
                                ),
                                const Text("Search",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "RobotoLight")),
                                wSpace(10),
                                SizedBox(
                                  height: 22,
                                  width: 110,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  //   border: Border.all(
                                  //     width: 0.5,
                                  //   ),
                                  //   color: Colors.white,
                                  // ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.5,
                                            color: Colors.grey.shade600),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffA0A0A0)),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 5),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.multiline,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        textBaseline: TextBaseline.alphabetic,
                                        fontWeight: FontWeight.w100),
                                    onChanged: (val) {
                                      filterData(val);
                                    },
                                  ),
                                ),
                              ],
                            )),
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      column(
                          colColor: const Color(0xffF6F6F6),
                          columnTitle: "Sr. No.",
                          wdt: dynamicSize,
                          // flx: 1,
                          hgt1: 45,
                          clr: const Color(0xff727272),
                          fntWeight: FontWeight.bold),
                      column(
                          colColor: const Color(0xffF6F6F6),
                          columnTitle: "Org Code",
                          dropdownVis: true,
                          flx: 3,
                          hgt1: 45,
                          clr: const Color(0xff727272),
                          fntWeight: FontWeight.bold),
                      column(
                          colColor: const Color(0xffF6F6F6),
                          columnTitle: "Organisation Name",
                          dropdownVis: true,
                          flx: 5,
                          hgt1: 45,
                          clr: const Color(0xff727272),
                          fntWeight: FontWeight.bold),
                      column(
                          colColor: const Color(0xffF6F6F6),
                          columnTitle: "Division",
                          dropdownVis: true,
                          flx: 5,
                          hgt1: 45,
                          clr: const Color(0xff727272),
                          fntWeight: FontWeight.bold),
                      column(
                          colColor: const Color(0xffF6F6F6),
                          columnTitle: "Deliveries For Bidding",
                          dropdownVis: true,
                          flx: 4,
                          hgt1: 45,
                          clr: const Color(0xff727272),
                          fntWeight: FontWeight.bold),
                      column(
                          colColor: const Color(0xffF6F6F6),
                          columnTitle: "Actions",
                          flx: 2,
                          hgt1: 45,
                          clr: const Color(0xff727272),
                          fntWeight: FontWeight.bold),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: transporterbidtResponseList1,
                    builder: (BuildContext context,
                        List<TransportResponseList> value, Widget? child) {
                      if (value.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text("No data found"),
                          ),
                        );
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.length,
                          itemBuilder: (_, index) {
                            Color clr;
                            index % 2 != 0
                                ? clr = const Color(0xffF6F6F6)
                                : clr = Colors.white;
                            return Row(
                              children: [
                                column(
                                    colColor: clr,
                                    columnTitle:
                                        "${((currentPage - 1) * int.parse(selectedDropdownValue)) + index + 1}",
                                    flx: 1,
                                    fntWeight: FontWeight.normal,
                                    clr: const Color(0xff727272)),
                                column(
                                    colColor: clr,
                                    columnTitle:
                                        value[index].plantId.toString(),
                                    flx: 3,
                                    fntWeight: FontWeight.normal,
                                    clr: const Color(0xff727272)),
                                column(
                                    colColor: clr,
                                    columnTitle: value[index].plantName ?? "",
                                    flx: 5,
                                    fntWeight: FontWeight.normal,
                                    clr: const Color(0xff727272)),
                                column(
                                    colColor: clr,
                                    columnTitle: value[index].division ?? "",
                                    flx: 5,
                                    fntWeight: FontWeight.normal,
                                    clr: const Color(0xff727272)),
                                column(
                                    selectable: false,
                                    colColor: clr,
                                    columnTitle:
                                        value[index].diNumber.toString(),
                                    clr: ColorConstant.redbar,
                                    flx: 4,
                                    fntWeight: FontWeight.normal,
                                    funx: () {
                                      sp?.setInt(
                                          "plantId", value[index].plantId!);
                                      sp?.setString("plantCode",
                                          "${value[index].plantId}");
                                      sp?.setString("PlantName",
                                          "${value[index].plantName}");
                                      sp?.setString("division",
                                          "${value[index].division}");
                                      control.currentIndex.value = 8;
                                      // control.preBid2PlantId.value =
                                      //     "${value[index].plantId}";
                                    }),
                                imgCell(
                                    colColor: clr,
                                    flx: 2,
                                    imgPath: "assets/images/searchicon.png",
                                    icnClr: const Color(0xff0055D5),
                                    icnSize: 21,
                                    tapAction: () {
                                      sp?.setInt(
                                          "plantId", value[index].plantId!);
                                      sp?.setString("plantCode",
                                          "${value[index].plantId}");
                                      sp?.setString("PlantName",
                                          "${value[index].plantName}");
                                      sp?.setString("division",
                                          "${value[index].division}");
                                      control.currentIndex.value = 8;
                                    }),
                              ],
                            );
                          });
                    },
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        child: Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: transporterbidtResponseList,
                              builder: (BuildContext context,
                                  List<TransportResponseList> value,
                                  Widget? child) {
                                if (value.isEmpty) {
                                  return Container();
                                } else {}
                                return Expanded(
                                  flex: 2,
                                  child: Text(
                                      "Showing 1 to ${transporterbidtResponseList1.value.length} of ${value.length} entries",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal)),
                                );
                              },
                            ),
                            buildValueListenableBuilder()
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => Visibility(
                visible: loaderScreen.value,
                child: Container(
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.redbar,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  ValueListenableBuilder<List<TransportResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: transporterbidtResponseList,
      builder: (BuildContext context, List<TransportResponseList> value,
          Widget? child) {
        if (value.isEmpty) {
          return Center(child: Container());
        }

        int itemsPerPage = int.parse(selectedDropdownValue);
        int numberOfPages = (value.length / itemsPerPage).ceil();

        // Calculate the range of pages to display
        int startPage = (currentPage - 2).clamp(1, numberOfPages);
        int endPage = (currentPage + 2).clamp(1, numberOfPages);

        List<Widget> pageWidgets = [];

        // Add "Previous" button if necessary
        if (currentPage > 1) {
          pageWidgets.add(
            Container(
              margin: const EdgeInsets.only(right: 1),
              child: InkWell(
                child: navBox(
                    boxWidth: 70,
                    text: "Previous",
                    txtClr: ColorConstant.redbar,
                    bgClr: Colors.white),
                onTap: () async {
                  currentPage--;
                  await fetchPreBidList();
                },
              ),
            ),
          );
        }

        // Add the page buttons
        for (int i = startPage; i <= endPage; i++) {
          Color color =
              (currentPage == i) ? Colors.white : ColorConstant.redbar;
          Color bgClr =
              (currentPage == i) ? ColorConstant.redbar : Colors.white;

          pageWidgets.add(
            InkWell(
              child: navBox(
                  boxWidth: 25,
                  text: i.toString(),
                  txtClr: color,
                  bgClr: bgClr),
              onTap: () async {
                currentPage = i;
                await fetchPreBidList();
              },
            ),
          );
        }

        // Add "Next" button if necessary
        if (endPage < numberOfPages) {
          pageWidgets.add(
            Container(
              margin: const EdgeInsets.only(left: 1),
              child: InkWell(
                child: navBox(
                    boxWidth: 70,
                    text: "Next",
                    txtClr: ColorConstant.redbar,
                    bgClr: Colors.white),
                onTap: () async {
                  currentPage++;
                  await fetchPreBidList();
                },
              ),
            ),
          );
        }

        return Row(
          children: pageWidgets,
        );
      },
    );
  }
}


const  dynamic startBidJson = {
    "responseMessage": "Plant wise DiDeliveries List",
    "responseCode": "200",
    "serviceDTO": null,
    "serviceDTOList": null,
    "responseList": [
        {
            "plantId": 1005,
            "plantName": "SCL-Khushkhera",
            "division": "Cement",
            "diNumber": "1231",
            "bidLotId": "LOT_ID_1005_2504171457723",
            "rownumber": 1
        }
    ]
};

  getJsonMapStartBid() {
    return StartBidTransporterModel.fromJson(startBidJson) ;
  }