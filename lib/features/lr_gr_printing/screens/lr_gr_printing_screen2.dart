// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
//import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:universal_html/html.dart' as html;
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/features/preBidding/api/states_list_api.dart';
import 'package:shreecement/features/preBidding/api/city_list_api.dart';
import 'package:shreecement/features/preBidding/api/district_list_api.dart';
import 'package:http/http.dart' as http;
import '../../common/widgets/custom_dropdown_3.dart';
import '../../common/widgets/customdropdownprebid.dart';
import '../api/lr_gr_api.dart';
import '../model/LrGrScreen2.dart';

class LrGrPrintingScreen2 extends StatefulWidget {
  const LrGrPrintingScreen2({super.key});

  @override
  State<LrGrPrintingScreen2> createState() => _LrGrPrintingScreen2();
}

class _LrGrPrintingScreen2 extends State<LrGrPrintingScreen2> {
  RxInt currentPagination = 1.obs;

  bool switchOn = false;

  final Controller control = Get.find(); // Access the controller

  ValueNotifier enabled = ValueNotifier(false);

  ValueNotifier<MapEntry<String, String>> selectedState =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedDistrict =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedCity =
      ValueNotifier(const MapEntry("", ""));

  late String plantId;
  late String division;

  String searchValue = "";
  List<LrGrDetailsModelResponseList> originalTransport2List = [];
  ValueNotifier<List<LrGrDetailsModelResponseList>>
      transporterBID2ListResponseList = ValueNotifier([]);
  ValueNotifier<List<LrGrDetailsModelResponseList>>
      transporterBID2ListResponseList1 = ValueNotifier([]);

final ValueNotifier<DateTime> fromDate = ValueNotifier<DateTime>(
  DateTime.now().subtract(const Duration(days: 3)) // 3 days ago by default
);
final ValueNotifier<DateTime> toDate = ValueNotifier<DateTime>(
  DateTime.now() // Current date by default
);

  double enteredValue = 0;
  bool saved = false;
  late DateTime scheduledTime;

  Future<void> showResultDialog(String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    selectedDropdownValue1 = "10";

    plantId = control.preBid2PlantId.value;

    fetchLrGrDetailsList();
  }

  // void startCountdown() {
  //   Duration remainingTime = DateTime.now().difference(scheduledTime);
  //
  //   if (remainingTime.isNegative) {
  //     // print("Scheduled time is in the past");
  //   } else {
  //     CountdownTimer(
  //       endTime: countdownEndTime,
  //       onEnd: () {
  //         // Handle when the countdown reaches 0
  //       },
  //       widgetBuilder: (_, CurrentRemainingTime? time) {
  //         if (time == null) {
  //           return const Text("00:00");
  //         }
  //
  //         String minutes = time.min.toString().padLeft(2, '0');
  //         String seconds = time.sec.toString().padLeft(2, '0');
  //         // String milliseconds = (time.millis! % 1000 ~/ 10).toString().padLeft(2, '0');
  //
  //         return Text("$minutes:$seconds");
  //       },
  //     );
  //   }
  // }
  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);
  List<LrGrDetailsModelResponseList> getCurrentPageItems(
      List<LrGrDetailsModelResponseList> items, int currentPage) {
    transporterBID2ListResponseList.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<LrGrDetailsModelResponseList> a = items.sublist(startIndex, endIndex);

    return a;
  }

  fetchLrGrDetailsList() async {
    try {
      final LrGrDetailsModel response =
          await LrGrPrintingAPI().getLrGrDetailFromAPI(
        employeeCode: sp?.getString("employeeCode") ?? "",
        plantId: sp!.getInt("plantId")!,
        division: sp!.getString("division")!,
        ctx: context,
        stateCode:
            selectedState.value.value == "All" ? "" : selectedState.value.value,
        districtCode: selectedDistrict.value.value == "All"
            ? ""
            : selectedDistrict.value.value,
        cityCode:
            selectedCity.value.value == "All" ? "" : selectedCity.value.value,
        fromDate: DateFormat('yyyy-MM-dd').format(fromDate.value.toLocal()),
        toDate: DateFormat('yyyy-MM-dd').format(toDate.value.toLocal()),
      );

      originalTransport2List = response.responseList ?? [];
    

      // transporterBID2ListResponseList1.value=getCurrentPageItems(originalTransport2List, currentPage);
      filterData(searchValue);
    } catch (e) {
      // Future.delayed(Duration.zero, () {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //         const TokenExpire()),
      //   );
      // });
      // print("error in fetch data $e");
    }
  }

  void filterData(String searchTerm) {
    if (searchTerm.trim().isEmpty) {
      // print(originalTransport2List);
      transporterBID2ListResponseList1.value =
          getCurrentPageItems(originalTransport2List, currentPage);
      return;
    }

    List<LrGrDetailsModelResponseList> filteredData = originalTransport2List
        .where((value) =>
            value.cityName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.districtName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.invoiceNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.ewayBillNumber
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
            value.brand
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.product
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.invoiceDate
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diType
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    transporterBID2ListResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  // Future<void> _selectFromDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: fromDate.value,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null && picked != fromDate.value) {
  //     if (picked.isAfter(toDate.value)) {
  //       toDate.value = DateTime.now();
  //     }
  //     fromDate.value = picked;
  //   }
  // }

  // Future<void> _selectToDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: toDate.value,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null && picked != toDate.value) {
  //     if (picked.isBefore(fromDate.value)) {
  //       fromDate.value = DateTime.utc(2024, 1, 1);
  //     }
  //     toDate.value = picked;
  //   }
  // }

Future<void> _selectFromDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: fromDate.value,
    firstDate: DateTime(2024, 1, 1), // Can be selected from Jan 1, 2024
    lastDate: DateTime.now(), // Until today
  );
  
  if (picked != null && picked != fromDate.value) {
    // Set "From Date"
    fromDate.value = picked;

    // Adjust "To Date" based on "From Date"
    final DateTime maxToDate = picked.add(const Duration(days: 3));
    if (toDate.value.isAfter(maxToDate) || toDate.value.isAfter(DateTime.now())) {
      // Ensure "To Date" is no more than 3 days after "From Date" and not greater than today
      toDate.value = DateTime.now().isBefore(maxToDate) ? DateTime.now() : maxToDate;
    }
  }
}

Future<void> _selectToDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: toDate.value,
    firstDate: fromDate.value, // Must be after "From Date"
    lastDate: DateTime.now().isBefore(fromDate.value.add(const Duration(days: 3))) 
        ? DateTime.now() 
        : fromDate.value.add(const Duration(days: 3)), // Max 3 days after "From Date" or today
  );
  
  if (picked != null && picked != toDate.value) {
    // Set "To Date"
    toDate.value = picked;
  }
}



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 13)) / 100;
    return CustomScaffold(
      appBarText: "LR / GR Printing",
      refreshButton: IconButton(
        iconSize: 30,
        color: ColorConstant.redbar,
        tooltip: "Refresh",
        icon: const Icon(Icons.refresh_sharp),
        onPressed: () async {
          await fetchLrGrDetailsList();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LR/GR',
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
                      Wrap(
                        runSpacing: 5,
                        children: [
                          FutureBuilder(
                              future: StatesListAPI().getStatesListFromAPI(),
                              builder: (stateIndex, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(
                                    color: ColorConstant.redbar,
                                  );
                                } else if (snapshot.hasData) {
                                  final List responseList =
                                      snapshot.data?.responseList ?? [];
                                  Map<String, String> map = {};
                                  map["All"] = "All";

                                  for (var element in responseList) {
                                    map[element.stateName] = element.stateCode;
                                  }
                                  selectedState.value = map.entries.first;
                                  return ValueListenableBuilder(
                                    valueListenable: selectedState,
                                    builder: (BuildContext context, data,
                                        Widget? child) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "State",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          CustomDropdownMenu3(
                                            selVal: selectedState.value.key,
                                            list: map.keys.toList(),
                                            fun: (value) {
                                              if (value == "All") {
                                                enabled.value = false;
                                              } else {
                                                enabled.value = true;
                                              }
                                              selectedState.value = MapEntry(
                                                value ?? "",
                                                map[value] ?? "",
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }  else {
                                    Future.delayed(Duration.zero, () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TokenExpire()),
                                      );
                                    });
                                    return const Text(
                                        "Token Error : Re check token in API");
                                  }
                              }),
                          wSpace(20),
                          ValueListenableBuilder(
                            valueListenable: selectedState,
                            builder: (BuildContext context, _, Widget? child) {
                              return FutureBuilder(
                                future:
                                    DistrictListAPI().getDistrictsListFromAPI(
                                  selectedState.value.key,
                                  selectedState.value.value,
                                ),
                                builder: (districtIndex, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                      color: ColorConstant.redbar,
                                    );
                                  } else if (snapshot.hasData) {
                                    final responseList =
                                        snapshot.data?.responseList ?? [];
                                    Map<String, String> map = {};
                                    map["All"] = "All";

                                    for (var element in responseList) {
                                      map[element.districtName ?? ""] =
                                          element.district ?? "";
                                    }
                                    selectedDistrict.value = map.entries.first;
                                    return ValueListenableBuilder(
                                      valueListenable: selectedDistrict,
                                      builder: (BuildContext context, data,
                                          Widget? child) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "District",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            CustomDropdownMenu3(
                                              selVal:
                                                  selectedDistrict.value.key,
                                              list: map.keys.toList(),
                                              fun: (value) {
                                                if (value == "All") {
                                                  enabled.value = false;
                                                } else {
                                                  enabled.value = true;
                                                }
                                                selectedDistrict.value =
                                                    MapEntry(
                                                  value ?? "",
                                                  map[value] ?? "",
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
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
                                        "Token Error : Re check token in API");
                                  }
                                },
                              );
                            },
                          ),
                          wSpace(20),
                          ValueListenableBuilder(
                            valueListenable: selectedState,
                            builder: (BuildContext context,
                                MapEntry<String, String> value, Widget? child) {
                              return ValueListenableBuilder(
                                valueListenable: selectedDistrict,
                                builder: (BuildContext context,
                                    MapEntry<String, String> value,
                                    Widget? child) {
                                  return FutureBuilder(
                                    future: CityListAPi().getCityNameList(
                                      districtName: selectedDistrict.value.key,
                                      districtCode:
                                          selectedDistrict.value.value,
                                    ),
                                    builder: (districtIndex, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator(
                                          color: ColorConstant.redbar,
                                        );
                                      } else if (snapshot.hasData) {
                                        final responseList =
                                            snapshot.data?.responseList ?? [];
                                        Map<String, String> map = {};
                                        map["All"] = "All";

                                        for (var element in responseList) {
                                          map[element.cityName ?? ""] =
                                              element.city ?? "";
                                        }
                                        selectedCity.value = map.entries.first;
                                        return ValueListenableBuilder(
                                          valueListenable: selectedCity,
                                          builder: (BuildContext context, data,
                                              Widget? child) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "City",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                CustomDropdownMenu3(
                                                  selVal:
                                                      selectedCity.value.key,
                                                  list: map.keys.toList(),
                                                  fun: (value) {
                                                    if (value == "All") {
                                                      enabled.value = false;
                                                    } else {
                                                      enabled.value = true;
                                                    }
                                                    selectedCity.value =
                                                        MapEntry(
                                                      value ?? "",
                                                      map[value] ?? "",
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
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
                                            "Token Error : Re check token in API");
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      vSpace(10),
                      Wrap(
                        runSpacing: 5,
                        children: [
                          InkWell(
                            onTap: () => _selectFromDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Wrap(
                                children: <Widget>[
                                  ValueListenableBuilder<DateTime>(
                                      valueListenable: fromDate,
                                      builder: (context, value, child) {
                                        return Text(
                                          'From Date: ${DateFormat('dd/MM/yyyy').format(value.toLocal())}\t',
                                          style: const TextStyle(fontSize: 15),
                                        );
                                      }),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () => _selectToDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Wrap(
                                children: <Widget>[
                                  ValueListenableBuilder<DateTime>(
                                      valueListenable: toDate,
                                      builder: (context, value, child) {
                                        return Text(
                                            'To Date: ${DateFormat('dd/MM/yyyy').format(value.toLocal())}\t');
                                      }),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      //timer need to show here
                      vSpace(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          button(
                              btnText: "Search",
                              tapFunction: () async {
                                currentPage = 1;
                                await fetchLrGrDetailsList();
                              }),
                          wSpace(10),
                          button(
                              btnText: "Reset",
                              btnClr: Colors.white,
                              btnTxtClr: ColorConstant.redbar,
                              tapFunction: () async {
                                selectedState.value =
                                    const MapEntry("All", "All");
                                selectedDistrict.value =
                                    const MapEntry("All", "All");
                                selectedCity.value =
                                    const MapEntry("All", "All");
                                fetchLrGrDetailsList();
                              }),
                        ],
                      ),
                    ],
                  ),
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
                                        selVal: selectedDropdownValue1,
                                        list: const [
                                          "10",
                                          "20",
                                          "30",
                                          "50",
                                          "100",
                                          "All"
                                        ],
                                        onChanged: (value) async {
                                          // Update the selected value when the dropdown changes
                                          setState(() {
                                            selectedDropdownValue1 = value;

                                            selectedDropdownValue = value ==
                                                    "All"
                                                ? transporterBID2ListResponseList
                                                    .value.length
                                                    .toString()
                                                : value;
                                            pageSize = int.parse(
                                                selectedDropdownValue);
                                            currentPage = 1;
                                          });
                                          filterData(searchValue);
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
                            Row(
                              children: [
                                wSpace(10),
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
                                      searchValue = val;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  )),
                ],
              ),
              ValueListenableBuilder(
                  valueListenable: transporterBID2ListResponseList1,
                  builder: (BuildContext context,
                      List<LrGrDetailsModelResponseList> data, Widget? child) {
                    if (data.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Text("No data found"),
                        ),
                      );
                    } else {
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
                              "City",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "DI Number",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Consignee Name",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Invoice Number",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Invoice Date",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Dispatch Date",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Goods/Product",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Grade",
                              width: dynamicSize,
                              heading: true,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Brand",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Invoice Amount",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "E-way Bill Number",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Gr. No",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Action",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                        ],
                        rows: List.generate(
                          data.length,
                          (index) {
                            // index1=index;
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
                                    data[index].cityName ?? "",
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
                                    data[index].customerName ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    data[index].invoiceNumber ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    formatDate(data[index].invoiceDate),
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    formatDate(data[index].dispatchedDate),
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
                                    "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    data[index].brand ?? "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    data[index].invoiceAmount.toString(),
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    (data[index].ewayBillNumber!).toString(),
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(
                                  TableColumn(
                                    "",
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                  ),
                                ),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          downloadPdf(
                                              diNumber: data[index].diNumber,
                                              division: data[index]
                                                  .division
                                                  .toString(),
                                              plantId: data[index]
                                                  .plantId
                                                  .toString());
                                        },
                                        icon: const Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.blue,
                                        )),
                                  ],
                                )),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  }),
              Container(
                color: Colors.grey.shade200,
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: transporterBID2ListResponseList1,
                          builder: (BuildContext context,
                              List<LrGrDetailsModelResponseList> value,
                              Widget? child) {
                            if (value.isEmpty) {
                              return Center(child: Container());
                            }
                            return Expanded(
                              flex: 2,
                              child: Text(
                                  "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length + (currentPage - 1) * int.parse(selectedDropdownValue)} of ${transporterBID2ListResponseList.value.length} entries",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            );
                          },
                        ),
                        //changed to upside
                        // button(
                        //     btnText: "Save All",
                        //     tapFunction: () async {
                        //       await saveAllStartBidTransporter(
                        //           responselist:
                        //               transporterBID2ListResponseList1.value);
                        //       setState(() {});
                        //       await fetchLrGrDetailsList();
                        //     }),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                        buildValueListenableBuilder()
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ValueListenableBuilder<List<LrGrDetailsModelResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: transporterBID2ListResponseList,
      builder: (BuildContext context, List<LrGrDetailsModelResponseList> value,
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
            pageWidgets.add(
              InkWell(
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
                  currentPage = i;
                  currentPagination.value = currentPage;
                  filterData(searchValue);
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
                    currentPagination.value = currentPage;
                    filterData(searchValue);
                  },
                ),
              ),
            );
          }

          return Row(
            children: pageWidgets,
          );
        });
      },
    );
  }

  String formatDate(String? dateTimeString) {
    if (dateTimeString == null) {
      return '';
    }

    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat.yMMMd().format(dateTime);
  }
}

Future<dynamic> downloadPdf({
  // int? index,
  String? diNumber,
  String? division,
  String? plantId,
}) async {
  String url = "$baseUrl/bidding/finance/generate-lr-pdf";
  
String? token = await secureStorage.read("token");
  try {
    var res = await http.post(Uri.parse(url),
        headers: {
          "Authorization":"Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: jsonEncode({
          "diNumber": diNumber ?? "",
          "division": division ?? "",
          "plantId": plantId ?? "",
          "transporterCode": sp?.getString("employeeCode") ?? ""
        }));
    // final result = jsonDecode(res.body);

    if (res.statusCode == 200) {
      // print(res.bodyBytes.toString());
      // String dir = (await getApplicationDocumentsDirectory()).path;
      // File file = File('download.pdf');
      // File file = File(fileName);

      final blob = html.Blob([Uint8List.fromList(res.bodyBytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "LRGR_Receipt_$diNumber.pdf")
        ..click();
      // await file.writeAsString("h");
  
      // savedSuccess[index].value = true;
    } else {
      // savedSuccess[index].value = false;
    }
  } catch (e) {
    // print("Error during Unlinked Saving API call: $e");
    // savedSuccess[index].value = false;
  }
}
