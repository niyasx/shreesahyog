import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/biddingProcess/models/manualdiallotment_action_transport_model.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

class ManualDiAllotmentActionApi {
  Future<ManualDiAllotmentActionTransportModel> getTransporterNames(
      {String? plantId}) async {
        String? token = await secureStorage.read("token");

    final queryParameters = {"plantCode": plantId};
    final uri =
        Uri.https(domain, "/app/master/transporter-list", queryParameters);
    var res = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    return ManualDiAllotmentActionTransportModel.fromJson(result);
  }

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

  Future<void> updateManualDiAllotmentActionData(
      {required String diNumber,
      required double costToTransport,
      required String freightChangeReason,
      required String reasonForDiAllotment,
      required String transporterId,
      required String transporterName,
      required BuildContext context}) async {
    try {
      String? token = await secureStorage.read("token");

      final uri = Uri.parse("$baseUrl/bidding/performManualDiAllotment");
      var response = await http.post(
        uri,
        body: jsonEncode({
          "diNumber": diNumber,
          "costToTransport": costToTransport,
          "freightChangeReason": freightChangeReason,
          "reasonForDiAllotment": reasonForDiAllotment,
          "transporterId": transporterId,
          "transporterName": transporterName,
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);
      // log("Maual Di Save Action: : $result");
      showResultDialog(result["responseMessage"], context);
      return result;
    } catch (err) {
      // throw Exception(err);
    }
  }
}
