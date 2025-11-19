// import 'package:flutter/material.dart';
// import 'package:shreecement/features/common/table/table_widgets.dart';
// import 'package:shreecement/features/common/widgets/custom_scaffold.dart';
//
// class DeliveriesForBidding extends StatefulWidget {
//   const DeliveriesForBidding({super.key});
//
//   @override
//   State<DeliveriesForBidding> createState() => _DeliveriesForBiddingState();
// }
//
// class _DeliveriesForBiddingState extends State<DeliveriesForBidding> {
//   bool switchOn = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       appBarText: "Deliveries For Bidding",
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Deliveries For Bidding (FGB:Finished Goods Cement BWR)',
//                 style: TextStyle(
//                     fontSize: 21,
//                     fontFamily: 'Roboto',
//                     fontWeight: FontWeight.w100),
//               ),
//               vSpace(20),
//               tableHeading(heading: "Search DI"),
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
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           labelledCustomDD(
//                               label: "State",
//                               selVal: "All",
//                               list: [
//                                 "All",
//                                 "Rajasthan",
//                                 "Punjab",
//                                 "Haryana",
//                                 "Gujarat",
//                                 "Maharashtra"
//                               ]),
//                           wSpace(20),
//                           labelledCustomDD(
//                               label: "District",
//                               selVal: "All",
//                               list: [
//                                 "All",
//                                 "Jodhpur",
//                                 "Jaipur",
//                                 "Jaisalmer",
//                                 "Ajmer"
//                               ]),
//                           wSpace(20),
//                           labelledCustomDD(label: "City", selVal: "All", list: [
//                             "All",
//                             "City 1",
//                             "City 2",
//                             "City 3",
//                             "City 4"
//                           ]),
//                           labelledSwitch(
//                               label: "Show Bidded DI",
//                               function: (value) {
//                                 switchOn = value;
//                                 setState(() {});
//                               },
//                               switchStatus: switchOn),
//                         ],
//                       ),
//                       wSpace(10),
//                       Row(
//                         children: [
//                           labelledEnabledText(
//                               label: "Bid Start Time",
//                               text: "03-11-2023 15:16:08"),
//                           wSpace(20),
//                           labelledEnabledText(
//                               label: "Bid Cancel Reason",
//                               text: "03-11-2023 15:16:08"),
//                         ],
//                       ),
//                       wSpace(20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           button(btnText: "Search", tapFunction: () {}),
//                           wSpace(10),
//                           button(
//                               btnText: "Reset",
//                               btnClr: Colors.white,
//                               btnTxtClr: ColorConstant.redbar,
//                               tapFunction: () {}),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               vSpace(20),
//               tableHeading(heading: "Deliveries for Bidding - FGB"),
//               searchBar(),
//               Row(
//                 children: [
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "Sr.No",
//                       flx: 1,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "City",
//                       dropdownVis: true,
//                       flx: 1,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "District",
//                       dropdownVis: true,
//                       flx: 3,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "DI Qty",
//                       dropdownVis: true,
//                       flx: 2,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "Frt. Amt",
//                       flx: 2,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "Frt. Rate",
//                       flx: 2,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "Customer",
//                       flx: 4,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "SO/Bidding Remarks",
//                       flx: 3,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "DI No.",
//                       flx: 2,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "Brand",
//                       flx: 2,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "Product",
//                       flx: 2,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "DI/SO",
//                       flx: 2,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                   column(
//                       colColor: const Color(0xffF6F6F6),
//                       columnTitle: "Action",
//                       flx: 2,
//                       hgt1: 48,
//                       clr: Colors.grey.shade700),
//                 ],
//               ),
//               ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: 10,
//                   itemBuilder: (_, index) {
//                     Color clr;
//                     index % 2 != 0
//                         ? clr = const Color(0xffF6F6F6)
//                         : clr = Colors.white;
//                     return Row(
//                       children: [
//                         column(
//                             colColor: clr,
//                             columnTitle: "${((currentPage-1)*int.parse(selectedDropdownValue)) + index + 1}",
//                             flx: 1,
//                             fntWeight: FontWeight.normal),
//                         column(
//                             colColor: clr,
//                             columnTitle: "Aslali",
//                             flx: 1,
//                             fntWeight: FontWeight.normal),
//                         column(
//                             colColor: clr,
//                             columnTitle: "Ahemdabad",
//                             flx: 3,
//                             fntWeight: FontWeight.normal),
//                         column(
//                             colColor: clr,
//                             columnTitle: "42",
//                             flx: 2,
//                             fntWeight: FontWeight.normal),
//                         column(
//                             colColor: clr,
//                             columnTitle: "971",
//                             flx: 2,
//                             fntWeight: FontWeight.normal),
//                         textEdit(flx: 1),
//                         column(
//                             colColor: clr,
//                             columnTitle: "SHX:Shree Aslali-Ahemdabad",
//                             flx: 2,
//                             fntWeight: FontWeight.normal),
//                         column(
//                             colColor: clr,
//                             columnTitle: "",
//                             flx: 4,
//                             fntWeight: FontWeight.normal),
//                         column(
//                             colColor: clr,
//                             columnTitle: "32135343",
//                             flx: 3,
//                             fntWeight: FontWeight.normal),
//                         column(
//                             colColor: clr,
//                             columnTitle: "Shree",
//                             flx: 2,
//                             fntWeight: FontWeight.normal),
//                         column(
//                             colColor: clr,
//                             columnTitle: "PPC",
//                             flx: 2,
//                             fntWeight: FontWeight.normal),
//                         column(
//                             colColor: clr,
//                             columnTitle: "ISO",
//                             flx: 2,
//                             fntWeight: FontWeight.normal),
//                         iconCell(
//                             colColor: clr,
//                             flx: 2,
//                             iconData: Icons.save,
//                             icnClr: Colors.green,
//                             icnSize: 21,
//                             tapAction: () {
//                               //open pre bidding screen 2
//                             }),
//                       ],
//                     );
//                   }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
