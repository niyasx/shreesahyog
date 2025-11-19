import 'package:flutter/material.dart';

import 'package:shreecement/features/common/table/user_data.dart';
import 'package:shreecement/features/common/widgets/custom_drop_down.dart';

import '../../../utils/color_constant.dart';
import '../../../utils/styletextconstant.dart';

Widget vSpace(double h) {
  return SizedBox(
    height: h,
  );
}

Widget wSpace(double w) {
  return SizedBox(
    width: w,
  );
}

String selectedDropdownValue = "10";
String selectedDropdownValue1 = "10";
Widget tableHeading({required String heading}) {
  return Row(
    children: [
      Expanded(
        child: Container(
            color: ColorConstant.color1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              child: Text(heading,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            )),
      ),
    ],
  );
}

Widget searchBar({void Function(String)? onChanged, required double size}) {
  return Row(
    children: [
      Expanded(
          child: Container(
        color: const Color(0xffE2E2E2),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                          child: CustomDropdownMenu(
                              selVal: "10", list: const ["10", "20", "30"])),
                      wSpace(6),
                      size > 600
                          ? const Text("records",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12))
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
                        borderSide:
                            BorderSide(width: 0.5, color: Colors.grey.shade600),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffA0A0A0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
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
                    onChanged: onChanged,
                  ),
                ),
              ],
            )),
      )),
    ],
  );
}

Widget labelledDropDown(
    {required String label,
    String hint = "All",
    List<String>? ddItems,
    double wd = 200,
    double ht = 30}) {
  String? selected = ddItems?.elementAt(0);

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
      vSpace(5),
      SizedBox(
        height: ht,
        width: wd,
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          iconSize: 25,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 11),
            filled: true,
            fillColor: Colors.white,
            errorStyle: const TextStyle(color: Colors.red),
          ),
          value: selected,
          items: ddItems
              ?.map((label) => DropdownMenuItem(
                    value: label,
                    child: Text(label, textAlign: TextAlign.center),
                  ))
              .toList(),
          onChanged: (value) {},
        ),
      ),
    ],
  );
}

Widget labelledCustomDD({
  required String label,
  required String selVal,
  required List<String> list,
  bool enabled = true,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Colors.grey),
      ),
      CustomDropdownMenu(
        selVal: selVal,
        list: list,
        enabled: enabled,
      ),
    ],
  );
}

Widget labelledCustomDD1({
  required String label,
  required String selVal,
  required List<String> list,
  double wd = 300,
  double ht = 50,
  bool enabled = true,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Color(0xff616161)),
      ),
      vSpace(5),
      CustomDropdownMenu(
        selVal: selVal,
        list: list,
        enabled: enabled,
      ),
    ],
  );
}

/*Widget labelledDisabledText({required String label, required String text, double hgt = 32}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Colors.grey),
      ),
      vSpace(5),
      Container(
        height: hgt,
        width: 283,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(),
          color: Colors.grey.shade200,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 5),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    ],
  );
}*/

Widget labelledDisabledText(
    {required String label,
    required String text,
    double hgt = 32,
    bool? enabled}) {
  TextEditingController ctrl = TextEditingController();
  ctrl.text = text;
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
      SizedBox(
        height: hgt,
        width: 283,
        /*decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(),
          color: Colors.white,
        ),*/
        child: TextField(
          enabled: enabled,
          controller: ctrl,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Colors.grey.shade600),

              //border: Border.all(color: Color(0xffA0A0A0)),
              //         borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            filled: true,
            fillColor: Colors.transparent,
          ),
          textAlign: TextAlign.left,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              textBaseline: TextBaseline.alphabetic,
              fontWeight: FontWeight.w100),
        ),
      ),
    ],
  );
}

Widget labelledEnabledText(
    {required String label,
    required String text,
    double hgt = 32,
    bool? enabled}) {
  TextEditingController ctrl = TextEditingController();
  ctrl.text = text;
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
      SizedBox(
        height: hgt,
        width: 283,
        /*decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(),
          color: Colors.white,
        ),*/
        child: TextField(
          enabled: enabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Colors.grey.shade600),

              //border: Border.all(color: Color(0xffA0A0A0)),
              //         borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
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
        ),
      ),
    ],
  );
}

Widget labelledEnabledTextstart(
    {required String label,
    required String text,
    double hgt = 32,
    bool? enabled}) {
  TextEditingController ctrl = TextEditingController();
  ctrl.text = text;
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
      SizedBox(
        height: hgt,
        width: 283,
        /*decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(),
          color: Colors.white,
        ),*/
        child: TextField(
          enabled: enabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Colors.grey.shade600),

              //border: Border.all(color: Color(0xffA0A0A0)),
              //         borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
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
        ),
      ),
    ],
  );
}

Widget cellWrappedEnabledTextField(
    {double cellHgt = 35,
    Color colClr = Colors.white,
    double fieldHgt = 22,
    double vp = 0,
    double wdt = 200,
    TextEditingController? controller}) {
  TextEditingController controller = TextEditingController();
  return Container(
    height: cellHgt, //this is the size of whole cell
    width: wdt,
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: vp),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xff727272), width: 0.5),
      color: colClr,
    ),
    child: SizedBox(
      height: fieldHgt,
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
            color: Colors.black,
            width: 0.5
        ),
        color: Colors.white,
      ),*/
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xff727272)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
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
      ),
    ),
  );
}

Widget cellWrappedDropdown(
    {double cellHgt = 35,
    Color colClr = Colors.white,
    required String selVal,
    required List<String> list}) {
  return Container(
    height: cellHgt, //this is the size of whole cell
    width: 200,
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xff727272), width: 0.5),
      color: colClr,
    ),
    child: CustomDropdownMenu(
      selVal: selVal,
      list: list,
    ),
  );
}

Widget labelledDisabledText1(
    {required String label, required String text, double hgt = 32}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            color: Color(0xff616161), overflow: TextOverflow.ellipsis),
      ),
      vSpace(5),
      Container(
        height: hgt,
        width: 283,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            width: 0.5,
            color: const Color(0xff727272),
          ),
          color: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xff727272),
              fontSize: 13,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ),
    ],
  );
}

// Widget labelledDisabledText1(
//     {required String label, required String text, double hgt = 32}) {
//   TextEditingController ctrl = TextEditingController();
//   ctrl.text = text;
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: const TextStyle(color: Color(0xff616161),overflow: TextOverflow.ellipsis),
//       ),
//       vSpace(5),
//       Container(
//         height: hgt,
//         width: 283,
//         decoration: BoxDecoration(
//           borderRadius: const BorderRadius.all(Radius.circular(5)),
//           border: Border.all(
//             width: 0.5,
//             color: const Color(0xff727272),
//           ),
//           color: Colors.transparent,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 9, left: 5),
//           child: TextField(
//             decoration: const InputDecoration(border: InputBorder.none),
//             textAlign: TextAlign.left,
//             controller: ctrl,
//             enabled: false,
//             style: const TextStyle(
//                 color: Color(0xff727272),
//                 fontSize: 13,
//                 fontWeight: FontWeight.w100),
//           ),
//         ),
//       ),
//     ],
//   );
// }

Widget labelledEnabledText1(
    {required String label, required String text, double hgt = 32}) {
  TextEditingController ctrl = TextEditingController();
  ctrl.text = text;
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Color(0xff616161)),
      ),
      vSpace(1),
      Container(
        height: hgt,
        width: 283,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            width: 0.5,
            color: const Color(0xff727272),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 9, left: 5),
          child: TextField(
            decoration: const InputDecoration(border: InputBorder.none),
            textAlign: TextAlign.left,
            controller: ctrl,
            style: const TextStyle(
                color: Color(0xff727272),
                fontSize: 13,
                fontWeight: FontWeight.w100),
          ),
        ),
      ),
    ],
  );
}

Widget labelledSwitch1(
    {required String label,
    Function(bool)? function,
    required bool switchStatus}) {
  return Flexible(
    flex: 1,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        Switch(
          value: switchStatus,
          activeColor: ColorConstant.redbar,
          onChanged: function,
        ),
      ],
    ),
  );
}

Widget textEdit(
    {int flx = 1,
    bool dropdownVis = false,
    Color clr = Colors.black,
    double fntSize = 13,
    double colHgt = 35,
    FontWeight fntWeight = FontWeight.normal,
    Color colColor = Colors.white,
    VoidCallback? funx,
    bool manualDIScreen = false,
    String fieldValue = ""}) {
  TextEditingController ctrl = TextEditingController();
  ctrl.text = fieldValue;
  return Flexible(
    flex: flx,
    child: Container(
      height: colHgt,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        border: Border.all(
          width: 0.5,
          color: const Color(0xff727272),
        ),
        color: colColor,
      ),
      child: Padding(
        padding: manualDIScreen == true
            ? const EdgeInsets.symmetric(horizontal: 9, vertical: 5)
            : const EdgeInsets.only(bottom: 2, left: 2, right: 2, top: 2),
        child: TextField(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          textAlign: TextAlign.left,
          controller: ctrl,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.w100),
        ),
      ),
    ),
  );
}

Widget labelledSwitch(
    {required String label,
    Function(bool)? function,
    required bool switchStatus,
    String leftText = "No",
    String rightText = "Yes"}) {
  return SizedBox(
    width: 180,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        vSpace(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              leftText,
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w100,
                  fontFamily: "Roboto"),
            ),
            Switch(
              value: switchStatus,
              activeColor: ColorConstant.redbar,
              onChanged: function,
            ),
            Text(
              rightText,
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w100,
                  fontFamily: "Roboto"),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget labelledSwitch2(
    {required String label,
    Function(bool)? function,
    required bool switchStatus,
    String leftText = "No",
    String rightText = "Yes"}) {
  return SizedBox(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xff616161)),
        ),
        vSpace(5),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                leftText,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w100,
                    fontFamily: "Roboto"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Switch(
                  activeTrackColor: ColorConstant.redbar,
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                  value: switchStatus,
                  onChanged: function!,
                ),
              ),
              Text(
                rightText,
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w100,
                    fontFamily: "Roboto"),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget button(
    {required String btnText,
    Color? btnClr,
    Color btnTxtClr = Colors.white,
    VoidCallback? tapFunction,
    Widget? icon}) {
  btnClr == null ? btnClr = ColorConstant.color1 : btnClr = btnClr;
  return OutlinedButton(
    onPressed: tapFunction,
    style: OutlinedButton.styleFrom(
      backgroundColor: btnClr,
      foregroundColor: btnTxtClr,
      side: BorderSide(
          color: ColorConstant.color1, width: 1, style: BorderStyle.solid),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon ?? Container(),
        Text(
          btnText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget greyBorderColorButton(
    {required String btnText,
    Color? btnClr,
    Color btnTxtClr = Colors.white,
    VoidCallback? tapFunction}) {
  btnClr == null ? btnClr = ColorConstant.redbar : btnClr = btnClr;
  return OutlinedButton(
    onPressed: tapFunction,
    style: OutlinedButton.styleFrom(
      backgroundColor: btnClr,
      foregroundColor: btnTxtClr,
      side: const BorderSide(width: 0.5, color: Color(0xff727272)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    child: Text(btnText),
  );
}

Widget column(
    {int flx = 1,
    double hgt1 = 35,
    double? wdt,
    bool selectable = true,
    required String columnTitle,
    bool dropdownVis = false,
    Color clr = Colors.black,
    VoidCallback? tapAction,
    double fntSize = 13,
    FontWeight fntWeight = FontWeight.normal,
    Color colColor = Colors.white,
    VoidCallback? funx,
    EdgeInsetsGeometry? padding}) {
  return Expanded(
      flex: flx,
      child: columnHeading(columnTitle,
          dropdown: dropdownVis,
          txtClr: clr,
          fntSize: fntSize,
          fntW: fntWeight,
          hgt: hgt1,
          wdt: wdt,
          fun: funx,
          selectable: selectable,
          colColor: colColor,
          padding: padding));
}

Widget columnWithoutExpanded(
    {double hgt1 = 35,
    double? wdt,
    bool selectable = true,
    required String columnTitle,
    bool dropdownVis = false,
    Color clr = Colors.black,
    VoidCallback? tapAction,
    double fntSize = 13,
    FontWeight fntWeight = FontWeight.normal,
    Color colColor = Colors.white,
    VoidCallback? funx,
    EdgeInsetsGeometry? padding}) {
  return columnHeading(columnTitle,
      dropdown: dropdownVis,
      txtClr: clr,
      fntSize: fntSize,
      fntW: fntWeight,
      hgt: hgt1,
      wdt: wdt,
      fun: funx,
      selectable: selectable,
      colColor: colColor,
      padding: padding);
}

Widget columnHeading(String columnHeading,
    {Color txtClr = Colors.black,
    bool dropdown = false,
    double fntSize = 13,
    bool selectable = true,
    required FontWeight fntW,
    double hgt = 35,
    double? wdt,
    Color colColor = Colors.white,
    VoidCallback? fun,
    EdgeInsetsGeometry? padding}) {
  return Container(
    height: hgt,
    width: wdt,
    padding: padding,
    decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: const Color(0xff727272),
        ),
        color: colColor),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: InkWell(
            onTap: fun,
            child: selectable
                ? SelectableText(
                    columnHeading,
                    style: TextStyle(
                      color: txtClr,
                      fontSize: fntSize,
                      fontWeight: fntW,
                      fontFamily: 'Roboto',
                    ),
                  )
                : Text(
                    columnHeading,
                    style: TextStyle(
                      color: txtClr,
                      fontSize: fntSize,
                      fontWeight: fntW,
                      fontFamily: 'Roboto',
                    ),
                  ),
          )),
          // Visibility(
          //   visible: dropdown,
          //   child: const Column(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Icon(
          //         Icons.arrow_drop_up,
          //         size: 13,
          //         color: Colors.grey,
          //       ),
          //       Icon(
          //         Icons.arrow_drop_down,
          //         size: 13,
          //         color: Colors.grey,
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    ),
  );
}

Widget userRow(
    {required int sno,
    required String name,
    required String role,
    required String org,
    required String geo,
    required String status,
    Color userCellClr = Colors.white,
    FontWeight fntW = FontWeight.normal}) {
  return Row(
    children: [
      Expanded(flex: 2, child: columnHeading(sno.toString(), fntW: fntW)),
      Expanded(
          flex: 3,
          child: columnHeading(name,
              txtClr: ColorConstant.redbar, colColor: userCellClr, fntW: fntW)),
      Expanded(
          flex: 3,
          child: columnHeading(role,
              txtClr: Colors.grey.shade600, colColor: userCellClr, fntW: fntW)),
      Expanded(
          flex: 3,
          child: columnHeading(org,
              txtClr: Colors.grey.shade600, colColor: userCellClr, fntW: fntW)),
      Expanded(
          flex: 3,
          child: columnHeading(geo,
              txtClr: Colors.grey.shade600, colColor: userCellClr, fntW: fntW)),
      Expanded(
          flex: 3,
          child: Container(
              height: 40,
              decoration:
                  BoxDecoration(border: Border.all(), color: userCellClr),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      color: status == "Active"
                          ? Colors.green.shade600
                          : ColorConstant.redbar,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          status,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              ))),
      Expanded(flex: 3, child: actionButtons(clr: userCellClr)),
    ],
  );
}

Widget allUsers() {
  return Expanded(
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10, //UserData().userData.length,
        itemBuilder: (_, index) {
          return userRow(
              sno: UserData().userData[index]["sno"],
              name: UserData().userData[index]["name"],
              role: UserData().userData[index]["role"],
              org: UserData().userData[index]["org"],
              geo: UserData().userData[index]["geo"],
              status: UserData().userData[index]["status"]);
        }),
  );
}

Widget navBox(
    {required double boxWidth,
    required String text,
    VoidCallback? tapAction,
    Color txtClr = Colors.grey,
    Color bgClr = Colors.white}) {
  return InkWell(
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    onTap: tapAction,
    child: Container(
      height: 30,
      width: boxWidth,
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff727272),
            width: 0.5,
          ),
          color: bgClr),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 12, color: txtClr, fontFamily: 'Roboto'),
        ),
      ),
    ),
  );
}

Widget actionButtons({Color clr = Colors.white}) {
  return Container(
    height: 35,
    padding: const EdgeInsets.only(left: 5),
    decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
        ),
        color: clr),
    child: Row(
      children: [
        const Icon(
          Icons.edit,
          color: Color(0xff10C400),
          size: 16,
        ),
        wSpace(5),
        const Icon(
          Icons.delete,
          color: Color(0xffFF0000),
          size: 16,
        ),
        wSpace(5),
        const Icon(
          Icons.sms_outlined,
          color: Color(0xff0055D5),
          size: 16,
        ),
        wSpace(5),
        const Icon(
          Icons.mail_outline,
          color: Color(0xffFF9900),
          size: 16,
        ),
      ],
    ),
  );
}

Widget iconCell(
    {required IconData iconData,
    required Color icnClr,
    required double icnSize,
    double cellHgt = 35,
    MainAxisAlignment mx = MainAxisAlignment.start,
    int flx = 1,
    VoidCallback? tapAction,
    Color colColor = Colors.white}) {
  return Expanded(
    flex: flx,
    child: Container(
        height: cellHgt,
        decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: const Color(0xff727272),
            ),
            color: colColor),
        child: Row(
          mainAxisAlignment: mx,
          children: [
            InkWell(
                onTap: tapAction,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(
                    iconData,
                    color: icnClr,
                    size: icnSize,
                  ),
                )),
          ],
        )),
  );
}

Widget imgCell(
    {required String imgPath,
    required Color icnClr,
    required double icnSize,
    double cellHgt = 35,
    MainAxisAlignment mx = MainAxisAlignment.start,
    int flx = 1,
    VoidCallback? tapAction,
    Color colColor = Colors.white}) {
  return Expanded(
    flex: flx,
    child: InkWell(
      onTap: tapAction,
      child: Container(
          height: cellHgt,
          decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: const Color(0xff727272),
              ),
              color: colColor),
          child: Row(
            mainAxisAlignment: mx,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Image.asset(
                  imgPath,
                  color: icnClr,
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          )),
    ),
  );
}

Widget bottomAppBar() {
  return BottomAppBar(
    color: ColorConstant.lightgrey,
    height: 40,
    child: Center(
      child: Text(
        'Copyright@2023   |   Contact Us',
        style: StyleText.robotow40012.copyWith(color: ColorConstant.redbar),
      ),
    ),
  );
}

Widget topAppBar({required String topText}) {
  return BottomAppBar(
    color: ColorConstant.lightgrey,
    height: 40,
    child: Text(
      topText,
      style: StyleText.robotow40012.copyWith(color: Colors.black),
    ),
  );
}

class TableColumn extends StatelessWidget {
  const TableColumn(
    this.text, {
    Key? key,
    this.heading = false,
    this.index,
    this.width,
    this.dropdown = false,
    this.onTap,
    this.colorbool = false,
    this.textTrim = false,
        this.backgroundColor, // Add this parameter
        this.allowRowColor = true, // Add this to control when to show row color
  })  : assert(!heading || index == null,
            'If heading is true, index must be null'),
        assert(
            heading || index != null, 'If heading is false, index is required'),
        super(key: key);

  final String text;
  final bool heading;
  final int? index;
  final double? width;
  final bool dropdown;
  final void Function()? onTap;
  final bool colorbool;
  final bool textTrim;
  final Color? backgroundColor;
  final bool allowRowColor;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(4.0),
        constraints: BoxConstraints(
          minWidth: width ?? 0,
        ),
        color: heading
            ? const Color(0xffF6F6F6) // Keep heading color
            : (allowRowColor && backgroundColor != null)
            ? backgroundColor // Use passed background color first
            : (index! % 2 != 0)
            ? const Color(0xffF6F6F6) // Original zebra striping
            : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !textTrim
                ? SelectableText(
                    text,
                    style: TextStyle(
                      color:
                          colorbool ? Colors.blueAccent : Colors.grey.shade700,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                      fontWeight:
                          !heading ? FontWeight.normal : FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                    maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  )
                : Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: SelectableText(
                      text,
                      style: TextStyle(
                        color: colorbool
                            ? Colors.blueAccent
                            : Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight:
                            !heading ? FontWeight.normal : FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
            Visibility(
              visible: dropdown,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_drop_up,
                    size: 13,
                    color: Colors.grey,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 13,
                    color: Colors.grey,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TableColumn1 extends StatelessWidget {
  const TableColumn1(
    this.text, {
    Key? key,
    this.heading = false,
    this.index,
    this.width,
    this.dropdown = false,
    this.onTap,
    this.colorbool = false,
    this.textTrim = false,
  })  : assert(!heading || index == null,
            'If heading is true, index must be null'),
        assert(
            heading || index != null, 'If heading is false, index is required'),
        super(key: key);

  final String text;
  final bool heading;
  final int? index;
  final double? width;
  final bool dropdown;
  final void Function()? onTap;
  final bool colorbool;
  final bool textTrim;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(4.0),
        constraints: BoxConstraints(
          minWidth: width ?? 0,
        ),
        color: heading
            ? const Color(0xffF6F6F6)
            : (index! % 2 != 0)
                ? const Color(0xffF6F6F6)
                : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !textTrim
                ? Text(
                    text,
                    style: TextStyle(
                      color:
                          colorbool ? Colors.blueAccent : Colors.grey.shade700,
                      fontSize: 13,
                      fontWeight:
                          !heading ? FontWeight.normal : FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : SizedBox(
                    width: 100,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: colorbool
                            ? Colors.blueAccent
                            : Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight:
                            !heading ? FontWeight.normal : FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            Visibility(
              visible: dropdown,
              child: const Column(
                children: [
                  Icon(
                    Icons.arrow_drop_up,
                    size: 13,
                    color: Colors.grey,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 13,
                    color: Colors.grey,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TableColumnTextField extends StatelessWidget {
  const TableColumnTextField({
    super.key,
    required this.index,
    this.controller,
    this.enabled,
    this.manualDIScreen = false,
    this.keyboardType,
    this.onChanged,
  });

  final int index;

  final TextEditingController? controller;
  final bool? enabled;
  final bool manualDIScreen;
  final TextInputType? keyboardType;

  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: (index % 2 != 0) ? const Color(0xffF6F6F6) : Colors.white,
      padding: manualDIScreen == true
          ? const EdgeInsets.symmetric(horizontal: 9, vertical: 5)
          : const EdgeInsets.only(bottom: 2, left: 2, right: 2, top: 2),
      child: TextField(
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        decoration: const InputDecoration(
          constraints: BoxConstraints(
            maxWidth: 145,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 4),
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(
            color: Colors.black, fontSize: 13, fontWeight: FontWeight.w100),
        onChanged: onChanged,
      ),
    );
  }
}

class TableColumnActionIcon extends StatelessWidget {
  const TableColumnActionIcon({
    super.key,
    required this.icon,
    required this.index,
    this.onPressed,
  });

  final Widget icon;
  final int index;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (index % 2 != 0) ? const Color(0xffF6F6F6) : Colors.white,
      // width: double.infinity,
      alignment: Alignment.centerLeft,
      child: IconButton(
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        disabledColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: icon,
      ),
    );
  }
}
