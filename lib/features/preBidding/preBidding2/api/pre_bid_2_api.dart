import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/preBidding/preBidding2/apiModels/pre_bid_2_model.dart';
import 'package:shreecement/global.dart';

import 'package:shreecement/main.dart';

class PreBid2API {
  Future<PreBid2Model> getPreBid2DataFromAPI({
    required String employeeCode,
    required int roleId,
    required String plantId,
    required List<String> division,
    required String diType,
    String stateName = "",
    String stateCode = "",
    String districtName = "",
    String districtCode = "",
    String cityName = "",
    String cityCode = "",
    required BuildContext context,
    required String pageType,
  }) async {
    try {
      String? token = await secureStorage.read("token");
      String url = "$baseUrl/bidding/dilist";
      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer $token",
            "username": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({
            "employeeCode": employeeCode,
            "roleId": roleId,
            "plantId": plantId,
            "stateName": stateName,
            "stateCode": stateCode,
            "district": districtCode,
            "districtName": districtName,
            "city": cityCode,
            "cityName": cityName,
            "updatedDI": "",
            "division": division,
            "bidStartTime": "",
            "diType": diType,
            "pageType" :pageType
          }));
      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TokenExpire()),
        );
      }
      // log("Pre Bid 2 data: $result");
      return PreBid2Model.fromJson(result);
    } catch (err) {
      throw Exception(err);
    }
  }


  Future<void> showResultDialog({required
    String message,required BuildContext context}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> updatePreBid2Data({
    required BuildContext ctx,
    required int plantId,
    required String diNumber,
    required double newFrtAmt,
    required String newFrtRemark,
    required String bidRemark,
    required double extFrt,
    required String frtRate,
    String? transporterP1,
    String? transporterP2,
    double? lowerLimitAmt
  }) async {
    try {String? token = await secureStorage.read("token");
      String uri = "$baseUrl/bidding/update-prebid";
      final http.Response response = await http.put(
        Uri.parse(uri),
        body: jsonEncode({
          "plantId": plantId,
          "diNumber": diNumber,
          "newFrtAmt": newFrtAmt,
          "newFrtRemark": newFrtRemark,
          "bidRemark" : bidRemark,
          "extFrt": extFrt,
          'updatedBy': (sp?.getString("email")).toString(),
          "transporterP1" :transporterP1 =="Select"?"":transporterP1,
          "transporterP2" :transporterP2 == "Select"?"":transporterP2,
          "lowerLimitAmt":lowerLimitAmt??0,
          "frtRate":frtRate,

        }),
        headers: {
          "Authorization":"Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );

      final result = jsonDecode(response.body);

      // ignore: use_build_context_synchronously
      showResultDialog(context:ctx, message: result['responseMessage'], );
      // log("Pre Bid 2 update API result : $result");
      return result;
    } catch (err) {
      // print("error in update api $err");
    }
  }
}
