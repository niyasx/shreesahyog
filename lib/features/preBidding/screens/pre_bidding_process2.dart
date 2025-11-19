import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/biddingProcess/api/manualdiallotment_action_api.dart';
import 'package:shreecement/features/biddingProcess/models/manualdiallotment_action_transport_model.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/controller/limitedtextcontroller.dart';
import 'package:shreecement/features/common/controller/numeric.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/features/preBidding/api/city_list_api.dart';
import 'package:shreecement/features/preBidding/api/district_list_api.dart';
import 'package:shreecement/features/preBidding/api/states_list_api.dart';
import 'package:shreecement/features/preBidding/preBidding2/api/pre_bid_2_api.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';

import '../../../global.dart';
import '../../common/api/businesslogicapi.dart';
import '../../common/models/business_rules.dart';
import '../../common/screens/token_expire.dart';
import '../../common/widgets/custom_dropdown_3.dart';
import '../../common/widgets/customdropdownprebid.dart';
import '../apiModels/prebid_response_model.dart';
import '../preBidding2/apiModels/pre_bid_2_model.dart';
import 'package:http/http.dart' as http;

class PreBidProcess2 extends StatefulWidget {
  const PreBidProcess2({
    super.key,
  });
  @override
  State<PreBidProcess2> createState() => PreBidProcess2State();
}

class PreBidProcess2State extends State<PreBidProcess2> {
  RxBool isLoading = false.obs;
  RxInt currentPagination = 1.obs;
  final Controller control = Get.find(); // Access the controller
  ValueNotifier switchState = ValueNotifier(false);
  List<double> extraFrt = [];
  List<ValueNotifier<double>> newFrtAmt = [];
  List<ValueNotifier<bool>> incDecFrtSwitchList = [];
  List<String> newFrtRemark = [];
  List<ValueNotifier<bool>> savedSuccess = [];
  List<NumericTextEditingController> extraFrtTextController = [];
  List<LimitedLengthTextController> remarkTextController = [];
  List<LimitedLengthTextController> bidRemarkTextController = [];
  List<NumericTextEditingController> lowerLimtAmtController = [];
  ValueNotifier enabled = ValueNotifier(false);
  ValueNotifier<MapEntry<String, String>> selectedState =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedDistrict =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedCity =
      ValueNotifier(const MapEntry("", ""));
  late BusinessRules businesrules;
  late ResponseListOfBusinessRules listofbusinessrules;
  ValueNotifier<String> bidStartTime = ValueNotifier("");
  late String plantId;
  late String division;
  String searchValue = "";
  List<PreBid2ModelResponseList> originalPreBidList = [];
  ValueNotifier<List<PreBid2ModelResponseList>> preBidListResponseList =
      ValueNotifier([]);
  ValueNotifier<List<PreBid2ModelResponseList>>
      preBidListResponseListFotLength = ValueNotifier([]);

  ValueNotifier<List<PreBid2ModelResponseList>> preBidListResponseList1 =
      ValueNotifier([]);

  int currentPage = 1;

  late double preBidIncFrtAmt;
  late double preBidDecFrtAmt;
  late bool transporterPriorityStatus = false;
  late double lowerLimitTsh;

//----------------------------------------------------------------
  Map<String, int> checkBoxMap = {};
  List<ValueNotifier<bool>> checkBox = [];

  Set<String> selectedRows = {};

  ValueNotifier<bool> allChecked = ValueNotifier(false);
  RxBool processDiButton = false.obs;

  @override
  void initState() {
    super.initState();
    selectedDropdownValue = "10";
    plantId = sp!.getString("preBid2PlantId") ?? "";
    division = sp!.getString("divisionPrebid") ?? "";
    fetchBusinessLogic();
    fetchPreBidList();
    // if (transporterPriorityStatus == true) {
    fetchTransporterData();
    // }
  }

  fetchBusinessLogic() async {
    businesrules = await BusinessLogic().getbusinesslogiclist(
        plantCode: sp!.getString("plantCode").toString(), ctx: context);

    preBidIncFrtAmt = businesrules.responseList![0].preBidDecFrtAmt!;
    preBidDecFrtAmt = businesrules.responseList![0].preBidDecFrtAmt!;
    transporterPriorityStatus =
        businesrules.responseList![0].transporterPriorityStatus!;
    lowerLimitTsh = businesrules.responseList![0].lowerLimitTsh!;
  }

  List<ResponseList> dpresponselist = [];

  List<Map<String, String>> transporterData = [];

  List<ValueNotifier<String>> selectedTransporterName1 = [];
  List<String> transporterNameList1 = [];
  List<String> transporterIdList1 = [];

  List<ValueNotifier<String>> selectedTransporterName2 = [];
  List<String> transporterNameList2 = [];
  List<String> transporterIdList2 = [];

  Future<void> fetchTransporterData() async {
    try {
      var data = await ManualDiAllotmentActionApi().getTransporterNames(
          plantId:
              sp?.getString("plantCode")); // Assuming sp is declared somewhere

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

      transporterData = transporters;
      // print(transporterData);
    } catch (e) {
      // print("Error fetching transporter data: $e");
    }
  }

  int pageSize = int.parse(selectedDropdownValue);
// Finally, update the getCurrentPageItems method to preserve checkBox state:
  List<PreBid2ModelResponseList> getCurrentPageItems(
      List<PreBid2ModelResponseList> items, int currentPage) {
    preBidListResponseListFotLength.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<PreBid2ModelResponseList> a = items.sublist(startIndex, endIndex);

    // Don't reset allChecked here as it loses selection state during pagination
    // allChecked.value = false;

    extraFrt.clear();
    newFrtAmt.clear();
    incDecFrtSwitchList.clear();
    newFrtRemark.clear();
    savedSuccess.clear();
    extraFrtTextController.clear();
    remarkTextController.clear();
    bidRemarkTextController.clear();
    lowerLimtAmtController.clear();
    transporterNameList1.clear();
    transporterIdList1.clear();
    selectedTransporterName1.clear();
    transporterNameList2.clear();
    transporterIdList2.clear();
    selectedTransporterName2.clear();

    for (var element in a) {
      if (element.newFrtAmount != null) {
        extraFrt.add(element.extFrt ?? 0);
      } else {
        extraFrt.add(0);
      }
      extraFrt.add(0);
      newFrtAmt.add(ValueNotifier(element.newFrtAmount ?? 0.0));
      if (element.newFrtAmount != null) {
        incDecFrtSwitchList
            .add(ValueNotifier(element.frtRate! < element.newFrtAmount!));
      } else {
        incDecFrtSwitchList.add(ValueNotifier(false));
      }

      newFrtRemark.add("");
      if (transporterPriorityStatus && element.transporterP1 != null) {
        savedSuccess.add(ValueNotifier(true));
      } else {
        savedSuccess.add(ValueNotifier(
            (element.newFrtAmount != null) || (element.bidRemark != null)));
      }
      extraFrtTextController.add(NumericTextEditingController(
          text: int.parse(element.extFrt.toString())));
      remarkTextController.add(
        LimitedLengthTextController(text: element.newFrtRemarks),
      );
      bidRemarkTextController.add(
        LimitedLengthTextController(text: element.bidRemark),
      );
      lowerLimtAmtController.add(NumericTextEditingController(
          text: int.tryParse((element.lowerLimitAmt ?? 0).toString())));
      transporterNameList1.add("");
      transporterIdList1.add("");
      selectedTransporterName1
          .add(ValueNotifier(element.transporterP1.toString()));
      transporterNameList2.add("");
      transporterIdList2.add("");
      selectedTransporterName2
          .add(ValueNotifier(element.transporterP2.toString()));
    }

    return a;
  }

// }
  fetchPreBidList() async {
    isLoading.value = true;
    final PreBid2Model response = await PreBid2API().getPreBid2DataFromAPI(pageType: "PREBID",
      context: context,
      employeeCode: sp?.getString("employeeCode") ?? "",
      roleId: int.parse(sp?.getString("employeeCode") ?? ""),
      plantId: plantId,
      division: [division],
      diType: sp?.getString("diType") ?? "",
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

    bidStartTime.value =
        response.serviceDTO?.bidStartTime ?? "Bid Not Schedule Yet";
    originalPreBidList = response.responseList ?? [];

    // Initialize checkboxes for all DIs
    for (int i = 0; i < originalPreBidList.length; i++) {
      checkBoxMap[originalPreBidList[i].diNumber ?? ""] = i;
      checkBox.add(ValueNotifier(false));

      // Here, we would get clubbing info from the response
      // Assuming the API now returns clubbing info in the PreBid2ModelResponseList
      // For example: if originalPreBidList[i].clubbedDIs is a comma-separated list of clubbed DIs
      String clubbedDIsList = originalPreBidList[i].diStatus ?? "";
      if (clubbedDIsList.isNotEmpty) {
        List<String> clubbedDIs =
            clubbedDIsList.split(',').map((e) => e.trim()).toList();
        if (clubbedDIs.isNotEmpty) {
          clubbedDIGroups[originalPreBidList[i].diNumber ?? ""] = clubbedDIs;
        }
      }
    }

    preBidListResponseList.value = List.from(originalPreBidList);
    isLoading.value = false;

    filterData(searchValue);
  }

  void filterData(String searchTerm) {
    // isLoading.value=false;
    if (searchTerm.trim().isEmpty) {
      preBidListResponseList1.value =
          getCurrentPageItems(originalPreBidList, currentPage);
      return;
    }
    List<PreBid2ModelResponseList> filteredData = originalPreBidList
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
            value.customerName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diNumber
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.product
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.soBiddingRemarks
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.updatedBy
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();
    preBidListResponseList.value = filteredData;
    preBidListResponseListFotLength.value = filteredData;
    preBidListResponseList1.value =
        getCurrentPageItems(preBidListResponseList.value, currentPage);
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

  Future<dynamic> saveAllData() async {
    String url = "$baseUrl/bidding/update-prebid-all";

    // num bidRate = extraFrt[index!];
    List<Map<String, dynamic>> payload = [];

    try {
      if (transporterPriorityStatus == true) {
        for (int index = 0;
            index < preBidListResponseList1.value.length;
            index++) {
          if ((transporterIdList1[index].compareTo("Select") != 0 &&
                  transporterIdList1[index] != transporterIdList2[index]) ||
              (transporterIdList2[index].compareTo("Select") == 0 &&
                      newFrtAmt[index].value.toString().trim().isNotEmpty &&
                      newFrtAmt[index].value != 0 &&
                      remarkTextController[index]
                          .value
                          .text
                          .toString()
                          .trim()
                          .isNotEmpty) &&
                  (bidRemarkTextController[index]
                      .value
                      .text
                      .toString()
                      .trim()
                      .isNotEmpty)) {
            payload.add({
              "plantId": int.parse(plantId),
              "diNumber": preBidListResponseList1.value[index].diNumber ?? "",
              "newFrtAmt": newFrtAmt[index].value,
              "newFrtRemark":
                  remarkTextController[index].value.text.toString().trim(),
              "bidRemark":
                  bidRemarkTextController[index].value.toString().trim(),
              "lowerLimitAmt":
                  double.tryParse(lowerLimtAmtController[index].value.text) ??
                      0,
              "extFrt":
                  double.tryParse(extraFrtTextController[index].value.text) ??
                      0,
              'updatedBy': (sp?.getString("email")).toString(),
              'transporterP1': transporterIdList1[index] == "Select"
                  ? ""
                  : transporterIdList1[index],
              "transporterP2": transporterIdList2[index] == "Select"
                  ? ""
                  : transporterIdList2[index],
              "frtRate": preBidListResponseList1.value[index].frtRate.toString()
            });
            savedSuccess[index].value = true;
          }
        }
      } else {
        for (int index = 0;
            index < preBidListResponseList1.value.length;
            index++) {
          if ((newFrtAmt[index].value.toString().trim().isEmpty &&
                  remarkTextController[index].value.text.trim().isEmpty &&
                  int.parse(newFrtAmt[index].value.toString()) > 0) &&
              (bidRemarkTextController[index]
                  .value
                  .text
                  .toString()
                  .trim()
                  .isEmpty)) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: const Text("Please fill the fields"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );

            return;
          }
        }

        for (int index = 0;
            index < preBidListResponseList1.value.length;
            index++) {
          // Check if data at the current index is not already saved
          if ((newFrtAmt[index].value.toString().trim().isNotEmpty &&
                  extraFrtTextController[index].value.text.trim().isNotEmpty &&
                  int.parse(newFrtAmt[index].value.toString()) > 0 &&
                  remarkTextController[index].value.text.trim().isNotEmpty) ||
              (bidRemarkTextController[index]
                  .value
                  .text
                  .toString()
                  .trim()
                  .isNotEmpty)) {
            // Save data for the current index
            payload.add({
              "plantId": int.parse(plantId),
              "diNumber": preBidListResponseList1.value[index].diNumber ?? "",
              "newFrtAmt": newFrtAmt[index].value,
              "newFrtRemark":
                  remarkTextController[index].value.text.toString().trim(),
              "bidRemark":
                  bidRemarkTextController[index].value.text.toString().trim(),
              "lowerLimitAmt":
                  double.tryParse(lowerLimtAmtController[index].value.text) ??
                      0,
              "extFrt":
                  double.tryParse(extraFrtTextController[index].value.text) ??
                      0,
              'updatedBy': (sp?.getString("email")).toString(),
              'transporterP1': transporterIdList1[index] == "Select"
                  ? ""
                  : transporterIdList1[index],
              "transporterP2": transporterIdList2[index] == "Select"
                  ? ""
                  : transporterIdList2[index],
              "frtRate": preBidListResponseList1.value[index].frtRate.toString()
            });
            savedSuccess[index].value = true;
          }
        }
      }
String? token = await secureStorage.read("token");
      var res = await http.put(Uri.parse(url),
          headers: {
            "Authorization": "Bearer $token",
            "username": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode(payload //[]
              ));
      final result = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // print("result $result");
        showResultDialog(result["responseMessage"]);

        // savedSuccess[index!].value = true;
      } else if (res.statusCode == 500) {
        showResultDialog(result["errorMessage"]);
      } else {
        // print("API call failed with status code: ${res.statusCode}");
        // savedSuccess[index!].value = false;
        showResultDialog(result["responseMessage"]);
      }
    } catch (e) {
      // print("Error during transporter save all API call: $e");
      // savedSuccess[index!].value = false;
    }
    await fetchPreBidList();
  }

// 1. First, add these new variables to your class:
  Map<String, List<String>> clubbedDIGroups =
      {}; // Maps a DI to its group of clubbed DIs
  RxBool clubButtonVisible = true.obs; // Controls Club button visibility


//-----------------------------------------------------------------------------------newww

// 2. New method to call the club DI API
  Future<void> clubSelectedDIs() async {
    if (selectedRows.isEmpty || selectedRows.length < 2) {
      showResultDialog("Please select at least two DIs to club together");
      return;
    }

  //    if (!validateSelectedDIsForClubbing()) {
  //   showResultDialog("Please fill all the required fields before clubbing DIs");
  //   return;
  // }

    // First show a confirmation dialog
    bool confirmed = await showConfirmationDialog(
        "Do you want to club these ${selectedRows.length} (${selectedRows.join(',')}) DIs together?");

    if (!confirmed) {
      return; // User cancelled
    }

    // Then show dialog to get remarks for clubbing
    String clubRemark = await showClubRemarkDialog();

    if (clubRemark.isEmpty) {
      // User cancelled or didn't enter remarks
      return;
    }

    // Create a list of all selected DI numbers
    List<String> selectedDINumbers = selectedRows.toList();

    // Call the new API for clubbing DIs
    try {
      // Replace this URL with your actual clubbing API endpoint
      String url = "$baseUrl/bidding/club/dis";

      // Create the payload for the club API
      Map<String, dynamic> payload = {
        "diList": selectedDINumbers,
        "diClubRemarks": clubRemark,
        // "plantId": int.parse(plantId),
        // "updatedBy": (sp?.getString("email")).toString()
      };
String? token = await secureStorage.read("token");
      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer $token",
            "username": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode(payload));

      final result = jsonDecode(res.body);

      for (int i = 0; i < checkBox.length; i++) {
    checkBox[i].value = false;
  }
  selectedRows.clear();
  allChecked.value = false;
  processDiButton.value = false;


      if (res.statusCode == 200) {
        // Update the local clubbedDIGroups map
        for (String diNumber in selectedDINumbers) {
          clubbedDIGroups[diNumber] = selectedDINumbers;
        }

        // Show confirmation to user
        showResultDialog(
            "Successfully clubbed ${selectedDINumbers.length} DIs with remark: $clubRemark");

        // Refresh the data to reflect clubbing
        await fetchPreBidList();
      } else if (res.statusCode == 500) {
        showResultDialog(
            result["errorMessage"] ?? "An error occurred while clubbing DIs");
      } else {
        showResultDialog(result["responseMessage"] ?? "Failed to club DIs");
      }
    } catch (e) {
      showResultDialog("Error while clubbing DIs: ${e.toString()}");
    }
  }

// 3. Confirmation dialog helper
  Future<bool> showConfirmationDialog(String message) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.redbar,
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

// 4. Helper method to show club remark dialog
  Future<String> showClubRemarkDialog() async {
    TextEditingController remarkController = TextEditingController();

    return await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Enter Club Remark'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter a remark explaining why these DIs are being clubbed.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: remarkController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your remark here...',
                      labelText: 'Club Remark',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(''); // Return empty string to cancel
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.redbar,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (remarkController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a remark')),
                      );
                      return;
                    }
                    Navigator.of(context).pop(remarkController.text.trim());
                  },
                ),
              ],
            );
          },
        ) ??
        '';
  }

// Simplified processSelectedDIs method without club validation
  Future<void> processSelectedDIs() async {
    if (selectedRows.isEmpty) {
      showResultDialog("Please select at least one DI to process");
      return;
    }

    // Proceed with processing the selected DIs without club validation
    List<String> selectedDINumbers = selectedRows.toList();
    selectedDINumbers.sort(); // Sort for better readability

    showResultDialog(
        "Processing ${selectedDINumbers.length} DIs:\n\n${selectedDINumbers.join(', ')}");

    // Implement your actual processing logic here
    // This is where you would call your API to process the selected DIs
  }

  bool isDIClubbed(String diNumber) {
    return clubbedDIGroups.containsKey(diNumber);
  }

  List<String> getClubGroupForDI(String diNumber) {
    return clubbedDIGroups[diNumber] ?? [];
  }

  bool isEntireClubSelected(String diNumber) {
    if (!isDIClubbed(diNumber)) {
      return true; // Not a clubbed DI, so consider it fully selected
    }

    List<String> clubGroup = getClubGroupForDI(diNumber);
    for (String clubbedDI in clubGroup) {
      if (!selectedRows.contains(clubbedDI)) {
        return false;
      }
    }

    return true;
  }



//   bool validateSelectedDIsForClubbing() {
//   for (String diNumber in selectedRows) {
//     // Find the index in the current page items
//     int? tableIndex;
//     for (int i = 0; i < preBidListResponseList1.value.length; i++) {
//       if (preBidListResponseList1.value[i].diNumber == diNumber) {
//         tableIndex = i;
//         break;
//       }
//     }
    
//     if (tableIndex != null) {
//       // Check if new freight amount and remark are filled
//       bool newFrtAmtFilled = newFrtAmt[tableIndex].value > 0;
//       bool remarkFilled = remarkTextController[tableIndex].value.text.trim().isNotEmpty;
//       // bool bidRemarkFilled = bidRemarkTextController[tableIndex].value.text.trim().isNotEmpty;
      
//       if (!newFrtAmtFilled || !remarkFilled ) {
//         return false;
//       }
//     }
//   }
//   return true;
// }


// Modified unclubDI function with proper dialog behavior
Future<void> unclubDI(String? diNumber, String? diClubReferenceNo) async {
  if (diNumber == null || diClubReferenceNo == null || diNumber.isEmpty || diClubReferenceNo.isEmpty) {
    showResultDialog("Invalid DI or Club Reference");
    return;
  }

  // Count how many DIs are in this club
  int clubDICount = 0;
  for (var item in originalPreBidList) {
    if (item.diClubReferenceNo == diClubReferenceNo) {
      clubDICount++;
    }
  }

  // Determine whether to show the single option based on DI count
  bool showSingleOption = clubDICount > 2;

  // Always show the dialog, but control which buttons appear
  String action = await showUnclubOptionsDialog(
    diNumber, 
    diClubReferenceNo, 
    showSingleOption: showSingleOption
  );
  
  if (action.isEmpty) {
    return; // User cancelled
  }
  
  try {
    String url = "$baseUrl/bidding/remove/club/dis";
    Map<String, dynamic> payload;
    
    if (action == "single") {
      // Remove just this DI from the club - pass only the DI number in the list
      payload = {
        "diList": [diNumber],
        "refNo": "",  // Empty ref number for single DI removal
      };
    } else {
      // Remove entire club - pass both ref number and DI number
      payload = {
        "diList": [],  // Empty list for full club removal
        "refNo": diClubReferenceNo,  // Include the reference number
      };
    }
String? token = await secureStorage.read("token");
    var res = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
      body: jsonEncode(payload)
    );

    final result = jsonDecode(res.body);

    if (res.statusCode == 200) {
      // Show success message
      String message = action == "single" 
          ? "Successfully removed DI from club" 
          : "Successfully removed entire club";
      showResultDialog(message);
      
      // Refresh the data
      await fetchPreBidList();
    } else {
      showResultDialog(result["responseMessage"] ?? "Failed to unclub DI");
    }
  } catch (e) {
    showResultDialog("Error while unclubbing DI: ${e.toString()}");
  }
}

// Dialog function remains mostly the same, but uses the showSingleOption parameter
Future<String> showUnclubOptionsDialog(String diNumber, String clubRefNo, {bool showSingleOption = true}) async {
  return await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Unclub Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Club Reference: $clubRefNo'),
            const SizedBox(height: 16),
            showSingleOption
                ? const Text('What would you like to do?')
                : const Text('This club contains only two DIs. Removing one would unclub both.'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(''); // Empty string means cancelled
            },
          ),
          // Only show "Remove this DI only" button if showSingleOption is true
          if (showSingleOption)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text(
                'Remove this DI only',
                style: TextStyle(color: ColorConstant.redbar),
              ),
              onPressed: () {
                Navigator.of(context).pop('single');
              },
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.redbar,
            ),
            child: const Text(
              'Remove entire club DI\'s',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop('all');
            },
          ),
        ],
      );
    },
  ) ?? '';
}

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 17)) / 100;
    return CustomScaffold(
      appBarText: "Pre-Bid Process",
      refreshButton: IconButton(
        iconSize: 30,
        color: ColorConstant.redbar,
        tooltip: "Refresh",
        icon: const Icon(Icons.refresh_sharp),
        onPressed: () async {
          await fetchPreBidList();
        },
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
                  Text(
                    'Pre-Bid Process- ${sp?.getString("plantName")} & ${sp?.getString("division1")}',
                    style: const TextStyle(
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
                            runSpacing: 10,
                            spacing: 20,
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
                                                    color: Colors.grey),
                                              ),
                                              CustomDropdownMenu3(
                                                selVal: selectedState.value.key,
                                                list: map.keys.toList(),
                                                fun: (value) async {
                                                  if (value == "All") {
                                                    enabled.value = false;
                                                    setState(() {});
                                                  } else {
                                                    enabled.value = true;
                                                  }
                                                  selectedState.value =
                                                      MapEntry(
                                                    value ?? "",
                                                    map[value] ?? "",
                                                  );
                                                  // currentPage=1;
                                                  // await fetchPreBidList();
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
                                                      color: Colors.grey),
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
                                                          color: Colors.grey),
                                                    ),
                                                    CustomDropdownMenu3(
                                                      selVal: selectedCity
                                                          .value.key,
                                                      list: map.keys.toList(),
                                                      fun: (value) {
                                                        if (value == "All") {
                                                          enabled.value = false;
                                                          setState(() {});
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
                              ValueListenableBuilder(
                                valueListenable: switchState,
                                builder: (BuildContext context, value,
                                    Widget? child) {
                                  return labelledSwitch2(
                                    label: "Show Updated DI",
                                    function: (value) async {
                                      switchState.value = value;
                                      currentPage = 1;
                                      if (!value) {
                                        preBidListResponseList1.value =
                                            getCurrentPageItems(
                                                preBidListResponseList.value,
                                                currentPage);
                                      } else {
                                        List<PreBid2ModelResponseList>
                                            filteredData =
                                            preBidListResponseList.value
                                                .where((value2) =>
                                                    value2.extFrt != null &&
                                                    value2.extFrt != 0)
                                                .toList();
                                        incDecFrtSwitchList.clear();
                                        extraFrtTextController.clear();
                                        newFrtAmt.clear();
                                        remarkTextController.clear();
                                        bidRemarkTextController.clear();
                                        lowerLimtAmtController.clear();
                                        for (var element in filteredData) {
                                          extraFrt.add(0);
                                          newFrtAmt.add(ValueNotifier(
                                              element.newFrtAmount ?? 0.0));
                                          incDecFrtSwitchList
                                              .add(ValueNotifier(false));
                                          newFrtRemark.add("");
                                          savedSuccess
                                              .add(ValueNotifier(false));
                                          extraFrtTextController.add(
                                              NumericTextEditingController(
                                                  text: int.parse(element.extFrt
                                                      .toString())));
                                          remarkTextController.add(
                                            LimitedLengthTextController(
                                                text: element.newFrtRemarks),
                                          );
                                          bidRemarkTextController.add(
                                              LimitedLengthTextController(
                                                  text: element.bidRemark));
                                          lowerLimtAmtController.add(
                                              NumericTextEditingController(
                                                  text: int.tryParse(
                                                      (element.lowerLimitAmt ??
                                                              0)
                                                          .toString())));
                                        }
                                        preBidListResponseListFotLength.value =
                                            filteredData;

                                        preBidListResponseList1.value =
                                            getCurrentPageItems(
                                                filteredData, currentPage);
                                      }
                                    },
                                    switchStatus: switchState.value,
                                  );
                                },
                              ),
                              ValueListenableBuilder(
                                valueListenable: bidStartTime,
                                builder: (BuildContext context, String value,
                                    Widget? child) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Bid Start Time",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Container(
                                        width: 283,
                                        height: 32,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 8),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 1,
                                                color: Color(0xFF727272)),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Color(0xFF727272),
                                            fontSize: 14,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          vSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              button(
                                  btnText: "Search",
                                  tapFunction: () async {
                                    currentPage = 1;
                                    currentPage = 1;
                                    await fetchPreBidList();
                                  }),
                              wSpace(10),
                              button(
                                  btnText: "Reset",
                                  btnClr: Colors.white,
                                  btnTxtClr: ColorConstant.redbar,
                                  tapFunction: () async {
                                    switchState.value =
                                        switchState.value ? false : false;
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
                        ],
                      ),
                    ),
                  ),
                  vSpace(20),
                  tableHeading(heading: "Deliveries for Bidding"),
                  // searchBar(onChanged: (value) {
                  //   filterData(value);
                  // }),
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
                                                    ? preBidListResponseListFotLength
                                                        .value.length
                                                        .toString()
                                                    : value;
                                                pageSize = int.parse(value ==
                                                        "All"
                                                    ? preBidListResponseListFotLength
                                                        .value.length
                                                        .toString()
                                                    : value);
                                                currentPage = 1;
                                              });
                                              // if(value=="All"){
                                              //   isLoading.value=true;
                                              //  await fetchPreBidList();
                                              //   isLoading.value=false;
                                              // }
                                              // else{
                                              //   filterData(searchValue);
                                              //
                                              // }
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
                                    onChanged: (value) {
                                      filterData(value);
                                      searchValue = value;
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
                        columns: [
                          // For the column header checkbox to select all, add this to your table header
// Similarly, update the header checkbox to handle empty checkBox list:
                          DataColumn(
                            label: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: const Color(0xff727272),
                                ),
                              ),
                              // child: ValueListenableBuilder<bool>(
                              //   valueListenable: allChecked,
                              //   builder: (BuildContext context, bool value,
                              //       Widget? child) {
                              //     return Checkbox(
                              //       value: value,
                              //       onChanged: (value) {
                              //         if (checkBox.isEmpty)
                              //           return; // Guard against empty checkBox list

                              //         allChecked.value = value ?? false;
                              //         if (value == true) {
                              //           selectedRows.clear();
                              //           for (int i = 0;
                              //               i <
                              //                   preBidListResponseList1
                              //                       .value.length;
                              //               i++) {
                              //             selectedRows.add(
                              //                 preBidListResponseList1
                              //                         .value[i].diNumber ??
                              //                     "");
                              //             int checkBoxIndex = checkBoxMap[
                              //                     preBidListResponseList1
                              //                             .value[i].diNumber ??
                              //                         ""] ??
                              //                 0;
                              //             if (checkBoxIndex < checkBox.length) {
                              //               // Guard against out of range
                              //               checkBox[checkBoxIndex].value =
                              //                   true;
                              //             }
                              //           }
                              //         } else {
                              //           for (int i = 0;
                              //               i <
                              //                   preBidListResponseList1
                              //                       .value.length;
                              //               i++) {
                              //             int checkBoxIndex = checkBoxMap[
                              //                     preBidListResponseList1
                              //                             .value[i].diNumber ??
                              //                         ""] ??
                              //                 0;
                              //             if (checkBoxIndex < checkBox.length) {
                              //               // Guard against out of range
                              //               checkBox[checkBoxIndex].value =
                              //                   false;
                              //             }
                              //           }
                              //           selectedRows.clear();
                              //         }

                              //         if (selectedRows.isNotEmpty) {
                              //           processDiButton.value = true;
                              //         } else {
                              //           processDiButton.value = false;
                              //         }
                              //       },
                              //     );
                              //   },
                              // ),
                            ),
                          ),
                          const DataColumn(
                            label: TableColumn(
                              "Sr.No",
                              heading: true,
                              width: 30,
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
                              "Taluka",
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
                              "Consignee",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Consignee Address ",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                         
                          DataColumn(
                            label: TableColumn(
                              "SO/STO Number",
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
                              "Status",
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
                              "Dec/Inc Frt",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Extra Frt.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "New Frt. Amt.",
                              heading: true,
                              dropdown: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Remark", //maxlength 50
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Bid Remark", //maxlength 50
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
                          if (transporterPriorityStatus == true) ...[
                            DataColumn(
                              label: TableColumn(
                                "Lower Limit Amt.",
                                heading: true,
                                width: dynamicSize,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Transporter 1",
                                heading: true,
                                width: dynamicSize,
                              ),
                            ),
                            DataColumn(
                              label: TableColumn(
                                "Transporter 2",
                                heading: true,
                                width: dynamicSize,
                              ),
                            ),
                          ],
                           DataColumn(
                            label: TableColumn(
                              "Club Ref No.",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Club Remark",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Updated By",
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
                              "Action",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                          DataColumn(
                            label: TableColumn(
                              "Club Action",
                              heading: true,
                              width: dynamicSize,
                            ),
                          ),
                        ],
                        rows: List.generate(
                          preBidListResponseList1.value.length,
                          (index) {
                            final hasClubReference = data[index].diClubReferenceNo != null &&
                                data[index].diClubReferenceNo!.isNotEmpty;
                            return DataRow(

                            cells: [
                              // Replace your checkbox DataCell with this implementation
                              DataCell(
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                      color: const Color(0xff727272),
                                    ),
                                  ),
                                  child: Builder(builder: (context) {
                                    if (data[index].diClubReferenceNo != null &&
                                        data[index].diClubReferenceNo!
                                            .isNotEmpty) {
                                      return Container();
                                      // Checkbox(
                                      //                                   activeColor: Colors.grey,
                                      //                                   checkColor: Colors.white,
                                      //                                   value: true,
                                      //                                   onChanged:(value) {

                                      //                                   },);
                                    }


                                    final checkBoxIndex = checkBoxMap[
                                    data[index].diNumber ?? ""] ??
                                        0;
                                    // Guard against index out of range
                                    if (checkBox.isEmpty ||
                                        checkBoxIndex >= checkBox.length) {
                                      return Checkbox(
                                        value: false,
                                        onChanged: (newVal) {},
                                      );
                                    }

                                    return ValueListenableBuilder<bool>(
                                      valueListenable: checkBox[checkBoxIndex],
                                      builder: (BuildContext context,
                                          bool value, Widget? child) {
                                        return Checkbox(
                                          activeColor: ColorConstant.redbar,
                                          checkColor: Colors.white,
                                          value: value,
                                          onChanged: (newVal) {
                                            if (newVal == true) {
                                              selectedRows.add(
                                                  data[index].diNumber ?? "");
                                              checkBox[checkBoxIndex].value =
                                                  true;
                                            } else {
                                              selectedRows.remove(
                                                  data[index].diNumber ?? "");
                                              checkBox[checkBoxIndex].value =
                                                  false;
                                            }

                                            // Update the button state
                                            if (selectedRows.isNotEmpty) {
                                              processDiButton.value = true;
                                            } else {
                                              processDiButton.value = false;
                                            }
                                          },
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  "${((currentPage - 1) *
                                      int.parse(selectedDropdownValue)) +
                                      index + 1}",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].diNumber ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].stateName ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].districtName ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].talukaName ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].cityName ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].customerName ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].consigneeAddress ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),

                              DataCell(
                                TableColumn(
                                  data[index].salesOrderNo ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].product ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].diQty.toString(),
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].diStatus.toString(),
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].frtRate.toString(),
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("  -"),
                                  ValueListenableBuilder(
                                    valueListenable: incDecFrtSwitchList[index],
                                    builder: (BuildContext context, bool value,
                                        Widget? child) {
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
                                              incDecFrtSwitchList[index].value =
                                                  value;
                                              if (value) {
                                                extraFrtTextController[index]
                                                    .clear();
                                                newFrtAmt[index].value = 0;
                                              } else {
                                                extraFrtTextController[index]
                                                    .clear();
                                                newFrtAmt[index].value = 0;
                                              }
                                            },
                                          ));
                                    },
                                  ),
                                  const Text("+  ")
                                ],
                              )),
                              DataCell(
                                TableColumnTextField(
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  controller: extraFrtTextController[index],
                                  // enabled: savedSuccess[index].value ? false : true,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      extraFrt[index] = 0;
                                      newFrtAmt[index].value = 0;
                                    } else {
                                      extraFrt[index] = double.parse(value);
                                    }

                                    if (incDecFrtSwitchList[index].value &&
                                        extraFrt[index] > preBidIncFrtAmt) {
                                      extraFrtTextController[index].clear();
                                      newFrtAmt[index].value = 0;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Input is not valid"),
                                            content: Text(
                                                "Please insert less than $preBidIncFrtAmt or equal to $preBidIncFrtAmt"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    } else if (!incDecFrtSwitchList[index]
                                        .value &&
                                        extraFrt[index] > preBidDecFrtAmt) {
                                      extraFrtTextController[index].clear();
                                      newFrtAmt[index].value = 0;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Input is not valid"),
                                            content: Text(
                                                "Please insert less than $preBidDecFrtAmt or equal to $preBidDecFrtAmt"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    }

                                    if (value.isNotEmpty) {
                                      if (!incDecFrtSwitchList[index].value) {
                                        newFrtAmt[index].value =
                                            data[index].frtRate! -
                                                double.parse(value);
                                      } else {
                                        newFrtAmt[index].value =
                                            data[index].frtRate! +
                                                double.parse(value);
                                      }
                                    }
                                    // if (value.isEmpty) {
                                    //   newFrtAmt[index].value =
                                    //       data[index].newFrtAmount!;
                                    // }
                                    //newFrtAmt[index];
                                  },
                                ),
                              ),
                              DataCell(
                                ValueListenableBuilder(
                                  valueListenable: newFrtAmt[index],
                                  builder: (BuildContext context, value,
                                      Widget? child) {
                                    // Check if the value is numeric
                                    return TableColumn(
                                      value == 0.0 ? "" : value.toString(),
                                      index: index +
                                          int.parse(selectedDropdownValue) *
                                              currentPage -
                                          1,
                                      backgroundColor: hasClubReference
                                          ? Colors.lightBlue.withOpacity(0.2)
                                          : null,
                                      allowRowColor: hasClubReference, // Disable zebra striping when colored
                                    );
                                  },
                                ),
                              ),
                              DataCell(
                                TableColumnTextField(
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  controller: remarkTextController[index],
                                  // enabled: savedSuccess[index].value ? false : true,

                                ),
                              ),
                              DataCell(
                                TableColumnTextField(
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  controller: bidRemarkTextController[index],
                                  // enabled: savedSuccess[index].value ? false : true,
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  (data[index].soBiddingRemarks ?? "").length >
                                      50
                                      ? (data[index].soBiddingRemarks ?? "")
                                      .substring(0, 50)
                                      : data[index].soBiddingRemarks ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              if (transporterPriorityStatus == true) ...[
                                DataCell(
                                  TableColumnTextField(
                                    index: index +
                                        int.parse(selectedDropdownValue) *
                                            currentPage -
                                        1,
                                    keyboardType: TextInputType.number,
                                    controller: lowerLimtAmtController[index],
                                    enabled: lowerLimtAmtController[index]
                                        .text
                                        .isNotEmpty &&
                                        int.parse(lowerLimtAmtController[index]
                                            .text) >
                                            0,
                                    onChanged: (value) {
                                      if (double.tryParse(value.toString())! >
                                          lowerLimitTsh) {
                                        extraFrtTextController[index].clear();
                                        newFrtAmt[index].value = 0;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Input is not valid"),
                                              content: Text(
                                                  "Lower limit maximum amount is $lowerLimitTsh"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        lowerLimtAmtController[index].text =
                                            lowerLimitTsh.toString();

                                        return;
                                      }
                                    },
                                  ),
                                ),
                                DataCell(Builder(
                                  builder: (context) {
                                    String transporterP1 =
                                    data[index].transporterP1.toString();
                                    bool isTransporterP1Present =
                                    dpresponselist.any((element) =>
                                    element.supplier.toString() ==
                                        transporterP1);

                                    Map<String, String> defaultTransporterMap =
                                    {};
                                    if (isTransporterP1Present) {
                                      for (var value in dpresponselist) {
                                        if (value.supplier.toString() ==
                                            transporterP1) {
                                          defaultTransporterMap[
                                          value.name.toString()] =
                                              value.supplier.toString();
                                          break; // Break the loop once the value is found
                                        }
                                      }
                                      for (var value in dpresponselist) {
                                        defaultTransporterMap[
                                        value.name.toString()] =
                                            value.supplier.toString();
                                      }
                                    } else {
                                      defaultTransporterMap["Select"] =
                                      "Select";
                                      for (var value in dpresponselist) {
                                        defaultTransporterMap[
                                        value.name.toString()] =
                                            value.supplier.toString();
                                      }
                                    }

                                    selectedTransporterName1[index].value =
                                        defaultTransporterMap.keys.first;
                                    transporterNameList1[index] =
                                        defaultTransporterMap.keys.first;
                                    transporterIdList1[index] =
                                        defaultTransporterMap.values.first;

                                    return ValueListenableBuilder(
                                      valueListenable:
                                      selectedTransporterName1[index],
                                      builder: (BuildContext context,
                                          String value, Widget? child) {
                                        return CustomDropdownMenu3(
                                          width: double.infinity,
                                          margin: const EdgeInsets.all(4),
                                          selVal:
                                          selectedTransporterName1[index]
                                              .value,
                                          list: defaultTransporterMap.keys
                                              .toList(),
                                          fun: (value) {
                                            // print("selected value $value");
                                            selectedTransporterName1[index]
                                                .value = value.toString();
                                            transporterNameList1[index] =
                                                value.toString();
                                            transporterIdList1[index] =
                                                defaultTransporterMap[
                                                value.toString()]
                                                    .toString();
                                          },
                                        );
                                      },
                                    );
                                  },
                                )),
                                DataCell(Builder(
                                  builder: (context) {
                                    String transporterP2 =
                                    data[index].transporterP2.toString();
                                    bool isTransporterP2Present =
                                    dpresponselist.any((element) =>
                                    element.supplier.toString() ==
                                        transporterP2);

                                    Map<String, String> defaultTransporterMap =
                                    {};
                                    if (isTransporterP2Present) {
                                      for (var value in dpresponselist) {
                                        if (value.supplier.toString() ==
                                            transporterP2) {
                                          defaultTransporterMap[
                                          value.name.toString()] =
                                              value.supplier.toString();
                                          break; // Break the loop once the value is found
                                        }
                                      }
                                      for (var value in dpresponselist) {
                                        defaultTransporterMap[
                                        value.name.toString()] =
                                            value.supplier.toString();
                                      }
                                    } else {
                                      defaultTransporterMap["Select"] =
                                      "Select";
                                      for (var value in dpresponselist) {
                                        defaultTransporterMap[
                                        value.name.toString()] =
                                            value.supplier.toString();
                                      }
                                    }

                                    selectedTransporterName2[index].value =
                                        defaultTransporterMap.keys.first;
                                    transporterNameList2[index] =
                                        defaultTransporterMap.keys.first;
                                    transporterIdList2[index] =
                                        defaultTransporterMap.values.first;

                                    // Map<String, String> transMapp = {};
                                    // transMapp["Select"] = "Select";

                                    // for (var value in dpresponselist) {
                                    //   transMapp[value.name.toString()] =
                                    //       value.supplier.toString();
                                    // }

                                    // selectedTransporterName2[index].value =
                                    //     transMapp.keys.toList().first;
                                    // transporterNameList2[index] =
                                    //     transMapp.keys.toList().first;
                                    // transporterIdList2[index] =
                                    //     transMapp.values.toList().first;
                                    return ValueListenableBuilder(
                                      valueListenable:
                                      selectedTransporterName2[index],
                                      builder: (BuildContext context,
                                          String value, Widget? child) {
                                        return CustomDropdownMenu3(
                                          width: double.infinity,
                                          margin: const EdgeInsets.all(4),
                                          selVal:
                                          selectedTransporterName2[index]
                                              .value,
                                          list: defaultTransporterMap.keys
                                              .toList(),
                                          fun: (value) {
                                            // print("selected value $value");
                                            selectedTransporterName2[index]
                                                .value = value.toString();
                                            transporterNameList2[index] =
                                                value.toString();
                                            transporterIdList2[index] =
                                                defaultTransporterMap[
                                                value.toString()]
                                                    .toString();
                                          },
                                        );
                                      },
                                    );
                                  },
                                )),
                              ],

                              //--------------------- club ref no

                              DataCell(
                                TableColumn(
                                  data[index].diClubReferenceNo ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),

                              DataCell(
                                TableColumn(
                                  data[index].diClubRemarks ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),


                              DataCell(
                                TableColumn(
                                  textTrim: true,
                                  savedSuccess[index].value
                                      ? data[index].updatedBy ?? ""
                                      : "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                TableColumn(
                                  data[index].payerBlock ?? "",
                                  index: index +
                                      int.parse(selectedDropdownValue) *
                                          currentPage -
                                      1,
                                  backgroundColor: hasClubReference
                                      ? Colors.lightBlue.withOpacity(0.2)
                                      : null,
                                  allowRowColor: hasClubReference, // Disable zebra striping when colored
                                ),
                              ),
                              DataCell(
                                ValueListenableBuilder(
                                  valueListenable: savedSuccess[index],
                                  builder: (BuildContext context, bool value,
                                      Widget? child) {
                                    return TableColumnActionIcon(
                                      index: index +
                                          int.parse(selectedDropdownValue) *
                                              currentPage -
                                          1,
                                      icon: Row(
                                        children: [
                                          const Icon(
                                            Icons.save,
                                            color: Colors.green,
                                            size: 21,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          if (value)
                                            const Icon(
                                              Icons.thumb_up,
                                              color: Colors.green,
                                              size: 21,
                                            )
                                          else
                                            Container()
                                        ],
                                      ),

                                      //
                                      onPressed: () async {
                                        try {
                                          if (transporterPriorityStatus ==
                                              true) {
                                            if ((transporterIdList1[index]
                                                .compareTo(
                                                "Select") !=
                                                0 &&
                                                transporterIdList1[index] !=
                                                    transporterIdList2[
                                                    index]) ||
                                                (transporterIdList2[
                                                index]
                                                    .compareTo(
                                                    "Select") ==
                                                    0 &&
                                                    newFrtAmt[
                                                    index]
                                                        .value
                                                        .toString()
                                                        .trim()
                                                        .isNotEmpty &&
                                                    newFrtAmt[index].value !=
                                                        0 &&
                                                    remarkTextController[index]
                                                        .value
                                                        .text
                                                        .toString()
                                                        .trim()
                                                        .isNotEmpty &&
                                                    (bidRemarkTextController[
                                                    index]
                                                        .value
                                                        .text
                                                        .toString()
                                                        .trim()
                                                        .isEmpty))) {
                                              final jsonResponse = await PreBid2API()
                                                  .updatePreBid2Data(
                                                  ctx: context,
                                                  lowerLimitAmt: double
                                                      .tryParse(
                                                      lowerLimtAmtController[index]
                                                          .value
                                                          .text
                                                          .toString()) ??
                                                      0,
                                                  transporterP1:
                                                  transporterIdList1[index],
                                                  transporterP2:
                                                  transporterIdList2[index],
                                                  plantId: int.parse(plantId),
                                                  diNumber: data[index]
                                                      .diNumber ??
                                                      "",
                                                  newFrtAmt:
                                                  newFrtAmt[index].value,
                                                  newFrtRemark:
                                                  remarkTextController[index]
                                                      .value
                                                      .text
                                                      .toString()
                                                      .trim(),
                                                  bidRemark: bidRemarkTextController[index]
                                                      .value
                                                      .text
                                                      .toString()
                                                      .trim(),
                                                  extFrt: double.tryParse(
                                                      extraFrtTextController[index]
                                                          .value
                                                          .text
                                                          .toString()) ??
                                                      0,
                                                  frtRate: data[index].frtRate
                                                      .toString());

                                              PrebidResponseModel
                                              prebidResponseModel =
                                              PrebidResponseModel.fromJson(
                                                  jsonResponse);

                                              savedSuccess[index].value = true;
                                              await fetchPreBidList();
                                              if (prebidResponseModel
                                                  .responseCode ==
                                                  "404") {
                                                Get.dialog(
                                                  AlertDialog(
                                                    title: const Text("Error"),
                                                    content: Text(
                                                        prebidResponseModel
                                                            .responseMessage),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Get
                                                              .back(); // Close the dialog
                                                        },
                                                        child: const Text("OK"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            } else {
                                              //  Show error message if Transporter 1 is not selected
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Error"),
                                                    content: const Text(
                                                        "Please fill all fields"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text("OK"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          } else {
                                            if ((newFrtAmt[index]
                                                .value
                                                .toString()
                                                .trim()
                                                .isEmpty ||
                                                newFrtAmt[index].value ==
                                                    0 ||
                                                remarkTextController[index]
                                                    .value
                                                    .text
                                                    .toString()
                                                    .trim()
                                                    .isEmpty) &&
                                                (bidRemarkTextController[index]
                                                    .value
                                                    .text
                                                    .toString()
                                                    .trim()
                                                    .isEmpty)) {
                                              // Show a dialog for newFrtAmt being null or empty
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Error"),
                                                    content: const Text(
                                                        "Please fill all fields"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text("OK"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              return;
                                            }

                                            final jsonResponse = await PreBid2API()
                                                .updatePreBid2Data(
                                                ctx: context,
                                                lowerLimitAmt: double.tryParse(
                                                    lowerLimtAmtController[index]
                                                        .value
                                                        .text
                                                        .toString()) ??
                                                    0,
                                                transporterP1:
                                                transporterIdList1[index],
                                                transporterP2:
                                                transporterIdList2[index],
                                                plantId: int.parse(plantId),
                                                diNumber:
                                                data[index].diNumber ?? "",
                                                newFrtAmt:
                                                newFrtAmt[index].value,
                                                newFrtRemark:
                                                remarkTextController[index]
                                                    .value
                                                    .text
                                                    .toString()
                                                    .trim(),
                                                bidRemark: bidRemarkTextController[index]
                                                    .value
                                                    .text
                                                    .toString()
                                                    .trim(),
                                                extFrt: double.tryParse(
                                                    extraFrtTextController[index]
                                                        .value
                                                        .text
                                                        .toString()) ??
                                                    0,
                                                frtRate: data[index].frtRate
                                                    .toString());

                                            PrebidResponseModel
                                            prebidResponseModel =
                                            PrebidResponseModel.fromJson(
                                                jsonResponse);

                                            savedSuccess[index].value = true;
                                            await fetchPreBidList();
                                            // buildSnackBarSuccess("Success",
                                            //     "Successfully Updated");

                                            if (prebidResponseModel
                                                .responseCode ==
                                                "404") {
                                              Get.dialog(
                                                AlertDialog(
                                                  title: const Text("Error"),
                                                  content: Text(
                                                      prebidResponseModel
                                                          .responseMessage),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Get
                                                            .back(); // Close the dialog
                                                      },
                                                      child: const Text("OK"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          }
                                        } catch (err) {
                                          // Handle error
                                          // print(err.toString());
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),


                              DataCell(
                                ValueListenableBuilder(
                                  valueListenable: savedSuccess[index],
                                  builder: (context, value, child) {
                                    // Only show delete icon if this DI has a club reference number
                                    if (data[index].diClubReferenceNo == null ||
                                        data[index].diClubReferenceNo!
                                            .isEmpty) {
                                      return Container(); // Empty container if no club ref
                                    }

                                    return TableColumnActionIcon(
                                      index: index +
                                          int.parse(selectedDropdownValue) *
                                              currentPage - 1,
                                      icon: const Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.red,
                                        size: 21,
                                      ),
                                      onPressed: () {
                                        // Implement unclub function
                                        unclubDI(data[index].diNumber,
                                            data[index].diClubReferenceNo);
                                      },
                                    );
                                  },
                                ),
                              )


                            ],
                          );
                          }
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
                          child: size.width > 600
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    size.width > 600
                                        ? ValueListenableBuilder(
                                            valueListenable:
                                                preBidListResponseList1,
                                            builder: (BuildContext context,
                                                List<PreBid2ModelResponseList>
                                                    value,
                                                Widget? child) {
                                              return Text(
                                                  "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length + (currentPage - 1) * int.parse(selectedDropdownValue)} of ${preBidListResponseList.value.length} entries",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal));
                                            },
                                          )
                                        : Container(),
                                    buildValueListenableBuilder(),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: button(
                                              btnText: "Save All",
                                              tapFunction: () {
                                                saveAllData();
                                              }),
                                        ),
                                        const SizedBox(width: 8),
                                        Obx(() => processDiButton.value
                                            ? Row(
                                                children: [
                                                  // button(
                                                  //   btnText: "Process Selected DIs",
                                                  //   tapFunction: () {
                                                  //     processSelectedDIs();
                                                  //   }
                                                  // ),
                                                  // const SizedBox(width: 8),
                                                  button(
                                                      btnText: "Club DIs",
                                                      btnClr:
                                                          ColorConstant.redbar,
                                                      btnTxtClr: Colors.white,
                                                      tapFunction: () {
                                                        clubSelectedDIs();
                                                      }),
                                                ],
                                              )
                                            : Container()),
                                      ],
                                    ),
                                  ],
                                )
                              : Wrap(
                                  spacing: 20,
                                  runSpacing: 10,
                                  children: [
                                    size.width > 600
                                        ? ValueListenableBuilder(
                                            valueListenable:
                                                preBidListResponseList1,
                                            builder: (BuildContext context,
                                                List<PreBid2ModelResponseList>
                                                    value,
                                                Widget? child) {
                                              return Text(
                                                  "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length + (currentPage - 1) * int.parse(selectedDropdownValue)} of ${preBidListResponseList.value.length} entries",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal));
                                            },
                                          )
                                        : Container(),
                                    buildValueListenableBuilder(),
                                    SizedBox(
                                      width: 110,
                                      child: button(
                                          btnText: "Save All",
                                          tapFunction: () {
                                            saveAllData();
                                          }),
                                    ),
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
                visible: isLoading.value,
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

  List<String> list() {
    List<String> a = ["10", "20", "30", "50", "100", "All"];

    return a;
  }

  ValueListenableBuilder<List<PreBid2ModelResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: preBidListResponseListFotLength,
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

          return Wrap(
            children: pageWidgets,
          );
        });
      },
    );
  }
}
