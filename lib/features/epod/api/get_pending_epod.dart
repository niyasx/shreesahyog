import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../global.dart';
import '../../../main.dart';
import '../models/epod_model.dart';

Future<EpodDetails> getPendingEpod({
  String? plantId,
  String? transporterId,
  String? fromDate,
  String? toDate,
  String? diType,
}) async {
  try {
    String? token = await secureStorage.read("token");
    final uri = Uri.parse("$baseUrl/finance/epod/get-pending-epod-details");
    var response = await http.post(
      uri,
      body: jsonEncode({
        "plantId": plantId,
        "transporterCode": transporterId,
        "diType": diType,
        "fromDate": fromDate,
        "toDate": toDate
      }),
      headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
    );
    final result = jsonDecode(response.body);
    // // print("Maual Di Save Action: : $result");
    return EpodDetails.fromJson(result);
  } catch (err) {
    // print("error in delink api $err");
  }
  return EpodDetails();
}

Future<dynamic> epodStatusUpdate({
  String? diNumber,
  String? invoiceNumber,
  int? status,
}) async {
  try {
    String? token = await secureStorage.read("token");
    final uri = Uri.parse("$baseUrl/finance/epod/epod-status-update");
   await http.post(
      uri,
      body: jsonEncode({
        "diNumber": diNumber,
        "invoiceNumber": invoiceNumber,
        "status": status,
      }),
      headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
    );

  } catch (err) {
    // print("error in delink api $err");
  }
}
