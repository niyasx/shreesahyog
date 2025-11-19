import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shreecement/features/di_pendency_screen/models/di_pendency_category_model.dart';
import 'package:shreecement/features/di_pendency_screen/models/di_pendency_response_model.dart';
import 'package:shreecement/main.dart';

import 'package:universal_html/html.dart' as html;

import '../../../global.dart';

class DIPendencyApis{

  //api gor getting categories for category dropdown
  Future<GetDIPendencyCategoryModel> getDIPendencyListFromAPI() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/bidding/pendencyCategory";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    // // print(result);
    return GetDIPendencyCategoryModel.fromJson(result);
  }

  Future<dynamic> viewDIPendencyList({
    required BuildContext ctx,
    // required String transporterId,
    required String plantCode,
    required String category,
    // required String status,
    required String fromDate,
    required String toDate,
    String plantName = "",
    String diType = "",
    String state = "",
    String district = "",
    String city = "",
    String truckNumber = "",
    String truckType = "",
    String transporterCode = "",
    String transporterName = "",
  }) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.parse(
          "$baseUrl/bidding/diPendencyList");
      var response = await http.post(
        uri,
        body: jsonEncode({
          // "transporterId": transporterId,
          "plantCode": int.parse(plantCode),
          "category": category,
          // "status": status,
          "fromDate": fromDate,
          "toDate": toDate,
          "plantName": plantName,
          "diType": diType,
          "state": state,
          "district": district,
          "city": city,
          "truckNumber": truckNumber,
          "truckType": truckType,
          "transporterCode": transporterCode,
          "transporterName": transporterName
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);
      // // print(result);
      print("pendency api called end");

      return DIPendencyResponseListModel.fromJson(result);
    } catch (err) {

      // throw Exception(err);
      print("error in view pendency $err");
    }
  }


  String formatDateExcel(String date) {
    DateTime parsedDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(parsedDate);
  }
  Future<dynamic> downloadDIPendencyExcelReport({
    // int? index,
    String? startDate,
    String? endDate,
    int? plantId,
    // String? reportType,
    String? plantName,
    String? category,
    String? diType = "",
    String state = "",
    String district = "",
    String city = "",
    String truckNumber = "",
    String truckType = "",
    String? transporterCode = "",
    String transporterName = "",
  }) async {
    String url = "$baseUrl/bidding/diPendencyList/excel";

    try {
      String? token = await secureStorage.read("token");
      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer $token",
            "username": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({


              "fromDate": startDate ?? "",
              "toDate": endDate ?? "",
              "plantCode": plantId,
              // "reportType":reportType??"",
            "category": category,
            // "plantCode": 1003,
            "plantName": "",
            // "fromDate": "2023-01-18",
            // "toDate": "2024-12-18",
            "diType": diType ?? "",
            "state": state,
            "district": district,
            "city": city,
            "truckNumber": truckNumber,
            "truckType": truckType,
            "transporterCode": transporterCode ?? "",
            "transporterName": transporterName

            }));
      // final result = jsonDecode(res.body);


      if (res.statusCode == 200) {
        // print(res.bodyBytes.toString());
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
      // print("Error during Unlinked Saving API call: $e");
      // savedSuccess[index].value = false;
    }
  }
}