import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/biddingProcess/models/startbid_transporter_model.dart';
import 'package:shreecement/features/biddingProcess/models/transporter_action_model.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

class TransporterApi {
  Future<dynamic> getTransport2DataFromAPI({
    required String employeeCode,
    required int plantId,
    required String division,
    required BuildContext ctx,
    String stateName = "",
    String stateCode = "",
    String districtName = "",
    String districtCode = "",
    String cityName = "",
    String cityCode = "",
  }) async {
    try {
      String? token = await secureStorage.read("token");
      String url = "$baseUrl/bidding/trans/getTransBidDIDetails";
      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization":"Bearer $token",
            "userName": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({
            "plantId": plantId,
            "division": division,
            "transporterCode": employeeCode,
            "stateName": stateName,
            "stateCode": stateCode,
            "district": districtCode,
            "districtName": districtName,
            "city": cityCode,
            "cityName": cityName,
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

      TransporterBid2ModelResponseList.resetCounter();


      return TransporterBid2Model.fromJson(result);
    } catch (err) {
    }
  }

  Future<dynamic> getTransporterBidData(
    BuildContext ctx,
  ) async {
    final queryParameters;
    if (sp?.getString("roleName") == "TRANSPORTER_STAFF") {
      queryParameters = {
        'staffCode': sp?.getString("staffCode") ?? "",
        'transporterCode': sp?.getString("employeeCode") ?? ""
      };
    } else {
      queryParameters = {
        'transporterCode': sp?.getString("employeeCode") ?? ""
      };
    }

    final uri = Uri.https(
        domain, "/app/bidding/trans/getTransBidDICount", queryParameters);
    try {

      String? token = await secureStorage.read("token");
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
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
      final result = jsonDecode(res.body);
      return StartBidTransporterModel.fromJson(result);
    } catch (e) {
    }
  }
}
