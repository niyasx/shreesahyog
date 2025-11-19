// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget datePicker(
    {String? label, TextEditingController? controller, VoidCallback? ontap}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label ?? "label",
        style: const TextStyle(color: Colors.black),
      ),
      Container(
        width: 283,
        height: 30,
        color: Colors.white,
        child: TextFormField(
          readOnly: true,
          style: const TextStyle(fontSize: 13, color: Colors.black),
          controller: controller,
          textAlign: TextAlign.start,
          // textAlignVertical: TextAlignVertical.center,
          onTap: ontap,
          decoration: InputDecoration(
            contentPadding: const EdgeInsetsDirectional.only(start: 15),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Colors.grey.shade600),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xffA0A0A0)),
            ),
            // hintText: '',
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Color.fromRGBO(114, 114, 114, 1),
            ),
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
      ),
    ],
  );
}

Future<void> selectDate(
    BuildContext context, TextEditingController textcontroller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    textcontroller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
  }
}
