import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/preBidding/api/city_list_api.dart';
import 'package:shreecement/features/preBidding/api/district_list_api.dart';
import 'package:shreecement/features/preBidding/api/states_list_api.dart';
import 'package:shreecement/features/tokenMapping/api/token_mapping_apis.dart';
import 'package:shreecement/features/tokenMapping/models/token_mapping_action_model.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import '../../common/controller/controller.dart';
import '../../common/screens/token_expire.dart';
import '../../common/widgets/custom_dropdown_3.dart';

class TokenMappingActionLogistics extends StatefulWidget {
  const TokenMappingActionLogistics({super.key});

  @override
  State<TokenMappingActionLogistics> createState() => _TokenMappingActionLogisticsState();
}

class _TokenMappingActionLogisticsState extends State<TokenMappingActionLogistics> {
  final Controller control = Get.find(); // Access the controller
  ValueNotifier switchState = ValueNotifier(false);
  RxBool loaderScreen = false.obs;

  List<double> extraFrt = [];
  List<ValueNotifier<double>> newFrtAmt = [];
  List<ValueNotifier<bool>> incDecFrtSwitchList = [];
  List<String> newFrtRemark = [];
  List<ValueNotifier<bool>> savedSuccess = [];
  List<TextEditingController> extraFrtTextController = [];
  List<TextEditingController> remarkTextController = [];

  ValueNotifier enabled = ValueNotifier(false);

  ValueNotifier<MapEntry<String, String>> selectedState =
  ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedDistrict =
  ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedCity =
  ValueNotifier(const MapEntry("", ""));

  List<TokenMappingActionResponseList> originalTokenMapActionList = [];
  ValueNotifier<List<TokenMappingActionResponseList>> tokenActionResponseList =
  ValueNotifier([]);
  // bool isLoading = false;
  ValueNotifier<bool> isloading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    fetchTokenActionList();
  }

  fetchTokenActionList() async {
    try {
      // isLoading = true;
      // isloading.value=true;
      loaderScreen.value = true;

      final TokenMappingActionModel response =
      await TokenMappingApi().getTokenMapingActionListLogistic(
        transporterId: sp?.getString("transporterCode") ?? "",
        plantId: int.parse(sp?.getString("plantId") ?? ""),
        stateName:
        selectedState.value.key == "All" ? "" : selectedState.value.key,
        stateCode:
        selectedState.value.value == "All" ? "" : selectedState.value.value,
        districtName: selectedDistrict.value.key == "All"
            ? ""
            : selectedDistrict.value.key,
        districtCode: selectedDistrict.value.value == "All"
            ? ""
            : selectedDistrict.value.value,
        cityName: selectedCity.value.key == "All" ? "" : selectedCity.value.key,
        cityCode:
        selectedCity.value.value == "All" ? "" : selectedCity.value.value,
      );
      loaderScreen.value = false;

      extraFrt.clear();
      newFrtAmt.clear();
      incDecFrtSwitchList.clear();
      newFrtRemark.clear();
      savedSuccess.clear();
      extraFrtTextController.clear();
      remarkTextController.clear();

      List<TokenMappingActionResponseList> responseList =
          response.responseList ?? [];
      for (var element in responseList) {
        extraFrt.add(0);
        newFrtAmt.add(ValueNotifier(element.newFrtAmount ?? 0.0));
        incDecFrtSwitchList.add(ValueNotifier(false));
        newFrtRemark.add("");
        savedSuccess.add(ValueNotifier(false));
        // extraFrtTextController
        //     .add(TextEditingController(text: element.extFrt.toString()));
        // remarkTextController.add(
        //   TextEditingController(text: element.newFrtRemarks),
        // );
      }
      originalTokenMapActionList = response.responseList ?? [];
      tokenActionResponseList.value = List.from(originalTokenMapActionList);

      //  setState(() {
      //    isLoading = false;
      //  });
      //  isloading.value=false;
    } catch (error) {
      isloading.value = false;

      // print("Error fetching data for aw: $error");
    }
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      tokenActionResponseList.value = List.from(originalTokenMapActionList);
      return;
    }

    List<TokenMappingActionResponseList> filteredData =
    originalTokenMapActionList
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
        value.consigneeAddress
            .toString()
            .toLowerCase()
            .contains(searchTerm.toLowerCase()) ||
        value.diQty
            .toString()
            .toLowerCase()
            .contains(searchTerm.toLowerCase()) ||
        value.diNumber
            .toString()
            .toLowerCase()
            .contains(searchTerm.toLowerCase()) ||
        // value.frtRate
        //     .toString()
        //     .toLowerCase()
        //     .contains(searchTerm.toLowerCase()) ||
        // value.newFrtRemarks
        //     .toString()
        //     .toLowerCase()
        //     .contains(searchTerm.toLowerCase()) ||
        // value.lastProcessedTime
        //     .toString()
        //     .toLowerCase()
        //     .contains(searchTerm.toLowerCase()) ||
        value.product
            .toString()
            .toLowerCase()
            .contains(searchTerm.toLowerCase()) ||
        value.soBiddingRemarks
            .toString()
            .toLowerCase()
            .contains(searchTerm.toLowerCase()))
        .toList();

    tokenActionResponseList.value = filteredData;
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
    final dynamicSize = ((size.width - 312 + 20) * (100 / 13)) / 100;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Token Mapping",
            ),
            IconButton(
              iconSize: 30,
              color: ColorConstant.redbar,
              tooltip: "Refresh",
              icon: const Icon(Icons.refresh_sharp),
              onPressed: () async {
                await fetchTokenActionList();
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
                            runSpacing: 5,
                            children: [
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
                              wSpace(20),
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
                              wSpace(20),
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
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: ValueListenableBuilder(
                                    valueListenable: switchState,
                                    builder: (BuildContext context, value,
                                        Widget? child) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: labelledSwitch2(
                                          label: "Show Updated DI",
                                          function: (value) {
                                            switchState.value = value;
                                            if (!value) {
                                              tokenActionResponseList.value =
                                                  originalTokenMapActionList;
                                            } else {
                                              // List<TokenMappingActionResponseList>
                                              // filteredData =
                                              // originalTokenMapActionList
                                              //     .where((value2) =>
                                              //         value2.extFrt != null &&
                                              //         value2.extFrt != 0)
                                              //     .toList();

                                              // tokenActionResponseList.value =
                                              //     filteredData;
                                            }
                                          },
                                          switchStatus: switchState.value,
                                        ),
                                      );
                                    },
                                  )),
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
                                    await fetchTokenActionList();
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
                                    fetchTokenActionList();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  vSpace(20),
                  tableHeading(heading: "Deliveries for Bidding"),
                  searchBar(
                      size: size.width,
                      onChanged: (value) {
                        filterData(value);
                      }),
                  isloading.value
                      ? Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.redbar,
                    ),
                  )
                      : ValueListenableBuilder(
                    valueListenable: tokenActionResponseList,
                    builder: (BuildContext context,
                        List<TokenMappingActionResponseList> data,
                        Widget? child) {
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
                              "City",
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
                              "Consignee",
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
                              "Product",
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
                              "Remarks",
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
                              "State",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "SO Remark",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Remaining Time",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Payer Block",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Link",
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
                                  data[index].cityName ?? "",
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
                                  data[index].customerName ?? "",
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
                                  data[index].product ?? "",
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].diQty.toString(),
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].winFrtAmount.toString(),
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].reasonForDiAllotment ?? "",
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].talukaName ?? "",
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
                                  data[index].soBiddingRemarks ?? "",
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].remainingTime ?? "",
                                  index: index,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].payerBlock ?? "",
                                  index: index,
                                ),
                              ),
                              DataCell(ValueListenableBuilder(
                                valueListenable: savedSuccess[index],
                                builder: (BuildContext context, value,
                                    Widget? child) {
                                  return TableColumnActionIcon(
                                    index: index,
                                    icon: Row(
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          "assets/images/truck.png",
                                          color: Colors.green,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        if (value ||
                                            data[index].tokenNumber !=
                                                null &&
                                                data[index].tokenNumber !=
                                                    "")
                                          const Icon(
                                            Icons.thumb_up,
                                            color: Colors.green,
                                            size: 15,
                                          )
                                        else
                                          Container()
                                      ],
                                    ),
                                    onPressed: () {
                                      if (value ||
                                          data[index].tokenNumber !=
                                              null &&
                                              data[index].tokenNumber !=
                                                  "") {
                                        showResultDialog(
                                            "No Action Allowed");
                                      } else {
                                        // if (data[index].processed=false) {
                                        sp?.setString("productName",
                                            data[index].product ?? "");
                                        sp?.setString(
                                            "pckagingType",
                                            data[index].materialFrtGrp ??
                                                "");
                                        sp?.setString("diNumber",
                                            data[index].diNumber ?? "");
                                        control.currentIndex.value = 35;
                                      }
                                      // }else{
                                      // // print("no action allowed");
                                      // showResultDialog("No Action Allowed");
                                      // }
                                    },
                                  );
                                },
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  vSpace(15),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: tokenActionResponseList,
                          builder: (BuildContext context,
                              List<TokenMappingActionResponseList> value,
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
                          valueListenable: tokenActionResponseList,
                          builder: (BuildContext context,
                              List<TokenMappingActionResponseList> value,
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
                  )
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
