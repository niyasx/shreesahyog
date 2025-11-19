import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shreecement/features/biddingProcess/api/start_bid.dart';
import 'package:shreecement/features/biddingProcess/models/start_bid_model.dart';
import 'package:shreecement/features/common/widgets/custom_dropdown_2.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/common/widgets/customdropdownprebid.dart';
import 'package:shreecement/features/preBidding/api/division_list_api.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/utils/color_constant.dart';
import '../common/controller/controller.dart';
import 'package:shreecement/features/preBidding/apiModels/di_model.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/main.dart';
import 'dart:convert';
import '../common/screens/token_expire.dart';

class StartBidLogistics extends StatefulWidget {
  const StartBidLogistics({super.key});

  @override
  State<StartBidLogistics> createState() => _StartBidLogisticsState();
}

class _StartBidLogisticsState extends State<StartBidLogistics> {
  final control = Get.put(Controller());

  RxBool loaderScreen = false.obs;
  RxInt currentPagination = 1.obs;
  String searchValue = "";

  String? seldivison;

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
    return DiList.fromJson(result);
  }

  ValueNotifier<Duration> countdownTimer = ValueNotifier(const Duration());

  ValueNotifier<String> selectedDivision = ValueNotifier("CEMENT");
  ValueNotifier<String> selectedDitype = ValueNotifier("All");
  ValueNotifier<List<StartBidResponseItem>> startBidResponseList =
      ValueNotifier([]);
  ValueNotifier<List<StartBidResponseItem>> startBidResponseList1 =
      ValueNotifier([]);
  List<StartBidResponseItem> originalstartBidList = [];

  void startCountdown(String endTimeString) {
    DateTime endTime = DateTime.parse(endTimeString);
    Duration remainingTime = endTime.difference(DateTime.now());

    countdownTimer.value = remainingTime;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownTimer.value.inSeconds > 0) {
        countdownTimer.value =
            countdownTimer.value - const Duration(seconds: 1);
      } else {
        timer.cancel();
        // Handle when the countdown reaches 0
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    sp?.remove("selectedDivisionStartBid");
    sp?.remove("diType");
    fetchPreBidList();
  }

  fetchPreBidList() async {
    loaderScreen.value = true;
    final StartBidModel response = await StartBidApi().getStartBidData(
        division: selectedDivision.value, ditype: selectedDitype.value);
    loaderScreen.value = false;
    originalstartBidList = response.responseList ?? [];
    startBidResponseList.value = response.responseList ?? [];
    startBidResponseList1.value =
        getCurrentPageItems(startBidResponseList.value, currentPage);
  }

  int totalPages = 10;
  int currentPage = 1;
  int pageSize = 10;

  List<StartBidResponseItem> getCurrentPageItems(
      List<StartBidResponseItem> items, int currentPage) {
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    return items.sublist(startIndex, endIndex);
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      startBidResponseList1.value =
          getCurrentPageItems(originalstartBidList, currentPage);
      return;
    }

    List<StartBidResponseItem> filteredData = originalstartBidList
        .where((value) =>
            value.plantId
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.deliveries
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.division
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.plantName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.bidStatus
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.scheduledBidTime
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.unlinkedDelivery
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    startBidResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 6)) / 100;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(211, 216, 239, 1.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Start Bid",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            IconButton(
              iconSize: 30,
              color: ColorConstant.redbar,
              tooltip: "Refresh",
              icon: const Icon(Icons.refresh_sharp),
              onPressed: () async {
                await fetchPreBidList();
              },
            ),
          ],
        ),
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
                                    int i;
                                    List<String> division = [];
                                    for (i = 0;
                                        i < snapshot.data!.divisionlist!.length;
                                        i++) {
                                      division.add(snapshot
                                          .data!.divisionlist![i]
                                          .toString());
                                    }
                                    seldivison = division.first;
                                    selectedDivision.value = division.first;

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
                                          builder: (BuildContext context,
                                              String data, Widget? child) {
                                            return CustomDropdownMenu2(
                                              selVal: data,
                                              list: division,
                                              fun: (value) {
                                                selectedDivision.value =
                                                    value ?? "";
                                              },
                                            );
                                          },
                                        ),
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
                            ],
                          ),
                          vSpace(10),
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
                    valueListenable: startBidResponseList1,
                    builder: (BuildContext context,
                        List<StartBidResponseItem> value, Widget? child) {
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
                              "Schedule Bid Time",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Unlinked Deliveries",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Deliveries for Bidding",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Bid Status",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Start Bid",
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
                                    value[index].plantId.toString(),
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
                                  TableColumn(
                                    value[index].scheduledBidTime ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn1(
                                    colorbool: true,
                                    value[index].unlinkedDelivery.toString(),
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                    onTap: () {
                                      if (value.isNotEmpty) {}
                                      sp?.setString("plantName",
                                          "${value[index].plantName}");
                                      sp?.setString(
                                          "division1", selectedDivision.value);
                                      sp?.setInt(
                                          "plantId", value[index].plantId!);
                                      sp?.setString(
                                          "diType", selectedDitype.value);

                                      if (value[index].unlinkedDelivery == 0) {
                                      } else {
                                        control.currentIndex.value = 9;
                                      }
                                    },
                                  ),
                                ),
                                DataCell(
                                  TableColumn1(
                                    colorbool: true,
                                    value[index].deliveries.toString(),
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                    onTap: () {
                                      if (value.isNotEmpty) {
                                        sp?.setString("bidStatus",
                                            value[index].bidStatus ?? "");
                                        if (value[index]
                                                .timeForBiddingInMinutes !=
                                            null) {
                                          sp?.setString(
                                              "timeForBiddingInMinutes",
                                              value[index]
                                                  .timeForBiddingInMinutes
                                                  .toString());
                                          sp?.setString(
                                              "reBidTimeInHours",
                                              value[index]
                                                  .reBidTimeInHours
                                                  .toString());
                                        } else {
                                          sp?.remove("timeForBiddingInMinutes");
                                          sp?.remove("reBidTimeInHours");
                                        }

                                        sp?.setString(
                                            "timerValue",
                                            value[index].scheduledBidTime ??
                                                "1");
                                      }
                                      sp?.setString("plantName",
                                          "${value[index].plantName}");
                                      sp?.setString(
                                          "division1", selectedDivision.value);
                                      sp?.setInt(
                                          "plantId", value[index].plantId!);
                                      sp?.setString(
                                          "diType", selectedDitype.value);

                                      sp?.setString("startBIdPlant",
                                          value[index].plantId.toString());
                                      sp?.setString("selectedDivisionStartBid",
                                          selectedDivision.value);

                                      control.currentIndex.value = 22;
                                    },
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    value[index].bidStatus ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumnActionIcon(
                                    icon: Image.asset(
                                      "assets/images/bidicon.png",
                                    ),
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                    onPressed: () {
                                      if (value.isNotEmpty) {
                                        sp?.setString("bidStatus",
                                            value[index].bidStatus ?? "");
                                        if (value.isNotEmpty) {
                                          sp?.setString("bidStatus",
                                              value[index].bidStatus ?? "");
                                          if (value[index]
                                                  .timeForBiddingInMinutes !=
                                              null) {
                                            sp?.setString(
                                                "timeForBiddingInMinutes",
                                                value[index]
                                                    .timeForBiddingInMinutes
                                                    .toString());
                                            sp?.setString(
                                                "reBidTimeInHours",
                                                value[index]
                                                    .reBidTimeInHours
                                                    .toString());
                                          } else {
                                            sp?.remove(
                                                "timeForBiddingInMinutes");
                                            sp?.remove("reBidTimeInHours");
                                          }
                                        }

                                        sp?.setString(
                                            "timerValue",
                                            value[index].scheduledBidTime ??
                                                "1");
                                      }
                                      sp?.setString("plantName",
                                          "${value[index].plantName}");
                                      sp?.setString(
                                          "division1", selectedDivision.value);
                                      sp?.setString(
                                          "diType", selectedDitype.value);
                                      sp?.setInt(
                                          "plantId", value[index].plantId!);
                                      control.currentIndex.value = 22;
                                      sp?.setString("startBIdPlant",
                                          value[index].plantId.toString());
                                      sp?.setString("selectedDivisionStartBid",
                                          selectedDivision.value);
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                      valueListenable: startBidResponseList1,
                      builder: (BuildContext context,
                          List<StartBidResponseItem> value, Widget? child) {
                        if (value.isEmpty) {
                          return Center(child: Container());
                        }
                        return Container(
                          color: Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                vSpace(15),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                          "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length + (currentPage - 1) * int.parse(selectedDropdownValue)} of ${startBidResponseList.value.length} entries",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                    buildValueListenableBuilder()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      })
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

  ValueListenableBuilder<List<StartBidResponseItem>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: startBidResponseList,
      builder: (BuildContext context, List<StartBidResponseItem> value,
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

// ValueListenableBuilder(
//   valueListenable: startBidResponseList,
//   builder: (BuildContext context,
//       List<StartBidResponseItem> value,
//       Widget? child) {
//     if (value.isEmpty) {
//       return Center(child: Container());
//     } else if (value.length <= 10) {
//       return Row(
//         children: [
//           navBox(
//               boxWidth: 25,
//               text: "1",
//               txtClr: Colors.white,
//               bgClr: ColorConstant.redbar),
//         ],
//       );
//     } else if (value.length <= 20) {
//       return Row(
//         children: [
//           navBox(
//               boxWidth: 25,
//               text: "1",
//               txtClr: Colors.white,
//               bgClr: ColorConstant.redbar),
//           navBox(
//               boxWidth: 25,
//               text: "2",
//               txtClr: ColorConstant.redbar),
//         ],
//       );
//     } else if (value.length <= 30) {
//       Row(
//         children: [
//           navBox(
//               boxWidth: 25,
//               text: "1",
//               txtClr: Colors.white,
//               bgClr: ColorConstant.redbar),
//           navBox(
//               boxWidth: 25,
//               text: "2",
//               txtClr: ColorConstant.redbar),
//           navBox(
//               boxWidth: 25,
//               text: "3",
//               txtClr: ColorConstant.redbar),
//         ],
//       );
//     }
//     return Row(
//       children: [
//         navBox(boxWidth: 70, text: "Previous"),
//         navBox(
//             boxWidth: 25,
//             text: "1",
//             txtClr: Colors.white,
//             bgClr: ColorConstant.redbar),
//         navBox(
//             boxWidth: 25,
//             text: "2",
//             txtClr: ColorConstant.redbar),
//         navBox(
//             boxWidth: 25,
//             text: "3",
//             txtClr: ColorConstant.redbar),
//         navBox(
//             boxWidth: 50,
//             text: "Next",
//             txtClr: ColorConstant.redbar),
//       ],
//     );
//   },
// )

// ValueListenableBuilder(
//   valueListenable: startBidResponseList,
//   builder: (BuildContext context,
//       List<StartBidResponseItem> value,
//       Widget? child) {
//     if (value.isEmpty) {
//       return Center(child: Container());
//     } else {
//       int totalPages = (value.length / 10).ceil();
//       int currentPage = 1;
//       return Row(
//         children: [
//           if (currentPage > 1)
//             navBox(
//               boxWidth: 70,
//               text: "Previous",
//               tapAction: () {
//                 setState(() {
//                   currentPage--;
//                 });
//               },
//             ),
//           for (int i = currentPage;
//               i <= currentPage + 2;
//               i++)
//             if (i <= totalPages)
//               navBox(
//                 boxWidth: 25,
//                 text: "$i",
//                 txtClr: i == currentPage
//                     ? Colors.white
//                     : ColorConstant.redbar,
//                 bgClr: i == currentPage
//                     ? ColorConstant.redbar
//                     : Colors.white,
//                 tapAction: () {
//                   setState(() {
//                     currentPage = i;
//                   });
//                 },
//               ),
//           if (currentPage < totalPages)
//             navBox(
//               boxWidth: 50,
//               text: "Next",
//               txtClr: ColorConstant.redbar,
//               tapAction: () {
//                 setState(() {
//                   currentPage++;
//                 });
//               },
//             ),
//         ],
//       );
//     }
//   },
// ),
