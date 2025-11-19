// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/preBidding/preBidding2/api/pre_bid_2_api.dart';
import 'package:shreecement/features/preBidding/preBidding2/apiModels/pre_bid_2_model.dart';
import 'package:shreecement/main.dart';

import '../../utils/color_constant.dart';
import '../common/api/businesslogicapi.dart';
import '../common/models/business_rules.dart';
import '../common/widgets/customdropdownprebid.dart';

class StartBidLogisticsActionScreen extends StatefulWidget {
  const StartBidLogisticsActionScreen({
    super.key,
  });

  @override
  State<StartBidLogisticsActionScreen> createState() =>
      StartBidLogisticsActionScreenState();
}

class StartBidLogisticsActionScreenState
    extends State<StartBidLogisticsActionScreen> {
  final Controller control = Get.find(); // Access the controller

  ValueNotifier<MapEntry<String, String>> selectedState =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedDistrict =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedCity =
      ValueNotifier(const MapEntry("", ""));

  RxInt currentPagination = 1.obs;
  String searchValue = "";

  late String plantId;
  late String division;
  late BusinessRules businesrules;
  RxBool loaderScreen = false.obs;

  List<PreBid2ModelResponseList> originalPreBidList = [];
  ValueNotifier<List<PreBid2ModelResponseList>> preBidListResponseList =
      ValueNotifier([]);
  ValueNotifier<List<PreBid2ModelResponseList>> preBidListResponseList1 =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    plantId = sp?.getString("startBIdPlant") ?? "";
    division = sp?.getString("selectedDivisionStartBid") ?? "";
    fetchBusinessLogic();
    fetchPreBidList();
  }

  fetchBusinessLogic() async {
    businesrules = await BusinessLogic().getbusinesslogiclist(
        plantCode: sp!.getString("startBIdPlant").toString(), ctx: context);

    sp?.setString("manualReBidTime",
        businesrules.responseList![0].manualRebidTime.toString());
  }

  fetchPreBidList() async {
    loaderScreen.value = true;
    final PreBid2Model response = await PreBid2API().getPreBid2DataFromAPI(pageType: "STARTBID",
      context: context,
      employeeCode: sp?.getString("employeeCode") ?? "",
      roleId: int.parse(sp?.getString("employeeCode") ?? ""),
      plantId: plantId,
      division: [division],
      diType: sp?.getString("diType") ?? "",
      stateName:
          selectedState.value.key == "All" ? "" : selectedState.value.key,
      stateCode:
          selectedState.value.value == "All" ? "" : selectedState.value.value,
      districtName:
          selectedDistrict.value.key == "All" ? "" : selectedDistrict.value.key,
      districtCode: selectedDistrict.value.value == "All"
          ? ""
          : selectedDistrict.value.value,
      cityName: selectedCity.value.key == "All" ? "" : selectedCity.value.key,
      cityCode:
          selectedCity.value.value == "All" ? "" : selectedCity.value.value,
    );
    loaderScreen.value = false;

    originalPreBidList = response.responseList ?? [];
    preBidListResponseList.value = List.from(originalPreBidList);
    preBidListResponseList1.value =
        getCurrentPageItems(preBidListResponseList.value, currentPage);
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      preBidListResponseList1.value =
          getCurrentPageItems(originalPreBidList, currentPage);
      return;
    }

    List<PreBid2ModelResponseList> filteredData = originalPreBidList
        .where((value) =>
            value.stateName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.districtName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.talukaName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.cityName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.customerName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.product
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.soBiddingRemarks
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    preBidListResponseList.value = filteredData;
    preBidListResponseList1.value =
        getCurrentPageItems(preBidListResponseList.value, currentPage);
  }

  // int totalPages = 10;
  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);

  List<PreBid2ModelResponseList> getCurrentPageItems(
      List<PreBid2ModelResponseList> items, int currentPage) {
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    return items.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 10) * (100 / 14)) / 100;
    return CustomScaffold(
      appBarText: "Deliveries For Bidding",
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deliveries For Bidding ${sp?.getString("plantName")} &  ${sp?.getString("division1")}',
                    style: const TextStyle(
                        fontSize: 21,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100),
                  ),
                  vSpace(20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.0, // Horizontal spacing between items
                          runSpacing: 8.0,
                          children: [
                            SizedBox(
                              width: 191,
                              child: button(
                                  btnText: "View Unlinked Deliveries",
                                  btnClr: Colors.white,
                                  btnTxtClr: ColorConstant.redbar,
                                  tapFunction: () {
                                    control.currentIndex.value = 9;
                                  }),
                            ),
                            SizedBox(
                              width: 100,
                              child: button(
                                  btnText: sp?.getString("bidStatus") ==
                                              "MANUAL_SCHEDULED" ||
                                          sp?.getString("bidStatus") ==
                                              "AUTO_SCHEDULED"
                                      ? "View Bid"
                                      : "Start Bid",
                                  tapFunction: () {
                                    // // print(sp?.getString("bidStatus"));
                                    // // print( "in build timer value ${sp?.getString("scheduledtime")??""}");

                                    control.currentIndex.value = 6;
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  vSpace(20),
                  tableHeading(heading: "Deliveries for Bidding"),
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
                  ValueListenableBuilder(
                    valueListenable: preBidListResponseList1,
                    builder: (BuildContext context,
                        List<PreBid2ModelResponseList> data, Widget? child) {
                      if (data.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text("No data found"),
                          ),
                        );
                      }
                      return CustomTable(
                        columns: [
                          DataColumn(
                            label: TableColumn(
                              "Sr.No",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "State",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "District",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Taluka",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "City",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Consignee",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                           DataColumn(
                            label: TableColumn(
                              "Consignee Address",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ), 
                          DataColumn(
                            label: TableColumn(
                              "DI No.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                           DataColumn(
                            label: TableColumn(
                              "SO/STO Number",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Product.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Qty",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Frt. Amt.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Extra Frt.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "New Frt. Amt.",
                              heading: true,
                              dropdown: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Remark.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Bid Remark.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "SO Remark.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                        ],
                        rows: List.generate(
                          data.length,
                          (index) => DataRow(
                            cells: [
                              DataCell(
                                TableColumn(
                                  "${((currentPage - 1) * int.parse(selectedDropdownValue)) + index + 1}",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].stateName ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].districtName ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].talukaName ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].cityName ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].customerName ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].consigneeAddress ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].diNumber ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].salesOrderNo ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].product ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].diQty.toString(),
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].frtRate.toString(),
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].extFrt == null
                                      ? ""
                                      : data[index].extFrt.toString(),
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  (data[index].newFrtAmount == null ||
                                          data[index].extFrt == 0)
                                      ? ""
                                      : data[index].newFrtAmount.toString(),
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].newFrtRemarks ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].bidRemark ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].soBiddingRemarks ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
                          child: Row(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: preBidListResponseList1,
                                builder: (BuildContext context,
                                    List<PreBid2ModelResponseList> value,
                                    Widget? child) {
                                  return Expanded(
                                    flex: 2,
                                    child: Text(
                                        "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length + (currentPage - 1) * int.parse(selectedDropdownValue)} of ${preBidListResponseList.value.length} entries",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal)),
                                  );
                                },
                              ),
                              buildValueListenableBuilder()
                            ],
                          ),
                        ),
                      ],
                    ),
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

  ValueListenableBuilder<List<PreBid2ModelResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: preBidListResponseList,
      builder: (BuildContext context, List<PreBid2ModelResponseList> value,
          Widget? child) {
        if (value.isEmpty) {
          return Center(child: Container());
        }

        return Obx(() {
          int itemsPerPage = int.parse(selectedDropdownValue);
          int numberOfPages = (value.length / itemsPerPage).ceil();

          // Calculate the range of pages to display
          int startPage = (currentPagination.value - 2).clamp(1, numberOfPages);
          int endPage = (currentPagination.value + 2).clamp(1, numberOfPages);

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
                    // isLoading.value=true;
                    currentPage--;
                    currentPagination.value = currentPage;
                    filterData(searchValue);
                  },
                ),
              ),
            );
          }

          // Add the page buttons
          for (int i = startPage; i <= endPage; i++) {
            pageWidgets.add(Obx(() {
              return InkWell(
                child: navBox(
                    boxWidth: 25,
                    text: i.toString(),
                    txtClr: (currentPagination.value == i)
                        ? Colors.white
                        : ColorConstant.redbar,
                    bgClr: (currentPagination.value == i)
                        ? ColorConstant.redbar
                        : Colors.white),
                onTap: () async {
                  // isLoading.value=true;
                  currentPagination.value = i;
                  currentPage = i;
                  filterData(searchValue);
                },
              );
            }));
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
                    // isLoading.value=true;
                    currentPage++;
                    currentPagination.value = currentPage;
                    filterData(searchValue);
                  },
                ),
              ),
            );
          }

          return Wrap(
            children: pageWidgets,
          );
        });
      },
    );
  }
}
