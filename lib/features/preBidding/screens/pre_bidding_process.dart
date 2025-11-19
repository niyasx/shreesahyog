import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/common/widgets/custom_dropdown_2.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/preBidding/api/division_list_api.dart';
import 'package:shreecement/features/preBidding/api/prebid_list.dart';
import 'package:shreecement/features/preBidding/apiModels/prebid_first.dart';
import 'package:shreecement/main.dart';
import '../../../global.dart';
import '../../common/controller/controller.dart';
import '../../common/table/table_widgets.dart';
import 'package:shreecement/utils/color_constant.dart';
import '../../common/widgets/customdropdownprebid.dart';
import '../apiModels/di_model.dart';
import 'package:http/http.dart' as http;

class PreBiddingProcess extends StatefulWidget {
  const PreBiddingProcess({super.key});

  @override
  State<PreBiddingProcess> createState() => _PreBiddingProcessState();
}

class _PreBiddingProcessState extends State<PreBiddingProcess> {
  final control = Get.put(Controller());

  RxBool loaderScreen = false.obs;

  String selectedVal = "";

  int inc_index = 0;

  int selectedIndex = 1;

  Color previousClr = ColorConstant.redbar;

  int noOfPages = 0;

  int listViewTopIndex = 0;

  int displayNo = 1;
  RxInt currentPagination = 1.obs;
  String searchValue = "";

  ValueNotifier selectedDivision = ValueNotifier("CEMENT");

  String? seldivison;

  List<PreBidListResponseList> originalPreBidList = [];
  ValueNotifier<List<PreBidListResponseList>> preBidListResponseList =
      ValueNotifier([]);
  ValueNotifier<List<PreBidListResponseList>> preBidListResponseList1 =
      ValueNotifier([]);
  ValueNotifier<String> selectedDitype = ValueNotifier("All");
  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    fetchPreBidList();
    selectedDropdownValue1 = "10";
  }

  Future<DiList> getDitypeList() async {

     String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/diType-list";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });

    final result = json.decode(res.body);
    // // print(result);
    return DiList.fromJson(result);
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

  fetchPreBidList() async {
    loaderScreen.value = true;
    final PreBidListModel response = await PrebidListApi()
        .getPreBidList([selectedDivision.value], selectedDitype.value,"PREBID");
    loaderScreen.value = false;
    originalPreBidList = response.responseList ?? [];
    preBidListResponseList1.value =
        getCurrentPageItems(originalPreBidList, currentPage);
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

    preBidListResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 4)) / 100;
    return CustomScaffold(
      appBarText: "Pre-Bid Process",
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
                    'Pre-Bid Process',
                    style: TextStyle(
                        fontSize: 21,
                        fontFamily: 'RobotoLight',
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
                          Wrap(
                            spacing: 8.0, // Horizontal spacing between items
                            runSpacing: 8.0,

                            children: [
                              FutureBuilder(
                                future:
                                    DivisionListApi().getDivisionListFromAPI(),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                      color: ColorConstant.redbar,
                                    );
                                  } else if (snapshot.hasData) {
                                    // // print("Data received");
                                    int i;
                                    List<String> division = [];
                                    for (i = 0;
                                        i < snapshot.data!.divisionlist!.length;
                                        i++) {
                                      division.add(snapshot
                                          .data!.divisionlist![i]
                                          .toString());
                                    }
                                    selectedDivision.value = division.first;
                                    seldivison = division.first;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            builder: (context) =>
                                                const TokenExpire()),
                                      );
                                    });
                                    return const Text(
                                        "Token Error: Recheck token in API");
                                  }
                                },
                              ),
                              wSpace(20),
                              FutureBuilder(
                                future: getDitypeList(),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                      color: ColorConstant.redbar,
                                    );
                                  } else if (snapshot.hasData) {
                                    int i;
                                    List<String> diList = [
                                      "All"
                                    ]; // Initialize with "All"

                                    for (i = 0;
                                        i < snapshot.data!.diTypeList!.length;
                                        i++) {
                                      diList.add(snapshot.data!.diTypeList![i]
                                          .toString());
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "DI Type",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: selectedDitype,
                                          builder: (BuildContext context,
                                              String data, Widget? child) {
                                            return CustomDropdownMenu2(
                                              selVal: data,
                                              list: diList,
                                              fun: (value) {
                                                selectedDitype.value =
                                                    value ?? "";
                                              },
                                            );
                                          },
                                        ),
                                        // CustomDropdownMenu(
                                        //   selVal: diList.first,
                                        //   list: diList,
                                        //
                                        //
                                        // ),
                                      ],
                                    );
                                  } else {
                                    // Future.delayed(Duration.zero, () {
                                    //   Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    // const TokenExpire()),
                                    //   );
                                    // });
                                    return const Text(
                                        "Token Error: Recheck token in API");
                                  }
                                },
                              ),
                            ],
                          ),
                          vSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              button(
                                  btnText: "Search",
                                  tapFunction: () async {
                                    currentPage = 1;
                                    await fetchPreBidList();
                                  }),
                              wSpace(10),
                              button(
                                  btnText: "Reset",
                                  btnClr: Colors.white,
                                  btnTxtClr: ColorConstant.redbar,
                                  tapFunction: () async {
                                    try {
                                      selectedDivision.value = seldivison;

                                      await fetchPreBidList();
                                    } catch (e) {
                                      // // print("Error in Reset button: $e");
                                    }
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
                            label: TableColumn(
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
                                      sp?.setString("plantName",
                                          "${value[index].plantName}");
                                      sp?.setString("plantCode",
                                          "${value[index].plantId}");
                                      sp?.setString(
                                          "division1", selectedDivision.value);
                                      sp?.setString(
                                          "diType", selectedDitype.value);
                                      control.currentIndex.value = 4;
                                      sp?.setString("preBid2PlantId",
                                          value[index].plantId.toString());

                                      sp?.setString("divisionPrebid",
                                          selectedDivision.value.toString());
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
                                    sp?.setString("plantName",
                                        "${value[index].plantName}");
                                    sp?.setString(
                                        "plantCode", "${value[index].plantId}");
                                    sp?.setString(
                                        "division1", selectedDivision.value);
                                    sp?.setString(
                                        "diType", selectedDitype.value);
                                    control.currentIndex.value = 4;
                                    sp?.setString("preBid2PlantId",
                                        value[index].plantId.toString());

                                    sp?.setString("divisionPrebid",
                                        selectedDivision.value.toString());
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
