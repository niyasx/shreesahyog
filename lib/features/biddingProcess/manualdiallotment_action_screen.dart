import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/biddingProcess/api/manualdiallotment_action_api.dart';
import 'package:shreecement/features/biddingProcess/models/manualdiallotment_action_transport_model.dart';
import 'package:shreecement/features/common/controller/limitedtextcontroller.dart';

import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/preBidding/preBidding2/apiModels/pre_bid_2_model.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/features/preBidding/api/states_list_api.dart';
import 'package:shreecement/features/preBidding/preBidding2/api/pre_bid_2_api.dart';
import '../common/controller/controller.dart';
import '../common/controller/costtotransport.dart';
import '../common/screens/token_expire.dart';
import '../common/table/table_widgets.dart';
import 'package:shreecement/features/preBidding/api/city_list_api.dart';
import 'package:shreecement/features/preBidding/api/district_list_api.dart';

import '../common/widgets/custom_dropdown_3.dart';
import '../common/widgets/customdropdownprebid.dart';

class ManualDiAllotmentAction extends StatefulWidget {
  const ManualDiAllotmentAction({super.key});

  @override
  State<ManualDiAllotmentAction> createState() =>
      _ManualDiAllotmentActionState();
}

class _ManualDiAllotmentActionState extends State<ManualDiAllotmentAction> {
  final control = Get.put(Controller());
  List<num> extraFrt = [];
  List<ValueNotifier> newFrtAmt = [];
  bool switchOn = false;
  ValueNotifier switchState = ValueNotifier(false);
  ValueNotifier enabled = ValueNotifier(false);

  RxBool loaderScreen = false.obs;

  RxInt currentPagination = 1.obs;

  ValueNotifier<MapEntry<String, String>> selectedState =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedDistrict =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedCity =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedTransporter =
      ValueNotifier(const MapEntry("", ""));

  List<CtPNumericTextEditingController> costToTransportTextController = [];
  List<LimitedLengthTextController> frtChangeReasonTextController = [];
  List<LimitedLengthTextController> reasonDiAllotmentTextController = [];

  List<ValueNotifier<String>> selectedTransporterName = [];
  List<String> transporterNameList = [];
  List<String> transporterIdList = [];

  List<PreBid2ModelResponseList> originalPreBidList = [];
  ValueNotifier<List<PreBid2ModelResponseList>> preBidListResponseList =
      ValueNotifier([]);
  ValueNotifier<List<PreBid2ModelResponseList>> preBidListResponseList1 =
      ValueNotifier([]);
  List<Map<String, String>> transporterData = [];

  late String plantId;
  late String division;
  String searchValue = "";
  List<ResponseList> dpresponselist = [];

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    plantId = sp?.getString("plantId") ?? "";
    division = sp?.getString("selectedDivision") ?? "";
    fetchPreBidList();
    fetchTransporterData();
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

  // int totalPages = 10;
  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);

  List<PreBid2ModelResponseList> getCurrentPageItems(
      List<PreBid2ModelResponseList> items, int currentPage) {
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    preBidListResponseList.value = items;
    selectedTransporterName.clear();
    transporterNameList.clear();
    transporterIdList.clear();
    costToTransportTextController.clear();
    List<PreBid2ModelResponseList> a = items.sublist(startIndex, endIndex);
    for (int i = 0; i < a.length; i++) {
      extraFrt.add(0);
      newFrtAmt.add(ValueNotifier(a[i].newFrtAmount ?? 0.0));
      selectedTransporterName.add(ValueNotifier(""));
      transporterNameList.add("");
      transporterIdList.add("");
      if (a[i].newFrtAmount != null) {
        costToTransportTextController.add(CtPNumericTextEditingController(
            initialValue: a[i].newFrtAmount?.toDouble(),
            maxValue: a[i].newFrtAmount));
      } else {
        costToTransportTextController.add(CtPNumericTextEditingController(
            initialValue: a[i].frtRate?.toDouble(), maxValue: a[i].frtRate));
      }

      frtChangeReasonTextController.add(LimitedLengthTextController());
      reasonDiAllotmentTextController.add(LimitedLengthTextController());
    }
    return a;
  }

  fetchPreBidList() async {
    loaderScreen.value = true;
    final PreBid2Model response = await PreBid2API().getPreBid2DataFromAPI(pageType: "MANUAL",
      context: context,
      employeeCode: sp?.getString("employeeCode") ?? "",
      roleId: int.parse(sp?.getString("employeeCode") ?? ""),
      plantId: plantId,
      division: [division],
      diType: "",
      stateName:
          selectedState.value.key == "All" ? "" : selectedState.value.key,
      stateCode:
          selectedState.value.value == "All" ? "" : selectedState.value.value,
      districtName:
          selectedDistrict.value.key == "All" ? "" : selectedDistrict.value.key,
      districtCode: selectedDistrict.value.value == "All"
          ? ""
          : selectedDistrict.value.value,
      cityName: selectedCity.value.key == "All" ? "" : selectedCity.value.key,
      cityCode:
          selectedCity.value.value == "All" ? "" : selectedCity.value.value,
    );
    loaderScreen.value = false;

    originalPreBidList = response.responseList ?? [];

    // preBidListResponseList1.value=getCurrentPageItems(originalPreBidList, currentPage);
    filterData(searchValue);
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      preBidListResponseList1.value =
          getCurrentPageItems(originalPreBidList, currentPage);
      return;
    }

    List<PreBid2ModelResponseList> filteredData = originalPreBidList
        .where((value) =>
            value.cityName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.districtName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diQty
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.frtRate
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
            value.shipToCityName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.product
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.routeId
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.frtTerms
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    preBidListResponseList.value = filteredData;
    preBidListResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  @override
  void dispose() {
    super.dispose();
    for (var element in costToTransportTextController) {
      element.dispose();
    }
    for (var element in frtChangeReasonTextController) {
      element.dispose();
    }
    for (var element in reasonDiAllotmentTextController) {
      element.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      appBarText: "Manual DI Allotment",
      refreshButton: IconButton(
        iconSize: 30,
        color: ColorConstant.redbar,
        tooltip: "Refresh",
        icon: const Icon(Icons.refresh_sharp),
        onPressed: () async {
          await fetchPreBidList();
        },
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manual DI Allotment',
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
                                                  setState(() {});
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
                              valueListenable: selectedDistrict,
                              builder: (BuildContext context,
                                  MapEntry<String, String> value,
                                  Widget? child) {
                                return FutureBuilder(
                                  future: CityListAPi().getCityNameList(
                                    districtName: selectedDistrict.value.key,
                                    districtCode: selectedDistrict.value.value,
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
                                                selVal: selectedCity.value.key,
                                                list: map.keys.toList(),
                                                fun: (value) {
                                                  if (value == "All") {
                                                    enabled.value = false;
                                                  } else {
                                                    enabled.value = true;
                                                  }
                                                  selectedCity.value = MapEntry(
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
                          ],
                        ),
                        vSpace(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            button(
                                btnText: "Search",
                                tapFunction: () {
                                  fetchPreBidList();
                                }),
                            wSpace(10),
                            button(
                                btnText: "Reset",
                                btnClr: Colors.white,
                                btnTxtClr: ColorConstant.redbar,
                                tapFunction: () {
                                  selectedState.value =
                                      const MapEntry("All", "All");
                                  selectedDistrict.value =
                                      const MapEntry("All", "All");
                                  selectedCity.value =
                                      const MapEntry("All", "All");
                                  fetchPreBidList();
                                }),
                          ],
                        ),
                        vSpace(20),
                      ],
                    ),
                  ),
                ),
                vSpace(20),
                tableHeading(heading: "Deliveries For Bidding - FGB"),
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
                                    contentPadding: const EdgeInsets.symmetric(
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
                          )),
                    )),
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: preBidListResponseList1,
                  builder: (BuildContext context,
                      List<PreBid2ModelResponseList> data, Widget? child) {
                    if (data.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Text("No data found"),
                        ),
                      );
                    }
                    return CustomTable(
                      columns: const [
                        DataColumn(
                          label: TableColumn(
                            "Sr.No",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "State",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "District",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "City",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "DI No",
                            heading: true,
                          ),
                        ),
                         DataColumn(
                            label: TableColumn(
                              "SO/STO Number",
                              heading: true,
                            ),
                          ),
                        DataColumn(
                          label: TableColumn(
                            "DI Qty",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Product",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                            label: TableColumn(
                              "Customer Name",
                              heading: true,
                            ),
                          ),
                           DataColumn(
                            label: TableColumn(
                              "Consignee Address",
                              heading: true,
                            ),
                          ), 
                        DataColumn(
                          label: TableColumn(
                            "Ship To City",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Route",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Frt. Terms",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Cost To Transport",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Frt. Change Reason",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Transporter Name",
                            heading: true,
                            dropdown: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Reason For DI Allotment",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Payer Block",
                            heading: true,
                          ),
                        ),
                        DataColumn(
                          label: TableColumn(
                            "Action",
                            heading: true,
                          ),
                        ),
                      ],
                      rows: List.generate(
                        data.length,
                        (index) => DataRow(
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
                                data[index].salesOrderNo ?? "",
                                index: index +
                                    int.parse(selectedDropdownValue) *
                                        currentPage -
                                    1,
                              ),
                            ),
                            DataCell(
                              TableColumn(
                                data[index].diQty.toString(),
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
                                data[index].customerName ?? "",
                                index: index +
                                    int.parse(selectedDropdownValue) *
                                        currentPage -
                                    1,
                              ),
                            ),
                            DataCell(
                                TableColumn(
                                  data[index].consigneeAddress ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                ),
                              ),
                            DataCell(
                              TableColumn(
                                data[index].shipToCityName ?? "",
                                index: index +
                                    int.parse(selectedDropdownValue) *
                                        currentPage -
                                    1,
                              ),
                            ),
                            DataCell(
                              TableColumn(
                                data[index].routeId.toString() == "null"
                                    ? ""
                                    : data[index].routeId.toString(),
                                index: index +
                                    int.parse(selectedDropdownValue) *
                                        currentPage -
                                    1,
                              ),
                            ),
                            DataCell(
                              TableColumn(
                                data[index].frtTerms ?? "",
                                index: index +
                                    int.parse(selectedDropdownValue) *
                                        currentPage -
                                    1,
                              ),
                            ),
                            DataCell(
                              TableColumnTextField(
                                controller:
                                    costToTransportTextController[index],
                                index: index +
                                    int.parse(selectedDropdownValue) *
                                        currentPage -
                                    1,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            DataCell(
                              TableColumnTextField(
                                controller:
                                    frtChangeReasonTextController[index],
                                index: index +
                                    int.parse(selectedDropdownValue) *
                                        currentPage -
                                    1,
                              ),
                            ),
                            DataCell(Builder(
                              builder: (context) {
                                Map<String, String> transMapp = {};
                                transMapp["Select"] = "Select";

                                for (var value in dpresponselist) {
                                  transMapp[value.name.toString()] =
                                      value.supplier.toString();
                                }

                                selectedTransporterName[index].value =
                                    transMapp.keys.toList().first;
                                transporterNameList[index] =
                                    transMapp.keys.toList().first;
                                transporterIdList[index] =
                                    transMapp.values.toList().first;
                                return ValueListenableBuilder(
                                  valueListenable:
                                      selectedTransporterName[index],
                                  builder: (BuildContext context, String value,
                                      Widget? child) {
                                    return CustomDropdownMenu3(
                                      width: double.infinity,
                                      margin: const EdgeInsets.all(4),
                                      selVal:
                                          selectedTransporterName[index].value,
                                      list: transMapp.keys.toList(),
                                      fun: (value) {
                                        selectedTransporterName[index].value =
                                            value.toString();
                                        transporterNameList[index] =
                                            value.toString();
                                        transporterIdList[index] =
                                            transMapp[value.toString()]
                                                .toString();
                                      },
                                    );
                                  },
                                );
                              },
                            )),
                            DataCell(
                              TableColumnTextField(
                                controller:
                                    reasonDiAllotmentTextController[index],
                                index: index +
                                    int.parse(selectedDropdownValue) *
                                        currentPage -
                                    1,
                              ),
                            ),
                            DataCell(
                              TableColumn(
                                data[index].payerBlock ?? "",
                                index: index +
                                    int.parse(selectedDropdownValue) *
                                        currentPage -
                                    1,
                              ),
                            ),
                            DataCell(TableColumnActionIcon(
                              index: index +
                                  int.parse(selectedDropdownValue) *
                                      currentPage -
                                  1,
                              icon: const Icon(
                                Icons.save,
                                color: Colors.green,
                                size: 21,
                              ),
                              onPressed: () async {
                                // Get the values from the controllers
                                String diNumber =
                                    data[index].diNumber.toString();
                                String transporterId = transporterIdList[index];
                                String transporterName =
                                    transporterNameList[index];
                                String costToTransport =
                                    costToTransportTextController[index]
                                        .value
                                        .text;
                                String freightChangeReason =
                                    frtChangeReasonTextController[index]
                                        .value
                                        .text;
                                String reasonForDiAllotment =
                                    reasonDiAllotmentTextController[index]
                                        .value
                                        .text;

                                // Check for empty or null values
                                if (costToTransport.isEmpty ||
                                    transporterName == "Select") {
                                  // Show a dialog if any field is empty
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Invalid Input'),
                                        content: const Text(
                                            'Please fill all fields.'),
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
                                } else {
                                  // All fields are valid, proceed with the update
                                  try {
                                    loaderScreen.value = true;
                                    await ManualDiAllotmentActionApi()
                                        .updateManualDiAllotmentActionData(
                                      diNumber: diNumber,
                                      transporterId: transporterId,
                                      transporterName: transporterName,
                                      costToTransport:
                                          double.parse(costToTransport),
                                      freightChangeReason: freightChangeReason,
                                      reasonForDiAllotment:
                                          reasonForDiAllotment,
                                      context: context,
                                    );
                                    loaderScreen.value = false;

                                    // Update the UI by fetching the latest data
                                    setState(() async {
                                      costToTransportTextController = [];
                                      frtChangeReasonTextController = [];
                                      reasonDiAllotmentTextController = [];
                                      await fetchPreBidList();
                                    });
                                  } catch (e) {
                                    // logout();
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => LoginScreen()),
                                    // );
                                  }
                                }
                              },
                            )),
                          ],
                        ),
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
                                List<PreBid2ModelResponseList> value,
                                Widget? child) {
                              return Expanded(
                                flex: 2,
                                child: Text(
                                    size.width > 600
                                        ? "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length * (currentPage)} of ${preBidListResponseList.value.length} entries"
                                        : "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to\n ${value.length * (currentPage)} of ${preBidListResponseList.value.length} entries",
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
      ]),
    );
  }

  ValueListenableBuilder<List<PreBid2ModelResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: preBidListResponseList,
      builder: (BuildContext context, List<PreBid2ModelResponseList> value,
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
