import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/widgets/custom_dropdown_2.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/preBidding/api/prebid_list.dart';
import 'package:shreecement/features/preBidding/apiModels/prebid_first.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/features/preBidding/api/division_list_api.dart';
import '../common/controller/controller.dart';
import '../common/screens/token_expire.dart';
import '../common/table/table_widgets.dart';
import '../common/widgets/customdropdownprebid.dart';

class ManualDiallotment extends StatefulWidget {
  const ManualDiallotment({super.key});

  @override
  State<ManualDiallotment> createState() => _ManualDiallotmentState();
}

class _ManualDiallotmentState extends State<ManualDiallotment> {
  final control = Get.put(Controller());

  RxBool loaderScreen = false.obs;
  RxInt currentPagination = 1.obs;
  String searchValue = "";

  ValueNotifier selectedDivision = ValueNotifier("Cement");
  List<PreBidListResponseList> originalPreBidList = [];
  ValueNotifier<List<PreBidListResponseList>> preBidListResponseList =
      ValueNotifier([]);
  ValueNotifier<List<PreBidListResponseList>> preBidListResponseList1 =
      ValueNotifier([]);
  String? seldivison;

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    fetchPreBidList();
  }

  fetchPreBidList() async {
    loaderScreen.value = true;
    final PreBidListModel response =
        await PrebidListApi().getPreBidList([selectedDivision.value], "","MANUAL");
    loaderScreen.value = false;
    originalPreBidList = response.responseList ?? [];

    preBidListResponseList1.value = getCurrentPageItems(originalPreBidList, currentPage);
  }

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);
  List<PreBidListResponseList> getCurrentPageItems(
      List<PreBidListResponseList> items, int currentPage) {
    preBidListResponseList.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<PreBidListResponseList> a = items.sublist(startIndex, endIndex);

    return a;
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      preBidListResponseList1.value =
          getCurrentPageItems(originalPreBidList, currentPage);
      return;
    }

    List<PreBidListResponseList> filteredData = originalPreBidList
        .where((value) =>
            value.plantId
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.plantName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    preBidListResponseList.value = filteredData;
    preBidListResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 4)) / 100;
    return CustomScaffold(
      appBarText: "Manual DI Allotment",
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
                    'Manual DI Allotment',
                    style: TextStyle(
                        fontSize: 21,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100),
                  ),
                  vSpace(20),
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
                          FutureBuilder(
                            future: DivisionListApi().getDivisionListFromAPI(),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                  color: ColorConstant.redbar,
                                );
                              } else if (snapshot.hasData) {
                                int i;
                                List<String> division = [];
                                for (i = 0;
                                    i < snapshot.data!.divisionlist!.length;
                                    i++) {
                                  division.add(snapshot.data!.divisionlist![i]
                                      .toString());
                                }
                                seldivison = division.first;
                                selectedDivision.value = division.first;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Division",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: selectedDivision,
                                      builder: (BuildContext context, data,
                                          Widget? child) {
                                        return CustomDropdownMenu2(
                                          selVal: data,
                                          list: division,
                                          fun: (value) {
                                            selectedDivision.value = value;
                                          },
                                        );
                                      },
                                    )
                                  ],
                                );
                              } else {
                                Future.delayed(Duration.zero, () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const TokenExpire()),
                                  );
                                });
                                return const Text(
                                    "Token Error: Recheck token in API");
                              }
                            },
                          ),
                          vSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              button(
                                  btnText: "Search",
                                  tapFunction: () {
                                    fetchPreBidList();
                                  }),
                              wSpace(10),
                              button(
                                  btnText: "Reset",
                                  btnClr: Colors.white,
                                  btnTxtClr: ColorConstant.redbar,
                                  tapFunction: () async {
                                    selectedDivision.value = seldivison!;

                                    await fetchPreBidList();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                                          : Container()
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
                                  width: 130,
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
                                    onChanged: (value) {
                                      filterData(value);
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
                        List<PreBidListResponseList> value, Widget? child) {
                      if (value.isEmpty) {
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
                              "Sr. No.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Org Code",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Organisation Name",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "DI for Deliveries",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn1(
                              "Actions",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                        ],
                        rows: List.generate(
                          value.length,
                          (index) {
                            return DataRow(
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
                                    value[index].plantId ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    value[index].plantName ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn1(
                                    colorbool: true,
                                    value[index].diCount.toString(),
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                    onTap: () {
                                      sp?.setString(
                                          "plantId", "${value[index].plantId}");
                                      control.currentIndex.value = 12;
                                      sp?.setString("selectedDivision",
                                          "${selectedDivision.value}");
                                    },
                                  ),
                                ),
                                DataCell(TableColumnActionIcon(
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  icon:
                                      Image.asset("assets/images/bidicon.png"),
                                  onPressed: () {
                                    sp?.setString(
                                        "plantId", "${value[index].plantId}");
                                    sp?.setString("selectedDivision",
                                        "${selectedDivision.value}");
                                    control.currentIndex.value = 12;
                                  },
                                )),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 5),
                        child: Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: preBidListResponseList1,
                              builder: (BuildContext context,
                                  List<PreBidListResponseList> value,
                                  Widget? child) {
                                if (value.isEmpty) {
                                  return Center(child: Container());
                                }
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
                    child:
                        CircularProgressIndicator(color: ColorConstant.redbar),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  ValueListenableBuilder<List<PreBidListResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: preBidListResponseList,
      builder: (BuildContext context, List<PreBidListResponseList> value,
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
