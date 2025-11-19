// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/preBidding/apiModels/district.dart';
import 'package:shreecement/features/preBidding/apiModels/states.dart';
import 'package:shreecement/features/super_admin/api/state_api.dart';
import 'package:shreecement/features/super_admin/model/transporter_list.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:http/http.dart' as http;

import '../../../global.dart';
import '../../../main.dart';
import '../../common/models/plant_list_model.dart';
import '../../common/screens/token_expire.dart';
import '../../common/widgets/custom_dropdown_3.dart';
import '../../epod/screens/epod_screen.dart';
import '../api/reports_api.dart';

class BidReports extends StatefulWidget {
  const BidReports({
    super.key,
  });

  @override
  State<BidReports> createState() => BidReportsState();
}

class BidReportsState extends State<BidReports> {
  RxBool loaderScreen = false.obs;

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
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

  List<String> manualAuto = ['Manual', 'Scheduled'];
  ValueNotifier<String> selectedReportType = ValueNotifier("Scheduled");

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController statetextEditingController =
      TextEditingController();
  ValueNotifier<MapEntry<String, int>> selectedPlant =
      ValueNotifier(const MapEntry("", 0));
  RxList<TransporterList> rxTransporterList = RxList();
  RxList<ResponseList> rxStateList = RxList();
  RxList<DistrictResponseList> rxDistrictList = RxList();
  String selectedValue = '';
  RxString selectedState = ''.obs;
  RxString selectedDist = "".obs;
  String selectedTransporterid = "";
  String searchValue = "";

  String? selectedStateCode = "";

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

  // List to store selected districts
  TextEditingController searchController = TextEditingController();

  List<DistrictResponseList> districtList = [];
  RxList<DistrictResponseList> districtResponseListForEdit = RxList();
  List<DistrictResponseList> districtResponseToFilter = [];
  ValueNotifier<List<DistrictResponseList>> districtListResponceList =
      ValueNotifier([]);

  // Other existing code...

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDate =DateTime(now.year, now.month, 1);  // Limit to last 31 days
    DateTime lastDate = now;
    fromDateController.text = DateFormat('dd/MM/yyyy').format(firstDate);
    toDateController.text = DateFormat('dd/MM/yyyy').format(lastDate);

    return CustomScaffold(
      appBarText: "Reports/View Bid Report",
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tableHeading(heading: "Search"),
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
                            children: [
                              //drop down for getting the transporters list according to plant
                              FutureBuilder(
                                  future: loaderScreen.value
                                      ? null
                                      : getAllPlantList(context),
                                  builder: (stateIndex, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(
                                        color: ColorConstant.redbar,
                                      );
                                    } else if (snapshot.hasData) {
                                      final List responseList =
                                          snapshot.data?.responseList ?? [];
                                      Map<String, int> map = {};

                                      map["Select Plant"] = 0;
                                      for (var element in responseList) {
                                        map[element.plantName] =
                                            element.plantCode;
                                      }
                                      selectedPlant.value = map.entries.first;

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
                                                    if (selectedPlant.value.key
                                                            .compareTo(
                                                                value ?? "") ==
                                                        0) {
                                                      return;
                                                    } else {
                                                      selectedPlant.value =
                                                          MapEntry(
                                                        value ?? "",
                                                        map[value] ?? 0,
                                                      );
                                                    }
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
                                          "Token Error: Recheck token in API");
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
                              ValueListenableBuilder(
                                valueListenable: selectedReportType,
                                builder: (BuildContext context, data,
                                    Widget? child) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Report Type",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      CustomDropdownMenu3(
                                          selVal: selectedReportType.value,
                                          list: manualAuto,
                                          fun: (value) async {
                                            if (selectedReportType.value
                                                    .compareTo(value ?? "") ==
                                                0) {
                                              return;
                                            } else {
                                              selectedReportType.value =
                                                  value ?? "";
                                            }
                                          }),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                          vSpace(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              button(
                                  btnText: "Download",
                                  tapFunction: loaderScreen.value
                                      ? null
                                      : () async {
                                    if(selectedPlant.value.value==0){
                                      Get.dialog(
                                          AlertDialog(
                                            title: const Text("Error"),
                                            content: const Text(
                                                "Please select a plant"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Get.back(); // Close the dialog
                                                },
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          )
                                      );
                                      return;
                                    }
                                          try {
                                            loaderScreen.value = true;
                                            await downloadExcelSheetReport(
                                                startDate: parseDate(
                                                    fromDateController.text),
                                                endDate: parseDate(
                                                    toDateController.text),
                                                plantId:
                                                    selectedPlant.value.value,
                                                reportType: selectedReportType
                                                    .value
                                                    .toLowerCase(),
                                                plantName:
                                                    selectedPlant.value.key);
                                            loaderScreen.value = false;
                                          } catch (e) {
                                            // debugPrint("error dist $e");
                                          }
                                        }),
                              wSpace(10),
                              button(
                                  btnText: "Reset",
                                  btnClr: Colors.white,
                                  btnTxtClr: ColorConstant.redbar,
                                  tapFunction: () async {
                                    try {
                                      setState(() {});
                                      selectedReportType.value = "Scheduled";
                                      //   fromDateController.text=;
                                      // toDateController.text=;
                                      DateTime now = DateTime.now();
                                      DateTime firstDate = now.subtract(
                                          const Duration(
                                              days:
                                                  31)); // Limit to last 31 days
                                      DateTime lastDate = now;

                                      // Current date is greater than 5th of the month
                                      fromDateController.text =
                                          DateFormat('dd/MM/yyyy')
                                              .format(firstDate);
                                      toDateController.text =
                                          DateFormat('dd/MM/yyyy')
                                              .format(lastDate);
                                    } catch (e) {
                                      // print('error in resetting $e');
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
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

  void callTransporterApi() async {
    loaderScreen.value = true;
    var list = await StateApi().getTransporterList(context);
    loaderScreen.value = false;
    var transporterObj = TransporterList(name: 'Select Transporter');
    if (rxTransporterList.isNotEmpty) {
      rxTransporterList
        ..clear()
        ..add(transporterObj)
        ..addAll(list.transporterList!)
        ..refresh();
    } else {
      rxTransporterList
        ..add(transporterObj)
        ..addAll(list.transporterList!)
        ..refresh();
    }
    selectedValue = rxTransporterList[0].name!;
  }

  Future<dynamic> getAllPlantList(BuildContext ctx) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.https(domain, "/app/master/getallplants");
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      if (res.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }

      final result = jsonDecode(res.body);
      // print(result);
      return PlantListModelAdmin.fromJson(result);
    } catch (e) {
      // print("error in tokenmap api $e");
    }
  }
  Future<void> selectFromDate(
      BuildContext context, TextEditingController fromDateController) async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(2024, 1, 1); // Set to 1st January 2024
    DateTime lastDate = now;
    DateTime initialDate = DateTime(now.year, now.month, 1);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      fromDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      // Store the selected from date in a global variable or state
      _selectedFromDate = pickedDate;

      // Calculate the last valid toDate based on fromDate
      DateTime calculatedLastDate = pickedDate.add(const Duration(days: 31));
      if (calculatedLastDate.isAfter(now)) {
        calculatedLastDate = now;
      }

      toDateController.text = DateFormat('dd/MM/yyyy').format(calculatedLastDate);
    }
  }

// Global variable to store the selected from date
  DateTime? _selectedFromDate;

  Future<void> selectToDate(
      BuildContext context, TextEditingController textController) async {
    DateTime now = DateTime.now();
    DateTime firstDate = _selectedFromDate ?? now.subtract(const Duration(
        days: 31)); // Default to last 31 days if from date not selected
    DateTime lastDate = _selectedFromDate != null
        ? _selectedFromDate!.add(const Duration(days: 31))
        : now;

    if (lastDate.isAfter(now)) {
      lastDate = now;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      textController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }
}
