// // import 'package:flutter/material.dart';
// <<<<<<< HEAD
//
// // Widget vSpace(double h) {
// //   return SizedBox(
// //     height: h,
// //   );
// // }
//
// // Widget hSpace(double w) {
// //   return SizedBox(
// //     width: w,
// //   );
// // }
//
// =======
// // //
// // // Widget vSpace(double h) {
// // //   return SizedBox(
// // //     height: h,
// // //   );
// // // }
// // //
// // // Widget hSpace(double w) {
// // //   return SizedBox(
// // //     width: w,
// // //   );
// // // }
// //
// >>>>>>> 109408272c6fa3760e1cdda99e292c3afaa8ba26
// // Widget menuItem(IconData iconData, String textData, IconData? icn2,
// //     {Color icnClr = Colors.black, Color textClr = Colors.black}) {
// //   return Column(

// //     children: [
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.start,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           hSpace(10),
// //           Icon(
// //             iconData,
// //             color: icnClr,
// //             size: 30,
// //           ),
// //           hSpace(10),
// //           Expanded(
// //               flex: 7,
// //               child: Text(
// //                 textData,
// //                 style: TextStyle(color: textClr, fontSize: 20),
// //               )),
// //           hSpace(5),
// //           Icon(
// //             icn2,
// //             color: Colors.black,
// //             size: 30,
// //           ),
// //         ],
// //       ),
// //       Divider(
// //         color: Colors.black,
// //       ),
// //     ],
// //   );
// // }
// <<<<<<< HEAD
//
// =======
// //
// >>>>>>> 109408272c6fa3760e1cdda99e292c3afaa8ba26
// // Widget columnHeading(String columnHeading,
// //     {Color txtClr = Colors.black, bool dropdown = false}) {
// //   return Container(
// //     height: 40,
// //     decoration:
// //         BoxDecoration(border: Border.all(), color: Colors.grey.shade100),
// //     child: Padding(
// //       padding: const EdgeInsets.all(4.0),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.start,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           Expanded(
// //               child: Text(
// //             columnHeading,
// //             style: TextStyle(color: txtClr),
// //           )),
// //           Visibility(
// //             visible: dropdown,
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.end,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.arrow_drop_up,
// //                   size: 15,
// //                   color: Colors.grey,
// //                 ),
// //                 Icon(
// //                   Icons.arrow_drop_down,
// //                   size: 15,
// //                   color: Colors.grey,
// //                 ),
// //               ],
// //             ),
// //           )
// //         ],
// //       ),
// //     ),
// //   );
// // }
// <<<<<<< HEAD
//
// =======
// //
// >>>>>>> 109408272c6fa3760e1cdda99e292c3afaa8ba26
// // Widget userRow({
// //   required String sno,
// //   required String name,
// //   required String role,
// //   required String org,
// // }) {
// //   return Row(
// //     children: [
// //       Expanded(flex: 1, child: columnHeading(sno)),
// //       Expanded(
// //           flex: 2, child: columnHeading(name, txtClr: Colors.grey.shade600)),
// //       Expanded(
// //           flex: 2, child: columnHeading(role, txtClr: Colors.grey.shade600)),
// //       Expanded(flex: 2, child: columnHeading(org, txtClr: ColorConstant.redbar)),
// //       Expanded(flex: 1, child: actionButtons()),
// //     ],
// //   );
// // }
// <<<<<<< HEAD
//
// =======
// //
// >>>>>>> 109408272c6fa3760e1cdda99e292c3afaa8ba26
// // Widget navBox(
// //     {required double boxWidth,
// //     required String text,
// //     Color txtClr = Colors.grey,
// //     Color bgClr = Colors.white}) {
// //   return Container(
// //     height: 30,
// //     width: boxWidth,
// //     decoration: BoxDecoration(border: Border.all(), color: bgClr),
// //     child: Center(
// //       child: Text(
// //         text,
// //         style: TextStyle(fontSize: 12, color: txtClr),
// //       ),
// //     ),
// //   );
// // }
// <<<<<<< HEAD
//
// =======
// //
// >>>>>>> 109408272c6fa3760e1cdda99e292c3afaa8ba26
// // Widget actionButtons() {
// //   return Container(
// //     height: 40,
// //     decoration:
// //         BoxDecoration(border: Border.all(), color: Colors.grey.shade100),
// //     child: const Row(
// //       children: [
// //         Icon(
// //           Icons.search_rounded,
// //           color: Color.fromARGB(255, 0, 25, 138),
// //           size: 21,
// //         ),
// //       ],
// //     ),
// //   );
// // }
// <<<<<<< HEAD
//
// // Widget labelledDropDown({required String label, String hint = "All"}) {
// //   Color backgroundColor = Colors.transparent; // Default is transparent
//
// =======
// //
// // Widget labelledDropDown({required String label, String hint = "All"}) {
// //   Color backgroundColor = Colors.transparent; // Default is transparent
// //
// >>>>>>> 109408272c6fa3760e1cdda99e292c3afaa8ba26
// //   if (label == "Time For Bidding(In Mins.)" ||
// //       label == "Re-Bid Time(In Hours)" ||
// //       label == "Re-Bid Time(In Hours)") {
// //     backgroundColor = Colors.white;
// //     Colors.transparent; // Set background to white for specific labels
// //   }
// <<<<<<< HEAD
//
// =======
// //
// >>>>>>> 109408272c6fa3760e1cdda99e292c3afaa8ba26
// //   return Column(
// //     mainAxisAlignment: MainAxisAlignment.start,
// //     crossAxisAlignment: CrossAxisAlignment.start,
// //     children: [
// //       Text(
// //         label,
// //         style: TextStyle(color: Colors.grey),
// //       ),
// //       vSpace(5),
// //       Container(
// //         decoration: BoxDecoration(
// //           border: Border.all(color: Colors.grey),
// //           color: backgroundColor,
// //         ),
// //         child: DropdownButtonFormField(
// //           decoration: InputDecoration(
// //             hintText: hint,
// //             hintStyle: TextStyle(fontSize: 13),
// //             filled: true,
// //             fillColor:
// //                 Colors.transparent, // Use transparent for the dropdown area
// //             errorStyle: TextStyle(color: Color.fromRGBO(206, 16, 23, 1)),
// //           ),
// //           items: [],
// //           onChanged: (value) {},
// //         ),
// //       ),
// //     ],
// //   );
// // }
// <<<<<<< HEAD
//
// =======
// //
// >>>>>>> 109408272c6fa3760e1cdda99e292c3afaa8ba26
// // Widget labelledSwitch({required String label}) {
// //   bool state = true;
// //   return Column(
// //     mainAxisAlignment: MainAxisAlignment.start,
// //     children: [
// //       Text(
// //         label,
// //         style: TextStyle(color: const Color.fromARGB(255, 114, 114, 114)),
// //       ),
// //       vSpace(5),
// //       Switch(
// //         // This bool value toggles the switch.
// //         value: state,
// //         activeColor: Colors.green,
// //         onChanged: (bool value) {
// //           state = value;
// //         },
// //       ),
// //     ],
// //   );
// // }
// <<<<<<< HEAD
//
// =======
// //
// >>>>>>> 109408272c6fa3760e1cdda99e292c3afaa8ba26
// // Widget button({
// //   required String btnText,
// //   Color btnClr = const Color.fromARGB(255, 218, 218, 218),
// //   Color btnTxtClr = const Color.fromARGB(255, 59, 59, 59),
// // }) {
// //   return ElevatedButton(
// //     onPressed: () {},
// //     style: ElevatedButton.styleFrom(
// //       backgroundColor: btnClr,
// //       foregroundColor: btnTxtClr,
// //       shape: RoundedRectangleBorder(
// //         borderRadius:
// //             BorderRadius.circular(5), // Set border radius to 0 for rectangles
// //       ),
// //     ),
// //     child: Text(btnText),
// //   );
// // }
// <<<<<<< HEAD
//
// // Widget tableHeading({required String heading}) {
// //   return Container(
// //     height: 40,
// //     decoration: BoxDecoration(
// //       color: Color.fromRGBO(206, 16, 23, 1), // Set the background color to red
// //     ),
// //     child: Padding(
// //       padding:
// //           const EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.start,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           Text(
// //             heading,
// //             style: TextStyle(
// //               color: Colors.white, // Set the text color to white
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ],
// //       ),
// //     ),
// //   );
// // }
// =======
// //
// // // Widget tableHeading({required String heading}) {
// // //   return Container(
// // //     height: 40,
// // //     decoration: BoxDecoration(
// // //       color: Color.fromRGBO(206, 16, 23, 1), // Set the background color to red
// // //     ),
// // //     child: Padding(
// // //       padding:
// // //           const EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
// // //       child: Row(
// // //         mainAxisAlignment: MainAxisAlignment.start,
// // //         crossAxisAlignment: CrossAxisAlignment.center,
// // //         children: [
// // //           Text(
// // //             heading,
// // //             style: TextStyle(
// // //               color: Colors.white, // Set the text color to white
// // //               fontSize: 18,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     ),
// // //   );
// // // }
// >>>>>>> 109408272c6fa3760e1cdda99e292c3afaa8ba26
