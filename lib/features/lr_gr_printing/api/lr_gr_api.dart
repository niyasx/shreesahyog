import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

import '../model/LrGrScreen1.dart';
import '../model/LrGrScreen2.dart';

class LrGrPrintingAPI {
  Future<dynamic> getLrGrDetailFromAPI({
    required String employeeCode,
    required int plantId,
    required String division,
    required String fromDate,
    required String toDate,
    required BuildContext ctx,
    // String stateName = "",
    String stateCode = "",
    // String districtName = "",
    String districtCode = "",
    // String cityName = "",
    String cityCode = "",
  }) async {
    try {
      String? token = await secureStorage.read("token");
      String url = "$baseUrl/bidding/finance/get-trans-invoice-details";
      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer $token",
            "userName": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({
            "plantId": plantId,
            "division": division,
            "transporterCode": employeeCode,
            // "stateName": stateName,
            "fromDate": fromDate,
            "toDate": toDate,
            "stateCode": stateCode,
            "district": districtCode,
            // "districtName": districtName,
            "city": cityCode,
            // "cityName": cityName,
          }));
      final result = jsonDecode(res.body);

      if (res.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      // print(LrGrDetailsModel.fromJson(result));
      return LrGrDetailsModel.fromJson(result);
    } catch (err) {
      // print("error in gettransporterbid2 $err");
    }
  }

  Future<dynamic> getLrGrData(
    BuildContext ctx,
  ) async {
    final queryParameters;
    if (sp?.getString("roleName") == "TRANSPORTER_STAFF") {
      queryParameters = {
        'transporterCode': sp?.getString("employeeCode") ?? "",
        'staffCode': sp?.getString("staffCode") ?? "",
      };
    } else {
      queryParameters = {
        'transporterCode': sp?.getString("employeeCode") ?? ""
      };
    }
  String? token = await secureStorage.read("token");
    final uri = Uri.https(
        domain, "/app/bidding/finance/get-trans-lrinv-Count", queryParameters);
    try {
      var res = await http.get(uri, headers: {
        "Authorization":"Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      if (res.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      // // print(res.body);
      final result = jsonDecode(res.body);
      // // print(result);
      return LrGrTransporterModel.fromJson(result);
    } catch (e) {
      // // print("error in api call $e");
    }
  }
}
