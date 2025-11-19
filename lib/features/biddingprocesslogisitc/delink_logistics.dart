import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/biddingProcess/api/de_link_api.dart';
import 'package:shreecement/features/biddingProcess/api/manualdiallotment_action_api.dart';
import 'package:shreecement/features/biddingProcess/models/delink_model.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/controller/limitedtextcontroller.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';

import '../../global.dart';
import '../common/models/delink_reasons_model.dart';
import '../common/widgets/custom_drop_down.dart';
import '../common/widgets/custom_dropdown_3.dart';
import 'package:http/http.dart' as http;

class DelinkLogistics extends StatefulWidget {
  const DelinkLogistics({
    super.key,
  });

  @override
  State<DelinkLogistics> createState() => DelinkLogisticsState();
}

class DelinkLogisticsState extends State<DelinkLogistics> {
  final Controller control = Get.find(); // Access the controller
  ValueNotifier switchState = ValueNotifier(false);
  RxBool loaderScreen = false.obs;

  List<ValueNotifier<bool>> incDecFrtSwitchList = [];
  List<ValueNotifier<bool>> savedSuccess = [];

  List<LimitedLengthTextController> reasonTextController = [];

  ValueNotifier enabled = ValueNotifier(false);

  ValueNotifier<MapEntry<String, String>> selectedPlant =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedTokenNo =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedTransporter =
      ValueNotifier(const MapEntry("", ""));
  List<ValueNotifier<MapEntry<String, String>>> selectedReason = [];

  List<DeLinkResponseList> originalDeLinkList = [];
  List<DeLinkResponseList> filterDeLinkList = [];
  ValueNotifier<List<DeLinkResponseList>> deLinkListResponseList =
      ValueNotifier([]);

  Future<DelinkReasonListResponse> getReasons() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/delink-reasons";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = json.decode(res.body);
    // print(result);
    return DelinkReasonListResponse.fromJson(result);
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

  fetchUnLinkList() async {
    loaderScreen.value = true;
    final DeLinkModel response = await DelinkApi().getDeLinkActionData(
      plantId: selectedPlant.value.value == "Select Plant"
          ? ""
          : selectedPlant.value.value,
      transporterId: selectedTransporter.value.value == "Select Transporter"
          ? ""
          : selectedTransporter.value.value,
      tokenNumber: selectedTokenNo.value.key == "Select Token No."
          ? ""
          : selectedTokenNo.value.key,
    );
    loaderScreen.value = false;
    incDecFrtSwitchList.clear();
    savedSuccess.clear();
    reasonTextController.clear();
    filterDeLinkList.clear();

    List<DeLinkResponseList> responseList = response.responseList ?? [];

    for (var element in responseList) {
      incDecFrtSwitchList.add(ValueNotifier(element.unlinkStatus ?? false));
      selectedReason.add(ValueNotifier(const MapEntry("", "")));
      savedSuccess.add(ValueNotifier(element.unlinkStatus ?? false));
      reasonTextController.add(
        LimitedLengthTextController(text: element.diUnlinkReason),
      );
    }
    originalDeLinkList = response.responseList ?? [];
    for (int i = 0; i < originalDeLinkList.length; i++) {
      if (originalDeLinkList[i].tokenNumber != null &&
          originalDeLinkList[i].tokenNumber.toString().trim().isNotEmpty) {
        filterDeLinkList.add(originalDeLinkList[i]);
      }
      // filterDeLinkList.add(originalDeLinkList[i]);
    }
    deLinkListResponseList.value = List.from(filterDeLinkList);

    if (response.responseList!.isEmpty) {
      showResultDialog("No Data Available For This Plant");
    }
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      deLinkListResponseList.value = List.from(filterDeLinkList);
      return;
    }

    List<DeLinkResponseList> filteredData = filterDeLinkList
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
            value.diUnlinkReason
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.plantName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.transporterName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.tokenNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    deLinkListResponseList.value = filteredData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReasons();
  }

  List<DelinkReason> reasonresponseList = [];
  List<Map<String, String>> reasonsData = [];

  Future<void> fetchReasons() async {
    try {
      var data =
          await getReasons(); // Assuming getReasons is a function that fetches reasons
      reasonresponseList = data.responseList ?? [];
      List<Map<String, String>> reasonss = [];
      reasonss.add(
          {"reasonDesc": "Select a Reason", "reasonCode": "Select a Reason"});
      for (var element in reasonresponseList) {
        Map<String, String> map = {};

        map[element.reasonDesc ?? ""] = element.reasonCode ?? "";
        reasonss.add(map);
      }

      setState(() {
        reasonsData = reasonss;
      }); // Update the UI to reflect the fetched data
    } catch (e) {
      // print("Error fetching reasons: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 10)) / 100;
    return CustomScaffold(
      appBarText: "Unlink Token",
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
                    'Unlink Token',
                    style: TextStyle(
                        fontSize: 21,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w100),
                  ),
                  vSpace(20),
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
                                                selVal: selectedPlant.value.key,
                                                list: map.keys.toList(),
                                                fun: (value) {
                                                  if (value == "Select Plant") {
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
                                      Future.delayed(Duration.zero, () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TokenExpire()),
                                              );
                                            });
                                      return const Text(
                                          "Something is not right!");
                                    }
                                  }),
                              size.width > 600 ? wSpace(16) : const SizedBox(),
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
                                            map["Select Transporter"] =
                                                "Select Transporter";

                                            for (var element in responseList) {
                                              map[element.name ?? ""] =
                                                  element.supplier ?? "";
                                            }
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
                                                      selVal:
                                                          selectedTransporter
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
                                                  if (value ==
                                                      "Select Transporter") {
                                                    enabled.value = false;
                                                  } else {
                                                    enabled.value = true;
                                                  }
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
                              size.width > 600 ? wSpace(16) : const SizedBox(),
                              ValueListenableBuilder(
                                valueListenable: selectedPlant,
                                builder: (BuildContext context,
                                    MapEntry<String, String> value,
                                    Widget? child) {
                                  return
                                      //drop down for getting the token number list according to transporter and plant
                                      ValueListenableBuilder(
                                          valueListenable: selectedTransporter,
                                          builder: (BuildContext context,
                                              MapEntry<String, String> value,
                                              Widget? child) {
                                            if (selectedTransporter
                                                    .value.value !=
                                                "Select Transporter") {
                                              return FutureBuilder(
                                                future: DelinkApi()
                                                    .getTokenNumberList(
                                                  plantId:
                                                      selectedPlant.value.value,
                                                  transporterId:
                                                      selectedTransporter
                                                          .value.value,
                                                ),
                                                builder:
                                                    (districtIndex, snapshot) {
                                                  // print(snapshot.data);
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator(
                                                      color:
                                                          ColorConstant.redbar,
                                                    );
                                                  } else if (snapshot.hasData) {
                                                    final responseList = snapshot
                                                            .data
                                                            ?.responseList ??
                                                        [];
                                                    Map<String, String> map =
                                                        {};
                                                    map["Select Token No."] =
                                                        "Select Token No.";
                                                    for (var element
                                                        in responseList) {
                                                      map[element.toString()] =
                                                          element.toString();
                                                    }
                                                    selectedTokenNo.value =
                                                        map.entries.first;
                                                    return ValueListenableBuilder(
                                                      valueListenable:
                                                          selectedTokenNo,
                                                      builder:
                                                          (BuildContext context,
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
                                                              "Token No.",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            CustomDropdownMenu3(
                                                              selVal:
                                                                  selectedTokenNo
                                                                      .value
                                                                      .key,
                                                              list: map.keys
                                                                  .toList(),
                                                              fun: (value) {
                                                                if (value ==
                                                                    "Select Token No.") {
                                                                  enabled.value =
                                                                      false;
                                                                  if (selectedPlant
                                                                          .value
                                                                          .key ==
                                                                      "Select Plant") {
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                } else {
                                                                  enabled.value =
                                                                      true;
                                                                }
                                                                selectedTokenNo
                                                                        .value =
                                                                    MapEntry(
                                                                  value ?? "",
                                                                  map[value] ??
                                                                      "",
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    return const Text(
                                                        "No Data");
                                                  }
                                                },
                                              );
                                            } else {
                                              Map<String, String> map = {};
                                              map["Select Token No."] =
                                                  "Select Token No.";
                                              selectedTokenNo.value =
                                                  map.entries.first;
                                              return ValueListenableBuilder(
                                                valueListenable:
                                                    selectedTokenNo,
                                                builder: (BuildContext context,
                                                    data, Widget? child) {
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        "Token No.",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      CustomDropdownMenu3(
                                                        selVal: selectedTokenNo
                                                            .value.key,
                                                        list: map.keys.toList(),
                                                        fun: (value) {
                                                          if (value ==
                                                              "Select Token No.") {
                                                            enabled.value =
                                                                false;
                                                            if (selectedPlant
                                                                    .value
                                                                    .key ==
                                                                "Select Plant") {
                                                              setState(() {});
                                                            }
                                                          } else {
                                                            enabled.value =
                                                                true;
                                                          }
                                                          selectedTokenNo
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
                                          });
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
                                  btnText: "Search",
                                  tapFunction: () async {
                                    try {
                                      await fetchUnLinkList();
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
                                      selectedPlant.value = const MapEntry(
                                          "Select Plant", "Select Plant");
                                      selectedTransporter.value =
                                          const MapEntry("Select Transporter",
                                              "Select Transporter");
                                      selectedTokenNo.value = const MapEntry(
                                          "Select Token No.",
                                          "Select Token No.");
                                      await fetchUnLinkList();
                                    } catch (e) {
                                      // // print('error in resetting $e');
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  vSpace(24),
                  tableHeading(heading: "Search Result"),
                  vSpace(6),
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
                                          child: CustomDropdownMenu(
                                              selVal: "All",
                                              list: const ["All"])),
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
                    valueListenable: deLinkListResponseList,
                    builder: (BuildContext context,
                        List<DeLinkResponseList> data, Widget? child) {
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
                          const DataColumn(
                            label: TableColumn(
                              " Sr.No",
                              heading: true,
                              width: 32,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              " Plant",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              " State",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              " District",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              " City",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              " Transporter",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              " Token No.",
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
                              " Link / Unlink",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              " Reason",
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
                                  "${index + 1}",
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
                                  data[index].stateName ?? "",
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].districtName ?? "",
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].cityName ?? "",
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].transporterName ?? "",
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].tokenNumber ?? "",
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      '  Link ',
                                      style: TextStyle(
                                        color: Color(0xFF727272),
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable:
                                          incDecFrtSwitchList[index],
                                      builder: (BuildContext context,
                                          bool value, Widget? child) {
                                        return Transform.scale(
                                            scaleX: 0.75,
                                            scaleY: 0.7,
                                            child: Switch(
                                              activeTrackColor:
                                                  ColorConstant.redbar,
                                              inactiveTrackColor: Colors.grey,
                                              inactiveThumbColor: Colors.white,
                                              value: incDecFrtSwitchList[index]
                                                  .value,
                                              onChanged: (value) {
                                                incDecFrtSwitchList[index]
                                                    .value = value;
                                              },
                                            ));
                                      },
                                    ),
                                    const Text(
                                      ' Unlink  ',
                                      style: TextStyle(
                                        color: Color(0xFF727272),
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Builder(builder: (context) {
                                Map<String, String> map = {};
                                map["Select a Reason"] = "Select a Reason";

                                for (var element in reasonresponseList) {
                                  map[element.reasonDesc ?? ""] =
                                      element.reasonCode ?? "";
                                }
                                selectedReason[index].value = map.entries.first;

                                return ValueListenableBuilder(
                                  valueListenable: selectedReason[index],
                                  builder: (BuildContext context, data,
                                      Widget? child) {
                                    return CustomDropdownMenu4(
                                      width: 252,
                                      selVal: selectedReason[index].value.key,
                                      list: map.keys.toList(),
                                      fun: (value) {
                                        if (value == "Select a Reason") {
                                          enabled.value = false;
                                        } else {
                                          enabled.value = true;
                                        }
                                        selectedReason[index].value = MapEntry(
                                          value ?? "",
                                          map[value] ?? "",
                                        );
                                      },
                                    );
                                  },
                                );
                              })
                                  //   FutureBuilder(
                                  //   future: getReasons(),
                                  //   builder: (reasonIndex, snapshot) {
                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return CircularProgressIndicator(
                                  //         color: ColorConstant.redbar,
                                  //       );
                                  //     } else if (snapshot.hasData) {
                                  //       final responseList =
                                  //           snapshot.data?.responseList ?? [];
                                  //       Map<String, String> map = {};
                                  //       map["Select a Reason"] = "Select a Reason";

                                  //       for (var element in responseList) {
                                  //         map[element.reasonDesc ?? ""] =
                                  //             element.reasonCode ?? "";
                                  //       }
                                  //       selectedReason[index].value = map.entries.first;

                                  //       return ValueListenableBuilder(
                                  //         valueListenable: selectedReason[index],
                                  //         builder: (BuildContext context, data,
                                  //             Widget? child) {
                                  //           return CustomDropdownMenu4(
                                  //             width: 252,
                                  //             selVal: selectedReason[index].value.key,
                                  //             list: map.keys.toList(),
                                  //             fun: (value) {
                                  //               if (value == "Select a Reason") {
                                  //                 enabled.value = false;
                                  //               } else {
                                  //                 enabled.value = true;
                                  //               }
                                  //               selectedReason[index].value = MapEntry(
                                  //                 value ?? "",
                                  //                 map[value] ?? "",
                                  //               );
                                  //             },
                                  //           );
                                  //         },
                                  //       );
                                  //     } else {
                                  //       return const Text(
                                  //           "Token Error : Re check token in API");
                                  //     }
                                  //   },
                                  // )
                                  ),
                              DataCell(
                                ValueListenableBuilder(
                                  valueListenable: savedSuccess[index],
                                  builder: (BuildContext context, bool value,
                                      Widget? child) {
                                    return TableColumnActionIcon(
                                      index: index,
                                      icon: value
                                          ? Icon(
                                              Icons.thumb_up_alt_outlined,
                                              color: Colors.blue.shade800,
                                              size: 18,
                                            )
                                          : const Icon(
                                              Icons.save,
                                              color: Colors.green,
                                              size: 18,
                                            ),
                                      onPressed: value
                                          ? null
                                          : () async {
                                              if (selectedReason[index]
                                                      .value
                                                      .value ==
                                                  "Select a Reason") {
                                                // Show a dialog if any field is empty
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Error'),
                                                      content: const Text(
                                                          'Please fill all fields.'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                try {
                                                  loaderScreen.value = true;
                                                  await DelinkApi().saveUnlinkData(
                                                      diNumber: data[index]
                                                              .diNumber ??
                                                          "",
                                                      reason:
                                                          selectedReason[index]
                                                              .value
                                                              .key
                                                              .toString()
                                                              .trim(),
                                                      code:
                                                          selectedReason[index]
                                                              .value
                                                              .value
                                                              .toString()
                                                              .trim(),
                                                      userName: sp
                                                          ?.getString("email"),
                                                      unlinkStatus:
                                                          incDecFrtSwitchList[
                                                                  index]
                                                              .value,
                                                      context: context);
                                                  loaderScreen.value = false;
                                                  savedSuccess[index].value =
                                                      true;
                                                  await fetchUnLinkList();
                                                  // setState(() {});
                                                } catch (err) {
                                                  // ignore: use_build_context_synchronously
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title:
                                                            const Text('Error'),
                                                        content: const Text(
                                                            'Something went wrong!'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  // // print("error in saving unlink data $err");
                                                  // log(err.toString());
                                                }
                                                // setState(() {});
                                              }
                                            },
                                    );
                                  },
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
                                valueListenable: deLinkListResponseList,
                                builder: (BuildContext context,
                                    List<DeLinkResponseList> value,
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
                              // ValueListenableBuilder(
                              //   valueListenable: deLinkListResponseList,
                              //   builder: (BuildContext context,
                              //       List<DeLinkResponseList> value, Widget? child) {
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
}
