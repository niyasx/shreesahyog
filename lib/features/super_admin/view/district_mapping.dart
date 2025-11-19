// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_popup_menu.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/preBidding/apiModels/district.dart';
import 'package:shreecement/features/preBidding/apiModels/states.dart';
import 'package:shreecement/features/super_admin/api/save_update_api.dart';
import 'package:shreecement/features/super_admin/api/state_api.dart';
import 'package:shreecement/features/super_admin/model/state_district_response_list.dart';
import 'package:shreecement/features/super_admin/model/transporter_list.dart';
import 'package:shreecement/utils/color_constant.dart';

import '../../common/widgets/customdropdownprebid.dart';

class DistrictMapping extends StatefulWidget {
  const DistrictMapping({
    super.key,
  });

  @override
  State<DistrictMapping> createState() => DistrictMappingState();
}

class DistrictController extends GetxController {
  RxSet<String> selectedDistricts = RxSet();

  void addSelectedDistrict(String district) {
    selectedDistricts.add(district);
  }

  void removeSelectedDistrict(String district) {
    selectedDistricts.remove(district);
  }

  void resetSelectedDistrict() {
    selectedDistricts.clear();
  }

  List<int> getSelected() {
    List<int> intList = selectedDistricts.map((str) => int.parse(str)).toList();
    return intList;
  }
}

class DistrictMappingState extends State<DistrictMapping> {
  final DistrictController controller = Get.put(DistrictController());
  final Controller control = Get.find(); // Access the controller
  RxBool loaderScreen = false.obs;
  RxBool addOnSearch = false.obs;
  RxInt currentPagination = 1.obs;
  

  ValueNotifier enabled = ValueNotifier(false);

  

  List<StateDistrict> originalMappingList = [];
  ValueNotifier<List<StateDistrict>> mappingListResponseList =
      ValueNotifier([]);
  ValueNotifier<List<StateDistrict>> mappingListResponseList1 =
      ValueNotifier([]);

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController statetextEditingController =
      TextEditingController();

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

  ScrollController _scrollControllerForTable = ScrollController();
  ScrollController _scrollControllerForCustomPopup = ScrollController();

  List<String> districtNames = []; // List to store all districts
  List<String> filteredDistricts = []; // List to store filtered districts
  // List to store selected districts
  TextEditingController searchController = TextEditingController();

  List<DistrictResponseList> districtList = [];
  RxList<DistrictResponseList> districtResponseListForEdit = RxList();
  List<DistrictResponseList> districtResponseToFilter = [];
  ValueNotifier<List<DistrictResponseList>> districtListResponceList =
      ValueNotifier([]);

  // Other existing code...

  void callDistrictApi({String? stateName, String? stateCode}) async {
    final District response = await StateApi().getDistrictsListFromAPI(
        context: context, stateCode: stateCode, stateName: stateName);

    districtList = response.responseList ?? [];
    districtListResponceList.value = response.responseList ?? [];

    districtNames =
        districtList.map((district) => district.districtName ?? "").toList();
    filteredDistricts = districtNames;
  }

  void callDistrictForEditApi(
      {String? stateName,
      String? stateCode,
      List<DistrictResponseList>? districtResponseList}) async {
    final District response = await StateApi().getDistrictsListFromAPI(
        context: context, stateCode: stateCode, stateName: stateName);
    if (districtResponseToFilter.isNotEmpty) {
      districtResponseToFilter
        ..clear()
        ..addAll(response.responseList!);
    } else {
      districtResponseToFilter.addAll(response.responseList!);
    }
    if (districtResponseListForEdit.isNotEmpty) {
      districtResponseListForEdit
        ..clear()
        ..addAll(response.responseList!)
        ..refresh();
    } else {
      districtResponseListForEdit
        ..addAll(response.responseList!)
        ..refresh();
    }

    for (var objedit in districtResponseListForEdit) {
      final isSelected = districtResponseList!
          .any((d) => d.districtName == objedit.districtName);
      if (isSelected) {
        objedit.isSelected = true;
      } else {
        objedit.isSelected = false;
      }
    }
  }

  Widget checkBox() {
    return Obx(() {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // Border color
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(8.0), // Border radius
          ),
          child: Scrollbar(
            controller: _scrollControllerForCustomPopup,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _scrollControllerForCustomPopup,
              itemCount: districtResponseListForEdit.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 30,
                  child: CheckboxListTile(
                    title: Text(
                      districtResponseListForEdit[index].districtName!,
                      style: const TextStyle(fontSize: 15),
                    ),
                    value: districtResponseListForEdit[index].isSelected,
                    onChanged: (newValue) {
                      setState(() {
                        if (districtResponseListForEdit[index].isSelected!) {
                          districtResponseListForEdit[index].isSelected = false;
                        } else {
                          districtResponseListForEdit[index].isSelected = true;
                        }
                        districtResponseListForEdit.refresh();
                        /*onlineAssessmentController.dataInfoList[0]
                          .assesmentResult[indexOfMainList].options[index].option = newValue;*/
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  void filterDistricts(String query) {
    districtListResponceList.value = districtList
        .where((district) =>
            district.districtName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void filterDistrictsForEdit(String query) {
    List<DistrictResponseList> list = districtResponseToFilter
        .where((district) =>
            district.districtName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    districtResponseListForEdit
      ..clear()
      ..addAll(list)
      ..refresh();
  }

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);

  List<StateDistrict> getCurrentPageItems(
      List<StateDistrict> items, int currentPage) {
    mappingListResponseList.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<StateDistrict> a = items.sublist(startIndex, endIndex);

    return a;
  }

  fetchMappingList({required String transporterCodeId}) async {
    try {
      loaderScreen.value = true;
      final StateDistrictResponse response =
          await StateApi().getTableStateList(context, transporterCodeId);
      originalMappingList = response.responseList;
      loaderScreen.value = false;
      mappingListResponseList1.value =
          getCurrentPageItems(originalMappingList, currentPage);
    } catch (e) {
      throw Exception(e);
    }
  }

  // void filterData(String searchTerm) {
  //   if (searchTerm.isEmpty) {
  //     mappingListResponseList1.value =
  //         getCurrentPageItems(originalMappingList, currentPage);
  //     return;
  //   }

  //   List<StateDistrict> filteredData = originalMappingList
  //       .where((value) =>
  //           value.stateName
  //               .toString()
  //               .toLowerCase()
  //               .contains(searchTerm.toLowerCase()) ||
  //           value.districtDetails
  //               .toString()
  //               .toLowerCase()
  //               .contains(searchTerm.toLowerCase()))
  //       .toList();
        

  //   mappingListResponseList1.value =
  //       getCurrentPageItems(filteredData, currentPage);
  // }

  void filterData(String searchTerm) {
  if (searchTerm.isEmpty) {
    mappingListResponseList1.value =
        getCurrentPageItems(originalMappingList, currentPage);
    return;
  }

  List<StateDistrict> filteredData = originalMappingList.where((value) {
    bool stateNameContainsSearchTerm = value.stateName
        .toString()
        .toLowerCase()
        .contains(searchTerm.toLowerCase());
    
    bool districtNameContainsSearchTerm = value.districtDetails.any((district) =>
        district.districtName.toString().toLowerCase().contains(searchTerm.toLowerCase()));

    return stateNameContainsSearchTerm || districtNameContainsSearchTerm;
  }).toList();

  mappingListResponseList1.value =
      getCurrentPageItems(filteredData, currentPage);
}


  @override
  void initState() {
    super.initState();
    callTransporterApi();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      appBarText: "State/District Mapping",
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
                    'State/District Mapping',
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
                              //drop down for getting the transporters list according to plant
                              Obx(() {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Transporter",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 283,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xffA0A0A0)),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          child: DropdownButton2<String>(
                                            isDense: true,
                                            isExpanded: true,
                                            value: selectedValue,
                                            onChanged: (newValue) {
                                              // Handle item selection here
                                              selectedValue = newValue!;
                                              setState(() {});
                                            },
                                            style: const TextStyle(
                                                color: Color(0xff727272),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            /* onChanged: widget.myFun,*/
                                            items: rxTransporterList
                                                .map<DropdownMenuItem<String>>(
                                                    (TransporterList value) {
                                              return DropdownMenuItem<String>(
                                                onTap: () {
                                                  // value.transporterMasterId;
                                                  selectedTransporterid =
                                                      value.supplier.toString();
                                                },
                                                value: value.name,
                                                child: Container(
                                                  height: 30,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    value.name!,
                                                    softWrap: true,
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xff727272),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Roboto'),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            dropdownSearchData:
                                                DropdownSearchData(
                                              searchController:
                                                  textEditingController,
                                              searchInnerWidgetHeight: 50,
                                              searchInnerWidget: Container(
                                                height: 50,
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 4,
                                                  right: 8,
                                                  left: 8,
                                                ),
                                                child: TextFormField(
                                                  expands: true,
                                                  maxLines: null,
                                                  controller:
                                                      textEditingController,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 10,
                                                      vertical: 8,
                                                    ),
                                                    hintText:
                                                        'Search for an item...',
                                                    hintStyle: const TextStyle(
                                                        fontSize: 12),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              searchMatchFn:
                                                  (item, searchValue) {
                                                return item.value
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(searchValue
                                                        .toLowerCase());
                                              },
                                            ),
                                            dropdownStyleData:
                                                const DropdownStyleData(
                                                    maxHeight: 300),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
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
                                    try {
                                      if ("" != selectedTransporterid.trim()) {
                                        addOnSearch.value = true;
                                      }

                                      await fetchMappingList(
                                          transporterCodeId:
                                              selectedTransporterid);
                                      callStaterApi();
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
                                      addOnSearch.value = false;
                                      districtListResponceList.value=[];
                                      mappingListResponseList1.value=[];
                                      selectedValue="Select Transporter";
                                      setState(() {
                                        
                                      });

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
                            child: Wrap(
                              runSpacing: 20,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: [
                                    const Text("Display",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Roboto')),
                                    wSpace(6),
                                    SizedBox(
                                        width: 72,
                                        height: 22,
                                        child: PreCustomDropdownMenu(
                                          selVal: selectedDropdownValue1,
                                          list: list(),
                                          onChanged: (value) async {
                                            // isLoading.value=true;
                                            // Update the selected value when the dropdown changes
                                            setState(() {
                                              selectedDropdownValue1 = value;
                                              selectedDropdownValue = value ==
                                                      "All"
                                                  ? originalMappingList.length
                                                      .toString()
                                                  : value;
                                              pageSize = int.parse(value ==
                                                      "All"
                                                  ? originalMappingList.length
                                                      .toString()
                                                  : value);
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
                                SizedBox(
                                  width: 100,
                                  child: Obx(() => addOnSearch.value
                                      ? button(
                                          btnText: "Add",
                                          tapFunction: () async {
                                            selectedState.value =
                                                "Select a State";
                                            districtListResponceList.value
                                                .clear();
                                            controller.resetSelectedDistrict();

                                            setState(() {});
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CustomPopupAdmin(
                                                  title: "Add State/District",
                                                  columnChildrens: [
                                                    Wrap(
                                                      children: [
                                                        Obx(() {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text(
                                                                  "State:",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Container(
                                                                  height: 45,
                                                                  width: 283,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    border: Border.all(
                                                                        color: const Color(
                                                                            0xffA0A0A0)),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                  ),
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child:
                                                                        ButtonTheme(
                                                                      child: DropdownButton2<
                                                                          String>(
                                                                        isDense:
                                                                            true,
                                                                        isExpanded:
                                                                            true,
                                                                        value: selectedState
                                                                            .value,
                                                                        onChanged:
                                                                            (newValue) {
                                                                          // Handle item selection here
                                                                          selectedState.value =
                                                                              newValue!;
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Color(0xff727272),
                                                                            overflow: TextOverflow.ellipsis),
                                                                        /* onChanged: widget.myFun,*/
                                                                        items: rxStateList.map<
                                                                            DropdownMenuItem<
                                                                                String>>((ResponseList
                                                                            value) {
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            onTap:
                                                                                () async {
                                                                              try {
                                                                                selectedStateCode = value.stateCode;
                                                                                callDistrictApi(stateCode: value.stateCode, stateName: value.stateName);
                                                                              } catch (e) {
                                                                                // debugPrint("error dist $e");
                                                                              }
                                                                            },
                                                                            value:
                                                                                value.stateName,
                                                                            child:
                                                                                Container(
                                                                              height: 30,
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                value.stateName!,
                                                                                softWrap: true,
                                                                                textAlign: TextAlign.left,
                                                                                style: const TextStyle(color: Color(0xff727272), fontWeight: FontWeight.w600, fontFamily: 'Roboto'),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                        dropdownSearchData:
                                                                            DropdownSearchData(
                                                                          searchController:
                                                                              statetextEditingController,
                                                                          searchInnerWidgetHeight:
                                                                              50,
                                                                          searchInnerWidget:
                                                                              Container(
                                                                            height:
                                                                                50,
                                                                            padding:
                                                                                const EdgeInsets.only(
                                                                              top: 8,
                                                                              bottom: 4,
                                                                              right: 8,
                                                                              left: 8,
                                                                            ),
                                                                            child:
                                                                                TextFormField(
                                                                              expands: true,
                                                                              maxLines: null,
                                                                              controller: statetextEditingController,
                                                                              decoration: InputDecoration(
                                                                                isDense: true,
                                                                                contentPadding: const EdgeInsets.symmetric(
                                                                                  horizontal: 10,
                                                                                  vertical: 8,
                                                                                ),
                                                                                hintText: 'Search for an item...',
                                                                                hintStyle: const TextStyle(fontSize: 12),
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          searchMatchFn:
                                                                              (item, searchValue) {
                                                                            return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                                                                          },
                                                                        ),
                                                                        dropdownStyleData:
                                                                            const DropdownStyleData(maxHeight: 300),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                        wSpace(16),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              "Districts:",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Container(
                                                              constraints:
                                                                  const BoxConstraints(
                                                                      minWidth:
                                                                          200,
                                                                      minHeight:
                                                                          200,
                                                                      maxWidth:
                                                                          400,
                                                                      maxHeight:
                                                                          400),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 45,
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          searchController,
                                                                      onChanged:
                                                                          (value) {
                                                                        filterDistricts(
                                                                            value);
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'Search',
                                                                        hintText:
                                                                            'Search for a district',
                                                                        prefixIcon:
                                                                            const Icon(Icons.search),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  vSpace(7),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.grey, // Border color
                                                                          width:
                                                                              1.0, // Border width
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0), // Border radius
                                                                      ),
                                                                      child:
                                                                          ValueListenableBuilder(
                                                                        valueListenable:
                                                                            districtListResponceList,
                                                                        builder: (BuildContext context,
                                                                            List<DistrictResponseList>
                                                                                value,
                                                                            Widget?
                                                                                child) {
                                                                          return Scrollbar(
                                                                            controller:
                                                                                _scrollControllerForCustomPopup,
                                                                            thumbVisibility:
                                                                                true,
                                                                            child:
                                                                                ListView.builder(
                                                                              controller: _scrollControllerForCustomPopup,
                                                                              shrinkWrap: true,
                                                                              itemCount: value.length,
                                                                              itemBuilder: (_, index) {
                                                                                return Obx(() => SizedBox(
                                                                                      height: 30,
                                                                                      child: CheckboxListTile(
                                                                                        title: Text(value[index].districtName ?? ""),
                                                                                        value: controller.selectedDistricts.contains(value[index].district),
                                                                                        onChanged: (newValue) {
                                                                                          if (newValue == true) {
                                                                                            controller.addSelectedDistrict(value[index].district ?? "");
                                                                                          } else {
                                                                                            controller.removeSelectedDistrict(value[index].district ?? "");
                                                                                          }
                                                                                        },
                                                                                      ),
                                                                                    ));
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  vSpace(20),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                  buttonWidget: button(
                                                    btnText: "Add",
                                                    tapFunction: () async {
                                                      saveUpdateApi(
                                                        controller
                                                            .getSelected(),
                                                        selectedStateCode,
                                                        selectedTransporterid,
                                                      ).then((body) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "Message"),
                                                              content: Text(body
                                                                  .responseMessage),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "OK"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }).catchError((error) {
                                                        // Handle errors if necessary
                                                      });
                                                      Timer(
                                                          const Duration(
                                                              seconds: 1), () {
                                                        fetchMappingList(
                                                            transporterCodeId:
                                                                selectedTransporterid);
                                                      });
                                                    },
                                                  ),
                                                  buttonLabel2: "Cancel",
                                                );
                                              },
                                            );
                                            callStaterApi();
                                          })
                                      : Container()),
                                ),
                                Wrap(
                                  spacing: 5,
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
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xffA0A0A0)),
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
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            fontWeight: FontWeight.w100),
                                        onChanged: (val) {
                                          filterData(val);
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      )),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 200, // Adjust these constraints as needed
                        maxWidth: 702,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 70,
                                child: columnWithoutExpanded(
                                    colColor: const Color(0xffF6F6F6),
                                    columnTitle: "Sr. No.",
                                    hgt1: 45,
                                    clr: const Color(0xff727272),
                                    fntWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 250,
                                child: columnWithoutExpanded(
                                    colColor: const Color(0xffF6F6F6),
                                    columnTitle: "State",
                                    hgt1: 45,
                                    clr: const Color(0xff727272),
                                    fntWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 300,
                                child: columnWithoutExpanded(
                                    colColor: const Color(0xffF6F6F6),
                                    columnTitle: "District",
                                    hgt1: 45,
                                    clr: const Color(0xff727272),
                                    fntWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 81,
                                child: columnWithoutExpanded(
                                    colColor: const Color(0xffF6F6F6),
                                    columnTitle: "Actions",
                                    hgt1: 45,
                                    clr: const Color(0xff727272),
                                    fntWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          ValueListenableBuilder(
                              valueListenable: mappingListResponseList1,
                              builder: (BuildContext context,
                                  List<StateDistrict> data, Widget? child) {
                                if (data.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(30.0),
                                    child: Text("No data found"),
                                  );
                                } else {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: data.length,
                                      itemBuilder: (_, index) {
                                        Color clr;
                                        index % 2 != 0
                                            ? clr = const Color(0xffF6F6F6)
                                            : clr = Colors.white;
                                        return Row(
                                          children: [
                                            SizedBox(
                                              width: 70,
                                              height: 126,
                                              child: columnWithoutExpanded(
                                                  colColor: clr,
                                                  columnTitle:
                                                      '      ${((currentPage - 1) * int.parse(selectedDropdownValue)) + index + 1}',
                                                  fntWeight: FontWeight.normal,
                                                  clr: const Color(0xff727272)),
                                            ),
                                            SizedBox(
                                              width: 250,
                                              height: 126,
                                              child: columnWithoutExpanded(
                                                  colColor: clr,
                                                  columnTitle: data[index]
                                                      .stateName
                                                      .toString(),
                                                  fntWeight: FontWeight.normal,
                                                  clr: const Color(0xff727272)),
                                            ),
                                            SizedBox(
                                              width: 300,
                                              height: 126,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 0.5,
                                                      color: const Color(
                                                          0xff727272),
                                                    ),
                                                    color: Colors.white),
                                                child: ListView.builder(
                                                  itemCount: data[index]
                                                      .districtDetails
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int indexInner) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Center(
                                                        child: Container(
                                                          height: 20,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                          bottom:
                                                                              BorderSide(
                                                                    width: 0.4,
                                                                    color: Colors
                                                                        .grey,
                                                                  )),
                                                                  color: Colors
                                                                      .white),
                                                          child: Text(
                                                            data[index]
                                                                .districtDetails[
                                                                    indexInner]
                                                                .districtName!,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 81,
                                              height: 126,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 0.5,
                                                    color:
                                                        const Color(0xff727272),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    TableColumnActionIcon(
                                                      index: index,
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.green,
                                                        size: 21,
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            callDistrictForEditApi(
                                                                stateName: data[
                                                                        index]
                                                                    .stateName,
                                                                stateCode: data[
                                                                        index]
                                                                    .stateCode,
                                                                districtResponseList:
                                                                    data[index]
                                                                        .districtDetails);
                                                            return CustomPopupAdmin(
                                                              title:
                                                                  "Edit State/District",
                                                              columnChildrens: [
                                                                Wrap(
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .center,
                                                                  runSpacing:
                                                                      10,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          const Text(
                                                                            "State:",
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                45,
                                                                            width:
                                                                                283,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border.all(color: const Color(0xffA0A0A0)),
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(data[index].stateName),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    wSpace(16),
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Text(
                                                                          "Districts:",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                              color: Colors.black),
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 8,
                                                                              right: 8),
                                                                          constraints: const BoxConstraints(
                                                                              minWidth: 200,
                                                                              minHeight: 200,
                                                                              maxWidth: 400,
                                                                              maxHeight: 400),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 45,
                                                                                child: TextField(
                                                                                  controller: searchController,
                                                                                  onChanged: (value) {
                                                                                    filterDistrictsForEdit(value);
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                    labelText: 'Search',
                                                                                    hintText: 'Search for a district',
                                                                                    prefixIcon: const Icon(Icons.search),
                                                                                    border: OutlineInputBorder(
                                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              vSpace(7),
                                                                              checkBox(),
                                                                              vSpace(20)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                              buttonWidget:
                                                                  button(
                                                                btnText:
                                                                    "Submit",
                                                                tapFunction:
                                                                    () async {
                                                                  List<int> selectedDistricts = districtResponseListForEdit
                                                                      .where((district) =>
                                                                          district
                                                                              .isSelected ==
                                                                          true)
                                                                      .map((district) =>
                                                                          int.tryParse(
                                                                              district.district!) ??
                                                                          0)
                                                                      .toList();

                                                                  saveUpdateApi(
                                                                    selectedDistricts,
                                                                    data[index]
                                                                        .stateCode,
                                                                    selectedTransporterid,
                                                                  ).then(
                                                                      (body) {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text("Message"),
                                                                          content:
                                                                              Text(body.responseMessage),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: const Text("OK"),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }).catchError(
                                                                      (error) {
                                                                    // Handle errors if necessary
                                                                  });
                                                                  Timer(
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                      () {
                                                                    fetchMappingList(
                                                                        transporterCodeId:
                                                                            selectedTransporterid);
                                                                  });
                                                                },
                                                              ),
                                                              buttonLabel2:
                                                                  "Cancel",
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    TableColumnActionIcon(
                                                      index: index,
                                                      icon: const Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.red,
                                                        size: 21,
                                                      ),
                                                      onPressed: () {
                                                        StateApi()
                                                            .deleteStateApi(
                                                                context:
                                                                    context,
                                                                transporterCode:
                                                                    selectedTransporterid,
                                                                stateCode: data[
                                                                        index]
                                                                    .stateCode)
                                                            .whenComplete(() =>
                                                                fetchMappingList(
                                                                    transporterCodeId:
                                                                        selectedTransporterid));
                                                        callStaterApi();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: mappingListResponseList,
                                builder: (BuildContext context,
                                    List<StateDistrict> value, Widget? child) {
                                  if (value.isEmpty) {
                                    return Center(child: Container());
                                  }
                                  return Text(
                                      "Showing 1 to ${value.length} of ${value.length} entries",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal));
                                },
                              ),
                              buildValueListenableBuilder(),
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

  void callStaterApi() async {
    loaderScreen.value = true;
    var list = await StateApi().getStatesListFromAPI(context);
    loaderScreen.value = false;
    var stateObj = ResponseList(stateName: 'Select a State');
    List<ResponseList> filteredStates = list.responseList!
        .where((state) => originalMappingList
            .every((mappedState) => mappedState.stateName != state.stateName))
        .toList();
    if (rxStateList.isNotEmpty) {
      rxStateList
        ..clear()
        ..add(stateObj)
        ..addAll(filteredStates)
        ..refresh();
    } else {
      rxStateList
        ..add(stateObj)
        ..addAll(filteredStates)
        ..refresh();
    }
    selectedState.value = rxStateList[0].stateName!;
  }

  List<String> list() {
    List<String> a = ["10", "20", "30", "50", "100", "All"];

    return a;
  }

  ValueListenableBuilder<List<StateDistrict>> buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: mappingListResponseList,
      builder:
          (BuildContext context, List<StateDistrict> value, Widget? child) {
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
