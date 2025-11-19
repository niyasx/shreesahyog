// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_dropdown_3.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/common/widgets/customdropdownprebid.dart';
import 'package:shreecement/features/invoicing/models/view_freightbill_model.dart';
import 'package:shreecement/utils/color_constant.dart';

import '../../biddingProcess/api/de_link_api.dart';
import '../../biddingProcess/api/manualdiallotment_action_api.dart';
import '../../common/screens/token_expire.dart';
import '../api/get_pending_epod.dart';
import '../models/epod_model.dart';

class EpodScreen extends StatefulWidget {
  const EpodScreen({super.key});

  @override
  State<EpodScreen> createState() => _EpodScreenState();
}

class _EpodScreenState extends State<EpodScreen> {
  final Controller control = Get.find(); // Access the controller

  ValueNotifier enabled = ValueNotifier(false);
  RxBool loaderScreen = false.obs;
  ValueNotifier<MapEntry<String, String>> selectedPlant =
      ValueNotifier(const MapEntry("", ""));

  ValueNotifier<String> selectedDeliveryType2 = ValueNotifier("DI");
  ValueNotifier<MapEntry<String, String>> selectedTransporter =
      ValueNotifier(const MapEntry("", ""));

  List<EPODResponseList> originalViewFreightBillList = [];
  ValueNotifier<List<EPODResponseList>> viewFreightBillResponseList =
      ValueNotifier([]);
  ValueNotifier<List<EPODResponseList>> viewFreightBillResponseList1 =
      ValueNotifier([]);

  RxInt currentPagination = 1.obs;
  String searchValue = "";

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
  }

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);
  List<EPODResponseList> getCurrentPageItems(
      List<EPODResponseList> items, int currentPage) {
    viewFreightBillResponseList1.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<EPODResponseList> a = items.sublist(startIndex, endIndex);

    return a;
  }

  fetchPendingEpod() async {
    loaderScreen.value = true;
    final toDate = DateTime.parse(parseDate(toDateController.text));
    // Parse from date
    final fromDate = DateTime.parse(parseDate(fromDateController.text));
    final EpodDetails response = await getPendingEpod(
      plantId: selectedPlant.value.value == "Select Plant"
          ? ""
          : selectedPlant.value.value,
      transporterId: selectedTransporter.value.value == "Select Transporter"
          ? ""
          : selectedTransporter.value.value,
      fromDate: convertDateFormat(fromDate),
      toDate: convertDateFormat(toDate),
      diType: "DI",
    );
    loaderScreen.value = false;

    originalViewFreightBillList = response.responseList ?? [];

    viewFreightBillResponseList.value = List.from(originalViewFreightBillList);
    filterData(searchValue);
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      viewFreightBillResponseList1.value =
          getCurrentPageItems(originalViewFreightBillList, currentPage);
      return;
    }

    List<EPODResponseList> filteredData = originalViewFreightBillList
        .where((value) =>
            value.stateName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.districtName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.cityName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.customerName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.plantName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.talukaName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.consigneeAddress
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
            value.invoiceNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.ewayBillNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.grNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.division
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    viewFreightBillResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  List<ViewFreighBillResponseList> responselist = [];
  // int? index1;

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    fromDateController.text = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().subtract(const Duration(days: 90)));
    toDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 8)) / 100;
    return CustomScaffold(
      appBarText: "EPOD",
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
                    'EPOD Details',
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
                    heading: "Search",
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
                                runSpacing: 5,
                                children: [
                                  //dropdown for getting the plant details

                                  FutureBuilder(
                                      future: DelinkApi().getDelinkPlantList(),
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
                                          map["Select Plant"] = "Select Plant";
                                          for (var element in responseList) {
                                            map[element.plantName] =
                                                element.plantCode;
                                          }
                                          selectedPlant.value =
                                              map.entries.first;
                                          return ValueListenableBuilder(
                                            valueListenable: selectedPlant,
                                            builder: (BuildContext context,
                                                data, Widget? child) {
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
                                                    fun: (value) {
                                                      if (value ==
                                                          "Select Plant") {
                                                        enabled.value = false;
                                                        setState(() {});
                                                      } else {
                                                        enabled.value = true;
                                                      }
                                                      selectedPlant.value =
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
                                          return const Text(
                                              "Something is not right!");
                                        }
                                      }),

                                  wSpace(16),
                                  //drop down for getting the transporters list according to plant
                                  ValueListenableBuilder(
                                      valueListenable: selectedPlant,
                                      builder: (BuildContext context,
                                          MapEntry<String, String> value,
                                          Widget? child) {
                                        if (selectedPlant.value.value != "") {
                                          return FutureBuilder(
                                            future: ManualDiAllotmentActionApi()
                                                .getTransporterNames(
                                                    plantId: selectedPlant
                                                        .value.value),
                                            builder:
                                                (transporterIndex, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(
                                                  color: ColorConstant.redbar,
                                                );
                                              } else if (snapshot.hasData) {
                                                final responseList = snapshot
                                                        .data?.responseList ??
                                                    [];
                                                Map<String, String> map = {};
                                                map["Select Transporter"] =
                                                    "Select Transporter";

                                                for (var element
                                                    in responseList) {
                                                  map[element.name ?? ""] =
                                                      element.supplier ?? "";
                                                }
                                                selectedTransporter.value =
                                                    map.entries.first;

                                                return ValueListenableBuilder(
                                                  valueListenable:
                                                      selectedTransporter,
                                                  builder:
                                                      (BuildContext context,
                                                          data, Widget? child) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Transporter",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        CustomDropdownMenu3(
                                                          selVal:
                                                              selectedTransporter
                                                                  .value.key,
                                                          list:
                                                              map.keys.toList(),
                                                          fun: (value) {
                                                            if (value ==
                                                                "Select Transporter") {
                                                              enabled.value =
                                                                  false;
                                                            } else {
                                                              enabled.value =
                                                                  true;
                                                            }
                                                            selectedTransporter
                                                                    .value =
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
                                                Future.delayed(Duration.zero,
                                                    () {
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
                                          map["Select Transporter"] =
                                              "Select Transporter";
                                          selectedTransporter.value =
                                              map.entries.first;
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
                                                    selVal: selectedTransporter
                                                        .value.key,
                                                    list: map.keys.toList(),
                                                    fun: (value) {
                                                      if (value ==
                                                          "Select Transporter") {
                                                        enabled.value = false;
                                                      } else {
                                                        enabled.value = true;
                                                      }
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
                                        }
                                      }),
                                  size.width > 600 ? wSpace(16) : Container(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Delivery Type",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      CustomDropdownMenu3(
                                          selVal: selectedDeliveryType2.value,
                                          list: const ["DI"],
                                          fun: null
                                          // (value) {
                                          //   if (value ==
                                          //       "Select Delivery Type") {
                                          //     enabled.value = false;
                                          //   } else {
                                          //     enabled.value = true;
                                          //   }
                                          //   selectedDeliveryType.value =
                                          //       MapEntry(
                                          //     value ?? "",
                                          //     map[value] ?? "",
                                          //   );
                                          // },
                                          ),
                                    ],
                                  ),

                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [SizedBox()],
                                  ),
                                ],
                              ),
                              vSpace(10),
                              Wrap(
                                children: [
                                  datePicker(
                                    label: "From Date",
                                    controller: fromDateController,
                                    ontap: () => selectFromDate(
                                        context, fromDateController),
                                  ),
                                  wSpace(20),
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
                                          await fetchPendingEpod();
                                        } catch (e) {
                                          // // print("error in fetch");
                                        }
                                      }),
                                  wSpace(10),
                                  button(
                                      btnText: "Reset",
                                      btnClr: Colors.white,
                                      btnTxtClr: ColorConstant.redbar,
                                      tapFunction: () async {
                                        try {
                                          fromDateController.text = DateFormat(
                                                  'dd/MM/yyyy')
                                              .format(DateTime.now().subtract(
                                                  const Duration(days: 90)));
                                          toDateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now());

                                          selectedPlant.value = const MapEntry(
                                              "Select Plant", "Select Plant");
                                          selectedTransporter.value =
                                              const MapEntry(
                                                  "Select Transporter",
                                                  "Select Transporter");
                                        } catch (e) {
                                          // // print('error in resetting $e');
                                        }
                                      }),
                                ],
                              ),
                            ]),
                      )),
                  vSpace(20),
                  tableHeading(heading: "Search Results"),
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
                                      searchValue = val;
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
                      valueListenable: viewFreightBillResponseList1,
                      builder: (BuildContext context,
                          List<EPODResponseList> data, Widget? child) {
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
                                  " Sr.No",
                                  heading: true,
                                  width: 32,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Plant ID",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Plant Name",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " DI No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Customer Name",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Consignee Address",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Brand",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Product",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Eway Bill No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Eway Bill Date",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Invoice No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Invoice Date",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " GR No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  " Actions",
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
                                      "${index + int.parse(selectedDropdownValue) * (currentPage - 1) + 1}",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      data[index].plantId.toString(),
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      data[index].plantName ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      data[index].diNumber ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      data[index].customerName ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      textTrim: true,
                                      data[index].consigneeAddress ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      data[index].brand ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      data[index].product ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      data[index].ewayBillNumber ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      data[index].ewayBillDate ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      data[index].invoiceNumber ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      formatDate(data[index].invoiceDate),
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      data[index].grNumber ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumnActionIcon(
                                      index: index,
                                      icon: const Icon(
                                        Icons.save,
                                        color: Colors.green,
                                      ),
                                      onPressed: () async {
                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Message'),
                                              content: const Text(
                                                  "Do you want to confirm EPod?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () async {
                                                    await epodStatusUpdate(
                                                        diNumber: data[index]
                                                            .diNumber,
                                                        status: 1,
                                                        invoiceNumber:
                                                            data[index]
                                                                .invoiceNumber);
                                                    await fetchPendingEpod();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('No'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                                  List<EPODResponseList> value, Widget? child) {
                                if (value.isEmpty) {
                                  return Center(child: Container());
                                }
                                return Expanded(
                                  flex: 2,
                                  child: Text(
                                      "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length + (currentPage - 1) * int.parse(selectedDropdownValue)} of ${viewFreightBillResponseList.value.length} entries",
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

  ValueListenableBuilder<List<EPODResponseList>> buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: viewFreightBillResponseList,
      builder:
          (BuildContext context, List<EPODResponseList> value, Widget? child) {
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

String formatDate(String? dateTimeString) {
  if (dateTimeString == null) {
    return '';
  }

  DateTime dateTime = DateTime.parse(dateTimeString);
  return DateFormat.yMMMd().format(dateTime);
}
