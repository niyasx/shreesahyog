import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/customdropdownprebid.dart';
import 'package:shreecement/features/di_pendency_screen/apis/di_pendency_apis.dart';
import 'package:shreecement/features/di_pendency_screen/models/di_pendency_response_model.dart';
import 'package:shreecement/features/invoicing/models/deliverytype_model.dart';
import 'package:shreecement/features/preBidding/api/city_list_api.dart';
import 'package:shreecement/features/preBidding/api/district_list_api.dart';
import 'package:shreecement/features/preBidding/api/states_list_api.dart';
import 'package:shreecement/features/tokenMapping/api/token_mapping_apis.dart';
import 'package:shreecement/features/tokenMapping/models/token_mapping_model.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';

import '../biddingProcess/api/manualdiallotment_action_api.dart';
import '../biddingProcess/models/manualdiallotment_action_transport_model.dart';
import '../common/controller/controller.dart';
import '../common/screens/token_expire.dart';
import '../common/widgets/custom_dropdown_3.dart';
import '../common/widgets/custom_table.dart';
import '../invoicing/apis/shortage_master_apis.dart';
import '../invoicing/logistics_invoicing/view_frieght_bill.dart';


class PendingDiViewData extends StatefulWidget {
  const PendingDiViewData({super.key});

  @override
  State<PendingDiViewData> createState() => _PendingDiViewDataState();
}

class _PendingDiViewDataState extends State<PendingDiViewData> {
  final control = Get.put(Controller());
  RxBool loaderScreen = false.obs;
//
  ValueNotifier<MapEntry<String, String>> selectedPlant =
  ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedTransporter =
  ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedDeliveryType =
  ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedState =
  ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedDistrict =
  ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedCity =
  ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedCategory =
  ValueNotifier(const MapEntry("", ""));

  ValueNotifier enabled = ValueNotifier(false);
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController truckNoController = TextEditingController();
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

  List<PendingDIResponseList> originalDIPendencyList = [];
  ValueNotifier<List<PendingDIResponseList>> viewDIPendencyResponseList = ValueNotifier([]);
  ValueNotifier<List<PendingDIResponseList>> viewDIPendencyResponseList1 = ValueNotifier([]);

  List<TokenMappingResponseList> originalTokenList = [];

  List<ResponseList> dpresponselist = [];

  List<Map<String, String>> transporterData = [];

  ValueNotifier<List<TokenMappingResponseList>> tokenMappingListResponseList =
  ValueNotifier([]);
  ValueNotifier<List<TokenMappingResponseList>> tokenMappingListResponseList1 =
  ValueNotifier([]);

  String searchValue = "";

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);
  RxInt currentPagination = 1.obs;

  RxBool refreshed = false.obs;


  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
  }

  Future<void> fetchTransporterData() async {
    try {
      var data = await ManualDiAllotmentActionApi().getTransporterNames(
          plantId:
          sp?.getString("plantId")); // Assuming sp is declared somewhere

      dpresponselist = data.responseList ?? [];

      // Create a map for each transporter
      List<Map<String, String>> transporters = [];
      transporters.add({
        "name": "Select",
        "supplier": "Select"
      }); // Add "Select" as initial value
      for (var value in dpresponselist) {
        Map<String, String> transMap = {};
        transMap["name"] = value.name.toString();
        transMap["supplier"] = value.supplier.toString();
        transporters.add(transMap);
      }

      setState(() {
        transporterData = transporters;
      });

    } catch (e) {
    }
  }

  // fetchTokenMappingList({required String transporterCode}) async {
  //   loaderScreen.value = true;
  //   final TokenMappingModel response =
  //   await TokenMappingApi().getTokenMapingDiListLogistics(ctx: context,transporterCode: transporterCode);
  //   loaderScreen.value = false;
  //   originalTokenList = response.responseList ?? [];
  //   tokenMappingListResponseList.value = List.from(originalTokenList);
  //   // tokenMappingListResponseList1.value = getCurrentPageItems(originalTokenList, currentPage);
  // }


  fetchDIPendencyList(
      {
        // required String transporterId,
        required String category,
        required String plantId,
        required String fromDate,
        required String toDate,
        String plantName = "",
        String diType = "",
        String state = "",
        String district = "",
        String city = "",
        String truckNumber = "",
        String truckType = "",
        String transporterCode = "",
        String transporterName = "",

      }) async {
    try {
      // Check if dropdown values are the default selections
      final String selectDiType = diType == "Select Delivery Type" ? "" : diType;
      final String selectTransporterCode = transporterCode == "Select Transporter" ? "" : transporterCode;

      debugPrint("start call");
      final DIPendencyResponseListModel response = await DIPendencyApis()
          .viewDIPendencyList(
        ctx: context,
          plantCode: plantId,
          fromDate: fromDate,
          toDate: toDate,
          category: category,
          plantName: plantName,
          diType: selectDiType,
          state: state,
          district: district,
          city: city,
          truckNumber: truckNumber,
          truckType: truckType,
          transporterCode: selectTransporterCode,
          transporterName: transporterName
          // status: status,
          // transporterId: transporterId
      );

      debugPrint("end call");
      debugPrint("if response data is empty: ${response.responseList?.isEmpty}");
      // print("response${response.responseList?[0].diNumber}");
      originalDIPendencyList = response.responseList ?? [];
      viewDIPendencyResponseList.value = List.from(originalDIPendencyList);
      viewDIPendencyResponseList1.value =
          getCurrentPageItems(originalDIPendencyList, currentPage);

      debugPrint("response - ${viewDIPendencyResponseList1.value[0].diNumber}");
      // setState(() {});
    } catch (e) {
      // print("error in fetch data $e");
    }
  }

  List<PendingDIResponseList> getCurrentPageItems(
      List<PendingDIResponseList> items, int currentPage) {
    // viewDIPendencyResponseList1.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    // List<PendingDIResponseList> a = items.sublist(startIndex, endIndex);

    return items.sublist(startIndex, endIndex);
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      viewDIPendencyResponseList1.value = getCurrentPageItems(originalDIPendencyList, currentPage);
      return;
    }

    List<PendingDIResponseList> filteredData = originalDIPendencyList
        .where((value) =>
    value.diNumber
        .toString()
        .toLowerCase()
        .contains(searchTerm.toLowerCase()))
        .toList();

    viewDIPendencyResponseList1.value = getCurrentPageItems(filteredData, currentPage);
  }

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
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    DateTime firstDate =DateTime(now.year, now.month, 1);  // Limit to last 31 days
    DateTime lastDate = now;
    fromDateController.text = DateFormat('dd/MM/yyyy').format(firstDate);
    toDateController.text = DateFormat('dd/MM/yyyy').format(lastDate);
    final dynamicSize = ((size.width - 312 + 20) * (100 / 5)) / 100;
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
    sp?.getString("selectedDeliveryType") == null
        ? sp?.setString("selectedDeliveryType", "isEmpty")
        : "";
    sp?.getString("selectedDeliveryTypeValue") == null
        ? sp?.setString("selectedDeliveryTypeValue", "isEmpty")
        : "";
    sp?.getString("selectedCategory") == null
        ? sp?.setString("selectedCategory", "isEmpty")
        : "";
    sp?.getString("selectedCategoryValue") == null
        ? sp?.setString("selectedCategoryValue", "isEmpty")
        : "";
    sp?.getString("fromDate") != null
        ? fromDateController.text = sp!.getString("fromDate")!
        : DateFormat('dd/MM/yyyy')
        .format(DateTime.now().subtract(const Duration(days: 90)));
    sp?.getString("toDate") != null
        ? toDateController.text = sp!.getString("toDate")!
        : DateFormat('dd/MM/yyyy').format(DateTime.now());

    return CustomScaffold(
      appBarText: "Pending DI Data",
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
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
                            spacing: 20,
                            runSpacing: 5,
                            children: [

                              FutureBuilder(
                                  future: DIPendencyApis().getDIPendencyListFromAPI(),
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
                                      if (sp?.getString("selectedCategory") ==
                                          "isEmpty") {
                                        map["Select Category"] = "Select Category";
                                        for (var element in responseList) {
                                          map[element.category] =
                                              element.srNo.toString();
                                        }
                                        selectedCategory.value = map.entries.first;
                                      } else {
                                        map[sp?.getString("selectedCategory") ??
                                            ""] =
                                            sp?.getString("selectedCategory") ??
                                                "";

                                        for (var element in responseList) {
                                          map[element.category] =
                                              element.srNo.toString();
                                        }
                                        selectedCategory.value = map.entries.first;
                                      }
                                      return ValueListenableBuilder(
                                        valueListenable: selectedCategory,
                                        builder: (BuildContext context, data,
                                            Widget? child) {
                                          return Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Category",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              CustomDropdownMenu3(
                                                  selVal:
                                                  selectedCategory.value.key,
                                                  list: map.keys.toList(),
                                                  fun: (value) async {
                                                    if (value ==
                                                        "Select Category") {
                                                      sp?.setString(
                                                          "selectedCategory",
                                                          "isEmpty");
                                                      sp?.setString(
                                                          "selectedCategoryValue",
                                                          "isEmpty");
                                                    }

                                                    selectedCategory.value =
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

                              FutureBuilder<DeliveryTypeModel>(
                                  future: refreshed.value
                                      ? null
                                      : ShortageMasterApis()
                                      .getDeliveryTypeListFromAPI(),
                                  builder: (stateIndex, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(
                                        color: ColorConstant.redbar,
                                      );
                                    } else if (snapshot.hasData) {
                                      final List responseList =
                                          snapshot.data?.responseList ??
                                              [];
                                      Map<String, String> map = {};
                                      if (sp?.getString(
                                          "selectedDeliveryType") ==
                                          "isEmpty") {
                                        map["Select Delivery Type"] =
                                        "Select Delivery Type";

                                        for (var element
                                        in responseList) {
                                          map[element.deliveryName] =
                                              element.deliveryMasterId
                                                  .toString();
                                        }
                                        selectedDeliveryType.value =
                                            map.entries.first;
                                      } else {
                                        map[sp?.getString(
                                            "selectedDeliveryType") ??
                                            ""] = sp?.getString(
                                            "selectedDeliveryType") ??
                                            "";
                                        for (var element
                                        in responseList) {
                                          map[element.deliveryName] =
                                              element.deliveryMasterId
                                                  .toString();
                                        }
                                        selectedDeliveryType.value =
                                            map.entries.first;
                                      }

                                      return ValueListenableBuilder(
                                        valueListenable:
                                        selectedDeliveryType,
                                        builder: (BuildContext context,
                                            data, Widget? child) {
                                          return Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Delivery Type",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              CustomDropdownMenu3(
                                                selVal:
                                                selectedDeliveryType
                                                    .value.key,
                                                list: map.keys.toList(),
                                                fun: (value) async {
                                                  // if (value ==
                                                  //     "Select Delivery Type") {
                                                  //   enabled.value = false;
                                                  // } else
                                                  if(value == "Select Delivery Type"){
                                                    sp?.setString("selectedDeliveryType", "isEmpty");
                                                    sp?.setString(
                                                        "selectedDeliveryTypeValue",
                                                        "isEmpty");
                                                    selectedDeliveryType.value =
                                                        MapEntry(value ?? "", "");
                                                  }

                                                  selectedDeliveryType.value =
                                                      MapEntry(
                                                        value ?? "",
                                                        map[value] ?? "",
                                                      );
                                                  /*if (selectedDeliveryType
                                                      .value.key ==
                                                      value) {
                                                    return;
                                                  } else {
                                                    bool checkVal =
                                                    await fetchInitiated();
                                                    if (checkVal) {
                                                      await showContinueDialogForReset(
                                                          "Would you like to proceed with a new Freight Bill? Please note that any previous initiations will be cleared.");

                                                      if (yesOrNo) {
                                                        // ignore: use_build_context_synchronously
                                                        FreightBillApi()
                                                            .resetInitiatedApi(
                                                            ctx:
                                                            context);
                                                        // enabled.value =
                                                        //     true;

                                                        selectedDeliveryType
                                                            .value =
                                                            MapEntry(
                                                              value ?? "",
                                                              map[value] ??
                                                                  "",
                                                            );
                                                      }
                                                    } else {
                                                      // enabled.value =
                                                      //     true;

                                                      selectedDeliveryType
                                                          .value =
                                                          MapEntry(
                                                            value ?? "",
                                                            map[value] ?? "",
                                                          );
                                                    }
                                                  }*/
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
                                          "Token Error: Recheck token in API");
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
                                                        selectedTransporter
                                                            .value = MapEntry(
                                                          value ?? "",
                                                          map[value] ?? "",
                                                        );
                                                        print(selectedTransporter.value.value);
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
                                  future:
                                  StatesListAPI().getStatesListFromAPI(),
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
                                        map[element.stateName] =
                                            element.stateCode;
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
                                                style: TextStyle(
                                                    color: Colors.black),
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
                                                  selectedState.value =
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
                              // wSpace(20),
                              ValueListenableBuilder(
                                valueListenable: selectedState,
                                builder:
                                    (BuildContext context, _, Widget? child) {
                                  return FutureBuilder(
                                    future: DistrictListAPI()
                                        .getDistrictsListFromAPI(
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
                                        selectedDistrict.value =
                                            map.entries.first;
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
                                                  selVal: selectedDistrict
                                                      .value.key,
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
                              // wSpace(20),
                              ValueListenableBuilder(
                                valueListenable: selectedState,
                                builder: (BuildContext context,
                                    MapEntry<String, String> value,
                                    Widget? child) {
                                  return ValueListenableBuilder(
                                    valueListenable: selectedDistrict,
                                    builder: (BuildContext context,
                                        MapEntry<String, String> value,
                                        Widget? child) {
                                      return FutureBuilder(
                                        future: CityListAPi().getCityNameList(
                                          districtName:
                                          selectedDistrict.value.key,
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
                                                snapshot.data?.responseList ??
                                                    [];
                                            Map<String, String> map = {};
                                            map["All"] = "All";

                                            for (var element in responseList) {
                                              map[element.cityName ?? ""] =
                                                  element.city ?? "";
                                            }
                                            selectedCity.value =
                                                map.entries.first;
                                            return ValueListenableBuilder(
                                              valueListenable: selectedCity,
                                              builder: (BuildContext context,
                                                  data, Widget? child) {
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
                                                      selVal: selectedCity
                                                          .value.key,
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
                                                        TokenExpire()),
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
                              Padding(padding: EdgeInsets.symmetric(),
                              child: customTextField(
                                label: "Truck No.",
                                controller: truckNoController,
                                onChanged: (value) {
                                  //condition for maxLength 15 no only
                                  if (value.length > 15) {
                                    truckNoController.text = value.substring(0, 15);
                                    truckNoController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: truckNoController.text.length),
                                    );
                                  }
                                },
                              ),),
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

                                    if (fromDateController.text.isEmpty ||
                                        toDateController.text.isEmpty ||
                                        selectedCategory.value.value == "Select Category" ||
                                        selectedPlant.value.key ==
                                            "Select Plant") {
                                      showResultDialog(
                                          "Please fill all required fields.");
                                      return;
                                    }
                                    try {
                                      // final toDate = DateTime.parse(
                                      //     parseDate(toDateController.text));
                                      // // Parse from date
                                      // final fromDate = DateTime.parse(
                                      //     parseDate(fromDateController.text));
                                      loaderScreen.value = true;
                                      await fetchDIPendencyList(
                                          // status: selectedStatus.value.key,
                                          plantId: selectedPlant.value.value,
                                          // plantName: selectedPlant.value.key,
                                          category: selectedCategory.value.key,
                                          diType: selectedDeliveryType.value.key,
                                          transporterCode: selectedTransporter.value.value,
                                          state: selectedState.value.value,
                                          district: selectedDistrict.value.value,
                                          city: selectedCity.value.value,
                                          truckNumber: truckNoController.text,
                                          // transporterId:
                                          // selectedTransporter.value.value,
                                          fromDate: parseDate(fromDateController.text),
                                          toDate: parseDate(toDateController.text)
                                        // fromDate: "2025-01-01",toDate: "2025-03-20"
                                      );
                                      loaderScreen.value = false;

                                      sp?.setString("selectedPlant",
                                          selectedPlant.value.key);
                                      sp?.setString("selectedPlantValue",
                                          selectedPlant.value.value);
                                      sp?.setString("selectedTransporter",
                                          selectedTransporter.value.key);
                                      sp?.setString("selectedTransporterValue",
                                          selectedTransporter.value.value);
                                      sp?.setString("selectedCategory",
                                          selectedCategory.value.key);
                                      sp?.setString("selectedCategoryValue",
                                          selectedCategory.value.value);
                                      sp?.setString(
                                          "fromDate", fromDateController.text);
                                      sp?.setString(
                                          "toDate", toDateController.text);
                                      // sp?.setString("selectedStatus",
                                      //     selectedStatus.value.key);


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
                                          "selectedPlantValue", "isEmpty");
                                      sp?.setString(
                                          "selectedTransporter", "isEmpty");
                                      sp?.setString("selectedTransporterValue",
                                          "isEmpty");
                                      sp?.setString(
                                          "selectedCategory", "isEmpty");
                                      sp?.setString("selectedCategoryValue",
                                          "isEmpty");
                                      sp?.setString(
                                          "fromDate",
                                          DateFormat('dd/MM/yyyy')
                                              .format(DateTime.now().subtract(const Duration(days: 90))));
                                      sp?.setString(
                                          "toDate",
                                          toDateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(DateTime.now()));

                                      originalDIPendencyList = [];
                                      viewDIPendencyResponseList.value = [];
                                      viewDIPendencyResponseList1.value = [];
                                      setState(() {});


                                    } catch (e) {
                                      // print(e);
                                    }
                                  }),
                              wSpace(10),
                              button(
                                  btnText: "Download",
                                  tapFunction: loaderScreen.value
                                      ? null
                                      : () async {
                                    if(selectedPlant.value.value =="Selected Plant" || selectedPlant.value.value.isEmpty){
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
                                      await DIPendencyApis().downloadDIPendencyExcelReport(
                                          startDate: parseDate(
                                              fromDateController.text),
                                          endDate: parseDate(
                                              toDateController.text),
                                          plantId: int.tryParse(selectedPlant.value.value),
                                          // reportType: selectedReportType
                                          //     .value
                                          //     .toLowerCase(),
                                          plantName:
                                          selectedPlant.value.key,
                                          category: selectedCategory.value.key,
                                          diType: selectedDeliveryType.value.key == "Select Delivery Type" ? "" : selectedDeliveryType.value.key,
                                          transporterCode: selectedTransporter.value.value == "Select Transporter" ? "" : selectedTransporter.value.key,
                                          state: selectedState.value.value,
                                          district: selectedDistrict.value.value,
                                          city: selectedCity.value.value,
                                          truckNumber: truckNoController.text,
                                      );
                                      loaderScreen.value = false;
                                    } catch (e) {
                                      debugPrint("error dist $e");
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //

                  vSpace(20),
                  tableHeading(heading: "DI Pending Data"),
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
                                          filterData(val);
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                          )),
                    ],
                  ),
                  /*ValueListenableBuilder(
                    valueListenable: viewDIPendencyResponseList1,
                    builder: (BuildContext context,
                        List<PendingDIResponseList> value, Widget? child) {
                      print("111 Di pendency - $value");
                      print("111 length- ${value.length}");
                      if (value.isEmpty) {
                        print("222$value");
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text("No data available"),
                          ),
                        );
                      }
                      // print("333 length- ${value.length}");
                      print("Builder triggered. Value length: ${value.length}");
                      for (var item in value) {
                        print("Item: ${item.diNumber}");
                      }

                      return Container(
                        color: Colors.grey.shade200,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Sr.No",
                                        flx: 1,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "DI Number",
                                        flx: 3,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "DI Date",
                                        flx: 5,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Days",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "DI Qty.",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Brand",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Product",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Consignee Address",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Customer Name",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Ship to City",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Ship to Taluka",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Ship to District",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Ship to State",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Frt. Term",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Token No.",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Remark",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Transporter Name",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "SO No.",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                  ],
                                ),
                                ListView.builder(
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
                                            columnTitle: "${index + 1}",
                                            flx: 1,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].diNumber.toString(),
                                            flx: 3,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].diDate ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].days.toString() ?? "",
                                            flx: 4,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].diQty.toString() ?? "",
                                            flx: 4,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].brand ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].product ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].consigneeAddress ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].customerName ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].cityName ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].talukaName ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].districtName ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].stateName ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].frtTerms ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].tokenNumber ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].soBiddingRemarks ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].transporterName ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].salesOrderNo ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                        ],
                                      );
                                    }),
                                vSpace(15),
                                Container(
                                  color: Colors.grey.shade200,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 5),
                                      child: Row(
                                        children: [
                                          ValueListenableBuilder(
                                            valueListenable:
                                            viewDIPendencyResponseList1,
                                            builder: (BuildContext context,
                                                List<PendingDIResponseList>
                                                value,
                                                Widget? child) {
                                              if (value.isEmpty) {
                                                return Center(child: Container());
                                              }
                                              return Expanded(
                                                flex: 2,
                                                child: Text(
                                                    "Showing ${(int.parse(selectedDropdownValue) * (currentPage - 1)) + 1} to ${(int.parse(selectedDropdownValue) * (currentPage - 1)) + value.length} of ${viewDIPendencyResponseList.value.length} entries",
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
                                          buildValueListenableBuilder()
                                        ],
                                      )),
                                ),
                              ],
                            )),
                      );
                    },
                  ),*/
                  ValueListenableBuilder(
                    valueListenable: viewDIPendencyResponseList1,
                    builder: (BuildContext context,
                        List<PendingDIResponseList> value, Widget? child) {
                      debugPrint("List-  $value");
                      // print(value.length);
                      if (value.isEmpty) {
                        // print("222--  $value");
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text("No data available"),
                          ),
                        );
                      } else {
                        debugPrint("List length--  ${value.length}");
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
                                "DI Number",
                                heading: true,
                                width: dynamicSize,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                // dropdown: true,
                                "DI Date",
                                heading: true,
                                width: dynamicSize,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                // dropdown: true,
                                "Days",
                                heading: true,
                                width: dynamicSize,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                // dropdown: true,
                                "DI Qty.",
                                heading: true,
                                width: dynamicSize,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Brand",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Category",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Product",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Package Type",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Bag Type",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Consignee Name",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Consignee Address",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Customer Name",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Ship to City",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Ship to Taluka",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Ship to District",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Ship to State",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Frt. Term",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Inco. Terms",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Frt Master",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Freight Bid",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Frt Upd.",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Token No.",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Truck No.",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Truck Status",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "So Remark",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Transporter ID",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Transporter Name",
                                width: dynamicSize,
                                heading: true,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "SO No.",
                                width: dynamicSize,
                                heading: true,
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
                                      "${index + 1}",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].diNumber ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].diDate ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].days.toString() ?? '',
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].diQty.toString() ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].brand ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].category ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].product ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].materialFrtGrpName ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].bagType ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].consignorName ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].consignorAddress ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].customerName ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].cityName ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].talukaName ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].districtName ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].stateName ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].frtTerms ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].incoTerms ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].frtRate?.toString() ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].bidRate?.toString() ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].newFrtAmount?.toString() ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].tokenNumber ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].truckNumber ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].truckStatus ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].soBiddingRemarks ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].transporterId ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].transporterName ?? "",
                                      index: index,
                                    ),
                                  ),
                                  DataCell(
                                    TableColumn(
                                      value[index].salesOrderNo ?? "",
                                      index: index,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
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
                                valueListenable: viewDIPendencyResponseList1,
                                builder: (BuildContext context,
                                    List<PendingDIResponseList> value,
                                    Widget? child) {
                                  return Expanded(
                                    flex: 2,
                                    child: Text(
                                        "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length + (currentPage - 1) * int.parse(selectedDropdownValue)} of ${viewDIPendencyResponseList.value.length} entries",
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
                  /*vSpace(15),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: viewDIPendencyResponseList,
                          builder: (BuildContext context,
                              List<PendingDIResponseList> value,
                              Widget? child) {
                            if (value.isEmpty) {
                              return Center(child: Container());
                            }
                            return Expanded(
                              flex: 2,
                              child: Text(
                                  "Showing 1 to ${value.length} of ${value.length} entries",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            );
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: viewDIPendencyResponseList,
                          builder: (BuildContext context,
                              List<PendingDIResponseList> value,
                              Widget? child) {
                            if (value.isEmpty) {
                              return Center(child: Container());
                            } else if (value.length <= 10) {
                              return Row(
                                children: [
                                  navBox(
                                      boxWidth: 25,
                                      text: "1",
                                      txtClr: Colors.white,
                                      bgClr: ColorConstant.redbar),
                                ],
                              );
                            } else if (value.length <= 20) {
                              return Row(
                                children: [
                                  navBox(
                                      boxWidth: 25,
                                      text: "1",
                                      txtClr: Colors.white,
                                      bgClr: ColorConstant.redbar),
                                  navBox(
                                      boxWidth: 25,
                                      text: "2",
                                      txtClr: ColorConstant.redbar),
                                ],
                              );
                            } else if (value.length <= 30) {
                              Row(
                                children: [
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
                                ],
                              );
                            }
                            return Row(
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
                            );
                          },
                        )
                      ],
                    ),
                  )*/
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

  ValueListenableBuilder<List<PendingDIResponseList>>
  buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: viewDIPendencyResponseList,
      builder: (BuildContext context, List<PendingDIResponseList> value,
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

          return Row(
            children: pageWidgets,
          );
        });
      },
    );
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


