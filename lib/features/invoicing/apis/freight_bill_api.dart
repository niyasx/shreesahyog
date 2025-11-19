// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/invoicing/models/di_qty_model.dart';
import 'package:shreecement/features/invoicing/models/freight_bill_model.dart';
import 'package:shreecement/features/invoicing/models/frozen_period_model.dart';
import 'package:shreecement/features/invoicing/models/process_freight_bill_model.dart';
import 'package:shreecement/features/invoicing/transporter_invoicing/view_frieght_bill_transporter.dart';
import '../../../global.dart';
import "package:http/http.dart" as http;
import '../../../main.dart';
import '../models/initiated_freight_bill_updated.dart';

class FreightBillApi {
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

  Future<void> showResultDialogForDi(
      String message, BuildContext context) async {
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
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> getFreightBillTransporter({required BuildContext ctx}) async {
    final queryParameters = {
      "transporterId": sp?.getString("employeeCode") ?? "",
    };
    final uri = Uri.https(domain,
        "/app/finance/freightBill/getAllDiByTransporterId", queryParameters);
    try {
      String? token = await secureStorage.read("token");
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      // // print(result);
      return FreightBillModel.fromJson(result);
    } catch (e) {
      // print("error in frieghtbill api $e");
    }
  }

  Future<dynamic> initiateFreightBill(
      {required List<Map<String, dynamic>> diNumber,
      required BuildContext ctx}) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.parse("$baseUrl/finance/freightBill/initiateFreightBill");
      var response = await http.post(
        uri,
        body: jsonEncode({"diAndInitatedStatusList": diNumber}),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);
      if (response.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      // // print(result);
      return FreightBillModel.fromJson(result);
    } catch (err) {
      // throw Exception(err);
    }
  }

  Future<dynamic> searchFrieghBill({
    required String deliveryType,
    required String freightBillType,
    required String distributionChannel,
    required String division,
    required String product,
    required String brand,
    required String stateId,
    required String plantId,
    required String fromDate,
    required String toDate,
    required BuildContext ctx,
    required String materialFrtGrp,
  }) async {
    try {
      String? token = await secureStorage.read("token");
      final queryParameters = {
        "transporterId": sp?.getString("employeeCode") ?? "",
      };

      final uri = Uri.https(domain,
          "/app/finance/freightBill/searchTransporterDi", queryParameters);
      var response = await http.post(
        uri,
        body: jsonEncode({
          "deliveryType": deliveryType,
          "freightBillType": freightBillType,
          "distributionChannel": distributionChannel,
          "division": division,
          "product": product,
          "brand": brand,
          "stateId": stateId,
          "plantId": plantId,
          "fromDate": fromDate,
          "toDate": toDate,
          "materialFreightGroupId": materialFrtGrp
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);
      if (response.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      // // print(result);
      return FreightBillModel.fromJson(result);
    } catch (err) {
      // throw Exception(err);
      // print("error in search api $err");
    }
  }

  Future<dynamic> getDiQtyAndFreightAmt(
      {required String tokenNumber, required BuildContext ctx}) async {
    final queryParameters = {"tokenNumber": tokenNumber};
    final uri = Uri.https(
        domain, "/app/finance/freightBill/getweightDetails", queryParameters);
    try {
      String? token = await secureStorage.read("token");
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      // // print(result);
      return FreightBillDiQtyModel.fromJson(result);
    } catch (e) {
      // print("error in frieghtbill api $e");
    }
  }

  Future<dynamic> updateDi({
    required String diNumber,
    required String diUom,
    required BuildContext ctx,
    required String tollTax,
    required String kata,
    required String other,
    required String grossWeight,
    required String tareWeight,
    required String netWeight,
    required String tyreAmount,
    required String tokenNumber,
    String? shortageQuantity,
    String? remarks,
  }) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.https(domain, "/app/finance/freightBill/updateDiDetails");
      var response = await http.post(
        uri,
        body: jsonEncode({
          "transporterId": sp?.getString("employeeCode"),
          "diNumber": diNumber,
          "diUom": diUom,
          "tollTax": tollTax,
          "kata": kata,
          "other": other,
          "grossWeight": grossWeight,
          "tareWeight": tareWeight,
          "netWeight": netWeight,
          "tyreAmount": tyreAmount,
          "tokenNumber": tokenNumber,
          "shortageQty": shortageQuantity ?? "0",
          "remarks": remarks ?? "",
          "quantity": "0",
          "freightAmt": "0"
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);
      if (response.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      if (result["responseMessage"].runtimeType == String) {
        showResultDialogForDi(result["responseMessage"], ctx);
      }

      // print(result);
    } catch (err) {
      // throw Exception(err);
      // print("error in update di api $err");
    }
  }

  Future<dynamic> deleteSelectedDi(
      {required String diNumber, required BuildContext ctx}) async {
    final queryParameters = {"tokenNumber": diNumber};
    final uri = Uri.https(
        domain, "/app/finance/freightBill/deleteSelectedDi", queryParameters);
    try {
      String? token = await secureStorage.read("token");
      var res = await http.post(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      // print(result);
      return;
    } catch (e) {
      // print("error in frieghtbill api $e");
    }
  }

  Future<dynamic> getInitiatedAndUpdatedDiDetails(
      {required BuildContext ctx}) async {
    final queryParameters = {
      "transporterId": sp?.getString("employeeCode") ?? "",
    };
    final uri = Uri.https(
        domain,
        "/app/finance/freightBill/getInitiatedAndUpdatedDiDetails",
        queryParameters);
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

      // // print(result);
      return InitiatedDIResponse.fromJson(result);
    } catch (e) {
      // print("error in frieghtbill api $e");
    }
  }

  Future<dynamic> processFreightBill(
      {required List<String> diNumber, required BuildContext ctx}) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.parse("$baseUrl/finance/freightBill/processFreightBill");
      var response = await http.post(
        uri,
        body: jsonEncode({"diNumber": diNumber}),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);
      if (response.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }

        if (response.statusCode == 200) {
         controller. isProcess200.value = true;
        }else{
           controller. isProcess200.value = false;
         showResultDialog(result["responseMessage"], ctx);

        }

      // // print(result);
      return ProcessFreightBillModel.fromJson(result);
    } catch (err) {
      // throw Exception(err);
      // print("error process fr bill $err");
    }
  }

  Future<dynamic> sendForApprovalApi(
      {required String billNo, required BuildContext context}) async {
    final queryParameters = {"billNo": billNo};
    final uri = Uri.https(domain,
        "/app/finance/freightBill/sendBillForApproval", queryParameters);
    try {String? token = await secureStorage.read("token");
      var res = await http.post(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      // print(result);
      showResultDialog(result["responseMessage"], context);
      return;
    } catch (e) {
      // print('error in send approval api $e');
    }
  }

  Future<dynamic> resetInitiatedApi({required BuildContext ctx}) async {
    final queryParameters = {
      "transporterId": sp?.getString("employeeCode") ?? "",
    };
    final uri = Uri.https(domain,
        "/app/finance/freightBill/resetDataOnfilterChange", queryParameters);
    try {
      String? token = await secureStorage.read("token");
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      // // print(result);
      return FreightBillModel.fromJson(result);
    } catch (e) {
      // print("error in frieghtbill api $e");
    }
  }



  
  Future<dynamic> getFrozenPeriodTime() async {
    final uri = Uri.https(
        domain, "/app/finance/getFronzenPeriodDetails");
    try {
      String? token = await secureStorage.read("token");
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
     
      // // print(result);
      return FrozenPeriodModel.fromJson(result);
    } catch (e) {
      // print("error in frieghtbill api $e");
    }
  }
}
