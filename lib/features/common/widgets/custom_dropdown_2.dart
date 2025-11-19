import 'package:flutter/material.dart';

class CustomDropdownMenu2 extends StatefulWidget {
  late String myVal;
  late List<String> myList;
  late Function(String?)? myFun;

  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;

  CustomDropdownMenu2(
      {super.key,
      required String selVal,
      required List<String> list,
      Function(String?)? fun,
      this.height = 32,
      this.width = 283,
      this.margin}) {
    myVal = selVal;
    myList = list;
    myFun = fun;
  }

  @override
  State<CustomDropdownMenu2> createState() => _CustomDropdownMenu2State();
}

class _CustomDropdownMenu2State extends State<CustomDropdownMenu2> {
  /*String selectedValue = myVal;
  List<String> dropdownItems = myList;*/
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffA0A0A0)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: widget.myVal,
            icon: const Icon(
              Icons.arrow_drop_down,
            ), // Icon aligned at the center right
            iconSize: 18,
            elevation: 16,
            style: const TextStyle(
                color: Color(0xff727272), overflow: TextOverflow.ellipsis),
            onChanged: widget.myFun,
            items: widget.myList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  height: 30,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color(0xff727272),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto'),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
