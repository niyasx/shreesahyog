import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenu3 extends StatefulWidget {
  late String myVal;
  late List<String> myList;
  late Function(String?)? myFun;

  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;

  CustomDropdownMenu3(
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
  State<CustomDropdownMenu3> createState() => _CustomDropdownMenu3State();
}

class _CustomDropdownMenu3State extends State<CustomDropdownMenu3> {
  /*String selectedValue = myVal;
  List<String> dropdownItems = myList;*/
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

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
          child: DropdownButton2<String>(
            isDense: true,
            isExpanded: true,
            value: widget.myVal,
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
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color(0xff727272),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto'),
                  ),
                ),
              );
            }).toList(),
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
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
                  controller: textEditingController,
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
              searchMatchFn: (item, searchValue) {
                return item.value
                    .toString()
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            dropdownStyleData: const DropdownStyleData(maxHeight: 300),
          ),
        ),
      ),
    );
  }
}

class CustomDropdownMenu4 extends StatefulWidget {
  late String myVal;
  late List<String> myList;
  late Function(String?)? myFun;

  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;

  CustomDropdownMenu4(
      {super.key,
      required String selVal,
      required List<String> list,
      Function(String?)? fun,
      this.height = 32,
      this.width = 250,
      this.margin}) {
    myVal = selVal;
    myList = list;
    myFun = fun;
  }

  @override
  State<CustomDropdownMenu4> createState() => _CustomDropdownMenu4State();
}

class _CustomDropdownMenu4State extends State<CustomDropdownMenu4> {
  /*String selectedValue = myVal;
  List<String> dropdownItems = myList;*/
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

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
          child: DropdownButton2<String>(
            value: widget.myVal,
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
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
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
                  controller: textEditingController,
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
              searchMatchFn: (item, searchValue) {
                return item.value
                    .toString()
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            dropdownStyleData: DropdownStyleData(maxHeight: 300),
          ),
        ),
      ),
    );
  }
}
