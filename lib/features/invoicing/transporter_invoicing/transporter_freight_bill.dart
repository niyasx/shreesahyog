// ignore_for_file: avoid_debugPrint
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
import 'package:shreecement/features/common/controller/controller.dart';
import 'package:shreecement/features/common/controller/indian_currency.dart';
import 'package:shreecement/features/common/controller/limitedtextcontroller.dart';
import 'package:shreecement/features/common/table/table_widgets.dart';
import 'package:shreecement/features/common/widgets/custom_popup_menu1.dart';
import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
import 'package:shreecement/features/invoicing/apis/freight_bill_api.dart';
import 'package:shreecement/features/invoicing/apis/shortage_master_apis.dart';
import 'package:shreecement/features/invoicing/logistics_invoicing/shortage_master.dart';
import 'package:shreecement/features/invoicing/models/brand_model.dart';
import 'package:shreecement/features/invoicing/models/deliverytype_model.dart';
import 'package:shreecement/features/invoicing/models/di_qty_model.dart';
import 'package:shreecement/features/invoicing/models/distribution_channel_model.dart';
import 'package:shreecement/features/invoicing/models/freight_bill_model.dart';
import 'package:shreecement/features/invoicing/models/freight_bill_type_model.dart';
import 'package:shreecement/features/invoicing/models/frozen_period_model.dart';
import 'package:shreecement/features/invoicing/models/initiated_freight_bill_updated.dart';
import 'package:shreecement/features/invoicing/models/material_frt_group_model.dart';
import 'package:shreecement/features/invoicing/models/process_freight_bill_model.dart';
import 'package:shreecement/features/invoicing/models/product_model.dart';
import 'package:shreecement/features/preBidding/api/division_list_api.dart';
import 'package:shreecement/features/preBidding/api/division_list_by_plant.dart';
import 'package:shreecement/utils/color_constant.dart';
import 'package:shreecement/features/preBidding/api/states_list_api.dart';
import '../../../main.dart';
import '../../common/controller/double_number.dart';
import '../../common/screens/token_expire.dart';
import '../../common/widgets/custom_dropdown_3.dart';
import '../../common/widgets/customdropdownprebid.dart';
import '../models/diandinitiatedstatus.dart';

class TransporterFreightBill extends StatefulWidget {
  const TransporterFreightBill({super.key});

  @override
  State<TransporterFreightBill> createState() => _TransporterFreightBillState();
}

final Controller controller = Get.find();

class _TransporterFreightBillState extends State<TransporterFreightBill> {
// Access the controller

  List<ValueNotifier<bool>> savedSuccess = [];

  // ValueNotifier enabled = ValueNotifier(false);
  // List<ValueNotifier<bool>> checkBox = [];
  List<ValueNotifier<bool>> uomSwitchList = [];
  ValueNotifier<bool> allChecked = ValueNotifier(false);

  ValueNotifier<MapEntry<String, String>> selectedState =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedProduct =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedDeliveryType =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedFrBillType =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedDistChannel =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedBrand =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedPlant =
      ValueNotifier(const MapEntry("", ""));
  ValueNotifier<MapEntry<String, String>> selectedMaterialFrtGrp =
      ValueNotifier(const MapEntry("", ""));
  RxBool initiateButton = false.obs;
  RxBool processButton = false.obs;

  final DoubleNumericTextEditingController plantGrossWgtController =
      DoubleNumericTextEditingController();
  final DoubleNumericTextEditingController plantTareWeightController =
      DoubleNumericTextEditingController();
  final DoubleNumericTextEditingController plantNetWeightController =
      DoubleNumericTextEditingController();
  final List<DoubleNumericTextEditingController> tollTaxController = [];
  final List<DoubleNumericTextEditingController> kataController = [];
  final List<DoubleNumericTextEditingController> grossWeightController = [];
  final List<DoubleNumericTextEditingController> othersController = [];
  final List<DoubleNumericTextEditingController> tareWeightController = [];
  final List<DoubleNumericTextEditingController> netWeightController = [];
  final List<DoubleNumericTextEditingController> tyreAmtController = [];
  final List<LimitedLengthTextController> remarkController = [];
  final List<DoubleNumericTextEditingController> shortageQtyController = [];

  ValueNotifier<double> netWeight = ValueNotifier(0);
  ValueNotifier<double> bags = ValueNotifier(0);
  ValueNotifier<bool> remarkson = ValueNotifier(false);

  ValueNotifier<List<DoubleNumericTextEditingController>>
      tareWeightControllernotfy = ValueNotifier([]);

  ValueNotifier<String> selectedDivision = ValueNotifier("");
  ValueNotifier<String> selectedFreightBillType2 = ValueNotifier("Primary");

  List<FrieghtBillModelResponseList> originalFreightBillList = [];
  List<DeliveryItem> initiatedFreightBillList = [];
  ValueNotifier<List<FrieghtBillModelResponseList>>
      frieghtBillListResponseList = ValueNotifier([]);
  ValueNotifier<List<FrieghtBillModelResponseList>>
      frieghtBillListResponseList1 = ValueNotifier([]);
  List<ValueNotifier<bool>> checkBox = [];

  RxBool loaderScreen = false.obs;

  Map<String, int> checkBoxMap = {};

  double enteredValue = 0;
  bool saved = false;
  int counterForUpdtedDi = 0;

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

// popup for continue or cancel
  Future<void> showContinueDialog(String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                refreshed.value = true;
                final currentContext = context;
                FreightBillApi()
                    .getInitiatedAndUpdatedDiDetails(ctx: context)
                    .then((response) {
                  initiatedFreightBillList = response.responseList ?? [];
                  frieghtBillListResponseList.value =
                      convertDeliveryItemsToFreightBillModelResponseList(
                          initiatedFreightBillList);
                  originalFreightBillList =
                      convertDeliveryItemsToFreightBillModelResponseList(
                          initiatedFreightBillList);
                  frieghtBillListResponseList1.value = getCurrentPageItems(
                      frieghtBillListResponseList.value, currentPage);
                  counterForUpdtedDi = 0;
                  for (int i = 0; i < initiatedFreightBillList.length; i++) {
                    if (initiatedFreightBillList[i].dataUpdated == true) {
                      counterForUpdtedDi++;
                    }
                    selectedRows.add(initiatedFreightBillList[i].diNo ?? "");
                    uomSwitchList.add(ValueNotifier(false));

                    tollTaxController.add(DoubleNumericTextEditingController(
                        text: initiatedFreightBillList[i].tollTax));
                    kataController.add(DoubleNumericTextEditingController(
                        text: initiatedFreightBillList[i].kata));
                    othersController.add(DoubleNumericTextEditingController(
                        text: initiatedFreightBillList[i].other));
                    remarkController.add(LimitedLengthTextController(
                        text: initiatedFreightBillList[i].remarks));
                    shortageQtyController.add(
                        DoubleNumericTextEditingController(
                            text:
                                (initiatedFreightBillList[i].shortageQty ?? 0) *
                                    1000));
                    grossWeightController.add(
                        DoubleNumericTextEditingController(
                            text: initiatedFreightBillList[i].grossWeight));
                    tareWeightController.add(DoubleNumericTextEditingController(
                        text: initiatedFreightBillList[i].tareWeight));

                    netWeightController.add(DoubleNumericTextEditingController(
                        text: (double.parse(
                                (initiatedFreightBillList[i].grossWeight ?? 0)
                                    .toString()) -
                            double.parse(
                                (initiatedFreightBillList[i].tareWeight ?? 0)
                                    .toString()))));

                    tyreAmtController.add(DoubleNumericTextEditingController(
                        text: initiatedFreightBillList[i].tyreAmount));
                  }
                  if (initiatedFreightBillList.length == counterForUpdtedDi) {
                    processBill.value = true;
                    processButton.value = true;
                  }
                  Navigator.of(currentContext).pop();
                });
              },
              child: const Text('Yes'),
            ),
            const SizedBox(
              width: 5,
            ),
            TextButton(
              onPressed: () {
                FreightBillApi().resetInitiatedApi(ctx: context);
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  bool yesOrNo = false;
  Future<void> showContinueDialogForReset(String message) async {
    yesOrNo = false;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                yesOrNo = true;
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            const SizedBox(
              width: 5,
            ),
            TextButton(
              onPressed: () {
                yesOrNo = false;
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getFrozenPeriodTime();
    checkInitiated();
    // fetchFreightBillList();
  }

  Future<bool> fetchInitiated() async {
    final response =
        await FreightBillApi().getInitiatedAndUpdatedDiDetails(ctx: context);

    var originalInitiatedFreightBillList = response.responseList ?? [];
    return originalInitiatedFreightBillList.isNotEmpty ? true : false;
  }

  int currentPage = 1;
  int pageSize = int.parse(selectedDropdownValue);
  List<FrieghtBillModelResponseList> getCurrentPageItems(
      List<FrieghtBillModelResponseList> items, int currentPage) {
    frieghtBillListResponseList.value = items;
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = startIndex + pageSize > items.length
        ? items.length
        : startIndex + pageSize;
    allChecked.value = false;
    List<FrieghtBillModelResponseList> a = items.sublist(startIndex, endIndex);

    return a;
  }

  searchFrieghtBillData() async {
    try {
      final FreightBillModel response =
          await FreightBillApi().getFreightBillTransporter(ctx: context);

      originalFreightBillList = response.responseList ?? [];

      frieghtBillListResponseList.value = originalFreightBillList;
      frieghtBillListResponseList1.value =
          getCurrentPageItems(originalFreightBillList, currentPage);
    } catch (e) {
      // debugPrint("error in fetch data $e");
    }
  }

  void filterData(String searchTerm) {
    if (searchTerm.isEmpty) {
      frieghtBillListResponseList1.value =
          getCurrentPageItems(originalFreightBillList, currentPage);
      return;
    }

    List<FrieghtBillModelResponseList> filteredData = originalFreightBillList
        .where((value) =>
            value.diNo
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.grNo
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.invoiceDate
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.invoiceNo
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.plantId
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.shipTo
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.shipToCityId
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.shipToCityName
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.unloadingFrt
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.unloadBy
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            value.truckNo
                .toString()
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();

    frieghtBillListResponseList1.value =
        getCurrentPageItems(filteredData, currentPage);
  }

  List<FrieghtBillModelResponseList> responselist = [];

  String? selectedOption = 'cement';

  Set<String> selectedRows = {};
  RxBool refreshed = false.obs;
  TextEditingController dateController = TextEditingController();
  ValueNotifier<bool> processBill = ValueNotifier(false);
  final ScrollController _scrollController = ScrollController();

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

// Function to calculate and update net weight
  void updateNetWeight(int index) {
    double grossWeight = double.tryParse(grossWeightController[
                index + int.parse(selectedDropdownValue) * (currentPage - 1)]
            .text) ??
        0.0;
    double tareWeight = double.tryParse(tareWeightController[
                index + int.parse(selectedDropdownValue) * (currentPage - 1)]
            .text) ??
        0.0;

    double netWeightValue = grossWeight - tareWeight;
    if (grossWeight == 0.0 && tareWeight != 0.0) {
      netWeightValue = tareWeight;
    } else if (grossWeight != 0.0 && tareWeight == 0.0) {
      netWeightValue = grossWeight;
    }

    // Keep only two digits after the decimal point
    String formattedNetWeight = netWeightValue.toStringAsFixed(2);
    netWeight.value = double.parse(formattedNetWeight);
  }

  void updateShortageQty(int index) {
    double shortageQty = double.tryParse(shortageQtyController[
                index + int.parse(selectedDropdownValue) * (currentPage - 1)]
            .text) ??
        0.0;

    double netWeightValue = shortageQty / 50;

    // Keep only two digits after the decimal point
    String formattedNetWeight = netWeightValue.toStringAsFixed(2);
    bags.value = double.parse(formattedNetWeight);
  }

  String? frozenPeriodDate = "";
  String? lastDateFromApi = "";

  Future<void> getFrozenPeriodTime() async {
    debugPrint("fetching dates");
    try {
      final FrozenPeriodModel response =
          await FreightBillApi().getFrozenPeriodTime();

      String? frozenPeriodString = response.serviceDTO?.frozenPeriod;
      String? lastDateString = response.serviceDTO?.fyLastDate;

      debugPrint(
          "response.serviceDTO?.fyLastDate ${response.serviceDTO?.fyLastDate}");

      // Handle FY last date
      if (lastDateString != null && lastDateString.isNotEmpty) {
        try {
          // Parse the ISO format date string (e.g., "2025-03-31T23:59:59")
          DateTime parsedLastDate = DateTime.parse(lastDateString);

          // Format the date to dd/MM/yyyy
          lastDateFromApi = DateFormat('dd/MM/yyyy').format(parsedLastDate);

          debugPrint("Formatted FY last date: $lastDateFromApi");
        } catch (e) {
          debugPrint("Error parsing FY last date: $e");
          lastDateFromApi = "";
        }
      } else {
        debugPrint("FY last date is null or empty");
        lastDateFromApi = "";
      }

      // Handle frozen period date
      if (frozenPeriodString != null && frozenPeriodString.isNotEmpty) {
        try {
          // Parse the ISO format date string (e.g., "2025-04-10 23:59:59")
          DateTime parsedFrozenDate = DateTime.parse(frozenPeriodString);

          // Format the date to dd/MM/yyyy
          frozenPeriodDate = DateFormat('dd/MM/yyyy').format(parsedFrozenDate);

          debugPrint("Formatted frozen period date: $frozenPeriodDate");
        } catch (e) {
          debugPrint("Error parsing frozen period date: $e");
          frozenPeriodDate = "";
        }
      } else {
        debugPrint("Frozen period date is null or empty");
        frozenPeriodDate = "";
      }

      // After fetching the dates, initialize the date controls
      initializeDates(financialYearEndDate: lastDateFromApi);
    } catch (e) {
      debugPrint("Error getting frozen time: $e");
      // Set empty values to avoid null issues
      frozenPeriodDate = "";
      lastDateFromApi = "";
    }
  }

  ///--------------------------------------------

// // Date initialization with frozen period check
// void initializeDates() {
//   debugPrint("initializing");
//   DateTime currentDate = DateTime.now();

//   // From Date initialization
//   if (sp?.getString("fromDate1") != null) {
//     fromDateController.text = sp!.getString("fromDate1")!;
//   } else {
//     // Check if frozen period exists and is applicable
//     if (frozenPeriodDate != null && frozenPeriodDate!.isNotEmpty) {
//       try {
//         DateTime frozenDate = DateFormat('dd/MM/yyyy').parse(frozenPeriodDate!);

//         // Convert to date-only format to compare just the dates without time
//         DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
//         DateTime frozenDateOnly = DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

//         debugPrint("Date comparison: currentDateOnly $currentDateOnly, frozenDateOnly $frozenDateOnly");
//         debugPrint("Same date check: ${currentDateOnly.isAtSameMomentAs(frozenDateOnly)}");
//         debugPrint("Before date check: ${currentDateOnly.isBefore(frozenDateOnly)}");

//         // Compare dates without time component
//         if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
//             currentDateOnly.isBefore(frozenDateOnly)) {
//           // If under frozen period and we're in Apr+, set from date to March 1st of current year
//           if (currentDate.month >= 4) {
//             fromDateController.text =
//                 DateFormat('dd/MM/yyyy').format(DateTime(currentDate.year, 3, 1));
//             debugPrint("march 01");
//           } else {
//             // If we're in Jan-Mar, just use first day of current month
//             fromDateController.text = DateFormat('dd/MM/yyyy')
//                 .format(DateTime(currentDate.year, currentDate.month, 1));
//             debugPrint("first day of current month (frozen period)");
//           }
//         } else {
//           // Normal case - first day of current month
//           fromDateController.text = DateFormat('dd/MM/yyyy')
//               .format(DateTime(currentDate.year, currentDate.month, 1));
//           debugPrint("normal first day of month");
//         }
//       } catch (e) {
//         debugPrint("Error parsing frozen date during initialization: $e");
//         // Fallback to normal case
//         fromDateController.text = DateFormat('dd/MM/yyyy')
//             .format(DateTime(currentDate.year, currentDate.month, 1));
//       }
//     } else {
//       // Normal case - first day of current month
//       fromDateController.text = DateFormat('dd/MM/yyyy')
//           .format(DateTime(currentDate.year, currentDate.month, 1));
//     }
//   }

//   // To Date initialization
//   if (sp?.getString("toDate1") != null) {
//     toDateController.text = sp!.getString("toDate1")!;
//   } else {
//     // Check if frozen period exists and is applicable
//     if (frozenPeriodDate != null && frozenPeriodDate!.isNotEmpty) {
//       try {
//         DateTime frozenDate = DateFormat('dd/MM/yyyy').parse(frozenPeriodDate!);

//         // Convert to date-only format to compare just the dates without time
//         DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
//         DateTime frozenDateOnly = DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

//         // Compare dates without time component
//         if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
//             currentDateOnly.isBefore(frozenDateOnly)) {
//           // For March 31st of current financial year:
//           DateTime marchEnd = DateTime(currentDate.year, 3, 31);

//           // No matter what, never set a date in the future
//           if (marchEnd.isAfter(currentDate)) {
//             // If March 31st is still in the future (we're in Jan-Mar),
//             // just use the current date
//             toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
//             debugPrint("Setting to current date: $currentDate (March 31st is in future)");
//           } else if (currentDate.month >= 4) {
//             // We're in Apr+ with frozen period, use March 31st of current year
//             toDateController.text = DateFormat('dd/MM/yyyy').format(marchEnd);
//             debugPrint("Setting to March 31st: $marchEnd (we're in Apr+)");
//           } else {
//             // We're in Jan-Mar, use current date
//             toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
//             debugPrint("Setting to current date: $currentDate (we're in Jan-Mar)");
//           }
//         } else {
//           // Normal case - current date
//           toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
//           debugPrint("Normal case: current date");
//         }
//       } catch (e) {
//         debugPrint("Error parsing frozen date during initialization: $e");
//         // Fallback to normal case
//         toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
//       }
//     } else {
//       // Normal case - current date
//       toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
//     }
//   }
// }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // fromDateController.text =

    ///for setting the from date as april 1,
    //   DateFormat('dd/MM/yyyy').format(
    //  DateTime.now().isBefore(DateTime(DateTime.now().year, 4, 1)) ? DateTime.now() : DateTime(DateTime.now().year, 4, 1));

    ///for setting from date as first of current month

    // DateFormat('dd/MM/yyyy')
    //     .format(DateTime(2025, 6, 1));

    ///for setting the date past to 90 days

    // DateFormat('dd/MM/yyyy')
    //     .format(DateTime.now().subtract(const Duration(days: 90)));
    // toDateController.text = DateFormat('dd/MM/yyyy').format(DateTime(2025, 4, 8));

//     DateTime now = DateTime.now();
// DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
// DateTime lastDayOfPreviousMonth = firstDayOfCurrentMonth.subtract(const Duration(days: 1));
// DateTime firstDayOfPreviousMonth = DateTime(lastDayOfPreviousMonth.year, lastDayOfPreviousMonth.month, 1);

// if (now.day <= 5) {
//   // Current date is less than or equal to 5th of the month
//   fromDateController.text = DateFormat('dd/MM/yyyy').format(firstDayOfPreviousMonth);
//   toDateController.text = DateFormat('dd/MM/yyyy').format(lastDayOfPreviousMonth);
// } else {
//   // Current date is greater than 5th of the month
//   fromDateController.text = DateFormat('dd/MM/yyyy').format(firstDayOfCurrentMonth);
//   toDateController.text = DateFormat('dd/MM/yyyy').format(now);
// }

    sp?.getString("selectedDistChannel") == null
        ? sp?.setString("selectedDistChannel", "isEmpty")
        : "";
    sp?.getString("selectedDistChannelValue") == null
        ? sp?.setString("selectedDistChannelValue", "isEmpty")
        : "";
    sp?.getString("selectedProduct") == null
        ? sp?.setString("selectedProduct", "isEmpty")
        : "";
    sp?.getString("selectedDeliveryType") == null
        ? sp?.setString("selectedDeliveryType", "isEmpty")
        : "";
    sp?.getString("selectedMaterialFrtGrp") == null
        ? sp?.setString("selectedMaterialFrtGrp", "isEmpty")
        : "";
    sp?.getString("selectedBrand") == null
        ? sp?.setString("selectedBrand", "isEmpty")
        : "";
    sp?.getString("selectedState") == null
        ? sp?.setString("selectedState", "isEmpty")
        : "";
    sp?.getString("selectedPlant") == null
        ? sp?.setString("selectedPlant", "isEmpty")
        : "";
    sp?.getString("selectedDivision") == null
        ? sp?.setString("selectedDivision", "isEmpty")
        : "";

    // initializeDates();
    // sp?.getString("fromDate1") != null
    //     ? fromDateController.text = sp!.getString("fromDate1")!
    //     : (now.day <=5 ?  DateFormat('dd/MM/yyyy').format(firstDayOfPreviousMonth):DateFormat('dd/MM/yyyy').format(firstDayOfCurrentMonth));
    // sp?.getString("toDate1") != null
    //     ? toDateController.text = sp!.getString("toDate1")!
    //     : ( toDateController.text = (now.day <=5 ? DateFormat('dd/MM/yyyy').format(lastDayOfPreviousMonth):
    //         DateFormat('dd/MM/yyyy').format(now)));

    // sp?.getString("fromDate1") != null
    //     ? fromDateController.text = sp!.getString("fromDate1")!
    //     : fromDateController.text = // /for seting current month
    //         DateFormat('dd/MM/yyyy')
    //             .format(DateTime(2025, 6, 1));

    ///for april 1st
    //       DateFormat('dd/MM/yyyy').format(
    //  DateTime.now().isBefore(DateTime(DateTime.now().year, 4, 1)) ? DateTime.now() : DateTime(DateTime.now().year, 4, 1));

    ///for setting 90days past date
    //  DateFormat('dd/MM/yyyy')
    //     .format(DateTime.now().subtract(const Duration(days: 90)));
    // sp?.getString("toDate1") != null
    //     ? toDateController.text = sp!.getString("toDate1")!
    //     : toDateController.text =
    //         DateFormat('dd/MM/yyyy').format(DateTime(2025, 4, 8));

    return CustomScaffold(
      appBarText: "Freight Bill> Generate Bill",
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
                    'Generate Bill ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                  ),
                  vSpace(20),
                  Obx(() => Visibility(
                        visible: !refreshed.value,
                        child: tableHeading(
                          heading: "Search DI's",
                        ),
                      )),
                  Obx(() => Visibility(
                        visible: !refreshed.value,
                        child: Container(
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
                                        future: refreshed.value
                                            ? null
                                            : ShortageMasterApis()
                                                .getPlantList(),
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
                                                    "selectedPlant") ==
                                                "isEmpty") {
                                              map["Select Plant"] =
                                                  "Select Plant";
                                              for (var element
                                                  in responseList) {
                                                map[element.plantName] =
                                                    element.plantCode;
                                              }
                                              selectedPlant.value =
                                                  map.entries.first;
                                            } else {
                                              map[sp?.getString(
                                                      "selectedPlant") ??
                                                  ""] = sp?.getString(
                                                      "selectedPlant") ??
                                                  "";

                                              for (var element
                                                  in responseList) {
                                                map[element.plantName] =
                                                    element.plantCode;
                                              }
                                              selectedPlant.value =
                                                  map.entries.first;
                                            }
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
                                                      selVal: selectedPlant
                                                          .value.key,
                                                      list: map.keys.toList(),
                                                      fun: (value) async {
                                                        // if (value ==
                                                        //     "Select Plant") {
                                                        //   enabled.value = false;
                                                        // } else
                                                        if (selectedPlant
                                                                .value.key
                                                                .compareTo(
                                                                    value ??
                                                                        "") ==
                                                            0) {
                                                          return;
                                                        } else {
                                                          bool checkVal =
                                                              await fetchInitiated();
                                                          if (checkVal) {
                                                            await showContinueDialogForReset(
                                                                "Would you like to proceed with a new Freight Bill? Please note that any previous initiations will be cleared.");

                                                            if (yesOrNo) {
                                                              FreightBillApi()
                                                                  .resetInitiatedApi(
                                                                      ctx:
                                                                          context);
                                                              // enabled.value =
                                                              //     true;

                                                              selectedPlant
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

                                                            selectedPlant
                                                                    .value =
                                                                MapEntry(
                                                              value ?? "",
                                                              map[value] ?? "",
                                                            );
                                                          }
                                                        }
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
                                                        if (selectedDeliveryType
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
                                                        }
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
                                    FutureBuilder<FrieghtBillTypeModel>(
                                        future: refreshed.value
                                            ? null
                                            : ShortageMasterApis()
                                                .getFreightBillTypesFromApi(),
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
                                            map["Select Freight Bill Type"] =
                                                "Select Freight Bill Type";

                                            for (var element in responseList) {
                                              map[element.freightBillType] =
                                                  element.freightBillId
                                                      .toString();
                                            }
                                            selectedFrBillType.value =
                                                map.entries.first;
                                            return ValueListenableBuilder(
                                              valueListenable:
                                                  selectedFrBillType,
                                              builder: (BuildContext context,
                                                  data, Widget? child) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Frieght Bill Type",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    CustomDropdownMenu3(
                                                        selVal:
                                                            selectedFreightBillType2
                                                                .value,
                                                        list: map.keys.toList(),
                                                        fun: null
                                                        //  (value) {
                                                        //   if (value ==
                                                        //       "Select Freight Bill Type") {
                                                        //     enabled.value = false;
                                                        //   } else {
                                                        //     enabled.value = true;
                                                        //   }
                                                        //   selectedFrBillType.value =
                                                        //       MapEntry(
                                                        //     value ?? "",
                                                        //     map[value] ?? "",
                                                        //   );
                                                        // },
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
                                    // old code
                                    /*FutureBuilder(
                                      future: refreshed.value
                                          ? null
                                          : DivisionListApi()
                                              .getDivisionListFromAPI(),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator(
                                            color: ColorConstant.redbar,
                                          );
                                        } else if (snapshot.hasData) {
                                          int i;
                                          List<String> division = [];
                                          if (sp?.getString(
                                                  "selectedDivision") ==
                                              "isEmpty") {
                                            for (i = 0;
                                                i <
                                                    snapshot.data!.divisionlist!
                                                        .length;
                                                i++) {
                                              division.add(snapshot
                                                  .data!.divisionlist![i]
                                                  .toString());
                                            }
                                            selectedDivision.value =
                                                division.first;
                                          } else {
                                            for (i = 0;
                                                i <
                                                    snapshot.data!.divisionlist!
                                                        .length;
                                                i++) {
                                              division.add(snapshot
                                                  .data!.divisionlist![i]
                                                  .toString());
                                              selectedDivision.value = sp!
                                                  .getString(
                                                      "selectedDivision")!;
                                            }
                                          }

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Division",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              ValueListenableBuilder(
                                                valueListenable:
                                                    selectedDivision,
                                                builder: (BuildContext context,
                                                    String data,
                                                    Widget? child) {
                                                  return CustomDropdownMenu2(
                                                    selVal: data,
                                                    list: division,
                                                    fun: (value) async {
                                                      if (selectedDivision
                                                              .value ==
                                                          value) {
                                                        return;
                                                      }
                                                      bool checkVal =
                                                          await fetchInitiated();
                                                      if (checkVal) {
                                                        await showContinueDialogForReset(
                                                            "Would you like to proceed with a new Freight Bill? Please note that any previous initiations will be cleared.");
                                                        if (yesOrNo) {
                                                          FreightBillApi()
                                                              .resetInitiatedApi(
                                                                  ctx: context);

                                                          selectedDivision
                                                                  .value =
                                                              value ?? "";
                                                        }
                                                      } else {
                                                        selectedDivision.value =
                                                            value ?? "";
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
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
                                      },
                                    ),*/

                                    ///##################################################################################33

                                    ValueListenableBuilder(
                                      valueListenable: selectedPlant,
                                      builder: (BuildContext context, MapEntry<String, String> plantData, Widget? child) {
                                        final String plantId = plantData.value;

                                        debugPrint("This is plant id $plantId");

                                        return FutureBuilder<DivisionListResponseModel>(
                                          future: DivisionListApi().getDivisionListFromAPIForGenerateBill(plantId: plantId.isNotEmpty?plantId:null),
                                          builder: (BuildContext context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Division", style: TextStyle(color: Colors.black)),
                                                  const SizedBox(height: 8),
                                                  CircularProgressIndicator(color: ColorConstant.redbar),
                                                ],
                                              );
                                            }

                                            if (snapshot.hasData) {
                                              List<String> divisions = ["Select Division"];
                                              final divisionData = snapshot.data?.responseList;
                                              if (divisionData != null && divisionData.isNotEmpty) {
                                                divisions.addAll(divisionData.first.divisionList ?? []);
                                              }

                                              // Set default division (CEMENT if found)
                                              String? defaultDivision;
                                              final cementMatch = divisions.firstWhere(
                                                    (d) => d.toLowerCase() == "cement",
                                                orElse: () => "",
                                              );

                                              defaultDivision = cementMatch.isNotEmpty
                                                  ? cementMatch
                                                  : divisions.firstWhere(
                                                    (d) => d != "Select Division",
                                                orElse: () => "Select Division",
                                              );

                                              if (defaultDivision == "Select Division") {
                                                sp?.setString("selectedDivision", defaultDivision);
                                              }

                                              selectedDivision.value = defaultDivision;

                                              // final stored = sp?.getString("selectedDivision") ?? "isEmpty";
                                              final stored = sp?.getString("selectedDivision");
                                              // final stored = sp?.getString("selectedDivision");

                                              if (stored != null && divisions.contains(stored) &&
                                                  plantId == sp?.getString("selectedPlantValue")) {
                                                selectedDivision.value = stored;
                                              } else if (selectedDivision.value.isEmpty || !divisions.contains(selectedDivision.value)) {
                                                selectedDivision.value = "Select Division";
                                              }
                                              // if (stored == "isEmpty" || !divisions.contains(stored)) {
                                              //   selectedDivision.value = divisions.first;
                                              // } else {
                                              //   selectedDivision.value = stored;
                                              // }
                                              print("print valut of $stored");

                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Division", style: TextStyle(color: Colors.black)),
                                                  ValueListenableBuilder(
                                                    valueListenable: selectedDivision,
                                                    builder: (BuildContext context, String data, Widget? child) {
                                                      return CustomDropdownMenu3(
                                                        selVal: data,
                                                        list: divisions,
                                                        fun: (value) async {
                                                          if (selectedDivision.value == value) return;

                                                          bool checkVal = await fetchInitiated();
                                                          if (checkVal) {
                                                            await showContinueDialogForReset(
                                                                "Would you like to proceed with a new Freight Bill? Please note that any previous initiations will be cleared.");
                                                            if (yesOrNo) {
                                                              FreightBillApi().resetInitiatedApi(ctx: context);
                                                              selectedDivision.value = value ?? "";
                                                              sp?.setString("selectedDivision", value ?? "");
                                                            }
                                                          } else {
                                                            selectedDivision.value = value ?? "";
                                                            sp?.setString("selectedDivision", value ?? "");
                                                          }
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            } else {
                                              Future.delayed(Duration.zero, () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const TokenExpire()),
                                                );
                                              });
                                              return const Text("Token Error: Recheck token in API");
                                            }
                                          },
                                        );
                                      },
                                    ),

                                    ///#############################################################################################
                                    FutureBuilder(
                                        future: refreshed.value
                                            ? null
                                            : StatesListAPI()
                                                .getStatesListFromAPI(),
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
                                                    "selectedState") ==
                                                "isEmpty") {
                                              map["All"] = "All";

                                              for (var element
                                                  in responseList) {
                                                map[element.stateName] =
                                                    element.stateCode;
                                              }
                                              selectedState.value =
                                                  map.entries.first;
                                            } else {
                                              map[sp?.getString(
                                                      "selectedState") ??
                                                  ""] = sp?.getString(
                                                      "selectedState") ??
                                                  "";

                                              for (var element
                                                  in responseList) {
                                                map[element.stateName] =
                                                    element.stateCode;
                                              }
                                              selectedState.value =
                                                  map.entries.first;
                                            }
                                            return ValueListenableBuilder(
                                              valueListenable: selectedState,
                                              builder: (BuildContext context,
                                                  data, Widget? child) {
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
                                                      selVal: selectedState
                                                          .value.key,
                                                      list: map.keys.toList(),
                                                      fun: (value) {
                                                        // if (value == "All") {
                                                        //   enabled.value = false;
                                                        // } else {
                                                        //   enabled.value = true;
                                                        // }
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
                                      valueListenable: selectedDeliveryType,
                                      builder: (BuildContext context,
                                          MapEntry<String, String> value,
                                          Widget? child) {
                                        return FutureBuilder<
                                                DistributionChannelModel>(
                                            future: refreshed.value
                                                ? null
                                                : ShortageMasterApis()
                                                    .getDistributionChannelTypeListFromAPI(
                                                        diType:
                                                            selectedDeliveryType
                                                                .value.key),
                                            builder: (stateIndex, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(
                                                  color: ColorConstant.redbar,
                                                );
                                              } else if (snapshot.hasData) {
                                                final List responseList =
                                                    snapshot.data
                                                            ?.responseList ??
                                                        [];
                                                Map<String, String> map = {};
                                                if (sp?.getString(
                                                        "selectedDistChannel") ==
                                                    "isEmpty") {
                                                  map["All"] = "All";

                                                  for (var element
                                                      in responseList) {
                                                    map[element
                                                            .distributionChannelName] =
                                                        element
                                                            .distributionChannelCode
                                                            .toString();
                                                  }
                                                  selectedDistChannel.value =
                                                      map.entries.first;
                                                } else {
                                                  map[sp?.getString(
                                                          "selectedDistChannel") ??
                                                      ""] = sp?.getString(
                                                          "selectedDistChannelValue") ??
                                                      "";
                                                  for (var element
                                                      in responseList) {
                                                    map[element
                                                            .distributionChannelName] =
                                                        element
                                                            .distributionChannelCode
                                                            .toString();
                                                  }
                                                  selectedDistChannel.value =
                                                      map.entries.first;
                                                }

                                                return ValueListenableBuilder(
                                                  valueListenable:
                                                      selectedDistChannel,
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
                                                          "Distribution Channel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        CustomDropdownMenu3(
                                                          selVal:
                                                              selectedDistChannel
                                                                  .value.key,
                                                          list:
                                                              map.keys.toList(),
                                                          fun: (value) async {
                                                            // if (value ==
                                                            //     "Select Distribution Channel") {
                                                            //   enabled.value = false;
                                                            // } else
                                                            if (selectedDistChannel
                                                                    .value
                                                                    .key ==
                                                                value) {
                                                              return;
                                                            } else {
                                                              bool checkVal =
                                                                  await fetchInitiated();
                                                              if (checkVal) {
                                                                await showContinueDialogForReset(
                                                                    "Would you like to proceed with a new Freight Bill? Please note that any previous initiations will be cleared.");

                                                                if (yesOrNo) {
                                                                  FreightBillApi()
                                                                      .resetInitiatedApi(
                                                                          ctx:
                                                                              context);
                                                                  // enabled.value =
                                                                  //     true;

                                                                  selectedDistChannel
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

                                                                selectedDistChannel
                                                                        .value =
                                                                    MapEntry(
                                                                  value ?? "",
                                                                  map[value] ??
                                                                      "",
                                                                );
                                                              }
                                                            }
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
                                                    "Token Error: Recheck token in API");
                                              }
                                            });
                                      },
                                    ),
                                    FutureBuilder<ProductModel>(
                                        future: refreshed.value
                                            ? null
                                            : ShortageMasterApis()
                                                .getProductListFromAPI(),
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
                                                    "selectedProduct") ==
                                                "isEmpty") {
                                              map["All"] = "All";

                                              for (var element
                                                  in responseList) {
                                                map[element.productName] =
                                                    element.productMasterId
                                                        .toString();
                                              }
                                              selectedProduct.value =
                                                  map.entries.first;
                                            } else {
                                              map[sp?.getString(
                                                      "selectedProduct") ??
                                                  ""] = sp?.getString(
                                                      "selectedProduct") ??
                                                  "";
                                              for (var element
                                                  in responseList) {
                                                map[element.productName] =
                                                    element.productMasterId
                                                        .toString();
                                              }
                                              selectedProduct.value =
                                                  map.entries.first;
                                            }
                                            selectedProduct.value =
                                                map.entries.first;
                                            return ValueListenableBuilder(
                                              valueListenable: selectedProduct,
                                              builder: (BuildContext context,
                                                  data, Widget? child) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Product",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    CustomDropdownMenu3(
                                                      selVal: selectedProduct
                                                          .value.key,
                                                      list: map.keys.toList(),
                                                      fun: (value) {
                                                        // if (value == "All") {
                                                        //   enabled.value = false;
                                                        // } else {
                                                        //   enabled.value = true;
                                                        // }
                                                        selectedProduct.value =
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
                                                "Token Error: Recheck token in API");
                                          }
                                        }),
                                    FutureBuilder<BrandModel>(
                                        future: refreshed.value
                                            ? null
                                            : ShortageMasterApis()
                                                .getBrandListFromAPI(),
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
                                                    "selectedBrand") ==
                                                "isEmpty") {
                                              map["All"] = "All";

                                              for (var element
                                                  in responseList) {
                                                map[element.brandName] = element
                                                    .brandMasterId
                                                    .toString();
                                              }
                                              selectedBrand.value =
                                                  map.entries.first;
                                            } else {
                                              map[sp?.getString(
                                                      "selectedBrand") ??
                                                  ""] = sp?.getString(
                                                      "selectedBrand") ??
                                                  "";
                                              for (var element
                                                  in responseList) {
                                                map[element.brandName] = element
                                                    .brandMasterId
                                                    .toString();
                                              }
                                              selectedBrand.value =
                                                  map.entries.first;
                                            }
                                            return ValueListenableBuilder(
                                              valueListenable: selectedBrand,
                                              builder: (BuildContext context,
                                                  data, Widget? child) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Brand",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    CustomDropdownMenu3(
                                                      selVal: selectedBrand
                                                          .value.key,
                                                      list: map.keys.toList(),
                                                      fun: (value) {
                                                        // if (value == "All") {
                                                        //   enabled.value = false;
                                                        // } else {
                                                        //   enabled.value = true;
                                                        // }
                                                        selectedBrand.value =
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
                                                "Token Error: Recheck token in API");
                                          }
                                        }),
                                    ValueListenableBuilder(
                                      valueListenable: selectedDivision,
                                      builder: (BuildContext context,
                                          String value, Widget? child) {
                                        return FutureBuilder<
                                                MaterialFrtGroupModel>(
                                            future: refreshed.value
                                                ? null
                                                : ShortageMasterApis()
                                                    .getMaterialFrtGroup(
                                                        division:
                                                            selectedDivision
                                                                .value),
                                            builder: (stateIndex, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(
                                                  color: ColorConstant.redbar,
                                                );
                                              } else if (snapshot.hasData) {
                                                final List responseList =
                                                    snapshot.data
                                                            ?.responseList ??
                                                        [];
                                                Map<String, String> map = {};
                                                if (sp?.getString(
                                                        "selectedMaterialFrtGrp") ==
                                                    "isEmpty") {
                                                  map["All"] = "All";

                                                  for (var element
                                                      in responseList) {
                                                    map[element.frtGroupName] =
                                                        element.frtGroupCode
                                                            .toString();
                                                  }
                                                  selectedMaterialFrtGrp.value =
                                                      map.entries.first;
                                                } else {
                                                  map[sp?.getString(
                                                          "selectedMaterialFrtGrp") ??
                                                      ""] = sp?.getString(
                                                          "selectedMaterialFrtGrp") ??
                                                      "";
                                                  for (var element
                                                      in responseList) {
                                                    map[element.frtGroupName] =
                                                        element.frtGroupCode
                                                            .toString();
                                                  }
                                                  selectedMaterialFrtGrp.value =
                                                      map.entries.first;
                                                }

                                                return ValueListenableBuilder(
                                                  valueListenable:
                                                      selectedMaterialFrtGrp,
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
                                                          "Material Frt Group",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        CustomDropdownMenu3(
                                                          selVal:
                                                              selectedMaterialFrtGrp
                                                                  .value.key,
                                                          list:
                                                              map.keys.toList(),
                                                          fun: (value) async {
                                                            if (selectedMaterialFrtGrp
                                                                    .value
                                                                    .key ==
                                                                value) {
                                                              return;
                                                            } else {
                                                              bool checkVal =
                                                                  await fetchInitiated();
                                                              if (checkVal) {
                                                                await showContinueDialogForReset(
                                                                    "Would you like to proceed with a new Freight Bill? Please note that any previous initiations will be cleared.");

                                                                if (yesOrNo) {
                                                                  FreightBillApi()
                                                                      .resetInitiatedApi(
                                                                          ctx:
                                                                              context);
                                                                  // enabled.value =
                                                                  //     true;

                                                                  selectedMaterialFrtGrp
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

                                                                selectedMaterialFrtGrp
                                                                        .value =
                                                                    MapEntry(
                                                                  value ?? "",
                                                                  map[value] ??
                                                                      "",
                                                                );
                                                              }
                                                            }
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
                                                    "Token Error: Recheck token in API");
                                              }
                                            });
                                      },
                                    ),
                                    datePicker(
                                      label: "From Date",
                                      controller: fromDateController,
                                      ontap: () => selectFromDate(context,
                                          fromDateController, toDateController,
                                          frozenPeriodDate: frozenPeriodDate,
                                          financialYearEndDate:
                                              lastDateFromApi),
                                    ),
                                    datePicker(
                                      label: "To Date",
                                      controller: toDateController,
                                      ontap: () => selectToDate(
                                          context,
                                          toDateController,
                                          frozenPeriodDate: frozenPeriodDate,
                                          fromDateController,
                                          financialYearEndDate:
                                              lastDateFromApi),
                                    ),
                                  ],
                                ),
                                vSpace(16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    button(
                                        btnText: "Search",
                                        tapFunction: () async {
                                          if (fromDateController.text.isEmpty ||
                                              fromDateController.text == "" ||
                                              toDateController.text.isEmpty ||
                                              toDateController.text == "" ||
                                              selectedDeliveryType
                                                      .value.value ==
                                                  "Select Delivery Type" ||
                                              // selectedMaterialFrtGrp
                                              //     .value.value ==
                                              // "All" ||
                                              // selectedDistChannel.value.value ==
                                              //     "Select Distribution Channel" ||
                                              // selectedFrBillType.value.value ==
                                              //     "Select Freight Bill Type" ||
                                              selectedPlant.value.value ==
                                                  "Select Plant") {
                                            showResultDialog(
                                                "Please! Select all required fields.");
                                            return; // Exit function
                                          } else if(selectedDivision.value == "Select Division"){
                                            showResultDialog(
                                                "Please! Select Division field.");
                                            return;
                                          }

                                          try {
                                            loaderScreen.value = true;
                                            selectedRows.clear();
                                            final toDate = DateTime.parse(
                                                parseDate(
                                                    toDateController.text));
                                            // Parse from date
                                            final fromDate = DateTime.parse(
                                                parseDate(
                                                    fromDateController.text));

                                            final FreightBillModel response = await FreightBillApi()
                                                .searchFrieghBill(
                                                    materialFrtGrp:
                                                        selectedMaterialFrtGrp
                                                            .value.value,
                                                    ctx: context,
                                                    deliveryType:
                                                        selectedDeliveryType
                                                            .value
                                                            .key, //hardcoded value
                                                    freightBillType:
                                                        selectedFreightBillType2
                                                            .value, //hardcoded value
                                                    // selectedFrBillType.value.value, //actual value
                                                    distributionChannel:
                                                        selectedDistChannel
                                                            .value.value,
                                                    division:
                                                        selectedDivision.value,
                                                    product: selectedProduct
                                                        .value.value,
                                                    brand: selectedBrand
                                                        .value.value,
                                                    stateId: selectedState
                                                        .value.value,
                                                    plantId: selectedPlant
                                                        .value.value,
                                                    fromDate: convertDateFormat(
                                                        fromDate),
                                                    toDate: convertDateFormat(
                                                        toDate));
                                            loaderScreen.value = false;

                                            originalFreightBillList =
                                                response.responseList ?? [];
                                            for (int i = 0;
                                                i <
                                                    originalFreightBillList
                                                        .length;
                                                i++) {
                                              checkBoxMap[
                                                  originalFreightBillList[i]
                                                          .diNo ??
                                                      ""] = i;
                                              checkBox.add(ValueNotifier(
                                                  originalFreightBillList[i]
                                                          .isInitiated ??
                                                      false));
                                              if (originalFreightBillList[i]
                                                      .isInitiated ==
                                                  true) {
                                                selectedRows.add(
                                                    originalFreightBillList[i]
                                                            .diNo ??
                                                        "");
                                              }
                                            }
                                            if (selectedRows.isNotEmpty) {
                                              initiateButton.value = true;
                                            } else {
                                              initiateButton.value = false;
                                            }
                                            frieghtBillListResponseList.value =
                                                originalFreightBillList;
                                            frieghtBillListResponseList1.value =
                                                getCurrentPageItems(
                                                    originalFreightBillList,
                                                    currentPage);

                                            sp?.setString("selectedDivision",
                                                selectedDivision.value);
                                            sp?.setString("selectedDistChannel",
                                                selectedDistChannel.value.key);
                                            sp?.setString(
                                                "selectedDistChannelValue",
                                                selectedDistChannel
                                                    .value.value);
                                            sp?.setString(
                                                "selectedDeliveryType",
                                                selectedDeliveryType.value.key);
                                            sp?.setString(
                                                "selectedMaterialFrtGrp",
                                                selectedMaterialFrtGrp
                                                    .value.key);
                                            sp?.setString("selectedProduct",
                                                selectedProduct.value.key);
                                            sp?.setString("selectedBrand",
                                                selectedBrand.value.key);
                                            sp?.setString("selectedState",
                                                selectedState.value.key);
                                            sp?.setString("selectedPlant",
                                                selectedPlant.value.key);
                                            sp?.setString("selectedPlantValue",
                                                selectedPlant.value.value);
                                            sp?.setString("fromDate1",
                                                fromDateController.text);
                                            sp?.setString("toDate1",
                                                toDateController.text);
                                            sp?.setString("orgName",
                                                selectedPlant.value.key);
                                          } catch (e) {
                                            // debugPrint(
                                            //     "oops, something went wrong in search api $e");
                                          }
                                        }),
                                    wSpace(10),
                                    button(
                                        btnText: "Reset",
                                        btnClr: Colors.white,
                                        btnTxtClr: ColorConstant.redbar,
                                        tapFunction: () async {
                                          setState(() {});
                                          selectedRows.clear();
                                          sp?.setString("selectedDeliveryType",
                                              "isEmpty");
                                          sp?.setString(
                                              "selectedMaterialFrtGrp",
                                              "isEmpty");
                                          sp?.setString(
                                              "selectedDistChannel", "isEmpty");
                                          sp?.setString(
                                              "selectedDistChannelValue",
                                              "isEmpty");
                                          sp?.setString(
                                              "selectedProduct", "isEmpty");
                                          sp?.setString(
                                              "selectedBrand", "isEmpty");
                                          sp?.setString(
                                              "selectedState", "isEmpty");
                                          sp?.setString(
                                              "selectedPlant", "isEmpty");
                                          sp?.setString(
                                              "selectedPlantValue", "isEmpty");
                                          sp?.setString(
                                              "selectedDivision", "isEmpty");

                                          // ❗ Clear both plant & division
                                          selectedPlant.value = const MapEntry("", ""); // Important
                                          selectedDivision.value = "Select Division";

                                          resetDateSelections();
                                          initializeDates(
                                              financialYearEndDate:
                                                  lastDateFromApi);
                                          // sp?.setString(
                                          //     "fromDate1",
                                          //   ((now.day <= 5 ?  DateFormat('dd/MM/yyyy').format(firstDayOfPreviousMonth):DateFormat('dd/MM/yyyy').format(firstDayOfCurrentMonth))));
                                          // sp?.setString(
                                          //     "toDate1",
                                          //    (now.day <=5 ? DateFormat('dd/MM/yyyy').format(lastDayOfPreviousMonth): DateFormat('dd/MM/yyyy').format(now)));
                                          //                                          sp?.setString(
                                          //                                       "fromDate1",  ///for april 1st
                                          // fromDateController.text =
                                          //     // DateFormat('dd/MM/yyyy').format(
                                          //     //  DateTime.now().isBefore(DateTime(DateTime.now().year, 4, 1)) ? DateTime.now() : DateTime(DateTime.now().year, 4, 1)));
                                          //     ///for current month 1 st,
                                          //     DateFormat('dd/MM/yyyy').format(
                                          //         DateTime(DateTime.now().year,
                                          //             DateTime.now().month, 1));

                                          ///for 90 days past
                                          // DateFormat('dd/MM/yyyy').format(
                                          //     DateTime.now().subtract(
                                          //         const Duration(days: 90)))
                                          // );
                                          // sp?.setString(
                                          //     "toDate1",
                                          //     toDateController.text =
                                          //         DateFormat('dd/MM/yyyy')
                                          //             .format(DateTime.now()));

                                          originalFreightBillList = [];
                                          frieghtBillListResponseList.value =
                                              [];
                                          frieghtBillListResponseList1.value =
                                              [];
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                  vSpace(20),
                  tableHeading(heading: "Records"),
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
                  Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 200, // Adjust these constraints as needed
                          maxWidth: 2700,
                        ),
                        child: Obx(() => Column(
                              children: [
                                Row(
                                  children: [
                                    refreshed.value
                                        ? const SizedBox.shrink()
                                        : Expanded(
                                            flex: 2,
                                            child: Container(
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 0.5,
                                                    color:
                                                        const Color(0xff727272),
                                                  ),
                                                ),
                                                // child: ValueListenableBuilder<
                                                //         bool>(
                                                //     valueListenable: allChecked,
                                                //     builder:
                                                //         (BuildContext context,
                                                //             bool value,
                                                //             Widget? child) {
                                                //       return Checkbox(
                                                //         value: value,
                                                //         onChanged: (value) {
                                                //           allChecked.value =
                                                //               value ?? false;
                                                //           if (value == true) {
                                                //             selectedRows.clear();
                                                //             for (int i = 0;
                                                //                 i <
                                                //                     frieghtBillListResponseList1
                                                //                         .value
                                                //                         .length;
                                                //                 i++) {
                                                //               selectedRows.add(
                                                //                   frieghtBillListResponseList1
                                                //                           .value[
                                                //                               i]
                                                //                           .diNo ??
                                                //                       "");
                                                //               checkBox[i].value =
                                                //                   true;
                                                //             }
                                                //           } else {
                                                //             for (int i = 0;
                                                //                 i <
                                                //                     frieghtBillListResponseList1
                                                //                         .value
                                                //                         .length;
                                                //                 i++) {
                                                //               checkBox[i].value =
                                                //                   false;
                                                //             }
                                                //             selectedRows.clear();
                                                //           }
                                                //           if (selectedRows
                                                //               .isNotEmpty) {
                                                //             initiateButton.value =
                                                //                 true;
                                                //           } else {
                                                //             initiateButton.value =
                                                //                 false;
                                                //           }
                                                //         },
                                                //       );
                                                //     }),
                                                child: Container()),
                                          ),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Sr. No.",
                                        flx: 3,
                                        hgt1: 45,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Org Code",
                                        flx: 4,
                                        hgt1: 45,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "DI No.",
                                        flx: 7,
                                        hgt1: 45,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Token No.",
                                        flx: 7,
                                        hgt1: 45,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    SizedBox(
                                      width: 150,
                                      child: columnWithoutExpanded(
                                          colColor: const Color(0xffF6F6F6),
                                          columnTitle: "LR/GR",
                                          hgt1: 45,
                                          clr: const Color(0xff727272),
                                          fntWeight: FontWeight.bold),
                                    ),
                                    // column(
                                    //     colColor: const Color(0xffF6F6F6),
                                    //     columnTitle: "GRN/MRN",
                                    //     flx: 5,
                                    //     hgt1: 45,
                                    //     clr: const Color(0xff727272),
                                    //     fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Truck No.",
                                        flx: 7,
                                        hgt1: 45,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Inv No.",
                                        flx: 8,
                                        hgt1: 45,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Inv Date",
                                        flx: 7,
                                        hgt1: 45,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    SizedBox(
                                      width: 190,
                                      child: columnWithoutExpanded(
                                          colColor: const Color(0xffF6F6F6),
                                          columnTitle: "State",
                                          hgt1: 45,
                                          clr: const Color(0xff727272),
                                          fntWeight: FontWeight.bold),
                                    ),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "District",
                                        flx: 10,
                                        hgt1: 45,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    SizedBox(
                                      width: 250,
                                      child: columnWithoutExpanded(
                                          colColor: const Color(0xffF6F6F6),
                                          columnTitle: "Ship To",
                                          hgt1: 45,
                                          clr: const Color(0xff727272),
                                          fntWeight: FontWeight.bold),
                                    ),
                                    column(
                                        colColor: const Color(0xffF6F6F6),
                                        columnTitle: "Ship To City",
                                        flx: 12,
                                        hgt1: 45,
                                        clr: const Color(0xff727272),
                                        fntWeight: FontWeight.bold),
                                    refreshed.value
                                        ? column(
                                            colColor: const Color(0xffF6F6F6),
                                            columnTitle: "Di Qty",
                                            flx: 6,
                                            hgt1: 45,
                                            clr: const Color(0xff727272),
                                            fntWeight: FontWeight.bold)
                                        : const SizedBox.shrink(),
                                    refreshed.value
                                        ? column(
                                            colColor: const Color(0xffF6F6F6),
                                            columnTitle: "Shortage Qty",
                                            flx: 6,
                                            hgt1: 45,
                                            clr: const Color(0xff727272),
                                            fntWeight: FontWeight.bold)
                                        : const SizedBox.shrink(),
                                    refreshed.value
                                        ? column(
                                            colColor: const Color(0xffF6F6F6),
                                            columnTitle: "Frt Rate",
                                            flx: 6,
                                            hgt1: 45,
                                            clr: const Color(0xff727272),
                                            fntWeight: FontWeight.bold)
                                        : const SizedBox.shrink(),
                                    refreshed.value
                                        ? column(
                                            colColor: const Color(0xffF6F6F6),
                                            columnTitle: "Special Frt Rate",
                                            flx: 8,
                                            hgt1: 45,
                                            clr: const Color(0xff727272),
                                            fntWeight: FontWeight.bold)
                                        : const SizedBox.shrink(),
                                    refreshed.value
                                        ? column(
                                            colColor: const Color(0xffF6F6F6),
                                            columnTitle: "Unloading Frt Rate",
                                            flx: 8,
                                            hgt1: 45,
                                            clr: const Color(0xff727272),
                                            fntWeight: FontWeight.bold)
                                        : const SizedBox.shrink(),
                                    refreshed.value
                                        ? column(
                                            colColor: const Color(0xffF6F6F6),
                                            columnTitle: "Frt Amt.",
                                            flx: 6,
                                            hgt1: 45,
                                            clr: const Color(0xff727272),
                                            fntWeight: FontWeight.bold)
                                        : const SizedBox.shrink(),
                                    SizedBox(
                                      width: 180,
                                      child: columnWithoutExpanded(
                                          colColor: const Color(0xffF6F6F6),
                                          columnTitle: "Unloaded By",
                                          hgt1: 45,
                                          clr: const Color(0xff727272),
                                          fntWeight: FontWeight.bold),
                                    ),
                                    refreshed.value
                                        ? column(
                                            colColor: const Color(0xffF6F6F6),
                                            columnTitle: "Remarks",
                                            flx: 10,
                                            hgt1: 45,
                                            clr: const Color(0xff727272),
                                            fntWeight: FontWeight.bold)
                                        : const SizedBox.shrink(),

                                    refreshed.value
                                        ? column(
                                            colColor: const Color(0xffF6F6F6),
                                            columnTitle: "Action",
                                            flx: 8,
                                            hgt1: 45,
                                            clr: const Color(0xff727272),
                                            fntWeight: FontWeight.bold)
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                                ValueListenableBuilder(
                                    valueListenable:
                                        frieghtBillListResponseList1,
                                    builder: (BuildContext context,
                                        List<FrieghtBillModelResponseList> data,
                                        Widget? child) {
                                      if (data.isEmpty) {
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(30.0),
                                            child: Text("No data available"),
                                          ),
                                        );
                                      } else {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: data.length,
                                            itemBuilder: (_, index) {
                                              Color clr;
                                              index % 2 != 0
                                                  ? clr =
                                                      const Color(0xffF6F6F6)
                                                  : clr = Colors.white;
                                              return Row(
                                                children: [
                                                  refreshed.value
                                                      ? const SizedBox.shrink()
                                                      : Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            height: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                width: 0.5,
                                                                color: const Color(
                                                                    0xff727272),
                                                              ),
                                                            ),
                                                            child:
                                                                ValueListenableBuilder(
                                                              valueListenable: checkBox[
                                                                  checkBoxMap[data[index]
                                                                              .diNo ??
                                                                          ""] ??
                                                                      0],
                                                              builder: (BuildContext
                                                                      context,
                                                                  bool value,
                                                                  Widget?
                                                                      child) {
                                                                return Checkbox(
                                                                    activeColor:
                                                                        ColorConstant
                                                                            .color1,
                                                                    checkColor:
                                                                        Colors
                                                                            .white,
                                                                    value:
                                                                        value,
                                                                    onChanged:
                                                                        (newVal) {
                                                                      if (newVal ==
                                                                          true) {
                                                                        for (int i =
                                                                                0;
                                                                            i < originalFreightBillList.length;
                                                                            i++) {
                                                                          if (originalFreightBillList[i].tokenNo ==
                                                                              frieghtBillListResponseList1.value[index].tokenNo) {
                                                                            selectedRows.add(originalFreightBillList[i].diNo ??
                                                                                "");
                                                                            checkBox[i].value =
                                                                                true;
                                                                          }
                                                                        }
                                                                      } else {
                                                                        for (int i =
                                                                                0;
                                                                            i < originalFreightBillList.length;
                                                                            i++) {
                                                                          if (originalFreightBillList[i].tokenNo ==
                                                                              frieghtBillListResponseList1.value[index].tokenNo) {
                                                                            checkBox[i].value =
                                                                                false;
                                                                            selectedRows.remove(originalFreightBillList[i].diNo ??
                                                                                "");
                                                                          }
                                                                        }
                                                                      }

                                                                      if (selectedRows
                                                                          .isNotEmpty) {
                                                                        initiateButton.value =
                                                                            true;
                                                                      } else {
                                                                        initiateButton.value =
                                                                            false;
                                                                      }
                                                                    });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                  column(
                                                      colColor: clr,
                                                      columnTitle:
                                                          "${((currentPage - 1) * int.parse(selectedDropdownValue)) + index + 1}",
                                                      flx: 3,
                                                      fntWeight:
                                                          FontWeight.normal,
                                                      clr: const Color(
                                                          0xff727272)),
                                                  column(
                                                      colColor: clr,
                                                      columnTitle: data[index]
                                                          .plantId
                                                          .toString(),
                                                      flx: 4,
                                                      fntWeight:
                                                          FontWeight.normal,
                                                      clr: const Color(
                                                          0xff727272)),
                                                  column(
                                                      colColor: clr,
                                                      columnTitle:
                                                          data[index].diNo ??
                                                              "",
                                                      flx: 7,
                                                      fntWeight:
                                                          FontWeight.normal,
                                                      clr: const Color(
                                                          0xff727272)),
                                                  column(
                                                      colColor: clr,
                                                      columnTitle:
                                                          data[index].tokenNo ??
                                                              "",
                                                      flx: 7,
                                                      fntWeight:
                                                          FontWeight.normal,
                                                      clr: const Color(
                                                          0xff727272)),
                                                  SizedBox(
                                                    width: 150,
                                                    child:
                                                        columnWithoutExpanded(
                                                            colColor: clr,
                                                            columnTitle:
                                                                data[index]
                                                                        .grNo ??
                                                                    "",
                                                            fntWeight:
                                                                FontWeight
                                                                    .normal,
                                                            clr: const Color(
                                                                0xff727272)),
                                                  ),
                                                  column(
                                                      colColor: clr,
                                                      columnTitle:
                                                          data[index].truckNo ??
                                                              "",
                                                      flx: 7,
                                                      fntWeight:
                                                          FontWeight.normal,
                                                      clr: const Color(
                                                          0xff727272)),
                                                  column(
                                                      colColor: clr,
                                                      columnTitle: data[index]
                                                              .invoiceNo ??
                                                          "",
                                                      flx: 8,
                                                      fntWeight:
                                                          FontWeight.normal,
                                                      clr: const Color(
                                                          0xff727272)),
                                                  column(
                                                      colColor: clr,
                                                      columnTitle: DateFormat(
                                                              'dd/MM/yyyy')
                                                          .format(DateTime
                                                              .parse(data[index]
                                                                      .invoiceDate ??
                                                                  "")),
                                                      flx: 7,
                                                      fntWeight:
                                                          FontWeight.normal,
                                                      clr: const Color(
                                                          0xff727272)),
                                                  SizedBox(
                                                    width: 190,
                                                    child: columnWithoutExpanded(
                                                        colColor: clr,
                                                        columnTitle: data[index]
                                                                .stateName ??
                                                            "",
                                                        fntWeight:
                                                            FontWeight.normal,
                                                        clr: const Color(
                                                            0xff727272)),
                                                  ),
                                                  column(
                                                      colColor: clr,
                                                      columnTitle: data[index]
                                                              .districtName ??
                                                          "",
                                                      flx: 10,
                                                      fntWeight:
                                                          FontWeight.normal,
                                                      clr: const Color(
                                                          0xff727272)),
                                                  SizedBox(
                                                    width: 250,
                                                    child:
                                                        columnWithoutExpanded(
                                                            colColor: clr,
                                                            columnTitle: data[
                                                                        index]
                                                                    .shipTo ??
                                                                "",
                                                            fntWeight:
                                                                FontWeight
                                                                    .normal,
                                                            clr: const Color(
                                                                0xff727272)),
                                                  ),
                                                  column(
                                                      colColor: clr,
                                                      columnTitle: data[index]
                                                              .customerCityName ??
                                                          "",
                                                      flx: 12,
                                                      fntWeight:
                                                          FontWeight.normal,
                                                      clr: const Color(
                                                          0xff727272)),
                                                  refreshed.value
                                                      ? column(
                                                          colColor: clr,
                                                          columnTitle:
                                                              data[index]
                                                                  .quantity
                                                                  .toString(),
                                                          flx: 6,
                                                          fntWeight:
                                                              FontWeight.normal,
                                                          clr: const Color(
                                                              0xff727272))
                                                      : const SizedBox.shrink(),
                                                  refreshed.value
                                                      ? column(
                                                          colColor: clr,
                                                          columnTitle:
                                                              data[index]
                                                                  .shortageQty
                                                                  .toString(),
                                                          flx: 6,
                                                          fntWeight:
                                                              FontWeight.normal,
                                                          clr: const Color(
                                                              0xff727272))
                                                      : const SizedBox.shrink(),
                                                  refreshed.value
                                                      ? column(
                                                          colColor: clr,
                                                          columnTitle:
                                                              IndianCurrencyFormatter
                                                                  .format(data[
                                                                              index]
                                                                          .frtRate ??
                                                                      0.0),
                                                          flx: 6,
                                                          fntWeight:
                                                              FontWeight.normal,
                                                          clr: const Color(
                                                              0xff727272))
                                                      : const SizedBox.shrink(),
                                                  refreshed.value
                                                      ? column(
                                                          colColor: clr,
                                                          columnTitle:
                                                              IndianCurrencyFormatter
                                                                  .format(data[
                                                                              index]
                                                                          .specialFrtRate ??
                                                                      0.0),
                                                          flx: 8,
                                                          fntWeight:
                                                              FontWeight.normal,
                                                          clr: const Color(
                                                              0xff727272))
                                                      : const SizedBox.shrink(),
                                                  refreshed.value
                                                      ? column(
                                                          colColor: clr,
                                                          columnTitle:
                                                              IndianCurrencyFormatter
                                                                  .format(data[
                                                                              index]
                                                                          .unloadingFrtRate ??
                                                                      0.0),
                                                          flx: 8,
                                                          fntWeight:
                                                              FontWeight.normal,
                                                          clr: const Color(
                                                              0xff727272))
                                                      : const SizedBox.shrink(),
                                                  refreshed.value
                                                      ? column(
                                                          colColor: clr,
                                                          columnTitle:
                                                              IndianCurrencyFormatter
                                                                  .format(data[
                                                                              index]
                                                                          .frtAmount ??
                                                                      0.0),
                                                          flx: 6,
                                                          fntWeight:
                                                              FontWeight.normal,
                                                          clr: const Color(
                                                              0xff727272))
                                                      : const SizedBox.shrink(),
                                                  SizedBox(
                                                    width: 180,
                                                    child:
                                                        columnWithoutExpanded(
                                                            colColor: clr,
                                                            columnTitle: data[
                                                                        index]
                                                                    .unloadBy ??
                                                                "",
                                                            fntWeight:
                                                                FontWeight
                                                                    .normal,
                                                            clr: const Color(
                                                                0xff727272)),
                                                  ),
                                                  refreshed.value
                                                      ? column(
                                                          colColor: clr,
                                                          columnTitle: data[
                                                                      index]
                                                                  .remarks ??
                                                              "",
                                                          flx: 10,
                                                          fntWeight:
                                                              FontWeight.normal,
                                                          clr: const Color(
                                                              0xff727272))
                                                      : const SizedBox.shrink(),
                                                  refreshed.value
                                                      ? Expanded(
                                                          flex: 8,
                                                          child: Container(
                                                            height: 35,
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                width: 0.5,
                                                                color: const Color(
                                                                    0xff727272),
                                                              ),
                                                            ),
                                                            child: index <
                                                                    initiatedFreightBillList
                                                                        .length
                                                                ? initiatedFreightBillList[index +
                                                                                (int.parse(selectedDropdownValue) * (currentPage - 1))]
                                                                            .tokenRank ==
                                                                        1
                                                                    ? Row(
                                                                        children: [
                                                                          wSpace(
                                                                              5),
                                                                          InkWell(
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/searchicon.png",
                                                                              color: Colors.green,
                                                                            ),
                                                                            onTap:
                                                                                () async {
                                                                              try {
                                                                                loaderScreen.value = true;
                                                                                final FreightBillDiQtyModel res = await FreightBillApi().getDiQtyAndFreightAmt(ctx: context, tokenNumber: data[index].tokenNo ?? "");
                                                                                loaderScreen.value = false;

                                                                                plantGrossWgtController.text = (res.serviceDTO?.plantGrossWeight ?? "").toString();

                                                                                plantTareWeightController.text = (res.serviceDTO?.plantTareWeight ?? "").toString();
                                                                                plantNetWeightController.text = res.serviceDTO?.plantNetWeight.toString() ?? "";

                                                                                // ignore: use_build_context_synchronously
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    netWeight.value = double.parse(netWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].value.text);
                                                                                    bags.value = double.parse(shortageQtyController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].value.text) / 50;

                                                                                    return Stack(
                                                                                      children: [
                                                                                        CustomPopup1(
                                                                                          height: 380,
                                                                                          width: 914,
                                                                                          buttonLabel1: "Save",
                                                                                          buttonLabel2: "Cancel",
                                                                                          title: "Token No. ${data[index].tokenNo}",
                                                                                          ontap1: () async {
                                                                                            if (othersController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].text.isEmpty || kataController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].text.isEmpty || grossWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].text.isEmpty || tareWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].text.isEmpty || remarkController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].text.isEmpty
                                                                                                //  netWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].text.isEmpty ||
                                                                                                ) {
                                                                                              showResultDialog("Please fill all required fields.");
                                                                                              return; // Exit function
                                                                                            }
                                                                                            // else if ((double.parse(netWeight[index + (int.parse(selectedDropdownValue) * (currentPage - 1))].value.toString()).isNegative) || (double.parse(netWeight[index + (int.parse(selectedDropdownValue) * (currentPage - 1))].value.toString()).isEqual(0))) {
                                                                                            //   showResultDialog("Net Weight should not be negative or 0");
                                                                                            //   return;
                                                                                            // }

                                                                                            try {
                                                                                              loaderScreen.value = true;

                                                                                              await FreightBillApi().updateDi(tokenNumber: data[index].tokenNo ?? "", shortageQuantity: data[index].diType == "STO" ? data[index].shortageQty.toString() : (double.parse(shortageQtyController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))].text) / 1000).toString(), remarks: remarkController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))].text, ctx: context, diNumber: data[index].diNo.toString(), diUom: "KG", tollTax: tollTaxController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))].text, kata: kataController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))].text, other: othersController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))].text, grossWeight: grossWeightController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))].text, tareWeight: tareWeightController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))].text, netWeight: netWeight.value.toString(), tyreAmount: "0");

                                                                                              loaderScreen.value = false;
                                                                                              // ignore: use_build_context_synchronously
                                                                                              FreightBillApi().getInitiatedAndUpdatedDiDetails(ctx: context).then((response) {
                                                                                                initiatedFreightBillList = response.responseList ?? [];
                                                                                                frieghtBillListResponseList.value = convertDeliveryItemsToFreightBillModelResponseList(initiatedFreightBillList);
                                                                                                frieghtBillListResponseList1.value = getCurrentPageItems(frieghtBillListResponseList.value, currentPage);
                                                                                                counterForUpdtedDi = 0;
                                                                                                tollTaxController.clear();
                                                                                                kataController.clear();
                                                                                                othersController.clear();
                                                                                                shortageQtyController.clear();
                                                                                                grossWeightController.clear();
                                                                                                tareWeightController.clear();
                                                                                                netWeightController.clear();
                                                                                                tyreAmtController.clear();
                                                                                                remarkController.clear();
                                                                                                netWeight.value = 0;

                                                                                                for (int i = 0; i < initiatedFreightBillList.length; i++) {
                                                                                                  if (initiatedFreightBillList[i].dataUpdated == true) {
                                                                                                    counterForUpdtedDi++;
                                                                                                  }

                                                                                                  tollTaxController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].tollTax));
                                                                                                  kataController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].kata));
                                                                                                  othersController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].other));
                                                                                                  remarkController.add(LimitedLengthTextController(text: initiatedFreightBillList[i].remarks));
                                                                                                  shortageQtyController.add(DoubleNumericTextEditingController(text: (initiatedFreightBillList[i].shortageQty ?? 0) * 1000));
                                                                                                  grossWeightController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].grossWeight));
                                                                                                  tareWeightController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].tareWeight));
                                                                                                  netWeightController.add(DoubleNumericTextEditingController(text: (double.parse((initiatedFreightBillList[i].grossWeight ?? 0.0).toString()) - double.parse((initiatedFreightBillList[i].tareWeight ?? 0.0).toString()))));
                                                                                                }
                                                                                                netWeight.value = double.parse(netWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].value.text);

                                                                                                // debugPrint(initiatedFreightBillList
                                                                                                //     .length);
                                                                                                // debugPrint(
                                                                                                //     counterForUpdtedDi);

                                                                                                if (initiatedFreightBillList.length == counterForUpdtedDi) {
                                                                                                  processBill.value = true;
                                                                                                  processButton.value = true;
                                                                                                }
                                                                                              });
                                                                                            } catch (e) {
                                                                                              // debugPrint('error in update update di $e');
                                                                                            }
                                                                                          },
                                                                                          ontap2: () {
                                                                                            Navigator.of(context).pop();
                                                                                            tollTaxController.clear();
                                                                                            kataController.clear();
                                                                                            othersController.clear();
                                                                                            shortageQtyController.clear();
                                                                                            grossWeightController.clear();
                                                                                            tareWeightController.clear();
                                                                                            netWeightController.clear();
                                                                                            tyreAmtController.clear();
                                                                                            remarkController.clear();
                                                                                            netWeight.value = 0;

                                                                                            for (int i = 0; i < initiatedFreightBillList.length; i++) {
                                                                                              if (initiatedFreightBillList[i].dataUpdated == true) {
                                                                                                counterForUpdtedDi++;
                                                                                              }

                                                                                              tollTaxController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].tollTax));
                                                                                              kataController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].kata));
                                                                                              othersController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].other));
                                                                                              remarkController.add(LimitedLengthTextController(text: initiatedFreightBillList[i].remarks));
                                                                                              shortageQtyController.add(DoubleNumericTextEditingController(text: (initiatedFreightBillList[i].shortageQty ?? 0) * 1000));
                                                                                              grossWeightController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].grossWeight));
                                                                                              tareWeightController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].tareWeight));
                                                                                              netWeightController.add(DoubleNumericTextEditingController(text: (double.parse((initiatedFreightBillList[i].grossWeight ?? 0.0).toString()) - double.parse((initiatedFreightBillList[i].tareWeight ?? 0.0).toString()))));
                                                                                            }
                                                                                            netWeight.value = double.parse(netWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)].value.text);
                                                                                          },
                                                                                          columnChildrens: [
                                                                                            SizedBox(
                                                                                                height: 270,
                                                                                                child: SingleChildScrollView(
                                                                                                  child: Wrap(
                                                                                                    spacing: 20,
                                                                                                    runSpacing: 10,
                                                                                                    alignment: size.width > 600 ? WrapAlignment.start : WrapAlignment.center,
                                                                                                    children: [
                                                                                                      Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: const EdgeInsets.only(top: 15),
                                                                                                            child: Container(
                                                                                                              height: 32,
                                                                                                              width: 200,
                                                                                                              alignment: Alignment.centerLeft,
                                                                                                              child: const Text(
                                                                                                                "Plant Weight :",
                                                                                                                style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      customTextField(
                                                                                                        width: 200,
                                                                                                        disabled: true,
                                                                                                        isConst: true,
                                                                                                        controller: plantGrossWgtController,
                                                                                                        label: "Gross Weight",
                                                                                                      ),
                                                                                                      customTextField(
                                                                                                        width: 200,
                                                                                                        disabled: true,
                                                                                                        isConst: true,
                                                                                                        controller: plantTareWeightController,
                                                                                                        label: "Tare Weight",
                                                                                                      ),
                                                                                                      customTextField(
                                                                                                        width: 200,
                                                                                                        disabled: true,
                                                                                                        isConst: true,
                                                                                                        controller: plantNetWeightController,
                                                                                                        label: "Net Weight",
                                                                                                      ),
                                                                                                      Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: const EdgeInsets.only(top: 15),
                                                                                                            child: Container(
                                                                                                              height: 32,
                                                                                                              width: 200,
                                                                                                              alignment: Alignment.centerLeft,
                                                                                                              child: const Text(
                                                                                                                "Out Side Weight :",
                                                                                                                style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      customTextField(
                                                                                                        width: 200,
                                                                                                        controller: grossWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)],
                                                                                                        label: "Gross Weight",
                                                                                                        onChanged: (value) {
                                                                                                          updateNetWeight(index);
                                                                                                        },
                                                                                                      ),
                                                                                                      customTextField(
                                                                                                        width: 200,
                                                                                                        controller: tareWeightController[index + int.parse(selectedDropdownValue) * (currentPage - 1)],
                                                                                                        label: "Tare Weight",
                                                                                                        onChanged: (value) {
                                                                                                          updateNetWeight(index);
                                                                                                        },
                                                                                                      ),
                                                                                                      ValueListenableBuilder(
                                                                                                        valueListenable: netWeight,
                                                                                                        builder: (BuildContext context, double value, Widget? child) {
                                                                                                          return customTextField(
                                                                                                            width: 200,
                                                                                                            isConst: true,
                                                                                                            disabled: true,
                                                                                                            hint: value.toString(),
                                                                                                            label: "Net Weight",
                                                                                                          );
                                                                                                        },
                                                                                                      ),
                                                                                                      Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: const EdgeInsets.only(top: 15),
                                                                                                            child: Container(
                                                                                                              height: 32,
                                                                                                              width: 200,
                                                                                                              alignment: Alignment.centerLeft,
                                                                                                              child: const Text(
                                                                                                                "On Route Charges :",
                                                                                                                style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w500),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      customTextField(
                                                                                                        width: 200,
                                                                                                        controller: kataController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))],
                                                                                                        label: "Kata Amount",
                                                                                                      ),
                                                                                                      customTextField(width: 200, controller: tollTaxController[index + int.parse(selectedDropdownValue) * (currentPage - 1)], label: "Toll Tax"),
                                                                                                      customTextField(
                                                                                                        width: 200,
                                                                                                        controller: othersController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))],
                                                                                                        label: "Border Entry Charges",
                                                                                                        onChanged: (others) {
                                                                                                          if (others == "0" || others.isEmpty) {
                                                                                                            remarkson.value = false;
                                                                                                          } else {
                                                                                                            remarkson.value = true;
                                                                                                          }
                                                                                                        },
                                                                                                      ),
                                                                                                      size.width > 600
                                                                                                          ? const SizedBox(
                                                                                                              width: 200,
                                                                                                            )
                                                                                                          : Container(),
                                                                                                      customTextField(
                                                                                                        width: 200,
                                                                                                        controller: remarkController[index + (int.parse(selectedDropdownValue) * (currentPage - 1))],
                                                                                                        label: "Remarks",
                                                                                                      ),
                                                                                                      data[index].diType == "DI"
                                                                                                          ? Wrap(
                                                                                                              spacing: 20,
                                                                                                              children: [
                                                                                                                customTextField(
                                                                                                                  width: 200,
                                                                                                                  controller: shortageQtyController[index + int.parse(selectedDropdownValue) * (currentPage - 1)],
                                                                                                                  label: "Shortage Quantity (in KG)",
                                                                                                                  onChanged: (value) {
                                                                                                                    updateShortageQty(index);
                                                                                                                  },
                                                                                                                ),
                                                                                                                ValueListenableBuilder(
                                                                                                                  valueListenable: bags,
                                                                                                                  builder: (BuildContext context, double value, Widget? child) {
                                                                                                                    return customTextField(
                                                                                                                      width: 200,
                                                                                                                      isConst: true,
                                                                                                                      disabled: true,
                                                                                                                      hint: value.toString(),
                                                                                                                      label: "Bags",
                                                                                                                    );
                                                                                                                  },
                                                                                                                ),
                                                                                                              ],
                                                                                                            )
                                                                                                          : Container()
                                                                                                    ],
                                                                                                  ),
                                                                                                )),
                                                                                          ],
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
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } catch (e) {
                                                                                // debugPrint("error in action popup or api $e");
                                                                              }
                                                                            },
                                                                          ),
                                                                          wSpace(
                                                                              7),
                                                                          initiatedFreightBillList.length > index && initiatedFreightBillList[index + int.parse(selectedDropdownValue) * (currentPage - 1)].dataUpdated == true
                                                                              ? const Icon(
                                                                                  Icons.thumb_up,
                                                                                  size: 15,
                                                                                  color: Colors.green,
                                                                                )
                                                                              : Container(),
                                                                          wSpace(
                                                                              7),
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              //delete user
                                                                              await FreightBillApi().deleteSelectedDi(ctx: context, diNumber: frieghtBillListResponseList1.value[index].tokenNo ?? "");

                                                                              FreightBillApi().getInitiatedAndUpdatedDiDetails(ctx: context).then((response) {
                                                                                initiatedFreightBillList = response.responseList ?? [];

                                                                                frieghtBillListResponseList.value = convertDeliveryItemsToFreightBillModelResponseList(initiatedFreightBillList);
                                                                                frieghtBillListResponseList1.value = getCurrentPageItems(frieghtBillListResponseList.value, currentPage);

                                                                                counterForUpdtedDi = 0;
                                                                                selectedRows.clear();
                                                                                for (int i = 0; i < initiatedFreightBillList.length; i++) {
                                                                                  if (initiatedFreightBillList[i].dataUpdated == true) {
                                                                                    counterForUpdtedDi++;
                                                                                  }
                                                                                  selectedRows.add(initiatedFreightBillList[i].diNo ?? "");

                                                                                  tollTaxController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].tollTax));
                                                                                  kataController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].kata));
                                                                                  othersController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].other));
                                                                                  remarkController.add(LimitedLengthTextController(text: initiatedFreightBillList[i].remarks));
                                                                                  shortageQtyController.add(DoubleNumericTextEditingController(text: (initiatedFreightBillList[i].shortageQty ?? 0) * 1000));

                                                                                  grossWeightController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].grossWeight));
                                                                                  tareWeightController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].tareWeight));
                                                                                  netWeightController.add(DoubleNumericTextEditingController(text: (double.parse(initiatedFreightBillList[i].grossWeight.toString()) - double.parse(initiatedFreightBillList[i].tareWeight.toString()))));
                                                                                  netWeight = (ValueNotifier((double.parse(initiatedFreightBillList[i].grossWeight.toString()) - double.parse(initiatedFreightBillList[i].tareWeight.toString()))));

                                                                                  tyreAmtController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].tyreAmount));
                                                                                }
                                                                                if (initiatedFreightBillList.length == counterForUpdtedDi && initiatedFreightBillList.isNotEmpty) {
                                                                                  processBill.value = true;
                                                                                  processButton.value = true;
                                                                                } else {
                                                                                  processBill.value = false;
                                                                                  processButton.value = true;
                                                                                }
                                                                              });
                                                                            },
                                                                            child:
                                                                                Image.asset(
                                                                              "assets/images/deleteicon.png",
                                                                              height: 16,
                                                                              width: 16,
                                                                            ),
                                                                          ),
                                                                          wSpace(
                                                                              5)
                                                                        ],
                                                                      )
                                                                    : Container()
                                                                : Container(),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink()
                                                ],
                                              );
                                            });
                                      }
                                    }),
                              ],
                            )),
                      ),
                    ),
                  ),
                  Container(
                      color: Colors.grey.shade200,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
                          child: size.width > 600
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable:
                                          frieghtBillListResponseList1,
                                      builder: (BuildContext context,
                                          List<FrieghtBillModelResponseList>
                                              value,
                                          Widget? child) {
                                        if (value.isEmpty) {
                                          return Center(child: Container());
                                        }
                                        return Text(
                                            "Showing ${(int.parse(selectedDropdownValue) * (currentPage - 1)) + 1} to ${(int.parse(selectedDropdownValue) * (currentPage - 1)) + value.length} of ${frieghtBillListResponseList.value.length} entries",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal));
                                      },
                                    ),
                                    size.width > 600
                                        ? const Expanded(child: SizedBox())
                                        : Container(),
                                    buildValueListenableBuilder(),
                                    size.width > 600
                                        ? const Expanded(child: SizedBox())
                                        : Container(),
                                    SizedBox(
                                      child: Obx(() => Row(
                                            children: [
                                              refreshed.value
                                                  ? Row(
                                                      children: [
                                                        button(
                                                          btnText: "Back",
                                                          btnClr: ColorConstant
                                                              .redbar,
                                                          btnTxtClr:
                                                              Colors.white,
                                                          tapFunction:
                                                              () async {
                                                            frieghtBillListResponseList1
                                                                .value
                                                                .clear();
                                                            frieghtBillListResponseList
                                                                .value
                                                                .clear();

                                                            refreshed.value =
                                                                false;

                                                            try {
                                                              if (selectedPlant
                                                                      .value
                                                                      .value !=
                                                                  "Select Plant") {
                                                                final toDate = DateTime
                                                                    .parse(parseDate(
                                                                        toDateController
                                                                            .text));
                                                                // Parse from date
                                                                final fromDate =
                                                                    DateTime.parse(
                                                                        parseDate(
                                                                            fromDateController.text));

                                                                final FreightBillModel response = await FreightBillApi()
                                                                    .searchFrieghBill(
                                                                        materialFrtGrp: selectedMaterialFrtGrp
                                                                            .value
                                                                            .value,
                                                                        ctx:
                                                                            context,
                                                                        deliveryType: selectedDeliveryType
                                                                            .value
                                                                            .key,
                                                                        freightBillType:
                                                                            selectedFreightBillType2
                                                                                .value, //hardcoded value
                                                                        // selectedFrBillType.value.value, //actual value
                                                                        distributionChannel: selectedDistChannel
                                                                            .value
                                                                            .value,
                                                                        division:
                                                                            selectedDivision
                                                                                .value,
                                                                        product: selectedProduct
                                                                            .value
                                                                            .value,
                                                                        brand: selectedBrand
                                                                            .value
                                                                            .value,
                                                                        stateId: selectedState
                                                                            .value
                                                                            .value,
                                                                        plantId: selectedPlant
                                                                            .value
                                                                            .value,
                                                                        fromDate:
                                                                            convertDateFormat(
                                                                                fromDate),
                                                                        toDate:
                                                                            convertDateFormat(toDate));

                                                                originalFreightBillList =
                                                                    response.responseList ??
                                                                        [];
                                                                for (int i = 0;
                                                                    i <
                                                                        originalFreightBillList
                                                                            .length;
                                                                    i++) {
                                                                  checkBoxMap[
                                                                      originalFreightBillList[i]
                                                                              .diNo ??
                                                                          ""] = i;
                                                                  checkBox.add(ValueNotifier(
                                                                      originalFreightBillList[i]
                                                                              .isInitiated ??
                                                                          false));
                                                                  if (originalFreightBillList[
                                                                              i]
                                                                          .isInitiated ==
                                                                      true) {
                                                                    selectedRows.add(
                                                                        originalFreightBillList[i].diNo ??
                                                                            "");
                                                                  }
                                                                }
                                                                frieghtBillListResponseList
                                                                        .value =
                                                                    originalFreightBillList;
                                                                frieghtBillListResponseList1
                                                                        .value =
                                                                    getCurrentPageItems(
                                                                        originalFreightBillList,
                                                                        currentPage);
                                                              } else {
                                                                frieghtBillListResponseList
                                                                    .value
                                                                    .clear();
                                                                originalFreightBillList
                                                                    .clear();
                                                                frieghtBillListResponseList1
                                                                    .value
                                                                    .clear();
                                                                setState(() {});
                                                              }
                                                              if (selectedRows
                                                                  .isNotEmpty) {
                                                                initiateButton
                                                                        .value =
                                                                    true;
                                                              } else {
                                                                initiateButton
                                                                        .value =
                                                                    false;
                                                              }
                                                            } catch (e) {
                                                              // debugPrint(
                                                              // "oops, something went wrong in search api $e");
                                                            }
                                                          },
                                                        ),
                                                        wSpace(5),
                                                        ValueListenableBuilder(
                                                          valueListenable:
                                                              processBill,
                                                          builder: (BuildContext
                                                                  context,
                                                              bool value,
                                                              Widget? child) {
                                                            return Obx(() => processButton
                                                                    .value
                                                                ? button(
                                                                    btnText:
                                                                        "Process Freight Bill",
                                                                    btnClr: value
                                                                        ? ColorConstant
                                                                            .redbar
                                                                        : Colors
                                                                            .white,
                                                                    btnTxtClr:
                                                                        Colors
                                                                            .white,
                                                                    tapFunction:
                                                                        value
                                                                            ? () async {
                                                                                processButton.value = false;
                                                                                loaderScreen.value = true;
                                                                                controller.diNumberList = selectedRows.toList();

                                                                                final ProcessFreightBillModel response = await FreightBillApi().processFreightBill(diNumber: controller.diNumberList, ctx: context);

                                                                                controller.processfrbill.value = response;
                                                                                controller.originalProcessFrBill2List = response.serviceDTO?.diDetails ?? [];

                                                                                if (controller.isProcess200.value) {
                                                                                  controller.currentIndex.value = 26;
                                                                                }

                                                                                loaderScreen.value = false;

                                                                                // processButton.value = false;
                                                                              }
                                                                            : null)
                                                                : button(
                                                                    btnText:
                                                                        "Process Freight Bill",
                                                                    btnClr: Colors
                                                                        .white,
                                                                    btnTxtClr:
                                                                        Colors
                                                                            .white,
                                                                    tapFunction:
                                                                        null));
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  : ValueListenableBuilder(
                                                      valueListenable:
                                                          frieghtBillListResponseList1,
                                                      builder: (BuildContext
                                                              context,
                                                          List<FrieghtBillModelResponseList>
                                                              value,
                                                          Widget? child) {
                                                        if (value.isEmpty) {
                                                          return Center(
                                                              child:
                                                                  Container());
                                                        }
                                                        return Obx(() => initiateButton
                                                                .value
                                                            ? button(
                                                                btnText:
                                                                    "Initiate Freight Bill",
                                                                tapFunction:
                                                                    loaderScreen
                                                                            .value
                                                                        ? null
                                                                        : () async {
                                                                            currentPagination.value =
                                                                                1;
                                                                            currentPage =
                                                                                1;
                                                                            sp?.setString("selectedDivision",
                                                                                selectedDivision.value);
                                                                            sp?.setString("selectedDistChannel",
                                                                                selectedDistChannel.value.key);
                                                                            sp?.setString("selectedProduct",
                                                                                selectedProduct.value.key);
                                                                            sp?.setString("selectedBrand",
                                                                                selectedBrand.value.key);
                                                                            sp?.setString("selectedState",
                                                                                selectedState.value.key);
                                                                            sp?.setString("selectedPlant",
                                                                                selectedPlant.value.key);
                                                                            sp?.setString("fromDate1",
                                                                                fromDateController.text);
                                                                            sp?.setString("toDate1",
                                                                                toDateController.text);
                                                                            List<DiAndInitiatedStatus>
                                                                                diAndInitiatedStatusList =
                                                                                [];
                                                                            for (int i = 0;
                                                                                i < originalFreightBillList.length;
                                                                                i++) {
                                                                              if (originalFreightBillList[i].isInitiated == true) {
                                                                                diAndInitiatedStatusList.add(DiAndInitiatedStatus(diNo: originalFreightBillList[i].diNo ?? "", initiated: selectedRows.contains(originalFreightBillList[i].diNo)));
                                                                              } else {
                                                                                diAndInitiatedStatusList.add(DiAndInitiatedStatus(diNo: originalFreightBillList[i].diNo ?? "", initiated: selectedRows.contains(originalFreightBillList[i].diNo)));
                                                                              }
                                                                            }
                                                                            List<Map<String, dynamic>>
                                                                                jsonList =
                                                                                diAndInitiatedStatusList.map((item) => item.toJson()).toList();
                                                                            // String jsonString = json.encode({"diAndInitatedStatusList": jsonList});
                                                                            loaderScreen.value =
                                                                                true;
                                                                            final FreightBillModel
                                                                                response =
                                                                                await FreightBillApi().initiateFreightBill(ctx: context, diNumber: jsonList);
                                                                            originalFreightBillList =
                                                                                response.responseList ?? [];
                                                                            if (originalFreightBillList.isNotEmpty) {
                                                                              FreightBillApi().getInitiatedAndUpdatedDiDetails(ctx: context).then((response) {
                                                                                initiatedFreightBillList = response.responseList ?? [];
                                                                                if (response.responseList == null) {
                                                                                  frieghtBillListResponseList.value.clear();
                                                                                  frieghtBillListResponseList1.value.clear();
                                                                                  return;
                                                                                }
                                                                                frieghtBillListResponseList.value = convertDeliveryItemsToFreightBillModelResponseList(initiatedFreightBillList);
                                                                                frieghtBillListResponseList1.value = getCurrentPageItems(frieghtBillListResponseList.value, currentPage);
                                                                                counterForUpdtedDi = 0;

                                                                                tollTaxController.clear();
                                                                                othersController.clear();
                                                                                remarkController.clear();
                                                                                grossWeightController.clear();

                                                                                shortageQtyController.clear();
                                                                                tareWeightController.clear();
                                                                                netWeightController.clear();
                                                                                tyreAmtController.clear();
                                                                                uomSwitchList.clear();

                                                                                for (int i = 0; i < initiatedFreightBillList.length; i++) {
                                                                                  if (initiatedFreightBillList[i].dataUpdated == true) {
                                                                                    counterForUpdtedDi++;
                                                                                  }
                                                                                  uomSwitchList.add(ValueNotifier(false));

                                                                                  tollTaxController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].tollTax));
                                                                                  kataController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].kata));
                                                                                  othersController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].other));
                                                                                  remarkController.add(LimitedLengthTextController(text: initiatedFreightBillList[i].remarks));
                                                                                  shortageQtyController.add(DoubleNumericTextEditingController(text: (initiatedFreightBillList[i].shortageQty ?? 0) * 1000));
                                                                                  grossWeightController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].grossWeight));
                                                                                  tareWeightController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].tareWeight));
                                                                                  netWeightController.add(DoubleNumericTextEditingController(text: (double.parse((initiatedFreightBillList[i].grossWeight ?? 0).toString()) - double.parse((initiatedFreightBillList[i].tareWeight ?? 0).toString()))));
                                                                                  netWeight = (ValueNotifier((double.parse((initiatedFreightBillList[i].grossWeight ?? 0).toString()) - double.parse((initiatedFreightBillList[i].tareWeight ?? 0).toString()))));

                                                                                  tyreAmtController.add(DoubleNumericTextEditingController(text: initiatedFreightBillList[i].tyreAmount));
                                                                                }
                                                                                if (initiatedFreightBillList.length == counterForUpdtedDi) {
                                                                                  processBill.value = true;
                                                                                  processButton.value = true;
                                                                                }
                                                                              });
                                                                              currentPage = 1;
                                                                              refreshed.value = true;
                                                                              loaderScreen.value = false;
                                                                            }
                                                                          })
                                                            : button(
                                                                btnText:
                                                                    "Initiate Freight Bill",
                                                                btnClr: Colors
                                                                    .white,
                                                                btnTxtClr:
                                                                    Colors
                                                                        .white,
                                                                tapFunction:
                                                                    null));
                                                      })
                                            ],
                                          )),
                                    )
                                  ],
                                )
                              : Wrap(
                                  runSpacing: 5,
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable:
                                          frieghtBillListResponseList1,
                                      builder: (BuildContext context,
                                          List<FrieghtBillModelResponseList>
                                              value,
                                          Widget? child) {
                                        if (value.isEmpty) {
                                          return Center(child: Container());
                                        }
                                        return Text(
                                            "Showing ${(int.parse(selectedDropdownValue) * (currentPage - 1)) + 1} to ${(int.parse(selectedDropdownValue) * (currentPage - 1)) + value.length} of ${frieghtBillListResponseList.value.length} entries",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal));
                                      },
                                    ),
                                    buildValueListenableBuilder(),
                                    SizedBox(
                                      child: Obx(() => Row(
                                            children: [
                                              refreshed.value
                                                  ? Row(
                                                      children: [
                                                        button(
                                                          btnText: "Back",
                                                          btnClr: ColorConstant
                                                              .redbar,
                                                          btnTxtClr:
                                                              Colors.white,
                                                          tapFunction:
                                                              () async {
                                                            refreshed.value =
                                                                false;

                                                            try {
                                                              if (selectedPlant
                                                                      .value
                                                                      .value !=
                                                                  "Select Plant") {
                                                                selectedRows
                                                                    .clear();
                                                                final toDate = DateTime
                                                                    .parse(parseDate(
                                                                        toDateController
                                                                            .text));
                                                                // Parse from date
                                                                final fromDate =
                                                                    DateTime.parse(
                                                                        parseDate(
                                                                            fromDateController.text));

                                                                final FreightBillModel response = await FreightBillApi()
                                                                    .searchFrieghBill(
                                                                        materialFrtGrp: selectedMaterialFrtGrp
                                                                            .value
                                                                            .value,
                                                                        ctx:
                                                                            context,
                                                                        deliveryType: selectedDeliveryType
                                                                            .value
                                                                            .key,
                                                                        freightBillType:
                                                                            selectedFreightBillType2
                                                                                .value, //hardcoded value
                                                                        // selectedFrBillType.value.value, //actual value
                                                                        distributionChannel: selectedDistChannel
                                                                            .value
                                                                            .value,
                                                                        division:
                                                                            selectedDivision
                                                                                .value,
                                                                        product: selectedProduct
                                                                            .value
                                                                            .value,
                                                                        brand: selectedBrand
                                                                            .value
                                                                            .value,
                                                                        stateId: selectedState
                                                                            .value
                                                                            .value,
                                                                        plantId: selectedPlant
                                                                            .value
                                                                            .value,
                                                                        fromDate:
                                                                            convertDateFormat(
                                                                                fromDate),
                                                                        toDate:
                                                                            convertDateFormat(toDate));

                                                                originalFreightBillList =
                                                                    response.responseList ??
                                                                        [];
                                                                for (int i = 0;
                                                                    i <
                                                                        originalFreightBillList
                                                                            .length;
                                                                    i++) {
                                                                  checkBoxMap[
                                                                      originalFreightBillList[i]
                                                                              .diNo ??
                                                                          ""] = i;
                                                                  checkBox.add(ValueNotifier(
                                                                      originalFreightBillList[i]
                                                                              .isInitiated ??
                                                                          false));
                                                                  if (originalFreightBillList[
                                                                              i]
                                                                          .isInitiated ==
                                                                      true) {
                                                                    selectedRows.add(
                                                                        originalFreightBillList[i].diNo ??
                                                                            "");
                                                                  }
                                                                }
                                                                frieghtBillListResponseList
                                                                        .value =
                                                                    originalFreightBillList;
                                                                frieghtBillListResponseList1
                                                                        .value =
                                                                    getCurrentPageItems(
                                                                        originalFreightBillList,
                                                                        currentPage);
                                                              } else {
                                                                frieghtBillListResponseList
                                                                    .value
                                                                    .clear();
                                                                originalFreightBillList
                                                                    .clear();
                                                                frieghtBillListResponseList1
                                                                    .value
                                                                    .clear();
                                                                setState(() {});
                                                              }
                                                            } catch (e) {
                                                              // debugPrint(
                                                              //     "oops, something went wrong in search api $e");
                                                            }
                                                          },
                                                        ),
                                                        wSpace(5),
                                                        ValueListenableBuilder(
                                                          valueListenable:
                                                              processBill,
                                                          builder: (BuildContext
                                                                  context,
                                                              bool value,
                                                              Widget? child) {
                                                            return Obx(() => processButton
                                                                    .value
                                                                ? button(
                                                                    btnText:
                                                                        "Process Freight Bill",
                                                                    btnClr: value
                                                                        ? ColorConstant
                                                                            .redbar
                                                                        : Colors
                                                                            .white,
                                                                    btnTxtClr:
                                                                        Colors
                                                                            .white,
                                                                    tapFunction:
                                                                        value
                                                                            ? () async {
                                                                                processButton.value = false;
                                                                                loaderScreen.value = true;
                                                                                controller.diNumberList = selectedRows.toList();

                                                                                final ProcessFreightBillModel response = await FreightBillApi().processFreightBill(diNumber: [], ctx: context);

                                                                                controller.processfrbill.value = response;
                                                                                controller.originalProcessFrBill2List = response.serviceDTO?.diDetails ?? [];

                                                                                if (controller.isProcess200.value) {
                                                                                  controller.currentIndex.value = 26;
                                                                                }

                                                                                loaderScreen.value = false;

                                                                                // processButton.value = false;
                                                                              }
                                                                            : null)
                                                                : button(
                                                                    btnText:
                                                                        "Process Freight Bill",
                                                                    btnClr: Colors
                                                                        .white,
                                                                    btnTxtClr:
                                                                        Colors
                                                                            .white,
                                                                    tapFunction:
                                                                        null));
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  : ValueListenableBuilder(
                                                      valueListenable:
                                                          frieghtBillListResponseList1,
                                                      builder: (BuildContext
                                                              context,
                                                          List<FrieghtBillModelResponseList>
                                                              value,
                                                          Widget? child) {
                                                        if (value.isEmpty) {
                                                          return Center(
                                                              child:
                                                                  Container());
                                                        }
                                                        return Obx(() => initiateButton
                                                                .value
                                                            ? button(
                                                                btnText:
                                                                    "Initiate Freight Bill",
                                                                tapFunction:
                                                                    () async {
                                                                  currentPagination
                                                                      .value = 1;
                                                                  currentPage =
                                                                      1;
                                                                  sp?.setString(
                                                                      "selectedDivision",
                                                                      selectedDivision
                                                                          .value);
                                                                  sp?.setString(
                                                                      "selectedDistChannel",
                                                                      selectedDistChannel
                                                                          .value
                                                                          .key);
                                                                  sp?.setString(
                                                                      "selectedProduct",
                                                                      selectedProduct
                                                                          .value
                                                                          .key);
                                                                  sp?.setString(
                                                                      "selectedBrand",
                                                                      selectedBrand
                                                                          .value
                                                                          .key);
                                                                  sp?.setString(
                                                                      "selectedState",
                                                                      selectedState
                                                                          .value
                                                                          .key);
                                                                  sp?.setString(
                                                                      "selectedPlant",
                                                                      selectedPlant
                                                                          .value
                                                                          .key);
                                                                  sp?.setString(
                                                                      "fromDate1",
                                                                      fromDateController
                                                                          .text);
                                                                  sp?.setString(
                                                                      "toDate1",
                                                                      toDateController
                                                                          .text);
                                                                  List<DiAndInitiatedStatus>
                                                                      diAndInitiatedStatusList =
                                                                      [];
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          originalFreightBillList
                                                                              .length;
                                                                      i++) {
                                                                    if (originalFreightBillList[i]
                                                                            .isInitiated ==
                                                                        true) {
                                                                      diAndInitiatedStatusList.add(DiAndInitiatedStatus(
                                                                          diNo: originalFreightBillList[i].diNo ??
                                                                              "",
                                                                          initiated:
                                                                              selectedRows.contains(originalFreightBillList[i].diNo)));
                                                                    } else {
                                                                      diAndInitiatedStatusList.add(DiAndInitiatedStatus(
                                                                          diNo: originalFreightBillList[i].diNo ??
                                                                              "",
                                                                          initiated:
                                                                              selectedRows.contains(originalFreightBillList[i].diNo)));
                                                                    }
                                                                  }
                                                                  List<Map<String, dynamic>>
                                                                      jsonList =
                                                                      diAndInitiatedStatusList
                                                                          .map((item) =>
                                                                              item.toJson())
                                                                          .toList();
                                                                  // String jsonString = json.encode({"diAndInitatedStatusList": jsonList});

                                                                  final FreightBillModel
                                                                      response =
                                                                      await FreightBillApi().initiateFreightBill(
                                                                          ctx:
                                                                              context,
                                                                          diNumber:
                                                                              jsonList);
                                                                  originalFreightBillList =
                                                                      response.responseList ??
                                                                          [];
                                                                  if (originalFreightBillList
                                                                      .isNotEmpty) {
                                                                    FreightBillApi()
                                                                        .getInitiatedAndUpdatedDiDetails(
                                                                            ctx:
                                                                                context)
                                                                        .then(
                                                                            (response) {
                                                                      initiatedFreightBillList =
                                                                          response.responseList ??
                                                                              [];
                                                                      if (response
                                                                              .responseList ==
                                                                          null) {
                                                                        // debugPrint(
                                                                        //     "something it is not right");
                                                                        frieghtBillListResponseList
                                                                            .value
                                                                            .clear();
                                                                        frieghtBillListResponseList1
                                                                            .value
                                                                            .clear();
                                                                        return;
                                                                      }
                                                                      frieghtBillListResponseList
                                                                              .value =
                                                                          convertDeliveryItemsToFreightBillModelResponseList(
                                                                              initiatedFreightBillList);
                                                                      frieghtBillListResponseList1.value = getCurrentPageItems(
                                                                          frieghtBillListResponseList
                                                                              .value,
                                                                          currentPage);
                                                                      counterForUpdtedDi =
                                                                          0;

                                                                      tollTaxController
                                                                          .clear();
                                                                      othersController
                                                                          .clear();
                                                                      remarkController
                                                                          .clear();
                                                                      shortageQtyController
                                                                          .clear();
                                                                      grossWeightController
                                                                          .clear();
                                                                      tareWeightController
                                                                          .clear();
                                                                      netWeightController
                                                                          .clear();
                                                                      tyreAmtController
                                                                          .clear();
                                                                      uomSwitchList
                                                                          .clear();

                                                                      for (int i =
                                                                              0;
                                                                          i < initiatedFreightBillList.length;
                                                                          i++) {
                                                                        if (initiatedFreightBillList[i].dataUpdated ==
                                                                            true) {
                                                                          counterForUpdtedDi++;
                                                                        }
                                                                        uomSwitchList
                                                                            .add(ValueNotifier(false));

                                                                        tollTaxController.add(DoubleNumericTextEditingController(
                                                                            text:
                                                                                initiatedFreightBillList[i].tollTax));
                                                                        kataController.add(DoubleNumericTextEditingController(
                                                                            text:
                                                                                initiatedFreightBillList[i].kata));
                                                                        othersController.add(DoubleNumericTextEditingController(
                                                                            text:
                                                                                initiatedFreightBillList[i].other));
                                                                        remarkController.add(LimitedLengthTextController(
                                                                            text:
                                                                                initiatedFreightBillList[i].remarks));
                                                                        shortageQtyController.add(DoubleNumericTextEditingController(
                                                                            text:
                                                                                (initiatedFreightBillList[i].shortageQty ?? 0) * 1000));
                                                                        grossWeightController.add(DoubleNumericTextEditingController(
                                                                            text:
                                                                                initiatedFreightBillList[i].grossWeight));
                                                                        tareWeightController.add(DoubleNumericTextEditingController(
                                                                            text:
                                                                                initiatedFreightBillList[i].tareWeight));
                                                                        netWeightController.add(DoubleNumericTextEditingController(
                                                                            text:
                                                                                (double.parse(initiatedFreightBillList[i].grossWeight.toString()) - double.parse(initiatedFreightBillList[i].tareWeight.toString()))));
                                                                        netWeight =
                                                                            (ValueNotifier((double.parse(initiatedFreightBillList[i].grossWeight.toString()) -
                                                                                double.parse(initiatedFreightBillList[i].tareWeight.toString()))));

                                                                        tyreAmtController.add(DoubleNumericTextEditingController(
                                                                            text:
                                                                                initiatedFreightBillList[i].tyreAmount));
                                                                      }
                                                                      if (initiatedFreightBillList
                                                                              .length ==
                                                                          counterForUpdtedDi) {
                                                                        processBill.value =
                                                                            true;
                                                                        processButton.value =
                                                                            true;
                                                                      }
                                                                    });
                                                                    currentPage =
                                                                        1;
                                                                    refreshed
                                                                            .value =
                                                                        true;
                                                                  }
                                                                })
                                                            : button(
                                                                btnText:
                                                                    "Process Freight Bill",
                                                                btnClr: Colors
                                                                    .white,
                                                                btnTxtClr:
                                                                    Colors
                                                                        .white,
                                                                tapFunction:
                                                                    null));
                                                      })
                                            ],
                                          )),
                                    )
                                  ],
                                ))),
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

  ValueListenableBuilder<List<FrieghtBillModelResponseList>>
      buildValueListenableBuilder() {
    return ValueListenableBuilder(
      valueListenable: frieghtBillListResponseList,
      builder: (BuildContext context, List<FrieghtBillModelResponseList> value,
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

  void checkInitiated() async {
    bool initiated = await fetchInitiated();
    if (initiated) {
      showContinueDialog(
          "Do you want to continue with the existing selections? In case of 'No' any previous initiations will be cleared.  ");
    }
  }

// Date initialization with frozen period check and configurable financial year end date
  void initializeDates({String? financialYearEndDate}) {
    debugPrint("initializing");
    DateTime currentDate = DateTime.now();

    // Parse the financial year end date if provided
    DateTime? fyEndDate;
    if (financialYearEndDate != null && financialYearEndDate.isNotEmpty) {
      try {
        fyEndDate = DateFormat('dd/MM/yyyy').parse(financialYearEndDate);
        debugPrint("Using financial year end date: $fyEndDate");
      } catch (e) {
        debugPrint("Error parsing financial year end date: $e");
      }
    }

    // Default to March 31st if no financial year end date is provided
    fyEndDate ??= DateTime(currentDate.year, 3, 31);

    // Create a FY end date for the current year
    DateTime fyEndCurrentYear =
        DateTime(currentDate.year, fyEndDate.month, fyEndDate.day);

    // Calculate first day of new financial year (day after FY end)
    DateTime firstDayOfNewFY = fyEndCurrentYear.add(const Duration(days: 1));

    // First month of financial year (the month after FY end date)
    int firstMonthOfFY = fyEndDate.month < 12 ? fyEndDate.month + 1 : 1;
    debugPrint("First month of financial year: $firstMonthOfFY");

    // From Date initialization
    if (sp?.getString("fromDate1") != null) {
      fromDateController.text = sp!.getString("fromDate1")!;
    } else {
      // Calculate first day of new financial year (day after FY end)
      DateTime firstDayOfNewFY = fyEndCurrentYear.add(const Duration(days: 1));

      // Check if frozen period exists
      if (frozenPeriodDate != null && frozenPeriodDate!.isNotEmpty) {
        try {
          DateTime frozenDate =
              DateFormat('dd/MM/yyyy').parse(frozenPeriodDate!);

          // Convert to date-only format to compare just the dates without time
          DateTime currentDateOnly =
              DateTime(currentDate.year, currentDate.month, currentDate.day);
          DateTime frozenDateOnly =
              DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

          debugPrint(
              "Date comparison: currentDateOnly $currentDateOnly, frozenDateOnly $frozenDateOnly");

          // If current date is AFTER frozen period date
          if (currentDateOnly.isAfter(frozenDateOnly)) {
            // Past frozen period - initialize from date to first day of new financial year
            fromDateController.text =
                DateFormat('dd/MM/yyyy').format(firstDayOfNewFY);
            debugPrint(
                "Past frozen period: setting from date to first day of new FY: $firstDayOfNewFY");
          }
          // If still in frozen period or on frozen period date
          else if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
              currentDateOnly.isBefore(frozenDateOnly)) {
            // If under frozen period and current date is past FY end date
            if (currentDate.isAfter(fyEndCurrentYear)) {
              // Still in frozen period but past FY end - use first day of FY end month
              fromDateController.text = DateFormat('dd/MM/yyyy')
                  .format(DateTime(currentDate.year, fyEndDate.month, 1));
              debugPrint(
                  "In frozen period, after FY end: setting from date to first day of FY end month: ${fyEndDate.month}/01");
            } else {
              // In frozen period and before/at FY end - use first day of current month
              fromDateController.text = DateFormat('dd/MM/yyyy')
                  .format(DateTime(currentDate.year, currentDate.month, 1));
              debugPrint(
                  "In frozen period, before/at FY end: setting from date to first day of current month");
            }
          }
        } catch (e) {
          debugPrint("Error parsing frozen date during initialization: $e");
          // Fallback to normal case - first day of current month
          fromDateController.text = DateFormat('dd/MM/yyyy')
              .format(DateTime(currentDate.year, currentDate.month, 1));
        }
      } else {
        // No frozen period - use current month's first day
        fromDateController.text = DateFormat('dd/MM/yyyy')
            .format(DateTime(currentDate.year, currentDate.month, 1));
        debugPrint(
            "No frozen period: setting from date to first day of current month");
      }
    }

    // To Date initialization
    if (sp?.getString("toDate1") != null) {
      toDateController.text = sp!.getString("toDate1")!;
    } else {
      // Check if frozen period exists and is applicable
      if (frozenPeriodDate != null && frozenPeriodDate!.isNotEmpty) {
        try {
          DateTime frozenDate =
              DateFormat('dd/MM/yyyy').parse(frozenPeriodDate!);

          // Convert to date-only format to compare just the dates without time
          DateTime currentDateOnly =
              DateTime(currentDate.year, currentDate.month, currentDate.day);
          DateTime frozenDateOnly =
              DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

          // Compare dates without time component
          if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
              currentDateOnly.isBefore(frozenDateOnly)) {
            // For FY end date of current financial year:

            // Determine which date to use based on frozen period and FY end date

            // Check from date to maintain same financial year constraint
            DateTime fromDate =
                DateFormat('dd/MM/yyyy').parse(fromDateController.text);
            bool fromDateIsBeforeFYEnd = fromDate.isBefore(fyEndCurrentYear) ||
                fromDate.isAtSameMomentAs(fyEndCurrentYear);

            // No matter what, never set a date in the future
            if (fyEndCurrentYear.isAfter(currentDate)) {
              // If FY end date is still in the future
              if (fromDateIsBeforeFYEnd) {
                // From date is in current FY, use current date as to date
                toDateController.text =
                    DateFormat('dd/MM/yyyy').format(currentDate);
                debugPrint(
                    "Setting to current date: $currentDate (FY end date is in future, from date in current FY)");
              } else {
                // From date is in next FY (shouldn't happen normally),
                // use from date to maintain FY consistency
                toDateController.text =
                    DateFormat('dd/MM/yyyy').format(fromDate);
                debugPrint(
                    "Setting to from date: $fromDate (to maintain FY consistency)");
              }
            } else if (currentDate.isAfter(fyEndCurrentYear)) {
              // We're past FY end with frozen period
              if (fromDateIsBeforeFYEnd) {
                // From date is in previous FY, cap to date to FY end
                toDateController.text =
                    DateFormat('dd/MM/yyyy').format(fyEndCurrentYear);
                debugPrint(
                    "Setting to FY end date: $fyEndCurrentYear (from date in previous FY)");
              } else {
                // From date is in current FY, use current date
                toDateController.text =
                    DateFormat('dd/MM/yyyy').format(currentDate);
                debugPrint(
                    "Setting to current date: $currentDate (from date in current FY)");
              }
            } else {
              // We're at FY end date exactly
              toDateController.text =
                  DateFormat('dd/MM/yyyy').format(currentDate);
              debugPrint("Setting to current date: $currentDate (at FY end)");
            }
          } else {
            // Normal case - current date
            toDateController.text =
                DateFormat('dd/MM/yyyy').format(currentDate);
            debugPrint("Normal case: current date");
          }
        } catch (e) {
          debugPrint("Error parsing frozen date during initialization: $e");
          // Fallback to normal case
          toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
        }
      } else {
        // Normal case - current date
        toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
      }
    }
  }

  static const int maximumDateRange = 90;

  Future<void> selectFromDate(
      BuildContext context,
      TextEditingController fromDateController,
      TextEditingController toDateController,
      {String? frozenPeriodDate,
      String? financialYearEndDate}) async {
    DateTime currentDate = DateTime.now();
    DateTime threeMonthsAgo =
        currentDate.subtract(const Duration(days: maximumDateRange));
    DateTime firstDate = threeMonthsAgo;
    DateTime lastDate = currentDate;

    // Parse the financial year end date if provided
    DateTime? fyEndDate;
    if (financialYearEndDate != null && financialYearEndDate.isNotEmpty) {
      try {
        fyEndDate = DateFormat('dd/MM/yyyy').parse(financialYearEndDate);
      } catch (e) {
        debugPrint("Error parsing financial year end date: $e");
      }
    }

    // Default to March 31st of current year if no financial year end date is provided
    fyEndDate ??= DateTime(currentDate.year, 3, 31);

    // Check if we're in the frozen period
    if (frozenPeriodDate != null && frozenPeriodDate.isNotEmpty) {
      try {
        DateTime frozenDate = DateFormat('dd/MM/yyyy').parse(frozenPeriodDate);

        // Compare dates without time component
        DateTime currentDateOnly =
            DateTime(currentDate.year, currentDate.month, currentDate.day);
        DateTime frozenDateOnly =
            DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

        debugPrint(
            "From date selector - comparing dates: $currentDateOnly vs $frozenDateOnly");

        // If current date is before or same as frozen date, restrict selection to financial year end
        if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
            currentDateOnly.isBefore(frozenDateOnly)) {
          // Get FY end date of current year
          DateTime fyEndDateCurrentYear =
              DateTime(currentDate.year, fyEndDate.month, fyEndDate.day);

          // If we're past the FY end date in the current year, then we're restricted
          if (currentDate.isAfter(fyEndDateCurrentYear)) {
            lastDate = fyEndDateCurrentYear;

            // Set firstDate to be a reasonable date within the financial year
            // (e.g., 3 months before FY end or start of the year)
            DateTime potentialFirstDate =
                fyEndDateCurrentYear.subtract(const Duration(days: 90));
            firstDate = potentialFirstDate.isAfter(threeMonthsAgo)
                ? potentialFirstDate
                : threeMonthsAgo;
          }
        }
      } catch (e) {
        debugPrint("Error parsing frozen period date: $e");
      }
    }

    // Get FY end date of current year for checking financial year boundaries
    DateTime fyEndDateCurrentYear = fyEndDate != null
        ? DateTime(currentDate.year, fyEndDate.month, fyEndDate.day)
        : DateTime(currentDate.year, 3, 31);

    // CRITICAL: Ensure lastDate is never before firstDate
    if (lastDate.isBefore(firstDate)) {
      debugPrint(
          "Warning: lastDate ($lastDate) was before firstDate ($firstDate). Adjusting firstDate.");
      // Make firstDate same as lastDate or earlier
      firstDate = DateTime(
          lastDate.year, lastDate.month - 2 > 0 ? lastDate.month - 2 : 1, 1);
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: min(
          DateTime.parse(DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd/MM/yyyy').parse(fromDateController.text))),
          lastDate),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      fromDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      debugPrint("Selected from date: $pickedDate");

      // Auto-adjust the to date if needed for financial year compliance
      DateTime toDate = DateFormat('dd/MM/yyyy').parse(toDateController.text);

      // Check which financial year the picked date belongs to
      bool pickedDateIsBeforeFYEnd =
          pickedDate.isBefore(fyEndDateCurrentYear) ||
              pickedDate.isAtSameMomentAs(fyEndDateCurrentYear);
      bool toDateIsBeforeFYEnd = toDate.isBefore(fyEndDateCurrentYear) ||
          toDate.isAtSameMomentAs(fyEndDateCurrentYear);

      // CRITICAL CONSTRAINT: Ensure from date and to date are in the same financial year
      if (pickedDateIsBeforeFYEnd != toDateIsBeforeFYEnd) {
        debugPrint(
            "From date and to date are in different financial years. Adjusting to date.");

        // If they're in different financial years, adjust the to date
        if (pickedDateIsBeforeFYEnd) {
          // If from date is before FY end, to date must also be before FY end
          // Set to date to exactly the FY end date
          toDateController.text =
              DateFormat('dd/MM/yyyy').format(fyEndDateCurrentYear);
          debugPrint(
              "From date is before FY end, setting to date to FY end: $fyEndDateCurrentYear");
        } else {
          // If from date is after FY end, to date must also be after FY end
          // Find the day after FY end
          DateTime dayAfterFYEnd =
              fyEndDateCurrentYear.add(const Duration(days: 1));

          // If from date is after the day after FY end, use from date as to date
          if (pickedDate.isAfter(dayAfterFYEnd)) {
            toDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
            debugPrint(
                "From date is after day after FY end, setting to date to from date");
          } else {
            // Otherwise use day after FY end as to date
            toDateController.text =
                DateFormat('dd/MM/yyyy').format(currentDate);
            debugPrint(
                "From date is after FY end, setting to date to day after FY end");
          }
        }
      } else if (toDate.isBefore(pickedDate)) {
        // To date is before from date but they're in the same financial year
        debugPrint(
            "To date is before from date but in same financial year. Adjusting.");

        // If picked date is at or before FY end date, to date cannot exceed FY end
        if (pickedDateIsBeforeFYEnd) {
          // Set to date to min of current date and FY end date
          DateTime maxToDate = min(currentDate, fyEndDateCurrentYear);
          toDateController.text = DateFormat('dd/MM/yyyy').format(maxToDate);
          debugPrint(
              "Setting to date to: $maxToDate (min of current date and FY end)");
        } else {
          // Otherwise set to date to current date
          toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
          debugPrint("Setting to date to current date: $currentDate");
        }
      }
    }
  }

  Future<void> selectToDate(
      BuildContext context,
      TextEditingController toDateController,
      TextEditingController fromDateController,
      {String? frozenPeriodDate,
      String? financialYearEndDate}) async {
    DateTime currentDate = DateTime.now();
    DateTime fromDate = DateFormat('dd/MM/yyyy').parse(fromDateController.text);
    DateTime lastDate = currentDate;

    // Parse the financial year end date if provided
    DateTime? fyEndDate;
    if (financialYearEndDate != null && financialYearEndDate.isNotEmpty) {
      try {
        fyEndDate = DateFormat('dd/MM/yyyy').parse(financialYearEndDate);
      } catch (e) {
        debugPrint("Error parsing financial year end date: $e");
      }
    }

    // Default to March 31st of current year if no financial year end date is provided
    fyEndDate ??= DateTime(currentDate.year, 3, 31);

    // Get FY end date of current year
    DateTime fyEndDateCurrentYear =
        DateTime(currentDate.year, fyEndDate.month, fyEndDate.day);

    // IMPORTANT: Check which financial year the from date belongs to
    bool fromDateIsBeforeFYEnd = fromDate.isBefore(fyEndDateCurrentYear) ||
        fromDate.isAtSameMomentAs(fyEndDateCurrentYear);

    // If from date is before or equal to FY end date, restrict to date to also be before or equal to FY end date
    if (fromDateIsBeforeFYEnd) {
      // This is the critical constraint: To date cannot go beyond FY end date if from date is in previous FY
      lastDate = min(lastDate, fyEndDateCurrentYear);
      debugPrint(
          "Restricting lastDate to FY end date ($fyEndDateCurrentYear) because from date is in previous FY");
    } else {
      // From date is after FY end date, so ensure to date is also after FY end date
      // This is handled by setting firstDate to fromDate as done below
      debugPrint("From date is in current FY, allowing to date up to current date");
    }

    // Check if we're in the frozen period - this adds additional restrictions during frozen period
    if (frozenPeriodDate != null && frozenPeriodDate.isNotEmpty) {
      try {
        DateTime frozenDate = DateFormat('dd/MM/yyyy').parse(frozenPeriodDate);

        // Compare dates without time component
        DateTime currentDateOnly =
            DateTime(currentDate.year, currentDate.month, currentDate.day);
        DateTime frozenDateOnly =
            DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

        // If current date is before or same as frozen date, apply frozen period restrictions
        if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
            currentDateOnly.isBefore(frozenDateOnly)) {
          // During frozen period, if from date is in previous FY, restrict even more strictly to FY end
          if (fromDateIsBeforeFYEnd) {
            lastDate = min(lastDate, fyEndDateCurrentYear);
            debugPrint(
                "Frozen period adds restriction: to date cannot exceed FY end date");
          }
        }
      } catch (e) {
        debugPrint("Error parsing frozen period date: $e");
      }
    }

    // CRITICAL: Ensure firstDate is never after lastDate
    if (fromDate.isAfter(lastDate)) {
      debugPrint(
          "Warning: fromDate ($fromDate) is after lastDate ($lastDate). Adjusting lastDate.");
      // Make lastDate same as fromDate in this exceptional case
      lastDate = fromDate;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: min(
          DateTime.parse(DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd/MM/yyyy').parse(toDateController.text))),
          lastDate),
      firstDate: fromDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      // Set the to date
      toDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      debugPrint("Selected to date: $pickedDate");
    }
  }

// Helper function to find the minimum of two dates
  DateTime min(DateTime a, DateTime b) {
    return a.isBefore(b) ? a : b;
  }

////////////////deployed code for qa, ///month checking //working but need to make it dynamic

// static const int maximumDateRange = 90;

//  Future<void> selectFromDate(
//     BuildContext context,
//     TextEditingController fromDateController,
//     TextEditingController toDateController,
//     {String? frozenPeriodDate}) async {
//   DateTime currentDate = DateTime.now(); // Fixed date for testing
//   DateTime threeMonthsAgo =
//       currentDate.subtract(const Duration(days: maximumDateRange));
//   DateTime firstDate = threeMonthsAgo;
//   DateTime lastDate = currentDate;

//   // Case 1: Frozen Period Check
//   // If frozen period date exists and current date is before or equal to frozen period date
//   if (frozenPeriodDate != null && frozenPeriodDate.isNotEmpty) {
//     try {
//       DateTime frozenDate = DateFormat('dd/MM/yyyy').parse(frozenPeriodDate);

//        DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
//       DateTime frozenDateOnly = DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

//       debugPrint("From date selector - comparing dates: $currentDateOnly vs $frozenDateOnly");

//       if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
//           currentDateOnly.isBefore(frozenDateOnly)) {
//         // Instead of using previous year, we'll use the current year
//         DateTime marchEndDate = DateTime(currentDate.year, 3, 31);

//         // Limit lastDate to March 31st of current year if applicable
//         if (currentDate.month >= 4) {
//           // We're in April or later, so March 31 is in the past
//           lastDate = marchEndDate;

//           // IMPORTANT FIX: When setting lastDate to March 31,
//           // we must ensure firstDate isn't after that
//           // Set firstDate to Jan 1 of current year to ensure a valid range
//           DateTime marchFirst = threeMonthsAgo;
//           firstDate = marchFirst;
//         }
//       }
//     } catch (e) {
//       debugPrint("Error parsing frozen period date: $e");
//     }
//   }

//   // CRITICAL: Ensure lastDate is never before firstDate
//   if (lastDate.isBefore(firstDate)) {
//     debugPrint("Warning: lastDate ($lastDate) was before firstDate ($firstDate). Adjusting firstDate.");
//     // Make firstDate same as lastDate or earlier
//     firstDate = DateTime(lastDate.year, lastDate.month - 2 > 0 ? lastDate.month - 2 : 1, 1);
//   }

//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     initialDate: min(
//         DateTime.parse(DateFormat('yyyy-MM-dd')
//             .format(DateFormat('dd/MM/yyyy').parse(fromDateController.text))),
//         lastDate),
//     firstDate: firstDate,
//     lastDate: lastDate,
//   );

//   if (pickedDate != null) {
//     fromDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);

//     // Auto-adjust the to date if needed for financial year compliance
//     DateTime toDate = DateFormat('dd/MM/yyyy').parse(toDateController.text);

//     // Case 2: Check month-based constraints without changing year
//     if (pickedDate.month < 4 && currentDate.month >= 4) {
//       // If selected date is Jan-Mar but current date is Apr+,
//       // cap to date to March 31 of current year
//       DateTime marchEndDate = DateTime(currentDate.year, 3, 31);
//       toDateController.text = DateFormat('dd/MM/yyyy').format(marchEndDate);
//     }
//     // If the to date is now before from date, adjust to date
//     else if (toDate.isBefore(pickedDate)) {
//       // If frozen period is active, set to date to the last date
//       if (frozenPeriodDate != null && frozenPeriodDate.isNotEmpty) {
//         DateTime frozenDate =
//             DateFormat('dd/MM/yyyy').parse(frozenPeriodDate);

//                // Compare dates without time component
//         DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
//         DateTime frozenDateOnly = DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

//         if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
//             currentDateOnly.isBefore(frozenDateOnly)) {
//           toDateController.text = DateFormat('dd/MM/yyyy').format(lastDate);
//         } else {
//           toDateController.text =
//               DateFormat('dd/MM/yyyy').format(currentDate);
//         }
//       } else {
//         toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
//       }
//     }
//   }
// }

//   Future<void> selectToDate(
//       BuildContext context,
//       TextEditingController toDateController,
//       TextEditingController fromDateController,
//       {String? frozenPeriodDate}) async {
//     DateTime currentDate = DateTime.now(); // Fixed date for testing
//     DateTime fromDate = DateFormat('dd/MM/yyyy').parse(fromDateController.text);
//     DateTime lastDate = currentDate;

//     // Case 1: Frozen Period Check
//     // If frozen period date exists and current date is before or equal to frozen period date
//     if (frozenPeriodDate != null && frozenPeriodDate.isNotEmpty) {
//       try {
//         DateTime frozenDate = DateFormat('dd/MM/yyyy').parse(frozenPeriodDate);
//       // Convert to date-only format to compare just the dates without time
//       DateTime currentDateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
//       DateTime frozenDateOnly = DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

//       if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
//           currentDateOnly.isBefore(frozenDateOnly)) {

//           // Use March 31st of current year instead of previous year
//           DateTime marchEndDate = DateTime(currentDate.year, 3, 31);

//           // Only limit if we're past March (in Apr+)
//           if (currentDate.month >= 4) {
//             lastDate = marchEndDate;
//           }
//         }
//       } catch (e) {
//         debugPrint("Error parsing frozen period date: $e");
//       }
//     }

//     // Case 2: Financial Year Constraint - simplified to just check months
//     // If from date is in Jan-Mar and current date is in Apr+
//     if (fromDate.month < 4 && currentDate.month >= 4) {
//       // Cap the lastDate to March 31st of the current year
//       DateTime marchEndDate = DateTime(currentDate.year, 3, 31);
//       lastDate = marchEndDate.isBefore(lastDate) ? marchEndDate : lastDate;
//     }

//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: min(
//           DateTime.parse(DateFormat('yyyy-MM-dd')
//               .format(DateFormat('dd/MM/yyyy').parse(toDateController.text))),
//           lastDate),
//       firstDate: fromDate,
//       lastDate: lastDate,
//     );

//     if (pickedDate != null) {
//       toDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
//     }
//   }

//   // Helper function to find the minimum of two dates
//   DateTime min(DateTime a, DateTime b) {
//     return a.isBefore(b) ? a : b;
//   }

  // Reset function to restore default date selections
  void resetDateSelections({String? financialYearEndDate}) {
    debugPrint("Resetting date selections");

    // Clear any saved preferences
    if (sp != null) {
      sp!.remove("fromDate1");
      sp!.remove("toDate1");
    }

    // Get current date for calculations
    DateTime currentDate = DateTime.now(); // Use actual current date for reset

    // Parse the financial year end date if provided
    DateTime? fyEndDate;
    if (financialYearEndDate != null && financialYearEndDate.isNotEmpty) {
      try {
        fyEndDate = DateFormat('dd/MM/yyyy').parse(financialYearEndDate);
        debugPrint("Using financial year end date: $fyEndDate");
      } catch (e) {
        debugPrint("Error parsing financial year end date: $e");
      }
    }

    // Default to March 31st if no financial year end date is provided
    fyEndDate ??= DateTime(currentDate.year, 3, 31);

    // Create a FY end date for the current year
    DateTime fyEndCurrentYear =
        DateTime(currentDate.year, fyEndDate.month, fyEndDate.day);

    // Calculate first day of new financial year (day after FY end)
    DateTime firstDayOfNewFY = fyEndCurrentYear.add(const Duration(days: 1));

    // Reset From Date
    if (frozenPeriodDate != null && frozenPeriodDate!.isNotEmpty) {
      try {
        DateTime frozenDate = DateFormat('dd/MM/yyyy').parse(frozenPeriodDate!);

        // Convert to date-only format to compare just the dates without time
        DateTime currentDateOnly =
            DateTime(currentDate.year, currentDate.month, currentDate.day);
        DateTime frozenDateOnly =
            DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

        // If current date is AFTER frozen period date
        if (currentDateOnly.isAfter(frozenDateOnly)) {
          // Past frozen period - initialize from date to first day of new financial year
          fromDateController.text =
              DateFormat('dd/MM/yyyy').format(firstDayOfNewFY);
          debugPrint(
              "Past frozen period: resetting from date to first day of new FY: $firstDayOfNewFY");
        }
        // If still in frozen period or on frozen period date
        else if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
            currentDateOnly.isBefore(frozenDateOnly)) {
          // If under frozen period and current date is past FY end date
          if (currentDate.isAfter(fyEndCurrentYear)) {
            // Still in frozen period but past FY end - use first day of FY end month
            fromDateController.text = DateFormat('dd/MM/yyyy')
                .format(DateTime(currentDate.year, fyEndDate.month, 1));
            debugPrint(
                "In frozen period, after FY end: resetting from date to first day of FY end month: ${fyEndDate.month}/01");
          } else {
            // In frozen period and before/at FY end - use first day of current month
            fromDateController.text = DateFormat('dd/MM/yyyy')
                .format(DateTime(currentDate.year, currentDate.month, 1));
            debugPrint(
                "In frozen period, before/at FY end: resetting from date to first day of current month");
          }
        }
      } catch (e) {
        debugPrint("Error parsing frozen date during reset: $e");
        // Fallback to normal case - first day of current month
        fromDateController.text = DateFormat('dd/MM/yyyy')
            .format(DateTime(currentDate.year, currentDate.month, 1));
      }
    } else {
      // No frozen period - use current month's first day
      fromDateController.text = DateFormat('dd/MM/yyyy')
          .format(DateTime(currentDate.year, currentDate.month, 1));
      debugPrint(
          "No frozen period: resetting from date to first day of current month");
    }

    // Reset To Date
    // First, get the from date that was just set
    DateTime fromDate = DateFormat('dd/MM/yyyy').parse(fromDateController.text);

    if (frozenPeriodDate != null && frozenPeriodDate!.isNotEmpty) {
      try {
        DateTime frozenDate = DateFormat('dd/MM/yyyy').parse(frozenPeriodDate!);

        // Convert to date-only format to compare just the dates without time
        DateTime currentDateOnly =
            DateTime(currentDate.year, currentDate.month, currentDate.day);
        DateTime frozenDateOnly =
            DateTime(frozenDate.year, frozenDate.month, frozenDate.day);

        // If current date is AFTER frozen period date
        if (currentDateOnly.isAfter(frozenDateOnly)) {
          // Past frozen period - initialize to date to current date
          toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
          debugPrint(
              "Past frozen period: resetting to date to current date: $currentDate");
        }
        // If still in frozen period or on frozen period date
        else if (currentDateOnly.isAtSameMomentAs(frozenDateOnly) ||
            currentDateOnly.isBefore(frozenDateOnly)) {
          // Check which financial year the from date belongs to
          bool fromDateIsBeforeFYEnd = fromDate.isBefore(fyEndCurrentYear) ||
              fromDate.isAtSameMomentAs(fyEndCurrentYear);

          // If from date is before or at FY end, to date must also be before or at FY end
          if (fromDateIsBeforeFYEnd) {
            // Cap to date to FY end date
            if (currentDate.isBefore(fyEndCurrentYear)) {
              // If current date is before FY end, use current date
              toDateController.text =
                  DateFormat('dd/MM/yyyy').format(currentDate);
              debugPrint(
                  "In frozen period, from date in previous FY, current date before FY end: resetting to date to current date");
            } else {
              // Current date is after FY end, cap to FY end date
              toDateController.text =
                  DateFormat('dd/MM/yyyy').format(fyEndCurrentYear);
              debugPrint(
                  "In frozen period, from date in previous FY, current date after FY end: resetting to date to FY end date");
            }
          } else {
            // From date is after FY end, to date should be at least day after FY end
            if (currentDate.isBefore(fromDate)) {
              // Current date is before from date (shouldn't happen), use from date
              toDateController.text = DateFormat('dd/MM/yyyy').format(fromDate);
              debugPrint(
                  "In frozen period, from date after FY end, current date before from date: resetting to date to from date");
            } else {
              // Current date is after from date, use current date
              toDateController.text =
                  DateFormat('dd/MM/yyyy').format(currentDate);
              debugPrint(
                  "In frozen period, from date after FY end, current date after from date: resetting to date to current date");
            }
          }
        }
      } catch (e) {
        debugPrint("Error parsing frozen date during reset: $e");
        // Fallback to normal case - current date
        toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
      }
    } else {
      // No frozen period - use current date, but respect financial year boundaries
      bool fromDateIsBeforeFYEnd = fromDate.isBefore(fyEndCurrentYear) ||
          fromDate.isAtSameMomentAs(fyEndCurrentYear);

      if (fromDateIsBeforeFYEnd) {
        // From date is in previous FY, cap to date to FY end if needed
        if (currentDate.isAfter(fyEndCurrentYear)) {
          toDateController.text =
              DateFormat('dd/MM/yyyy').format(fyEndCurrentYear);
          debugPrint(
              "No frozen period, from date in previous FY, current date after FY end: resetting to date to FY end date");
        } else {
          toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
          debugPrint(
              "No frozen period, from date in previous FY, current date before FY end: resetting to date to current date");
        }
      } else {
        // From date is in current FY, use current date
        toDateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
        debugPrint(
            "No frozen period, from date in current FY: resetting to date to current date");
      }
    }

    // Optionally, you can add notification to refresh UI
    // setState(() {}); // If this function is within a StatefulWidget
  }
}
