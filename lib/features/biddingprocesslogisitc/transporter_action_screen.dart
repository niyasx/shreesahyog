// ignore_for_file: avoid_debugPrint
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/biddingProcess/api/transporter_apis.dart';
import 'package:shreecement/features/biddingProcess/models/transporter_action_model.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/controller/numeric.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/common/widgets/custom_table.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/features/preBidding/api/states_list_api.dart';
import 'package:shreecement/features/preBidding/api/city_list_api.dart';
import 'package:shreecement/features/preBidding/api/district_list_api.dart';
import 'package:http/http.dart' as http;
import '../common/api/businesslogicapi.dart';
import '../common/controller/timecontroller.dart';
import '../common/models/business_rules.dart';
import '../common/widgets/custom_dropdown_3.dart';
import '../common/widgets/customdropdownprebid.dart';

class StartBidTransporterAction extends StatefulWidget {
  const StartBidTransporterAction({super.key});

  @override
  State<StartBidTransporterAction> createState() =>
      _StartBidTransporterActionState();
}

class _StartBidTransporterActionState extends State<StartBidTransporterAction> {
  RxInt currentPagination = 1.obs;
  final TimerController timerController = TimerController();
  bool switchOn = false;
  ValueNotifier<String> bidStartTime = ValueNotifier("");
  final Controller control = Get.find(); // Access the controller
  ValueNotifier switchState = ValueNotifier(false);
  String? timerValue;
  String? bidEndTime;

  RxBool loaderScreen = false.obs;

  List<double> extraFrt = [];
  List<ValueNotifier<num>> newFrtAmt = [];
  List<ValueNotifier<bool>> incDecFrtSwitchList = [];
  List<String> newFrtRemark = [];
  List<ValueNotifier<bool>> savedSuccess = [];
  List<NumericTextEditingController> extraFrtTextController = [];
  List<TextEditingController> remarkTextController = [];

  ValueNotifier enabled = ValueNotifier(false);

  ValueNotifier<MapEntry<String, String>> selectedState =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedDistrict =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedCity =
      ValueNotifier(const MapEntry("", ""));

  late String plantId;
  late String division;
  late int countdownEndTime;
  late BusinessRules businesrules;
  late ResponseListOfBusinessRules listofbusinessrules;
  late double? frtLowerTol;
  late double? frtHigherTol;
  String searchValue = "";
  List<TransporterBid2ModelResponseList> originalTransport2List = [];
  ValueNotifier<List<TransporterBid2ModelResponseList>>
      transporterBID2ListResponseList = ValueNotifier([]);
  ValueNotifier<List<TransporterBid2ModelResponseList>>
      transporterBID2ListResponseList1 = ValueNotifier([]);

  double enteredValue = 0;
  bool saved = false;
  late DateTime scheduledTime;

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
    selectedDropdownValue = "10";
    selectedDropdownValue1 = "10";

    plantId = control.preBid2PlantId.value;
    fetchBusinessLogic();
    fetchTransportActionList();

    ever(timerController.isTimerZero, (bool isZero) async {
      if (isZero) {
        // Perform your desired action here
        // // debugPrint('Timer is zero. Triggering setState...');
        await fetchTransportActionListTimer();
      }
    });
  }

//---------------------------------------------------------------------------------------------

  Map<String, List<TransporterBid2ModelResponseList>> clubbedDIGroups = {};

// 2. Add a method to organize clubbed DIs in your fetchTransportActionList method
  void organizeClubbledDIs() {
    clubbedDIGroups.clear();

    // Group DIs by diClubReferenceNo
    for (var item in originalTransport2List) {
      if (item.diClubReferenceNo != null && item.diClubReferenceNo!.isNotEmpty) {
        if (!clubbedDIGroups.containsKey(item.diClubReferenceNo)) {
          clubbedDIGroups[item.diClubReferenceNo!] = [];
        }
        clubbedDIGroups[item.diClubReferenceNo!]!.add(item);
      }
    }
  }

  List<TransporterBid2ModelResponseList> getClubbledDIsForDI(String diNumber) {
    // Find the diClubReferenceNo for this DI
    String? diClubReferenceNo;

    debugPrint("Checking DI: $diNumber");
    for (var item in originalTransport2List) {
      debugPrint("Item DI: ${item.diNumber}, diClubReferenceNo: ${item.diClubReferenceNo}");
      if (item.diNumber == diNumber &&
          item.diClubReferenceNo != null &&
          item.diClubReferenceNo!.isNotEmpty) {
        diClubReferenceNo = item.diClubReferenceNo;
        debugPrint("Found diClubReferenceNo: $diClubReferenceNo for DI: $diNumber");
        break;
      }
    }

    // If there's no diClubReferenceNo, return empty list
    if (diClubReferenceNo == null || diClubReferenceNo.isEmpty) {
      return [];
    }

    // Return all DIs with the same diClubReferenceNo
    return clubbedDIGroups[diClubReferenceNo] ?? [];
  }

  Future<bool> showClubDIAlert(
      List<TransporterBid2ModelResponseList> clubbedDIs,
      String? currentDI) async {
    debugPrint(
        "showClubDIAlert called with ${clubbedDIs.length} DIs for currentDI: $currentDI");

    List<String> otherDIs = clubbedDIs
        .where((di) => di.diNumber != currentDI)
        .map((di) => di.diNumber ?? "")
        .toList();

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Clubbed DI Alert'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "This DI is part of a clubbed group. All the following DIs must be bidded together:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current DI: $currentDI",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Other clubbed DIs:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...otherDIs.map((di) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 4.0),
                              child: Text("• $di"),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                 
                ],
              ),
              actions: [
                TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.of(context).pop(false); // Cancel
                //   },
                //   child: const Text('Cancel'),
                // ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: ColorConstant.redbar,
                //   ),
                //   onPressed: () {
                //     Navigator.of(context).pop(); // Proceed
                //   },
                //   child: const Text(
                //     'ok',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            );
          },
        ) ??
        false;
  }

// 8. Add a dialog to show incomplete clubs alert
  Future<bool> showIncompleteClubsAlert(List<String> incompleteClubs) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Incomplete Club Selection'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "You are updating only some DIs from clubbed groups. All DIs in a club should be updated together:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...incompleteClubs.map((clubInfo) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text("• $clubInfo"),
                      )),
                 
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cancel
                  },
                  child: const Text('OK'),
                ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: ColorConstant.redbar,
                //   ),
                //   onPressed: () {
                //     Navigator.of(context).pop(true); // Proceed
                //   },
                //   child: const Text(
                //     'Continue Anyway',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            );
          },
        ) ??
        false;
  }

//---------------------------------------------------------------------------------
  fetchBusinessLogic() async {
    businesrules = await BusinessLogic().getbusinesslogiclist(
        plantCode: sp!.getString("plantCode").toString(), ctx: context);

    frtLowerTol = businesrules.responseList![0].frtLowerTol!;
    // debugPrint(frtLowerTol);
    frtHigherTol = businesrules.responseList![0].frtHigherTol!;
  }

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);
  List<TransporterBid2ModelResponseList> getCurrentPageItems(
      List<TransporterBid2ModelResponseList> items, int currentPage) {
    transporterBID2ListResponseList.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    List<TransporterBid2ModelResponseList> a =
        items.sublist(startIndex, endIndex);
    extraFrt.clear();
    newFrtAmt.clear();
    incDecFrtSwitchList.clear();
    newFrtRemark.clear();
    savedSuccess.clear();
    extraFrtTextController.clear();
    remarkTextController.clear();
    for (var element in a) {
      extraFrt.add(0);

      newFrtAmt.add(ValueNotifier(element.newFrtAmount ?? 0.0));

      incDecFrtSwitchList.add(ValueNotifier(false));
      newFrtRemark.add("");
      savedSuccess.add(ValueNotifier(false));
      extraFrtTextController
          .add(NumericTextEditingController(text: element.bidRate));
      remarkTextController.add(
        TextEditingController(text: element.soBiddingRemarks),
      );
    }

    return a;
  }

  fetchTransportActionListTimer() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final TransporterBid2Model response =
          await TransporterApi().getTransport2DataFromAPI(
        employeeCode: sp?.getString("employeeCode") ?? "",
        plantId: sp!.getInt("plantId")!,
        division: sp!.getString("division")!,
        ctx: context,
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

      originalTransport2List = response.responseList ?? [];

      // Organize clubbed DIs
      organizeClubbledDIs();

      bidStartTime.value = originalTransport2List.isNotEmpty
          ? originalTransport2List[0].startTime.toString()
          : "";

      bidEndTime = originalTransport2List.isNotEmpty
          ? originalTransport2List[0].endTime.toString()
          : "";
      // transporterBID2ListResponseList1.value=getCurrentPageItems(originalTransport2List, currentPage);
      filterData(searchValue);

      try {
        timerController.startTimer(DateTime.parse(bidEndTime!));
      } catch (e) {
        control.currentIndex.value = 14;
      }
    } catch (e) {
      control.currentIndex.value = 14;
      // Future.delayed(Duration.zero, () {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const TokenExpire()),
      //   );
      // });
      // debugPrint("error in fetch data $e");
    }
  }

  fetchTransportActionList() async {
    try {
      // loaderScreen.value = true;
      final TransporterBid2Model response =
      //  getJsonMapResponse();
          await TransporterApi().getTransport2DataFromAPI(
        employeeCode: sp?.getString("employeeCode") ?? "",
        plantId: sp!.getInt("plantId")!,
        division: sp!.getString("division")!,
        ctx: context,
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

      debugPrint("response code ${response.responseCode}");
      // loaderScreen.value = false;

      originalTransport2List = response.responseList ?? [];

      organizeClubbledDIs();

      bidStartTime.value = originalTransport2List.isNotEmpty
          ? originalTransport2List[0].startTime.toString()
          : "";

      bidEndTime = originalTransport2List.isNotEmpty
          ? originalTransport2List[0].endTime.toString()
          : "";
      // transporterBID2ListResponseList1.value=getCurrentPageItems(originalTransport2List, currentPage);
      filterData(searchValue);
      timerController.startTimer(DateTime.parse(bidEndTime!));
    } catch (e) {
      // debugPrint("error in fetch data $e");
    }
  }

  void filterData(String searchTerm) {
    if (searchTerm.trim().isEmpty) {
      // debugPrint(originalTransport2List);
      transporterBID2ListResponseList1.value =
          getCurrentPageItems(originalTransport2List, currentPage);
      return;
    }

    List<TransporterBid2ModelResponseList> filteredData = originalTransport2List
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
            value.newFrtAmount
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
            value.brand
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
            value.bidRemark
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.diType
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    transporterBID2ListResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  final List<BidDetailsPayload> payloadlist = [];

Future<dynamic> saveStartBidTransporter({
  required int index,
  String? diNumber,
  String? bidLotId,
  double? enteredVal,
  String? diClubReferenceNo
}) async {
  debugPrint("Starting bid update for DI: $diNumber");
  
  // Check if this DI is part of a club
  List<TransporterBid2ModelResponseList> clubbedDIs = getClubbledDIsForDI(diNumber ?? "");
  debugPrint("Found ${clubbedDIs.length} clubbed DIs for $diNumber");
  
  bool isClubbed = clubbedDIs.isNotEmpty && clubbedDIs.length > 1;
  
  if (isClubbed) {
    debugPrint("DI $diNumber is part of a club with ${clubbedDIs.length} DIs");
    
    // Check if all clubbed DIs have rates entered
    bool allDIsHaveRates = true;
    List<String> missingRateDIs = [];
    
    // Find all the DIs from the same club in the current page data
    for (var clubbedDI in clubbedDIs) {
      // Find the index of this clubbed DI in the current page data
      int currentPageIndex = transporterBID2ListResponseList1.value.indexWhere(
        (item) => item.diNumber == clubbedDI.diNumber
      );
      
      if (currentPageIndex != -1) {
        // Check if a rate has been entered for this DI
        bool hasRate = extraFrtTextController[currentPageIndex].text.isNotEmpty;
        
        if (!hasRate) {
          allDIsHaveRates = false;
          missingRateDIs.add(clubbedDI.diNumber ?? "");
        }
      } else {
        // DI is not in current page, show a different message
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Clubbed DI Not Visible'),
              content: Text(
                // ignore: prefer_adjacent_string_concatenation
                'Some DIs in this club (${clubbedDI.diNumber}) are not visible on the current page. ' +
                'Please make sure all clubbed DIs are visible and have bid rates entered before saving.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          }
        );
      }
    }
    
    if (!allDIsHaveRates) {
      // Show alert that some rates are missing
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Missing Bid Rates'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "All DIs in a club must have bid rates entered before saving.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text("Please enter bid rates for the following DIs:"),
                ...missingRateDIs.map((di) => Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: Text("• $di"),
                )),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
      );
    }
    
    // All rates are entered, proceed with update for all clubbed DIs
    try {
      List<Map<String, dynamic>> payload = [];
      
      // Build payload for all clubbed DIs
      for (var clubbedDI in clubbedDIs) {
        int currentPageIndex = transporterBID2ListResponseList1.value.indexWhere(
          (item) => item.diNumber == clubbedDI.diNumber
        );
        
        if (currentPageIndex != -1) {
          double diEnteredVal = double.parse(extraFrtTextController[currentPageIndex].text);
          
          payload.add({
            "diNumber": clubbedDI.diNumber,
            "bidRate": diEnteredVal,
            "transporterId": sp?.getString("employeeCode"),
            "createdBy": (sp?.getString("email")).toString(),
            "bidLotId": clubbedDI.bidLotId,
            "resultProcessed": true,
            "diClubReferenceNo" : clubbedDI.diClubReferenceNo
          });
        }
      }
      
      String? token = await secureStorage.read("token");
      // Make API call to update all clubbed DIs together
      String url = "$baseUrl/bidding/trans/updateBidDetails";
      var res = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization":"Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: jsonEncode(payload)
      );
      
      final result = jsonDecode(res.body);
      
      if (res.statusCode == 200) {
        // Set success for all clubbed DIs
        for (var clubbedDI in clubbedDIs) {
          int currentPageIndex = transporterBID2ListResponseList1.value.indexWhere(
            (item) => item.diNumber == clubbedDI.diNumber
          );
          
          if (currentPageIndex != -1) {
            savedSuccess[currentPageIndex].value = true;
          }
        }
        
        showResultDialog(result["responseMessage"]);
      } else {
        savedSuccess[index].value = false;
        showResultDialog(result["responseMessage"]);
      }
      
      return result;
    } catch (e) {
      debugPrint("Error during clubbed DI update: $e");
      savedSuccess[index].value = false;
      showResultDialog("An error occurred while updating bid rates.");
    }
  } else {
    // Not a clubbed DI, proceed with normal update
    String url = "$baseUrl/bidding/trans/updateBidDetails";
    String? token = await secureStorage.read("token");

    try {
      var res = await http.post(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: jsonEncode([
          {
            "diNumber": diNumber,
            "bidRate": enteredVal,
            "transporterId": sp?.getString("employeeCode"),
            "createdBy": (sp?.getString("email")).toString(),
            "bidLotId": bidLotId,
            "resultProcessed": true
          }
        ]));
      final result = jsonDecode(res.body);

      if (res.statusCode == 200) {
        showResultDialog(result["responseMessage"]);
        savedSuccess[index].value = true;
      } else {
        savedSuccess[index].value = false;
        showResultDialog(result["responseMessage"]);
      }

      
      return result;
    } catch (e) {
      debugPrint("Error during transporter save API call: $e");
      savedSuccess[index].value = false;
      showResultDialog("An error occurred while updating bid rate.");
    }
          await fetchTransportActionList();

  }
}



  List<TransporterBid2ModelResponseList> responselist = [];
  // int? index1;

  Future<dynamic> saveAllStartBidTransporter({
    List<dynamic>? responselist,
    // dynamic index
  }) async {
    // debugPrint("SAVE ALL STARTED");
    String url = "$baseUrl/bidding/trans/updateBidDetails";

    // num bidRate = extraFrt[index!];
    // for (int i = 0; i < responselist!.length; i++) {
    //   if (extraFrt[i]>0&&extraFrt[i]) {
    //
    //   }
    // }

// Group the DIs by diClubReferenceNo
    Map<String, List<int>> clubGroups = {};
    Map<String, String> clubDIList = {};

    for (int i = 0; i < responselist!.length; i++) {
      if (extraFrtTextController[i].value.text.isNotEmpty) {
        String diNumber = responselist[i].diNumber ?? "";
        String? diClubReferenceNo = responselist[i].diClubReferenceNo;

        if (diClubReferenceNo != null && diClubReferenceNo.isNotEmpty) {
          if (!clubGroups.containsKey(diClubReferenceNo)) {
            clubGroups[diClubReferenceNo] = [];
            clubDIList[diClubReferenceNo] = "";
          }
          clubGroups[diClubReferenceNo]!.add(i);
          clubDIList[diClubReferenceNo] = clubDIList[diClubReferenceNo]! + "$diNumber, ";
        }
      }
    }

    // Check if all clubs are fully represented
    List<String> incompleteClubs = [];

    for (var diClubReferenceNo in clubGroups.keys) {
      // Get all DIs in this club
      List<TransporterBid2ModelResponseList> allDIsInClub =
          clubbedDIGroups[diClubReferenceNo] ?? [];

      // Count how many of these DIs are being updated
      int updatedCount = clubGroups[diClubReferenceNo]!.length;

      // If not all DIs in the club are being updated, add to incomplete list
      if (updatedCount < allDIsInClub.length) {
        List<String> missingDIs = allDIsInClub
            .where((di) => !clubGroups[diClubReferenceNo]!
                .any((index) => responselist[index].diNumber == di.diNumber))
            .map((di) => di.diNumber ?? "")
            .toList();

        incompleteClubs.add(
            "Club with DIs ${clubDIList[diClubReferenceNo]} missing: ${missingDIs.join(', ')}");
      }
    }

    // If there are incomplete clubs, show alert
    if (incompleteClubs.isNotEmpty) {
      bool proceed = await showIncompleteClubsAlert(incompleteClubs);
      if (!proceed) {
        return; // User cancelled
      }
    }

    for (int i = 0; i < responselist!.length; i++) {
      if (extraFrtTextController[i].value.text.isNotEmpty) {
        double frtRate = double.parse((newFrtAmt[i].value).toString());
        double fiftyPercentFrtRate = (frtLowerTol! / 100) * frtRate;
        // debugPrint(frtLowerTol);

        double enteredVal = double.parse(extraFrtTextController[i].value.text);

        if ((responselist[i].lowerLimitAmt ?? 0) <= 0 &&
                enteredVal < fiftyPercentFrtRate ||
            (responselist[i].lowerLimitAmt ?? 0) > 0 &&
                enteredVal < frtRate - (responselist[i].lowerLimitAmt ?? 0)) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Invalid Input'),
                  content: Text(
                    'Please enter a number greater than or equal to ${responselist[i].lowerLimitAmt! <= 0 ? '$frtLowerTol% of freight Amount.' : frtRate - (responselist[i].lowerLimitAmt ?? 0)}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
          return;
        }
      }
    }
    try {
      List<Map<String, dynamic>> payload = [];
      for (int i = 0; i < responselist.length; i++) {
        if (extraFrtTextController[i].value.text.isNotEmpty) {
          double frtRate = double.parse((newFrtAmt[i].value).toString());
          double fiftyPercentFrtRate = (frtLowerTol! / 100) * frtRate;
          // debugPrint(frtLowerTol);

          double enteredVal =
              double.parse(extraFrtTextController[i].value.text);

          if (enteredVal >= fiftyPercentFrtRate) {
            payload.add({
              "diNumber": responselist[i].diNumber,
              "bidRate": enteredVal,
              "transporterId": sp?.getString("employeeCode"),
              "createdBy": (sp?.getString("email")).toString(),
              "bidLotId": responselist[i].bidLotId,
              "resultProcessed": true,
              "diClubReferenceNo" : responselist[i].diClubReferenceNo
            });
          }
        }
      }
      String? token = await secureStorage.read("token");
      var res = await http.post(Uri.parse(url),
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
        // debugPrint("result $result");
        showResultDialog(result["responseMessage"]);
        // savedSuccess[index!].value = true;
      } else {
        // debugPrint("API call failed with status code: ${res.statusCode}");
        // savedSuccess[index!].value = false;
        showResultDialog(result["responseMessage"]);
      }
      await fetchTransportActionList();
    } catch (e) {
      // debugPrint("Error during transporter save all API call: $e");
      // savedSuccess[index!].value = false;
    }
    setState(() {});
  }

  Future<void> showResultDialog1(String message, BuildContext context) async {
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


Future<void> withdrawDi({
  required String diNumber,
  required String bidLotId,
  required BuildContext context,
}) async {
  // Check if this DI is part of a club
  List<TransporterBid2ModelResponseList> clubbedDIs = getClubbledDIsForDI(diNumber);
  
  bool isClubbed = clubbedDIs.isNotEmpty && clubbedDIs.length > 1;
  
  if (isClubbed) {
    // Get the clubRefNo
    String? clubRefNo;
    for (var item in originalTransport2List) {
      if (item.diNumber == diNumber && item.diClubReferenceNo != null && item.diClubReferenceNo!.isNotEmpty) {
        clubRefNo = item.diClubReferenceNo;
        break;
      }
    }
    
    // Get the list of other DIs in the club
    List<String> otherDIs = clubbedDIs
      .where((di) => di.diNumber != diNumber)
      .map((di) => di.diNumber ?? "")
      .toList();
    
    // Show confirmation dialog
    bool shouldProceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Withdraw Clubbed DI'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "This DI is part of a clubbed group. Withdrawing this DI will withdraw all DIs in the club:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current DI: $diNumber",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Other clubbed DIs to be withdrawn:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...otherDIs.map((di) => Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text("• $di"),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Do you want to proceed with withdrawing all these DIs?",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.redbar,
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // Proceed
              },
              child: const Text(
                'Withdraw All',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ) ?? false;
    
    if (!shouldProceed) {
      return; // User cancelled the action
    }
    
    // If we get here, user wants to proceed with withdrawal
    try {
      loaderScreen.value = true;
      String? token = await secureStorage.read("token");
      final uri = Uri.parse("$baseUrl/bidding/withdraw/di");
      var response = await http.post(
        uri,
        body: jsonEncode({
          // "diNo": diNumber,
          "bidLotId": bidLotId,
          "transporterId": sp?.getString("employeeCode"),
          "diClubReferenceNo": clubRefNo // Include the club reference number
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);
      loaderScreen.value = false;
      
      // ignore: use_build_context_synchronously
      showResultDialog1(result["responseMessage"], context);
      await fetchTransportActionList();
      return;
    } catch (err) {
      loaderScreen.value = false;
      // ignore: use_build_context_synchronously
      showResultDialog1("An error occurred during withdrawal", context);
    }
  } else {
    // Not clubbed, proceed with normal withdrawal
    try {
      loaderScreen.value = true;
      String? token = await secureStorage.read("token");
      final uri = Uri.parse("$baseUrl/bidding/withdraw/di");
      var response = await http.post(
        uri,
        body: jsonEncode({
          "diNo": diNumber,
          "bidLotId": bidLotId,
          "transporterId": sp?.getString("employeeCode"),
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);
      loaderScreen.value = false;
      
      // ignore: use_build_context_synchronously
      showResultDialog1(result["responseMessage"], context);
      await fetchTransportActionList();
      return;
    } catch (err) {
      loaderScreen.value = false;
      // ignore: use_build_context_synchronously
      showResultDialog1("An error occurred during withdrawal", context);
    }
  }
  
  loaderScreen.value = false;
  await fetchTransportActionList();
}
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final dynamicSize = ((size.width - 312 + 20) * (100 / 13)) / 100;
    return CustomScaffold(
      appBarText: "Bidding Process > Deliveries For Bidding",
      refreshButton: IconButton(
        iconSize: 30,
        color: ColorConstant.redbar,
        tooltip: "Refresh",
        icon: const Icon(Icons.refresh_sharp),
        onPressed: () async {
          await fetchTransportActionList();
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
                  const Text(
                    'Deliveries For Bidding',
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
                            spacing: 20,
                            runSpacing: 20,
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
                                    function: (value) {
                                      switchState.value = value;
                                      currentPage = 1;
                                      if (!value) {
                                        filterData(searchValue);
                                      } else {
                                        List<TransporterBid2ModelResponseList>
                                            filteredData =
                                            transporterBID2ListResponseList
                                                .value
                                                .where((value2) =>
                                                    value2.bidRate != null &&
                                                    value2.bidRate != 0)
                                                .toList();

                                        transporterBID2ListResponseList1.value =
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
                                  String formattedDateTime;
                                  if (value.isDateTime) {
                                    formattedDateTime = DateFormat(
                                            'MM/dd/yyyy hh:mm:ss a')
                                        .format(
                                            DateTime.parse(value).toLocal());
                                  } else {
                                    formattedDateTime = value;
                                  }
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Bid Start Time",
                                        style: TextStyle(color: Colors.black),
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
                                          formattedDateTime,
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

                          Obx(() => Container(
                                margin: const EdgeInsets.only(
                                    top: 40, bottom: 20, right: 20),
                                child: Column(
                                  children: [
                                    const Text("Remaining Time",
                                        style: TextStyle(fontSize: 15)),
                                    Text(
                                      'Time: ${timerController.minutes}:${timerController.seconds.toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              )),

                          //timer need to show here
                          wSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              button(
                                  btnText: "Search",
                                  tapFunction: () async {
                                    currentPage = 1;
                                    await fetchTransportActionList();
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
                                    fetchTransportActionList();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  vSpace(20),
                  tableHeading(heading: "Deliveries for Bidding"),
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
                                  spacing: 5,
                                  children: [
                                    const Text("Display",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Roboto')),
                                    SizedBox(
                                        width: 65,
                                        height: 22,
                                        child: PreCustomDropdownMenu(
                                          selVal: selectedDropdownValue1,
                                          list: const [
                                            "10",
                                            "20",
                                            "30",
                                            "50",
                                            "100",
                                            "All"
                                          ],
                                          onChanged: (value) async {
                                            // Update the selected value when the dropdown changes
                                            setState(() {
                                              selectedDropdownValue1 = value;

                                              selectedDropdownValue = value ==
                                                      "All"
                                                  ? transporterBID2ListResponseList
                                                      .value.length
                                                      .toString()
                                                  : value;
                                              pageSize = int.parse(
                                                  selectedDropdownValue);
                                              currentPage = 1;
                                            });
                                            filterData(searchValue);
                                          },
                                        )),
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
                                  child: button(
                                      btnText: "Save All",
                                      tapFunction: () async {
                                        loaderScreen.value = true;
                                        await saveAllStartBidTransporter(
                                            responselist:
                                                transporterBID2ListResponseList1
                                                    .value);
                                        loaderScreen.value = false;

                                        // await fetchTransportActionList();
                                      }),
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
                                          searchValue = val;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      )),
                    ],
                  ),
                  ValueListenableBuilder(
                      valueListenable: transporterBID2ListResponseList1,
                      builder: (BuildContext context,
                          List<TransporterBid2ModelResponseList> data,
                          Widget? child) {
                        if (data.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Text("No data found"),
                            ),
                          );
                        } else {
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
                                  "DI Qty",
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
                                  "Frt. Rate",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Customer",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Consignee Address",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "So/Bidding Remarks",
                                  width: dynamicSize,
                                  heading: true,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "Bid Remarks",
                                  width: dynamicSize,
                                  heading: true,
                                ),
                              ),
                              DataColumn(
                                label: TableColumn(
                                  "DI. No.",
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
                                  "Brand",
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
                                  "DI/SO",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                               DataColumn(
                                label: TableColumn(
                                  "Club Ref. No.",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                               DataColumn(
                                label: TableColumn(
                                  "Club Remark.",
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
                                  "Withdraw",
                                  heading: true,
                                  width: dynamicSize,
                                ),
                              ),
                            ],
                            rows: List.generate(
                              data.length,
                              (index) {
                                final hasClubReference = data[index].diClubReferenceNo != null &&
                                    data[index].diClubReferenceNo!.isNotEmpty;
                                // index1=index;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      TableColumn(
                                        "${((currentPage - 1) * int.parse(selectedDropdownValue)) + index + 1}",
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
                                        (data[index].newFrtAmount!).toString(),
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
                                      TableColumnTextField(
                                        index: index +
                                            int.parse(selectedDropdownValue) *
                                                currentPage -
                                            1,
                                        controller:
                                            extraFrtTextController[index],
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          // extraFrt[index] = double.parse(value);
                                          try {
                                            enteredValue = double.parse(value);
                                            double frtRate = double.parse(
                                                (data[index].newFrtAmount!)
                                                    .toString());

                                            double fiftyPercentFrtRate =
                                                frtLowerTol! * frtRate / 100;

                                            if (enteredValue >=
                                                fiftyPercentFrtRate) {
                                              extraFrt[index] = enteredValue;
                                            }
                                            double totalled = frtRate +
                                                (frtRate * frtHigherTol! / 100);
                                            if (enteredValue > totalled) {
                                              extraFrtTextController[index]
                                                  .clear();
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Invalid Input'),
                                                      content: const Text(
                                                        'Bid rate should be less than freight rate.',
                                                      ),
                                                      actions: [
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
                                                  });
                                            }
                                          } catch (e) {
                                            //debugPrint
                                          }
                                        },
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
                                        data[index].soBiddingRemarks ?? "",
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
                                        data[index].bidRemark ?? "",
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
                                        data[index].diNumber.toString(),
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
                                        data[index].brand ?? "",
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
                                        data[index].diType ?? "",
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
                                      ValueListenableBuilder(
                                        valueListenable: savedSuccess[index],
                                        builder: (BuildContext context,
                                            bool value, Widget? child) {
                                          return TableColumnActionIcon(
                                              index: index +
                                                  int.parse(
                                                          selectedDropdownValue) *
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
                                                  if (value ||
                                                      data[index].bidRate !=
                                                              null &&
                                                          data[index].bidRate !=
                                                              0)
                                                    const Icon(
                                                      Icons.thumb_up,
                                                      color: Colors.green,
                                                      size: 21,
                                                    )
                                                  else
                                                    Container()
                                                ],
                                              ),
                                              onPressed: () async {
                                                loaderScreen.value = true;

                                                double frtRate = double.parse(
                                                    (data[index].newFrtAmount!)
                                                        .toString());

                                                double fiftyPercentFrtRate =
                                                    (frtLowerTol! / 100) *
                                                        frtRate;

                                                double enteredVal =
                                                    double.tryParse(
                                                            extraFrtTextController[
                                                                    index]
                                                                .value
                                                                .text) ??
                                                        0;
                                                if ((data[index].lowerLimitAmt ??
                                                                0) <=
                                                            0 &&
                                                        enteredVal >=
                                                            fiftyPercentFrtRate ||
                                                    (data[index].lowerLimitAmt ??
                                                                0) >
                                                            0 &&
                                                        enteredVal >=
                                                            frtRate -
                                                                (data[index]
                                                                        .lowerLimitAmt ??
                                                                    0)) {
                                                  await saveStartBidTransporter(
                                                      index: index,
                                                      diNumber:
                                                          data[index].diNumber??"",
                                                      bidLotId:
                                                          data[index].bidLotId??"",
                                                      enteredVal: enteredVal,diClubReferenceNo: data[index].diClubReferenceNo??"");
                                                      // fetchTransportActionList();
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Invalid Input'),
                                                          content: Text(
                                                            'Please enter a number greater than or equal to ${data[index].lowerLimitAmt! <= 0 ? '$frtLowerTol% of freight Amount.' : frtRate - (data[index].lowerLimitAmt ?? 0)}',
                                                          ),
                                                          actions: [
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
                                                      });
                                                }
                                                loaderScreen.value = false;
                                              });
                                        },
                                      ),
                                    ),
                                    DataCell(ValueListenableBuilder(
                                      valueListenable: savedSuccess[index],
                                      builder: (BuildContext context,
                                          bool value, Widget? child) {
                                        bool isActive = value ||
                                            (data[index].bidRate != null &&
                                                data[index].bidRate != 0);
                                        return TableColumnActionIcon(
                                          icon: isActive
                                              ? const Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.red,
                                                  size: 23,
                                                )
                                              : const Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.grey,
                                                  size: 23,
                                                ),
                                          index: index +
                                              int.parse(selectedDropdownValue) *
                                                  currentPage -
                                              1,
                                          onPressed: isActive
                                              ? () {
                                                  withdrawDi(
                                                      diNumber: data[index]
                                                          .diNumber
                                                          .toString(),
                                                      bidLotId: data[index]
                                                          .bidLotId
                                                          .toString(),
                                                      context: context,
                                                      );
                                                }
                                              : null,
                                        );
                                      },
                                    )),
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
                              valueListenable: transporterBID2ListResponseList1,
                              builder: (BuildContext context,
                                  List<TransporterBid2ModelResponseList> value,
                                  Widget? child) {
                                return Expanded(
                                  flex: 2,
                                  child: Text(
                                      "Showing ${(currentPage - 1) * int.parse(selectedDropdownValue) + 1} to ${value.length * (currentPage)} of ${transporterBID2ListResponseList.value.length} entries",
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
        ],
      ),
    );
  }

  ValueListenableBuilder<List<TransporterBid2ModelResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: transporterBID2ListResponseList,
      builder: (BuildContext context,
          List<TransporterBid2ModelResponseList> value, Widget? child) {
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
            pageWidgets.add(
              InkWell(
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
                  currentPage = i;
                  currentPagination.value = currentPage;
                  filterData(searchValue);
                },
              ),
            );
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

