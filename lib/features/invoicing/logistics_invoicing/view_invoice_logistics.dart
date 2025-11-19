// // ignore_for_file: avoid_print
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shreecement/features/biddingProcess/api/transporter_apis.dart';
// import 'package:shreecement/features/biddingProcess/models/transporter_action_model.dart';
// import 'package:shreecement/features/biddingprocesslogisitc/StartBidFgs.dart';
// import 'package:shreecement/features/common/controller/controller.dart';
// import 'package:shreecement/features/common/controller/numeric.dart';
// import 'package:shreecement/features/common/models/business_rules.dart';
// import 'package:shreecement/features/common/screens/token_expire.dart';
// import 'package:shreecement/features/common/table/table_widgets.dart';
// import 'package:shreecement/features/common/widgets/custom_dropdown_3.dart';
// import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
// import 'package:shreecement/features/common/widgets/custom_table.dart';
// import 'package:shreecement/features/common/widgets/customdropdownprebid.dart';
// import 'package:shreecement/features/common/widgets/invoice_dialogebox.dart';
// import 'package:shreecement/features/invoicing/invoice_page.dart';
// import 'package:shreecement/features/preBidding/apiModels/states.dart';
// import 'package:shreecement/main.dart';
// import 'package:shreecement/utils/color_constant.dart';
// import 'package:shreecement/features/preBidding/api/states_list_api.dart';
// import 'package:shreecement/features/preBidding/api/district_list_api.dart';

// class ViewInvoiceLogistics extends StatefulWidget {
//   const ViewInvoiceLogistics({super.key});

//   @override
//   State<ViewInvoiceLogistics> createState() => _ViewInvoiceLogisticsState();
// }

// class _ViewInvoiceLogisticsState extends State<ViewInvoiceLogistics> {
//   bool switchOn = false;
//   final Controller control = Get.find(); // Access the controller
//   ValueNotifier switchState = ValueNotifier(false);
//   List<ValueNotifier<num>> newFrtAmt = [];
//   List<ValueNotifier<bool>> incDecFrtSwitchList = [];
//   List<String> newFrtRemark = [];
//   List<ValueNotifier<bool>> savedSuccess = [];
//   List<NumericTextEditingController> extraFrtTextController = [];
//   List<TextEditingController> remarkTextController = [];

//   ValueNotifier enabled = ValueNotifier(false);

//   ValueNotifier<MapEntry<String, String>> selectedState =
//       ValueNotifier(const MapEntry("", ""));
//   ValueNotifier<MapEntry<String, String>> selectedDistrict =
//       ValueNotifier(const MapEntry("", ""));
//   ValueNotifier<MapEntry<String, String>> selectedCity =
//       ValueNotifier(const MapEntry("", ""));

//   late String plantId;
//   late String division;
//   late int countdownEndTime;
//   late BusinessRules businesrules;
//   late ResponseListOfBusinessRules listofbusinessrules;
//   late double? frtLowerTol;
//   late double? frtHigherTol;
//   List<TransporterBid2ModelResponseList> originalTransport2List = [];
//   ValueNotifier<List<TransporterBid2ModelResponseList>>
//       transporterBID2ListResponseList = ValueNotifier([]);
//   ValueNotifier<List<TransporterBid2ModelResponseList>>
//       transporterBID2ListResponseList1 = ValueNotifier([]);

//   double enteredValue = 0;
//   bool saved = false;
//   late DateTime scheduledTime;

//   Future<void> showResultDialog(String message) async {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Message'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     plantId = control.preBid2PlantId.value;
//     // fetchBusinessLogic();
//     // fetchTransportActionList();
//   }

//   // fetchBusinessLogic() async {
//   //   businesrules = await BusinessLogic()
//   //       .getbusinesslogiclist(plantCode: sp!.getString("plantCode").toString());

//   //   frtLowerTol = businesrules.responseList![0].frtLowerTol!;
//   //   print(frtLowerTol);
//   //   frtHigherTol = businesrules.responseList![0].frtHigherTol!;
//   // }

//   // int currentPage = 1;
//   // int pageSize = int.parse(selectedDropdownValue);
//   // List<TransporterBid2ModelResponseList> getCurrentPageItems(
//   //     List<TransporterBid2ModelResponseList> items, int currentPage) {
//   //   transporterBID2ListResponseList.value = items;
//   //   final startIndex = (currentPage - 1) * pageSize;
//   //   final endIndex = startIndex + pageSize > items.length
//   //       ? items.length
//   //       : startIndex + pageSize;
//   //   List<TransporterBid2ModelResponseList> a =
//   //       items.sublist(startIndex, endIndex);
//   //   extraFrt.clear();
//   //   newFrtAmt.clear();
//   //   incDecFrtSwitchList.clear();
//   //   newFrtRemark.clear();
//   //   savedSuccess.clear();
//   //   extraFrtTextController.clear();
//   //   remarkTextController.clear();
//   //   for (var element in a) {
//   //     extraFrt.add(0);
//   //     newFrtAmt.add(ValueNotifier(element.basicFrtAmount ?? 0.0));
//   //     incDecFrtSwitchList.add(ValueNotifier(false));
//   //     newFrtRemark.add("");
//   //     savedSuccess.add(ValueNotifier(false));
//   //     extraFrtTextController
//   //         .add(NumericTextEditingController(text: element.bidRate));
//   //     remarkTextController.add(
//   //       TextEditingController(text: element.soBiddingRemarks),
//   //     );
//   //   }

//   //   return a;
//   // }
//   ValueNotifier<String> selectedDivision = ValueNotifier("CEMENT");
//   String? seldivison;
//   fetchTransportActionList() async {
//     try {
//       final TransporterBid2Model response = await TransporterApi()
//           .getTransport2DataFromAPI(
//               ctx: context,
//               employeeCode: sp?.getString("employeeCode") ?? "",
//               plantId: sp!.getInt("plantId")!,
//               division: sp!.getString("division")!);
//       originalTransport2List = response.responseList ?? [];

//       // transporterBID2ListResponseList1.value =
//       //     getCurrentPageItems(originalTransport2List, currentPage);
//     } catch (e) {
//       // print("error in fetch data $e");
//     }
//   }

//   void filterData(String searchTerm) {
//     if (searchTerm.isEmpty) {
//       // transporterBID2ListResponseList1.value =
//       //     getCurrentPageItems(originalTransport2List, currentPage);
//       return;
//     }

//     List<TransporterBid2ModelResponseList> filteredData = originalTransport2List
//         .where((value) =>
//             value.cityName
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchTerm.toLowerCase()) ||
//             value.districtName
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchTerm.toLowerCase()) ||
//             value.diQty
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchTerm.toLowerCase()) ||
//             value.basicFrtAmount
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchTerm.toLowerCase()) ||
//             value.customerName
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchTerm.toLowerCase()) ||
//             value.diNumber
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchTerm.toLowerCase()) ||
//             value.brand
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchTerm.toLowerCase()) ||
//             value.product
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchTerm.toLowerCase()) ||
//             value.soBiddingRemarks
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchTerm.toLowerCase()) ||
//             value.diType
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchTerm.toLowerCase()))
//         .toList();

//     // transporterBID2ListResponseList1.value =
//     //     getCurrentPageItems(filteredData, currentPage);
//   }

//   List<TransporterBid2ModelResponseList> responselist = [];
//   // int? index1;

//   final TextEditingController fromDateController = TextEditingController();
//   final TextEditingController toDateController = TextEditingController();
//   @override
//   void dispose() {
//     fromDateController.dispose();
//     toDateController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final dynamicSize = ((size.width - 312 + 20) * (100 / 9)) / 100;
//     return CustomScaffold(
//       appBarText: "Invoicing > View Invoice ",
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'View Invoice',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.w300,
//                   height: 0,
//                 ),
//               ),
//               vSpace(20),

//               tableHeading(
//                 heading: "Search Bill",
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             FutureBuilder<States>(
//                                 future: StatesListAPI().getStatesListFromAPI(),
//                                 builder: (stateIndex, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return CircularProgressIndicator(
//                                       color: ColorConstant.redbar,
//                                     );
//                                   } else if (snapshot.hasData) {
//                                     final List responseList =
//                                         snapshot.data?.responseList ?? [];
//                                     Map<String, String> map = {};
//                                     map["All"] = "All";

//                                     for (var element in responseList) {
//                                       map[element.stateName] =
//                                           element.stateCode;
//                                     }
//                                     selectedState.value = map.entries.first;
//                                     return ValueListenableBuilder(
//                                       valueListenable: selectedState,
//                                       builder: (BuildContext context, data,
//                                           Widget? child) {
//                                         return Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             const Text(
//                                               "Plant",
//                                               style: TextStyle(
//                                                   color: Colors.black),
//                                             ),
//                                             CustomDropdownMenu3(
//                                               selVal: selectedState.value.key,
//                                               list: map.keys.toList(),
//                                               fun: (value) {
//                                                 if (value == "All") {
//                                                   enabled.value = false;
//                                                 } else {
//                                                   enabled.value = true;
//                                                 }
//                                                 selectedState.value = MapEntry(
//                                                   value ?? "",
//                                                   map[value] ?? "",
//                                                 );
//                                               },
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     );
//                                   } else {
//                                     return const Text(
//                                         "Something is not right!");
//                                   }
//                                 }),
//                             wSpace(20),
//                             ValueListenableBuilder(
//                               valueListenable: selectedState,
//                               builder:
//                                   (BuildContext context, _, Widget? child) {
//                                 return FutureBuilder(
//                                   future:
//                                       DistrictListAPI().getDistrictsListFromAPI(
//                                     selectedState.value.key,
//                                     selectedState.value.value,
//                                   ),
//                                   builder: (districtIndex, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return CircularProgressIndicator(
//                                         color: ColorConstant.redbar,
//                                       );
//                                     } else if (snapshot.hasData) {
//                                       final responseList =
//                                           snapshot.data?.responseList ?? [];
//                                       Map<String, String> map = {};
//                                       map["All"] = "All";

//                                       for (var element in responseList) {
//                                         map[element.districtName ?? ""] =
//                                             element.district ?? "";
//                                       }
//                                       selectedDistrict.value =
//                                           map.entries.first;
//                                       return ValueListenableBuilder(
//                                         valueListenable: selectedDistrict,
//                                         builder: (BuildContext context, data,
//                                             Widget? child) {
//                                           return Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               const Text(
//                                                 "Transporter",
//                                                 style: TextStyle(
//                                                     color: Colors.black),
//                                               ),
//                                               CustomDropdownMenu3(
//                                                 selVal:
//                                                     selectedDistrict.value.key,
//                                                 list: map.keys.toList(),
//                                                 fun: (value) {
//                                                   if (value == "All") {
//                                                     enabled.value = false;
//                                                   } else {
//                                                     enabled.value = true;
//                                                   }
//                                                   selectedDistrict.value =
//                                                       MapEntry(
//                                                     value ?? "",
//                                                     map[value] ?? "",
//                                                   );
//                                                 },
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       );
//                                     } else {
//                                       Future.delayed(Duration.zero, () {
//                                         Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   const TokenExpire()),
//                                         );
//                                       });
//                                       return const Text(
//                                           "Token Error : Re check token in API");
//                                     }
//                                   },
//                                 );
//                               },
//                             ),
//                             wSpace(20),
//                             datePicker(
//                               label: "From Date",
//                               controller: fromDateController,
//                               ontap: () =>
//                                   selectDate(context, fromDateController),
//                             ),
//                             wSpace(20),
//                             datePicker(
//                               label: "To Date",
//                               controller: toDateController,
//                               ontap: () =>
//                                   selectDate(context, toDateController),
//                             ),
//                           ],
//                         ),
//                       ),
//                       vSpace(10),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               customTextField(label: "Invoice Number")
//                             ]),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           button(
//                               btnText: "Search",
//                               tapFunction: () async {
//                                 // await fetchTransportActionList();
//                               }),
//                           wSpace(10),
//                           button(
//                               btnText: "Reset",
//                               btnClr: Colors.white,
//                               btnTxtClr: ColorConstant.redbar,
//                               tapFunction: () async {
//                                 // selectedState.value =
//                                 //     const MapEntry("All", "All");
//                                 // selectedDistrict.value =
//                                 //     const MapEntry("All", "All");
//                                 // selectedCity.value =
//                                 //     const MapEntry("All", "All");
//                                 // fetchTransportActionList();
//                               }),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               vSpace(20),
//               tableHeading(heading: "Search Results"),
//               Row(
//                 children: [
//                   Expanded(
//                       child: Container(
//                     color: const Color(0xffE2E2E2),
//                     child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 20),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               flex: 7,
//                               child: Row(
//                                 children: [
//                                   const Text("Display",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w400,
//                                           fontFamily: 'Roboto')),
//                                   wSpace(6),
//                                   SizedBox(
//                                       width: 65,
//                                       height: 22,
//                                       child: PreCustomDropdownMenu(
//                                         selVal: selectedDropdownValue,
//                                         list: const [
//                                           "10",
//                                           "20",
//                                           "30",
//                                           "50",
//                                           "100"
//                                         ],
//                                         onChanged: (value) async {
//                                           // Update the selected value when the dropdown changes
//                                           setState(() {
//                                             selectedDropdownValue = value;
//                                             // pageSize = int.parse(value);
//                                             // currentPage = 1;
//                                           });
//                                           await fetchTransportActionList();
//                                         },
//                                       )),
//                                   wSpace(6),
//                                   size.width > 600
//                                       ? const Text("records",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 12))
//                                       : Container(),
//                                 ],
//                               ),
//                             ),
//                             const Text("Search",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                     fontFamily: "RobotoLight")),
//                             wSpace(10),
//                             SizedBox(
//                               height: 22,
//                               width: 130,
//                               child: TextField(
//                                 decoration: InputDecoration(
//                                   border: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         width: 0.5,
//                                         color: Colors.grey.shade600),
//                                   ),
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         width: 1, color: Color(0xffA0A0A0)),
//                                   ),
//                                   contentPadding:
//                                       const EdgeInsets.symmetric(horizontal: 5),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                 ),
//                                 textAlign: TextAlign.left,
//                                 keyboardType: TextInputType.multiline,
//                                 style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 13,
//                                     textBaseline: TextBaseline.alphabetic,
//                                     fontWeight: FontWeight.w100),
//                                 onChanged: (val) {
//                                   filterData(val);
//                                 },
//                               ),
//                             ),
//                           ],
//                         )),
//                   )),
//                 ],
//               ),
//               // ValueListenableBuilder(
//               //     valueListenable: transporterBID2ListResponseList1,
//               //     builder: (BuildContext context,
//               //         List<TransporterBid2ModelResponseList> data,
//               //         Widget? child) {
//               //       if (data.isEmpty) {
//               //         return const Center(
//               //           child: Padding(
//               //             padding: EdgeInsets.all(30.0),
//               //             child: Text("No data found"),
//               //           ),
//               //         );
//               //       } else {
//               // return
//               CustomTable(
//                 columns: [
//                   const DataColumn(
//                     label: TableColumn(
//                       "Sr.No",
//                       heading: true,
//                       width: 32,
//                     ),
//                   ),
//                   DataColumn(
//                     label: TableColumn(
//                       "Transporter",
//                       dropdown: true,
//                       heading: true,
//                       width: dynamicSize,
//                     ),
//                   ),
//                   DataColumn(
//                     label: TableColumn(
//                       "Invoice Date",
//                       dropdown: true,
//                       heading: true,
//                       width: dynamicSize,
//                     ),
//                   ),
//                   DataColumn(
//                     label: TableColumn(
//                       "Invoice No.",
//                       heading: true,
//                       dropdown: true,
//                       width: dynamicSize,
//                     ),
//                   ),
//                   DataColumn(
//                     label: TableColumn(
//                       "Freight Amt.",
//                       heading: true,
//                       dropdown: true,
//                       width: dynamicSize,
//                     ),
//                   ),
//                   DataColumn(
//                     label: TableColumn(
//                       "Total Deduction",
//                       heading: true,
//                       dropdown: true,
//                       width: dynamicSize,
//                     ),
//                   ),
//                   DataColumn(
//                     label: TableColumn(
//                       "Tax Details",
//                       heading: true,
//                       dropdown: true,
//                       width: dynamicSize,
//                     ),
//                   ),
//                   DataColumn(
//                     label: TableColumn(
//                       "Net Amt.",
//                       width: dynamicSize,
//                       heading: true,
//                     ),
//                   ),
//                   DataColumn(
//                     label: TableColumn(
//                       "Payment Status",
//                       width: dynamicSize,
//                       heading: true,
//                     ),
//                   ),
//                   DataColumn(
//                     label: TableColumn(
//                       "Action",
//                       heading: true,
//                       width: dynamicSize,
//                     ),
//                   ),
//                 ],
//                 rows: List.generate(
//                   // data.length,
//                   5,
//                   (index) {
//                     // index1=index;
//                     return DataRow(
//                       cells: [
//                         DataCell(
//                           TableColumn(
//                             "${index + 1}",
//                             index: index,
//                           ),
//                         ),
//                         DataCell(
//                           TableColumn(
//                             // data[index].cityName ?? "",
//                             "",
//                             index: index,
//                           ),
//                         ),
//                         DataCell(
//                           TableColumn(
//                             // data[index].cityName ?? "",
//                             "",
//                             index: index,
//                           ),
//                         ),
//                         DataCell(
//                           TableColumn(
//                             // data[index].districtName ?? "",
//                             "",
//                             index: index,
//                           ),
//                         ),
//                         DataCell(
//                           TableColumn(
//                             // data[index].diQty.toString(),
//                             "",
//                             index: index,
//                           ),
//                         ),
//                         DataCell(
//                           TableColumn(
//                             // data[index].basicFrtAmount.toString(),
//                             "",
//                             index: index,
//                           ),
//                         ),
//                         DataCell(
//                           TableColumn(
//                             // data[index].customerName ?? "",
//                             "",
//                             index: index,
//                           ),
//                         ),
//                         DataCell(
//                           TableColumn(
//                             // data[index].soBiddingRemarks ?? "",
//                             "",
//                             index: index,
//                           ),
//                         ),
//                         DataCell(
//                           TableColumn(
//                             // data[index].diNumber.toString(),
//                             "",
//                             index: index,
//                           ),
//                         ),
//                         DataCell(
//                           TableColumnActionIcon(
//                             index: index,
//                             icon: Image.asset(
//                               "assets/images/searchicon.png",
//                               color: Colors.green,
//                             ),
//                             onPressed: () {
//                               showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return InvoicePopup(
//                                         title: "Invoice",
//                                         width: 410,
//                                         height: 602,
//                                         columnChildrens: const [
//                                           SizedBox(
//                                             child: InvoicePage(),
//                                           )
//                                         ],
//                                         buttons: [
//                                           SizedBox(
//                                             width: 66,
//                                             child: FittedBox(
//                                               fit: BoxFit.contain,
//                                               child: button(
//                                                   btnClr: Colors.white,
//                                                   btnTxtClr:
//                                                       ColorConstant.redbar,
//                                                   btnText: "Close",
//                                                   tapFunction: () {
//                                                     Navigator.of(context).pop();
//                                                   }),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 8.0)
//                                         ]);
//                                   });
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               // }
//               // }),
//               // Container(
//               //   color: Colors.grey.shade200,
//               //   child: Padding(
//               //       padding:
//               //           const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
//               //       child: Row(
//               //         children: [
//               //           ValueListenableBuilder(
//               //             valueListenable: transporterBID2ListResponseList,
//               //             builder: (BuildContext context,
//               //                 List<TransporterBid2ModelResponseList> value,
//               //                 Widget? child) {
//               //               if (value.isEmpty) {
//               //                 return Center(child: Container());
//               //               }
//               //               return Expanded(
//               //                 flex: 2,
//               //                 child: Text(
//               //                     "Showing 1 to ${transporterBID2ListResponseList1.value.length} of ${value.length} entries",
//               //                     style: const TextStyle(
//               //                         color: Colors.black,
//               //                         fontSize: 14,
//               //                         fontWeight: FontWeight.normal)),
//               //               );
//               //             },
//               //           ),
//               //           const SizedBox(
//               //             width: 20,
//               //           ),
//               //           // buildValueListenableBuilder()
//               //         ],
//               //       )),
//               // ),
//               Container(
//                 color: Colors.grey.shade200,
//                 child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Text(
//                             size.width > 600
//                                 ? "Showing 1 to 5 of 5 entries"
//                                 : "Showing 1 to \n5 of 5 entries",
//                             style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.normal)),
//                         const Expanded(child: SizedBox()),
//                         Container(
//                             color: Colors.grey.shade200,
//                             child: Column(children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 20, horizontal: 5),
//                                 child: Row(
//                                   children: [
//                                     navBox(boxWidth: 70, text: "Previous"),
//                                     navBox(
//                                         boxWidth: 25,
//                                         text: "1",
//                                         txtClr: Colors.white,
//                                         bgClr: ColorConstant.redbar),
//                                     navBox(
//                                         boxWidth: 25,
//                                         text: "2",
//                                         txtClr: ColorConstant.redbar),
//                                     navBox(
//                                         boxWidth: 25,
//                                         text: "3",
//                                         txtClr: ColorConstant.redbar),
//                                     navBox(
//                                         boxWidth: 50,
//                                         text: "Next",
//                                         txtClr: ColorConstant.redbar),
//                                   ],
//                                 ),
//                               )
//                             ])),
//                       ],
//                     )),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// //   ValueListenableBuilder<List<TransporterBid2ModelResponseList>>
// //       buildValueListenableBuilder() {
// //     return ValueListenableBuilder(
// //       valueListenable: transporterBID2ListResponseList,
// //       builder: (BuildContext context,
// //           List<TransporterBid2ModelResponseList> value, Widget? child) {
// //         if (value.isEmpty) {
// //           return Center(child: Container());
// //         }

// //         int itemsPerPage = int.parse(selectedDropdownValue);
// //         int numberOfPages = (value.length / itemsPerPage).ceil();

// //         // Calculate the range of pages to display
// //         int startPage = (currentPage - 2).clamp(1, numberOfPages);
// //         int endPage = (currentPage + 2).clamp(1, numberOfPages);

// //         List<Widget> pageWidgets = [];

// //         // Add "Previous" button if necessary
// //         if (currentPage > 1) {
// //           pageWidgets.add(
// //             Container(
// //               margin: const EdgeInsets.only(right: 1),
// //               child: InkWell(
// //                 child: navBox(
// //                     boxWidth: 70,
// //                     text: "Previous",
// //                     txtClr: ColorConstant.redbar,
// //                     bgClr: Colors.white),
// //                 onTap: () async {
// //                   currentPage--;
// //                   await fetchTransportActionList();
// //                 },
// //               ),
// //             ),
// //           );
// //         }

// //         // Add the page buttons
// //         for (int i = startPage; i <= endPage; i++) {
// //           Color color = (currentPage == i) ? ColorConstant.redbar : Colors.white;
// //           Color bgClr = (currentPage == i) ? Colors.white : ColorConstant.redbar;

// //           pageWidgets.add(
// //             InkWell(
// //               child: navBox(
// //                   boxWidth: 25,
// //                   text: i.toString(),
// //                   txtClr: color,
// //                   bgClr: bgClr),
// //               onTap: () async {
// //                 currentPage = i;
// //                 await fetchTransportActionList();
// //                 setState(() {});
// //               },
// //             ),
// //           );
// }

// //         // Add "Next" button if necessary
// //         if (endPage < numberOfPages) {
// //           pageWidgets.add(
// //             Container(
// //               margin: const EdgeInsets.only(left: 1),
// //               child: InkWell(
// //                 child: navBox(
// //                     boxWidth: 70,
// //                     text: "Next",
// //                     txtClr: ColorConstant.redbar,
// //                     bgClr: Colors.white),
// //                 onTap: () async {
// //                   currentPage++;
// //                   await fetchTransportActionList();
// //                 },
// //               ),
// //             ),
// //           );
// //         }

// //         return Row(
// //           children: pageWidgets,
// //         );
// //       },
// //     );
// //   }
// // }

// Widget datePicker(
//     {String? label, TextEditingController? controller, VoidCallback? ontap}) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label ?? "label",
//         style: const TextStyle(color: Colors.black),
//       ),
//       Container(
//         width: 283,
//         height: 30,
//         color: Colors.white,
//         child: TextFormField(
//           readOnly: true,
//           style: const TextStyle(fontSize: 13, color: Colors.black),
//           controller: controller,
//           textAlign: TextAlign.start,
//           // textAlignVertical: TextAlignVertical.center,
//           onTap: ontap,
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsetsDirectional.only(start: 15),
//             border: OutlineInputBorder(
//               borderSide: BorderSide(width: 0.5, color: Colors.grey.shade600),
//             ),
//             enabledBorder: const OutlineInputBorder(
//               borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
//             ),
//             hintText: 'DD/MM/YYYY',
//             suffixIcon: const Icon(
//               Icons.calendar_today_outlined,
//               size: 16,
//               color: Color.fromRGBO(114, 114, 114, 1),
//             ),
//             hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
//           ),
//         ),
//       ),
//     ],
//   );
// }

// Future<void> selectDate(
//     BuildContext context, TextEditingController textcontroller) async {
//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(1900),
//     lastDate: DateTime(2100),
//   );

//   if (pickedDate != null) {
//     textcontroller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
//   }
// }
