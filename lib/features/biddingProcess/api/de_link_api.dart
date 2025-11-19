import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/biddingProcess/models/delink_model.dart';
import 'package:shreecement/features/biddingProcess/models/delink_plant_model.dart';
import 'package:shreecement/features/tokenMapping/models/delink_token.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

class DelinkApi {
  Future<void> showResultDialog(String message, BuildContext context) async {
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

  Future<DeLinkPlantModel> getDelinkPlantList() async {
     final dynamic queryParameters;
    if (sp?.getString("roleName") == "TRANSPORTER_STAFF") {
      queryParameters = {
        "userId": sp?.getString("staffCode") ?? "",
        "role": sp?.getString("roleName") ?? ""
      };
    } else {
      queryParameters = {
        "userId": sp?.getString("employeeCode") ?? "",
        "role": sp?.getString("roleName") ?? ""
      };
    }
    String? token = await secureStorage.read("token");
    final uri =
        Uri.https(domain, "/app/users/getUserPlantMapping", queryParameters);
    var res = await http.get(uri, headers: {
      "Authorization":"Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });

    final result = jsonDecode(res.body);
    return DeLinkPlantModel.fromJson(result);
  }

  Future<dynamic> getDeLinkActionData({
    String? plantId,
    String? transporterId,
    String? tokenNumber,
  }) async {
    try {

      String? token = await secureStorage.read("token");
      final uri = Uri.parse("$baseUrl/bidding/linked/di");
      var response = await http.post(
        uri,
        body: jsonEncode({
          "plantId": plantId,
          "transporterId": transporterId,
          "tokenNumber": tokenNumber
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);
      return DeLinkModel.fromJson(result);
    } catch (err) {
    }
  }

  Future<DeLinkTokenList> getTokenNumberList(
      {String? transporterId, String? plantId}) async {
    // try {
    final queryParameters = {
      'transporterId': transporterId,
      "plantId": plantId
    };
    String? token = await secureStorage.read("token");
    
    final uri =
        Uri.https(domain, "/app/bidding/token/all-token", queryParameters);
    var res = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
      "roleName" :(sp?.getString("roleName")).toString(),
    });

    final result = jsonDecode(res.body);

    return DeLinkTokenList.fromJson(result);
  
  }

  Future<dynamic> saveUnlinkData({
    String? diNumber,
    String? reason,
    String? code,
    String? userName,
    bool? unlinkStatus,
    BuildContext? context,
  }) async {
    try {

      String? token = await secureStorage.read("token");
      final uri = Uri.parse("$baseUrl/bidding/unlink/di");
      var response = await http.post(
        uri,
        body: jsonEncode({
          "diNo": diNumber,
          "diUnlinkReason": reason,
          "diUnlinkReasonCode": code,
          "userName": userName,
          "unlinkStatus": unlinkStatus
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);
      showResultDialog(result["responseMessage"], context!);

      return DeLinkModel.fromJson(result);
    } catch (err) {
    }
  }
}
