//view frght bill code

// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/biddingProcess/api/manualdiallotment_action_api.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/controller/limitedtextcontroller.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_dropdown_3.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/common/widgets/customdropdownprebid.dart';
import 'package:shreecement/features/invoicing/apis/shortage_master_apis.dart';
import 'package:shreecement/features/invoicing/apis/view_freightbill_api.dart';
import 'package:shreecement/features/invoicing/models/view_freightbill_logistics_model.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';

import '../../common/controller/indian_currency.dart';

class ViewFrieghtBillLogistics extends StatefulWidget {
  const ViewFrieghtBillLogistics({super.key});

  @override
  State<ViewFrieghtBillLogistics> createState() =>
      _ViewFrieghtBillLogisticsState();
}

final Controller controller = Get.find();

class _ViewFrieghtBillLogisticsState extends State<ViewFrieghtBillLogistics> {
  // Access the controller

  ScrollController scrollController = ScrollController();

  RxInt currentPagination = 1.obs;
  String searchValue = "";
  RxBool loaderScreen = false.obs;

  ValueNotifier<MapEntry<String, String>> selectedPlant =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedTransporter =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedStatus =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedBillType =
      ValueNotifier(const MapEntry("All", "All"));

  List<ViewFreighBillLogisticsResponseList> originalViewFreightBillList = [];
  ValueNotifier<List<ViewFreighBillLogisticsResponseList>>
      viewFreightBillResponseList = ValueNotifier([]);
  ValueNotifier<List<ViewFreighBillLogisticsResponseList>>
      viewFreightBillResponseList1 = ValueNotifier([]);
  LimitedLengthTextController100 remarkController =
      LimitedLengthTextController100();
  double enteredValue = 0;
  bool saved = false;

bool isFreightBill = false;
bool isInvoice = false;

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
    // print(" back value ${control.back.value}");
    if (controller.back.value == true) {
      fetchViewFreightBillSp(
          plantIdsp: sp?.getString("selectedPlantValue") ?? "",
          transporterIdsp: sp?.getString("selectedTransporterValue") ?? "",
          statussp: sp?.getString("selectedStatus") ?? "",
          fromDatesp: sp?.getString("fromDate") ?? "",
          toDatesp: sp?.getString("toDate") ?? "");
    }
  }

  fetchViewFreightBillSp(
      {required String transporterIdsp,
      required String plantIdsp,
      required String fromDatesp,
      required String toDatesp,
      required String statussp}) async {
    try {
      final toDate = DateTime.parse(parseDate(toDatesp));
      final fromDate = DateTime.parse(parseDate(fromDatesp));
      loaderScreen.value = true;

      final ViewFreightBillLogisticsModel response = await ViewFreightBillApi()
          .viewFreightBillLogistics(
              status: statussp,
              plantId: plantIdsp,
              fromDate: convertDateFormat(fromDate),
              toDate: convertDateFormat(toDate),
              transporterId: transporterIdsp);
      loaderScreen.value = false;

      originalViewFreightBillList = response.responseList ?? [];
      viewFreightBillResponseList.value = originalViewFreightBillList;
      viewFreightBillResponseList1.value =
          getCurrentPageItems(originalViewFreightBillList, currentPage);
    } catch (e) {
      // print("error in fetchViewFreightBillSp data $e");
    }
  }

  fetchViewFreightBill(
      {required String transporterId,
      required String plantId,
      required String fromDate,
      required String toDate,
      required String status}) async {
    try {
      final ViewFreightBillLogisticsModel response = await ViewFreightBillApi()
          .viewFreightBillLogistics(
              plantId: plantId,
              fromDate: fromDate,
              toDate: toDate,
              status: status,
              transporterId: transporterId);
      originalViewFreightBillList = response.responseList ?? [];
      viewFreightBillResponseList.value = originalViewFreightBillList;
      viewFreightBillResponseList1.value =
          getCurrentPageItems(originalViewFreightBillList, currentPage);
    } catch (e) {
      // print("error in fetch data $e");
    }
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      selectedBillType.value = const MapEntry(
        "All",
        "All",
      );
      viewFreightBillResponseList1.value =
          getCurrentPageItems(originalViewFreightBillList, currentPage);
      return;
    }

    List<ViewFreighBillLogisticsResponseList> filteredData =
        originalViewFreightBillList
            .where((value) =>
                value.billDate
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.billNo
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.transporterName.toString().toLowerCase().contains(searchTerm
                    .toLowerCase()) ||
                value.frtNetAmount
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.totalTax
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.status
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.sapResponse
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.sapRefNo
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                value.netAmount
                    .toString()
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()))
            .toList();

    viewFreightBillResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  void filterInvoice() {
    List<ViewFreighBillLogisticsResponseList> filteredData =
        originalViewFreightBillList
            .where((element) =>
                element.sapRefNo != null || element.sapResponse != null)
            .toList();

    viewFreightBillResponseList1.value.clear();

    viewFreightBillResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

   void filterBill() {
    List<ViewFreighBillLogisticsResponseList> filteredData =
        originalViewFreightBillList
            .where((element) =>
                element.sapRefNo == null && element.sapResponse == null )
            .toList();

    viewFreightBillResponseList1.value.clear();

    viewFreightBillResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fromDateController.text = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().subtract(const Duration(days: 90)));
    toDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    sp?.getString("selectedPlant") == null
        ? sp?.setString("selectedPlant", "isEmpty")
        : "";
    sp?.getString("selectedStatus") == null
        ? sp?.setString("selectedStatus", "isEmpty")
        : "";
    sp?.getString("selectedPlantValue") == null
        ? sp?.setString("selectedPlantValue", "isEmpty")
        : "";
    sp?.getString("selectedTransporter") == null
        ? sp?.setString("selectedTransporter", "isEmpty")
        : "";
    sp?.getString("selectedTransporterValue") == null
        ? sp?.setString("selectedTransporterValue", "isEmpty")
        : "";
    sp?.getString("fromDate") != null
        ? fromDateController.text = sp!.getString("fromDate")!
        : DateFormat('dd/MM/yyyy')
            .format(DateTime.now().subtract(const Duration(days: 90)));
    sp?.getString("toDate") != null
        ? toDateController.text = sp!.getString("toDate")!
        : DateFormat('dd/MM/yyyy').format(DateTime.now());
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 5)) / 100;
    return CustomScaffold(
      appBarText: "Freight Bill > View Freight Bill ",
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'View Freight Bill',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                  ),
                  vSpace(20),
                  tableHeading(
                    heading: "Search Bill",
                  ),
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
                            spacing: 20,
                            runSpacing: 5,
                            children: [
                              FutureBuilder(
                                  future: ShortageMasterApis().getPlantList(),
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
                                      if (sp?.getString("selectedPlant") ==
                                          "isEmpty") {
                                        map["Select Plant"] = "Select Plant";
                                        for (var element in responseList) {
                                          map[element.plantName] =
                                              element.plantCode;
                                        }
                                        selectedPlant.value = map.entries.first;
                                      } else {
                                        map[sp?.getString("selectedPlant") ??
                                                ""] =
                                            sp?.getString("selectedPlant") ??
                                                "";

                                        for (var element in responseList) {
                                          map[element.plantName] =
                                              element.plantCode;
                                        }
                                        selectedPlant.value = map.entries.first;
                                      }
                                      return ValueListenableBuilder(
                                        valueListenable: selectedPlant,
                                        builder: (BuildContext context, data,
                                            Widget? child) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Plant",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              CustomDropdownMenu3(
                                                  selVal:
                                                      selectedPlant.value.key,
                                                  list: map.keys.toList(),
                                                  fun: (value) async {
                                                    if (value ==
                                                        "Select Plant") {
                                                      sp?.setString(
                                                          "selectedTransporter",
                                                          "isEmpty");
                                                      sp?.setString(
                                                          "selectedTransporterValue",
                                                          "isEmpty");
                                                    }

                                                    selectedPlant.value =
                                                        MapEntry(
                                                      value ?? "",
                                                      map[value] ?? "",
                                                    );
                                                    // }
                                                  }),
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
                                  }),
                              ValueListenableBuilder(
                                  valueListenable: selectedPlant,
                                  builder: (BuildContext context,
                                      MapEntry<String, String> value,
                                      Widget? child) {
                                    if (selectedPlant.value.value != "") {
                                      return FutureBuilder(
                                        future: ManualDiAllotmentActionApi()
                                            .getTransporterNames(
                                                plantId:
                                                    selectedPlant.value.value),
                                        builder: (transporterIndex, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator(
                                              color: ColorConstant.redbar,
                                            );
                                          } else if (snapshot.hasData) {
                                            final responseList =
                                                snapshot.data?.responseList ??
                                                    [];
                                            Map<String, String> map = {};
                                            if (sp?.getString(
                                                    "selectedTransporter") ==
                                                "isEmpty") {
                                              map["Select Transporter"] =
                                                  "Select Transporter";

                                              for (var element
                                                  in responseList) {
                                                map[element.name ?? ""] =
                                                    element.supplier ?? "";
                                              }
                                              selectedTransporter.value =
                                                  map.entries.first;
                                            } else {
                                              map[sp?.getString(
                                                      "selectedTransporter") ??
                                                  ""] = sp?.getString(
                                                      "selectedTransporter") ??
                                                  "";

                                              for (var element
                                                  in responseList) {
                                                map[element.name ?? ""] =
                                                    element.supplier ?? "";
                                              }
                                              selectedTransporter.value =
                                                  map.entries.first;
                                            }

                                            return ValueListenableBuilder(
                                              valueListenable:
                                                  selectedTransporter,
                                              builder: (BuildContext context,
                                                  data, Widget? child) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Transporter",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    CustomDropdownMenu3(
                                                      selVal:
                                                          selectedTransporter
                                                              .value.key,
                                                      list: map.keys.toList(),
                                                      fun: (value) {
                                                        // if (value ==
                                                        //     "Select Transporter") {
                                                        //   enabled.value = false;
                                                        // } else {
                                                        //   enabled.value = true;
                                                        // }
                                                        selectedTransporter
                                                            .value = MapEntry(
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
                                    } else {
                                      Map<String, String> map = {};
                                      if (sp?.getString(
                                              "selectedTransporter") ==
                                          "isEmpty") {
                                        map["Select Transporter"] =
                                            "Select Transporter";

                                        selectedTransporter.value =
                                            map.entries.first;
                                      } else {
                                        map[sp?.getString(
                                                "selectedTransporter") ??
                                            ""] = sp?.getString(
                                                "selectedTransporterValue") ??
                                            "";

                                        selectedTransporter.value =
                                            map.entries.first;
                                      }
                                      map["Select Transporter"] =
                                          "Select Transporter";
                                      selectedTransporter.value =
                                          map.entries.first;
                                      return ValueListenableBuilder(
                                        valueListenable: selectedTransporter,
                                        builder: (BuildContext context, data,
                                            Widget? child) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Transporter",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              CustomDropdownMenu3(
                                                selVal: selectedTransporter
                                                    .value.key,
                                                list: map.keys.toList(),
                                                fun: (value) {
                                                  // if (value ==
                                                  //     "Select Transporter") {
                                                  //   enabled.value = false;
                                                  // } else {
                                                  //   enabled.value = true;
                                                  // }
                                                  selectedTransporter.value =
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
                                    }
                                  }),
                              FutureBuilder(
                                  future: ShortageMasterApis()
                                      .getBillStatusListFromAPI(),
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
                                      if (sp?.getString("selectedStatus") ==
                                          "isEmpty") {
                                        map["All"] = "All";
                                        for (var element in responseList) {
                                          map[element.billStatus] =
                                              element.id.toString();
                                        }
                                        selectedStatus.value =
                                            map.entries.first;
                                      } else {
                                        map[sp?.getString("selectedStatus") ??
                                                ""] =
                                            sp?.getString("selectedStatus") ??
                                                "";

                                        for (var element in responseList) {
                                          map[element.billStatus] =
                                              element.id.toString();
                                        }
                                        selectedStatus.value =
                                            map.entries.first;
                                      }
                                      return ValueListenableBuilder(
                                        valueListenable: selectedStatus,
                                        builder: (BuildContext context, data,
                                            Widget? child) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Status",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              CustomDropdownMenu3(
                                                  selVal:
                                                      selectedStatus.value.key,
                                                  list: map.keys.toList(),
                                                  fun: (value) async {
                                                    // if (value == "All") {
                                                    //   enabled.value = false;
                                                    // }
                                                    //else {
                                                    //   enabled.value = true;
                                                    // }

                                                    selectedStatus.value =
                                                        MapEntry(
                                                      value ?? "",
                                                      map[value] ?? "",
                                                    );
                                                  }),
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
                                  }),
                              datePicker(
                                label: "From Date",
                                controller: fromDateController,
                                ontap: () =>
                                    selectFromDate(context, fromDateController),
                              ),
                              datePicker(
                                label: "To Date",
                                controller: toDateController,
                                ontap: () =>
                                    selectToDate(context, toDateController),
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
                                    // await fetchTransportActionList();
                                    if (fromDateController.text.isEmpty ||
                                        toDateController.text.isEmpty ||
                                        selectedPlant.value.key ==
                                            "Select Plant" ||
                                        selectedTransporter.value.key ==
                                            "Select Transporter") {
                                      showResultDialog(
                                          "Please fill all required fields.");
                                      return;
                                    }
                                    try {
                                      final toDate = DateTime.parse(
                                          parseDate(toDateController.text));
                                      // Parse from date
                                      final fromDate = DateTime.parse(
                                          parseDate(fromDateController.text));
                                      loaderScreen.value = true;
                                      await fetchViewFreightBill(
                                          status: selectedStatus.value.key,
                                          plantId: selectedPlant.value.value,
                                          transporterId:
                                              selectedTransporter.value.value,
                                          fromDate: convertDateFormat(fromDate),
                                          toDate: convertDateFormat(toDate));
                                      loaderScreen.value = false;

                                      sp?.setString("selectedPlant",
                                          selectedPlant.value.key);
                                      sp?.setString("selectedPlantValue",
                                          selectedPlant.value.value);
                                      sp?.setString("selectedTransporter",
                                          selectedTransporter.value.key);
                                      sp?.setString("selectedTransporterValue",
                                          selectedTransporter.value.value);
                                      sp?.setString(
                                          "fromDate", fromDateController.text);
                                      sp?.setString(
                                          "toDate", toDateController.text);
                                      sp?.setString("selectedStatus",
                                          selectedStatus.value.key);
                                      selectedBillType.value = const MapEntry(
                                        "All", // Default to "Bill" if value is null
                                        "All",
                                      );
                                       isFreightBill =false;
                                       isInvoice = false;
                                    } catch (e) {
                                      // print("error in search $e");
                                    }
                                  }),
                              wSpace(10),
                              button(
                                  btnText: "Reset",
                                  btnClr: Colors.white,
                                  btnTxtClr: ColorConstant.redbar,
                                  tapFunction: () async {
                                    try {
                                      sp?.setString("selectedPlant", "isEmpty");
                                      sp?.setString(
                                          "selectedStatus", "isEmpty");
                                      sp?.setString(
                                          "selectedPlantValue", "isEmpty");
                                      sp?.setString(
                                          "selectedTransporter", "isEmpty");
                                      sp?.setString("selectedTransporterValue",
                                          "isEmpty");
                                      sp?.setString(
                                          "fromDate",
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.now().subtract(
                                                  const Duration(days: 90))));
                                      sp?.setString(
                                          "toDate",
                                          toDateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now()));
                                                   isFreightBill =false;
                                                   isInvoice = false;
                                      setState(() {});

                                      // await fetchViewFreightBill(
                                      //     status: "1",
                                      //     plantId: "1",
                                      //     transporterId: "1",
                                      //     fromDate: "1",
                                      //     toDate: "1");
                                    } catch (e) {
                                      // print(e);
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  vSpace(20),
                  tableHeading(heading: "Search Results"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                  child: Column(
                                    children: [
                                      Row(
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
                                                    selectedDropdownValue =
                                                        value;
                                                    pageSize = int.parse(value);
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
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    size.width > 600
                                        ? ValueListenableBuilder(
                                            valueListenable: selectedBillType,
                                            builder: (BuildContext context,
                                                MapEntry<String, String> data,
                                                Widget? child) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Bill Type",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  CustomDropdownMenu3(
                                                    width: 200,
                                                    selVal: selectedBillType
                                                        .value.key,
                                                    list: const [
                                                      "All",
                                                      "Freight Bill",
                                                      "Freight Invoice"
                                                    ], // Dropdown options
                                                    fun: (value) async {
                                                      if (value ==
                                                          "All") {
                                                             isFreightBill =false;
                                                        final toDate = DateTime
                                                            .parse(parseDate(
                                                                toDateController
                                                                    .text));
                                                        // Parse from date
                                                        final fromDate = DateTime
                                                            .parse(parseDate(
                                                                fromDateController
                                                                    .text));
                                                        await fetchViewFreightBill(
                                                            status:
                                                                selectedStatus
                                                                    .value.key,
                                                            plantId:
                                                                selectedPlant
                                                                    .value
                                                                    .value,
                                                            transporterId:
                                                                selectedTransporter
                                                                    .value
                                                                    .value,
                                                            fromDate:
                                                                convertDateFormat(
                                                                    fromDate),
                                                            toDate:
                                                                convertDateFormat(
                                                                    toDate));
                                                      } else if (value ==
                                                          "Freight Invoice") {
                                                        // print("filterinvoice");
                                                        filterInvoice(); 
                                                        isInvoice = true;
                                                         isFreightBill =false;
                                                      }
                                                      else if (value ==
                                                          "Freight Bill") {
                                                        // print("filterinvoice");
                                                        isInvoice = false;
                                                        isFreightBill =true;
                                                        filterBill(); 
                                                      }

                                                      selectedBillType.value =
                                                          MapEntry(
                                                        value ??
                                                            "All", // Default to "Bill" if value is null
                                                        value ?? "All",
                                                      );
                                                    },
                                                  ),
                                                  vSpace(12)
                                                ],
                                              );
                                            },
                                          )
                                        : Container(),
                                    wSpace(10),
                                    Column(
                                      children: [
                                        vSpace(10),
                                        Row(
                                          children: [
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
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.5,
                                                        color: Colors
                                                            .grey.shade600),
                                                  ),
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xffA0A0A0)),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                                textAlign: TextAlign.left,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    fontWeight:
                                                        FontWeight.w100),
                                                onChanged: (val) {
                                                  searchValue = val;
                                                  filterData(val);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        vSpace(8),
                                        size.width < 600
                                            ? ValueListenableBuilder(
                                                valueListenable:
                                                    selectedBillType,
                                                builder: (BuildContext context,
                                                    MapEntry<String, String>
                                                        data,
                                                    Widget? child) {
                                                  return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Bill Type",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        CustomDropdownMenu3(
                                                          width: 200,
                                                          selVal:
                                                              selectedBillType
                                                                  .value.key,
                                                          list: const [
                                                            "All",
                                                            "Freight Bill",
                                                            "Freight Invoice"
                                                          ], // Dropdown options
                                                          fun: (value) async {
                                                            if (value ==
                                                                "All") {
                                                                  isFreightBill =false;
                                                              final toDate = DateTime
                                                                  .parse(parseDate(
                                                                      toDateController
                                                                          .text));
                                                              // Parse from date
                                                              final fromDate =
                                                                  DateTime.parse(
                                                                      parseDate(
                                                                          fromDateController
                                                                              .text));
                                                              await fetchViewFreightBill(
                                                                  status:
                                                                      selectedStatus
                                                                          .value
                                                                          .key,
                                                                  plantId:
                                                                      selectedPlant
                                                                          .value
                                                                          .value,
                                                                  transporterId:
                                                                      selectedTransporter
                                                                          .value
                                                                          .value,
                                                                  fromDate:
                                                                      convertDateFormat(
                                                                          fromDate),
                                                                  toDate:
                                                                      convertDateFormat(
                                                                          toDate));
                                                              // fetchData(); // Call fetchData when "Bill" is selected
                                                            } else if (value ==
                                                                "Freight Invoice") {
                                                           
                                                                  isInvoice = true;
                                                                  isFreightBill=false;
                                                              filterInvoice(); // Call filterData when "Invoice" is selected
                                                            }
                                                            else if (value ==
                                                                "Freight Bill") {
                                                            isInvoice = false;
                                                            isFreightBill=true;
                                                              filterBill(); // Call filterData when "Invoice" is selected
                                                            }

                                                            selectedBillType
                                                                    .value =
                                                                MapEntry(
                                                              value ??
                                                                  "All", // Default to "Bill" if value is null
                                                              value ??
                                                                  "All",
                                                            );
                                                          },
                                                        )
                                                      ]);
                                                })
                                            : Container()
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )),
                      )),
                    ],
                  ),
                  ValueListenableBuilder(
                      valueListenable: viewFreightBillResponseList1,
                      builder: (BuildContext context,
                          List<ViewFreighBillLogisticsResponseList> data,
                          Widget? child) {
                        if (data.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Text("No data available"),
                            ),
                          );
                        } else {
                          return CustomTable(
                            columns: [
                              const DataColumn(
                                label: TableColumn(
                                  "Sr.No",
                                  heading: true,
                                  width: 32,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  // dropdown: true,
                                  "Bill Date",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  // dropdown: true,
                                  "Bill No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  // dropdown: true,
                                  "Frt. Amt.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  // dropdown: true,
                                  "Tax Details",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Net Amt.",
                                  width: dynamicSize,
                                  heading: true,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "SAP Ref No.",
                                  width: dynamicSize,
                                  heading: true,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Ref No. Description",
                                  width: dynamicSize,
                                  heading: true,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Status",
                                  width: dynamicSize,
                                  heading: true,
                                ),
                              ),
                               if (!isInvoice) //
                              DataColumn(
                                label: TableColumn(
                                  "Action",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                               if (!isFreightBill) //
                              DataColumn(
                                label: TableColumn(
                                  "Freight Reversal Actions",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                            ],
                            rows: List.generate(
                              data.length,
                              (index) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      TableColumn(
                                        "${index + 1}",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].billDate ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].billNo ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].frtNetAmount ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].totalTax ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        IndianCurrencyFormatter.format(
                                            data[index].netAmount ?? 0.0),
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].sapRefNo ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].sapResponse ?? "",
                                        index: index,
                                      ),
                                    ),
                                    DataCell(
                                      TableColumn(
                                        data[index].status ?? "",
                                        index: index,
                                      ),
                                    ),
                                     if (!isInvoice) //
                                    DataCell(
                                      TableColumnActionIcon(
                                        index: index,
                                        icon: Row(
                                          children: [
                                            wSpace(8),
                                            InkWell(
                                              child: Image.asset(
                                                "assets/images/searchicon.png",
                                                color: Colors.green,
                                              ),
                                              onTap: () {
                                                sp?.setString("orgName",
                                                    selectedPlant.value.key);
                                                controller.billStatus.value =
                                                    data[index].status ?? "";
                                                controller.billNo.value =
                                                    data[index].billNo ?? "";

                                             
                                                controller.currentIndex.value =
                                                    27;
                                              },
                                            ),
                                            wSpace(12),
                                            (data[index].status == "PENDING" ||
                                                    data[index].status ==
                                                        "RESUBMITTED")
                                                ? InkWell(
                                                    child: Icon(
                                                      Icons
                                                          .thumb_up_alt_outlined,
                                                      size: 16,
                                                      color:
                                                          Colors.blue.shade800,
                                                    ),
                                                    onTap: () async {
                                                      // print("approve");
                                                      showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Message'),
                                                            content: const Text(
                                                                "Do you want to Approve?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  await ViewFreightBillApi().approveOrRejectFrBillApi(
                                                                      billNo:
                                                                          data[index].billNo ??
                                                                              "",
                                                                      isApproved:
                                                                          "1",
                                                                      isRejected:
                                                                          "0",
                                                                      remark:
                                                                          "This bill is approved");
                                                                  // ignore: use_build_context_synchronously
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  final toDate =
                                                                      DateTime.parse(
                                                                          parseDate(
                                                                              toDateController.text));
                                                                  // Parse from date
                                                                  final fromDate =
                                                                      DateTime.parse(
                                                                          parseDate(
                                                                              fromDateController.text));
                                                                  await fetchViewFreightBill(
                                                                      status: selectedStatus
                                                                          .value
                                                                          .key,
                                                                      plantId: selectedPlant
                                                                          .value
                                                                          .value,
                                                                      transporterId: selectedTransporter
                                                                          .value
                                                                          .value,
                                                                      fromDate:
                                                                          convertDateFormat(
                                                                              fromDate),
                                                                      toDate: convertDateFormat(
                                                                          toDate));
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Yes'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'No'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  )
                                                : Container(),
                                            wSpace(12),
                                            (data[index].status == "PENDING" ||
                                                    data[index].status ==
                                                        "RESUBMITTED")
                                                ? InkWell(
                                                    child: Icon(
                                                      Icons
                                                          .thumb_down_alt_outlined,
                                                      size: 16,
                                                      color:
                                                          ColorConstant.redbar,
                                                    ),
                                                    onTap: () async {
                                                      // print("reject");
                                                      showDialog<void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Remarks'),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  customTextField2(
                                                                      controller:
                                                                          remarkController,
                                                                      label: "")
                                                                ],
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (remarkController
                                                                        .text
                                                                        .isEmpty) {
                                                                      showResultDialog(
                                                                          "Please enter Remarks to continue");
                                                                    }
                                                                    await ViewFreightBillApi().approveOrRejectFrBillApi(
                                                                        billNo:
                                                                            data[index].billNo ??
                                                                                "",
                                                                        isApproved:
                                                                            "0",
                                                                        isRejected:
                                                                            "1",
                                                                        remark:
                                                                            remarkController.text);
                                                                    final toDate =
                                                                        DateTime.parse(
                                                                            parseDate(toDateController.text));
                                                                    // Parse from date
                                                                    final fromDate =
                                                                        DateTime.parse(
                                                                            parseDate(fromDateController.text));
                                                                    await fetchViewFreightBill(
                                                                        status: selectedStatus
                                                                            .value
                                                                            .key,
                                                                        plantId: selectedPlant
                                                                            .value
                                                                            .value,
                                                                        transporterId: selectedTransporter
                                                                            .value
                                                                            .value,
                                                                        fromDate:
                                                                            convertDateFormat(
                                                                                fromDate),
                                                                        toDate:
                                                                            convertDateFormat(toDate));
                                                                    // ignore: use_build_context_synchronously
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Ok'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                     if (!isFreightBill) //
                                    DataCell(TableColumnActionIcon(
                                        icon: Row(
                                          children: [
                                            wSpace(8),

                                            // Holding
                                            if (data[index].status ==
                                                    "APPROVED" &&
                                                data[index].sapRefNo == null &&
                                                data[index].sapResponse != null)
                                              InkWell(
                                                  onTap: () {
                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Message'),
                                                          content: const Text(
                                                              "Do you want to Hold The Bill?"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await ViewFreightBillApi()
                                                                    .holdOrUnholdBill(
                                                                  ctx: context,
                                                                  billNo: data[
                                                                          index]
                                                                      .billNo
                                                                      .toString(),
                                                                  status:
                                                                      "HOLD",
                                                                );

                                                                final toDate = DateTime
                                                                    .parse(parseDate(
                                                                        toDateController
                                                                            .text));
                                                                // Parse from date
                                                                final fromDate =
                                                                    DateTime.parse(
                                                                        parseDate(
                                                                            fromDateController.text));
                                                                await fetchViewFreightBill(
                                                                    status:
                                                                        selectedStatus
                                                                            .value
                                                                            .key,
                                                                    plantId: selectedPlant
                                                                        .value
                                                                        .value,
                                                                    transporterId:
                                                                        selectedTransporter
                                                                            .value
                                                                            .value,
                                                                    fromDate:
                                                                        convertDateFormat(
                                                                            fromDate),
                                                                    toDate: convertDateFormat(
                                                                        toDate));

                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: const Icon(
                                                    Icons.back_hand,
                                                    size: 17,
                                                    color: Colors.green,
                                                  )),
                                            //Unhloding
                                            if (data[index].status == "HOLD" &&
                                                data[index].sapRefNo == null &&
                                                data[index].sapResponse != null)
                                              InkWell(
                                                  onTap: () async {
                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Message'),
                                                          content: const Text(
                                                              "Do you want to UnHold The Bill?"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await ViewFreightBillApi()
                                                                    .holdOrUnholdBill(
                                                                  ctx: context,
                                                                  billNo: data[
                                                                          index]
                                                                      .billNo
                                                                      .toString(),
                                                                  status:
                                                                      "UNHOLD",
                                                                );

                                                                Get.back();

                                                                final toDate = DateTime
                                                                    .parse(parseDate(
                                                                        toDateController
                                                                            .text));
                                                                // Parse from date
                                                                final fromDate =
                                                                    DateTime.parse(
                                                                        parseDate(
                                                                            fromDateController.text));
                                                                await fetchViewFreightBill(
                                                                    status:
                                                                        selectedStatus
                                                                            .value
                                                                            .key,
                                                                    plantId: selectedPlant
                                                                        .value
                                                                        .value,
                                                                    transporterId:
                                                                        selectedTransporter
                                                                            .value
                                                                            .value,
                                                                    fromDate:
                                                                        convertDateFormat(
                                                                            fromDate),
                                                                    toDate: convertDateFormat(
                                                                        toDate));
                                                              },
                                                              child: const Text(
                                                                  'Yes'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                  'No'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.back_hand,
                                                    size: 17,
                                                    color: Colors.red[400],
                                                  )),

                                            wSpace(8),

                                            // resubmitting

                                            if (data[index].sapRefNo == null &&
                                                data[index].sapResponse != null)
                                              InkWell(
                                                  onTap: (data[index]
                                                                  .sapRefNo ==
                                                              null &&
                                                          data[index]
                                                                  .sapResponse !=
                                                              null &&
                                                          data[index].status !=
                                                              "HOLD")
                                                      ? () {
                                                          showDialog<void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Message'),
                                                                content: const Text(
                                                                    "Do you want to Resubmit The Bill?"),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await ViewFreightBillApi().resubmitBillLogisticsApi(
                                                                          billNo: data[index]
                                                                              .billNo
                                                                              .toString(),
                                                                          ctx:
                                                                              context);

                                                                      Get.back();

                                                                      final toDate =
                                                                          DateTime.parse(
                                                                              parseDate(toDateController.text));
                                                                      // Parse from date
                                                                      final fromDate =
                                                                          DateTime.parse(
                                                                              parseDate(fromDateController.text));
                                                                      await fetchViewFreightBill(
                                                                          status: selectedStatus
                                                                              .value
                                                                              .key,
                                                                          plantId: selectedPlant
                                                                              .value
                                                                              .value,
                                                                          transporterId: selectedTransporter
                                                                              .value
                                                                              .value,
                                                                          fromDate: convertDateFormat(
                                                                              fromDate),
                                                                          toDate:
                                                                              convertDateFormat(toDate));
                                                                      Get.back();
                                                                    },
                                                                    child: const Text(
                                                                        'Yes'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.back();
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                            'No'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                      : null,
                                                  child: Icon(
                                                    Icons.restore_page,
                                                    size: 20,
                                                    color: ColorConstant.redbar,
                                                  )),

                                            wSpace(8),

                                            //Cacelling bill

                                            if (data[index].sapRefNo == null &&
                                                data[index].sapResponse != null)
                                              InkWell(
                                                onTap: () {
                                                  showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Cancel Bill'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              customTextField2(
                                                                  controller:
                                                                      remarkController,
                                                                  label:
                                                                      "Remarks")
                                                            ],
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (remarkController
                                                                    .text
                                                                    .isEmpty) {
                                                                  showResultDialog(
                                                                      "Please enter Remarks to continue");
                                                                }

                                                                await ViewFreightBillApi().cancelBill(
                                                                    ctx:
                                                                        context,
                                                                    billNo: data[
                                                                            index]
                                                                        .billNo
                                                                        .toString(),
                                                                    status:
                                                                        "CANCEL",
                                                                    remark:
                                                                        remarkController
                                                                            .text);
                                                                final toDate = DateTime
                                                                    .parse(parseDate(
                                                                        toDateController
                                                                            .text));
                                                                // Parse from date
                                                                final fromDate =
                                                                    DateTime.parse(
                                                                        parseDate(
                                                                            fromDateController.text));
                                                                await fetchViewFreightBill(
                                                                    status:
                                                                        selectedStatus
                                                                            .value
                                                                            .key,
                                                                    plantId: selectedPlant
                                                                        .value
                                                                        .value,
                                                                    transporterId:
                                                                        selectedTransporter
                                                                            .value
                                                                            .value,
                                                                    fromDate:
                                                                        convertDateFormat(
                                                                            fromDate),
                                                                    toDate: convertDateFormat(
                                                                        toDate));

                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                  'Ok'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: const Icon(
                                                  Icons.cancel_presentation,
                                                  size: 19,
                                                  color: Colors.black,
                                                ),
                                              )
                                          ],
                                        ),
                                        index: index))
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 5),
                        child: Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: viewFreightBillResponseList1,
                              builder: (BuildContext context,
                                  List<ViewFreighBillLogisticsResponseList>
                                      value,
                                  Widget? child) {
                                if (value.isEmpty) {
                                  return Center(child: Container());
                                }
                                return Expanded(
                                  flex: 2,
                                  child: Text(
                                      "Showing 1 to ${value.length + (currentPage - 1) * int.parse(selectedDropdownValue)} of ${viewFreightBillResponseList.value.length}entries",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal)),
                                );
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            buildValueListenableBuilder(),
                            const SizedBox(
                              width: 20,
                            ),
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

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);
  List<ViewFreighBillLogisticsResponseList> getCurrentPageItems(
      List<ViewFreighBillLogisticsResponseList> items, int currentPage) {
    viewFreightBillResponseList.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<ViewFreighBillLogisticsResponseList> a =
        items.sublist(startIndex, endIndex);

    return a;
  }

  ValueListenableBuilder<List<ViewFreighBillLogisticsResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: viewFreightBillResponseList,
      builder: (BuildContext context,
          List<ViewFreighBillLogisticsResponseList> value, Widget? child) {
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

          return Row(
            children: pageWidgets,
          );
        });
      },
    );
  }
}

Widget datePicker(
    {String? label, TextEditingController? controller, VoidCallback? ontap}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label ?? "label",
        style: const TextStyle(color: Colors.black),
      ),
      Container(
        width: 283,
        height: 30,
        color: Colors.white,
        child: TextFormField(
          readOnly: true,
          style: const TextStyle(fontSize: 13, color: Colors.black),
          controller: controller,
          textAlign: TextAlign.start,
          // textAlignVertical: TextAlignVertical.center,
          onTap: ontap,
          decoration: InputDecoration(
            contentPadding: const EdgeInsetsDirectional.only(start: 15),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Colors.grey.shade600),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
            ),
            hintText: 'DD/MM/YYYY',
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Color.fromRGBO(114, 114, 114, 1),
            ),
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
      ),
    ],
  );
}

Future<void> selectDate(
    BuildContext context, TextEditingController textcontroller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    textcontroller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
  }
}

String parseDate(String inputDate) {
  // Check if the inputDate is already in the desired format
  if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(inputDate)) {
    return inputDate;
  }

  // If not in the desired format, convert it to the desired format
  final parts = inputDate.split('/');
  return '${parts[2]}-${parts[1]}-${parts[0]}';
}

String convertDateFormat(DateTime inputDate) {
  // Parse input date
  return DateFormat("yyyy-MM-dd").format(inputDate);
}

Future<void> selectFromDate(
    BuildContext context, TextEditingController textcontroller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 90)),
    lastDate: DateTime.now(),
  );

  if (pickedDate != null) {
    textcontroller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
  }
}

Future<void> selectToDate(
    BuildContext context, TextEditingController textcontroller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 90)),
    lastDate: DateTime.now(),
  );

  if (pickedDate != null) {
    textcontroller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
  }
}
//latest changes 