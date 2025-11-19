import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/customdropdownprebid.dart';
import 'package:shreecement/features/tokenMapping/api/token_mapping_apis.dart';
import 'package:shreecement/features/tokenMapping/models/token_mapping_model.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';

import '../../biddingProcess/api/manualdiallotment_action_api.dart';
import '../../biddingProcess/models/manualdiallotment_action_transport_model.dart';
import '../../common/controller/controller.dart';
import '../../common/screens/token_expire.dart';
import '../../common/widgets/custom_dropdown_3.dart';
import '../../invoicing/apis/shortage_master_apis.dart';

class TokenMappingLogistic extends StatefulWidget {
  const TokenMappingLogistic({super.key});

  @override
  State<TokenMappingLogistic> createState() => _TokenMappingLogisticState();
}

class _TokenMappingLogisticState extends State<TokenMappingLogistic> {
  final control = Get.put(Controller());
  RxBool loaderScreen = false.obs;
//
  ValueNotifier<MapEntry<String, String>> selectedPlant =
  ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedTransporter =
  ValueNotifier(const MapEntry("", ""));



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

  fetchTokenMappingList({required String transporterCode}) async {
    loaderScreen.value = true;
    final TokenMappingModel response =
    await TokenMappingApi().getTokenMapingDiListLogistics(ctx: context,transporterCode: transporterCode);
    loaderScreen.value = false;
    originalTokenList = response.responseList ?? [];
    tokenMappingListResponseList.value = List.from(originalTokenList);
    tokenMappingListResponseList1.value = getCurrentPageItems(originalTokenList, currentPage);
  }



    List<TokenMappingResponseList> getCurrentPageItems(
      List<TokenMappingResponseList> items, int currentPage) {
    tokenMappingListResponseList1.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<TokenMappingResponseList> a = items.sublist(startIndex, endIndex);

    return a;
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      tokenMappingListResponseList1.value = getCurrentPageItems(originalTokenList, currentPage);
      return;
    }

    List<TokenMappingResponseList> filteredData = originalTokenList
        .where((value) =>
    value.plantId
        .toString()
        .toLowerCase()
        .contains(searchTerm.toLowerCase()) ||
        value.diNumber
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
            .contains(searchTerm.toLowerCase()))
        .toList();

    tokenMappingListResponseList1.value = getCurrentPageItems(filteredData, currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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

    return CustomScaffold(
      appBarText: "Token Mapping",
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
                                    if (selectedTransporter.value.value.isNotEmpty) {
                                      await fetchTokenMappingList(transporterCode: selectedTransporter.value.value);

                                      // Print fetched data

                                    
                                    } else {
                                      // print("Please select a transporter.");
                                    }
                                    try {

                                      sp?.setString("selectedPlant",
                                          selectedPlant.value.key);
                                      sp?.setString("selectedPlantValue",
                                          selectedPlant.value.value);
                                      sp?.setString("selectedTransporter",
                                          selectedTransporter.value.key);
                                      sp?.setString("selectedTransporterValue",
                                          selectedTransporter.value.value);
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
                                      setState(() {});

                                     
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
                  //

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
                  ValueListenableBuilder(
                    valueListenable: tokenMappingListResponseList1,
                    builder: (BuildContext context,
                        List<TokenMappingResponseList> value, Widget? child) {
                      print("111 token mapping- $value");
                      print("111 length- ${value.length}");
                      if (value.isEmpty) {
                        print("222$value");
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text("No data found"),
                          ),
                        );
                      }
                      print("333 length- ${value.length}");
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
                                        columnTitle: "Org Code",
                                        flx: 3,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Organisation Name",
                                        flx: 5,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Division",
                                        flx: 4,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Deliveries Awarded",
                                        flx: 3,
                                        dropdownVis: true,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Actions",
                                        flx: 2,
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
                                            value[index].plantId.toString(),
                                            flx: 3,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].plantName ?? "",
                                            flx: 5,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            colColor: clr,
                                            columnTitle:
                                            value[index].division ?? "",
                                            flx: 4,
                                            clr: const Color(0xff727272),
                                          ),
                                          column(
                                            selectable: false,
                                            colColor: clr,
                                            columnTitle: value[index]
                                                .diNumber
                                                .toString(),
                                            flx: 3,
                                            clr: ColorConstant.redbar,
                                            funx: () {
                                              try {
                                                sp?.setString("plantId",
                                                    "${value[index].plantId}");
                                                sp?.setString("transporterCode",
                                                    selectedTransporter.value.value);
                                                control.currentIndex.value = 34;
                                              } catch (e) {
                                                // print("error $e");
                                              }
                                            },
                                          ),
                                          imgCell(
                                              tapAction: () {
                                                try {
                                                  sp?.setString("plantId",
                                                      "${value[index].plantId}");
                                                  sp?.setString("transporterCode",
                                                      selectedTransporter.value.value);
                                                  // print(selectedPlant.value.value);
                                                  // print(selectedTransporter.value.value);
                                                  control.currentIndex.value =
                                                  34;
                                                } catch (e) {
                                                  // print("error $e");
                                                }
                                              },
                                              colColor: clr,
                                              imgPath:
                                              "assets/images/searchicon.png",
                                              icnClr: Colors.indigo,
                                              icnSize: 16,
                                              flx: 2),
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
                                  tokenMappingListResponseList1,
                              builder: (BuildContext context,
                                  List<TokenMappingResponseList>
                                      value,
                                  Widget? child) {
                                if (value.isEmpty) {
                                  return Center(child: Container());
                                }
                                return Expanded(
                                  flex: 2,
                                  child: Text(
                                            "Showing ${(int.parse(selectedDropdownValue) * (currentPage - 1)) + 1} to ${(int.parse(selectedDropdownValue) * (currentPage - 1)) + value.length} of ${tokenMappingListResponseList.value.length} entries",
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

   ValueListenableBuilder<List<TokenMappingResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: tokenMappingListResponseList,
      builder: (BuildContext context, List<TokenMappingResponseList> value,
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


}


