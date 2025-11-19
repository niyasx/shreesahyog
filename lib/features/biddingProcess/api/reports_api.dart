import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../global.dart';
import 'package:http/http.dart'as http;
import 'package:universal_html/html.dart' as html;

import '../../../main.dart';

String formatDateExcel(String date) {
  DateTime parsedDate = DateTime.parse(date);
  DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(parsedDate);
}
Future<dynamic> downloadExcelSheetReport({
  // int? index,
  String? startDate,
  String? endDate,
  int? plantId,
  String? reportType,
  String? plantName
}) async {
  String url = "$baseUrl/report/getDiDetailsSummaryReport";
  
  String? token = await secureStorage.read("token");
  try {
    var res = await http.post(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: jsonEncode({
    "serviceDTO": {

      "startDate": startDate ?? "",
      "endDate": endDate ?? "",
      "plantId": [plantId ?? 0],
      "reportType":reportType??"",

    }}));
    // final result = jsonDecode(res.body);


    if (res.statusCode == 200) {
      // String dir = (await getApplicationDocumentsDirectory()).path;
      // File file = File('download.pdf');
      // File file = File(fileName);
      String startDateFormat=formatDateExcel(startDate??"");
      String startEndFormat=formatDateExcel(endDate??"");


      final blob = html.Blob([Uint8List.fromList(res.bodyBytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "BidViewReport_${plantName??''}_$startDateFormat _ $startEndFormat.xlsx")
        ..click();
      // await file.writeAsString("h");

      // savedSuccess[index].value = true;
    }
   else if(res.statusCode == 400){
      Get.dialog(
      AlertDialog(
        title: const Text("Success"),
        content: const Text(
            "No records found for the selected Plant"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text("OK"),
          ),
        ],
      )
      );
    }
    else{
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: const Text(
              "Please try again later!"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    // savedSuccess[index].value = false;
  }
}