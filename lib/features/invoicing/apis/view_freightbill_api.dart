// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/invoicing/models/transporter_view_invoice_model.dart';
import 'package:shreecement/features/invoicing/models/validate_freight_logistics_model.dart';
import 'package:shreecement/features/invoicing/models/view_freightbill_logistics_model.dart';
import 'package:shreecement/features/invoicing/models/view_freightbill_model.dart';
import 'package:shreecement/global.dart';
import "package:http/http.dart" as http;
import 'package:shreecement/main.dart';

class ViewFreightBillApi {
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
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> viewFreightBillTransporter(
      {required String plantId,
      required String fromDate,
      required String toDate,
      required String status,
      required BuildContext ctx}) async {
    try {
      String? token = await secureStorage.read("token");
      final uri =
          Uri.parse("$baseUrl/finance/freightBill/getTransporterBillDetails");
      var response = await http.post(
        uri,
        body: jsonEncode({
          "transporterId": sp?.getString("employeeCode") ?? "",
          "plantId": int.parse(plantId),
          "status": status,
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
      if (response.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      final result = jsonDecode(response.body);

      // // print(result);
      return ViewFreightBillModel.fromJson(result);
    } catch (err) {
      // throw Exception(err);
      // print("error view fr bill $err");
    }
  }

  Future<dynamic> viewFreightBillLogistics({
    required String transporterId,
    required String plantId,
    required String status,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.parse(
          "$baseUrl/finance/logistic/freightBill/getTransporterBillDetails");
      var response = await http.post(
        uri,
        body: jsonEncode({
          "transporterId": transporterId,
          "plantId": int.parse(plantId),
          "status": status,
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
      // // print(result);

      return ViewFreightBillLogisticsModel.fromJson(result);
    } catch (err) {
      // throw Exception(err);
      // print("error view fr bill $err");
    }
  }

  Future<dynamic> validateFReightBillLogisticsApi(
      {required String billNo,
      required String role,
      required BuildContext ctx}) async {
    final queryParameters = {"billNo": billNo};
    final uri = Uri.https(
        domain,
        "/app/finance/logistic/freightBill/getTransporterDiDetails",
        queryParameters);
    try {
      String? token = await secureStorage.read("token");
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
        "userRole": role
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
      return ValidateFreightLogisticsModel.fromJson(result);
    } catch (e) {
      // print("error in frieghtbill api $e");
    }
  }

  Future<dynamic> approveOrRejectFrBillApi({
    required String billNo,
    required String isApproved,
    required String isRejected,
    required String remark,
  }) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.parse(
          "$baseUrl/finance/logistic/freightBill/approveOrRejectFreightBill");
      await http.post(
        uri,
        body: jsonEncode({
          "billNo": billNo,
          "isApproved": int.parse(isApproved),
          "isRejected": int.parse(isRejected),
          "remark": remark
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      // final result = jsonDecode(response.body);
      // print(result);
    } catch (err) {
      // throw Exception(err);
      // print("error view fr bill $err");
    }
  }

  Future<dynamic> resubmitFreightBillApi(
      {required String billNo, required BuildContext ctx}) async {
        String? token = await secureStorage.read("token");
    final queryParameters = {"billNo": billNo};
    final uri = Uri.https(
        domain, "/app/finance/freightBill/reSubmitBill", queryParameters);
    try {
      var res = await http.post(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      // print(result);
      if (res.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      showResultDialog(result["responseMessage"], ctx);
    } catch (e) {
      // print("error in resubmit api $e");
    }
  }

  Future<dynamic> viewInvoiceTransporter(
      {required String plantId,
      required String fromDate,
      required String toDate,
      required String status,
      required BuildContext ctx}) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.parse(
          "$baseUrl/finance/freightBill/getTransporterInvoiceDetails");
      var response = await http.post(
        uri,
        body: jsonEncode({
          "transporterId": sp?.getString("employeeCode") ?? "",
          "plantId": int.parse(plantId),
          "status": status,
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
      if (response.statusCode == 403) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            ctx,
            MaterialPageRoute(builder: (context) => const TokenExpire()),
          );
        });
      }
      return TransporterViewInvoiceModel.fromJson(result);
    } catch (err) {
      // throw Exception(err);
      // print("error view fr bill $err");
    }
  }

  Future<dynamic> holdOrUnholdBill({
    required String billNo,
    required String status,
    required BuildContext ctx,
  }) async {
    try {
      String? token = await secureStorage.read("token");
      final uri =
          Uri.parse("$baseUrl/finance/logistic/freightBill/changeBillStatus");
      var response = await http.post(
        uri,
        body: jsonEncode({
          "billNo": billNo,
          "status": status,
        }),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (status == "UNHOLD") {
          await ViewFreightBillApi()
              .resubmitBillLogisticsApi(billNo: billNo, ctx: ctx);
        }else{
           await showResultDialog(result["responseMessage"], ctx);
        }
      }else{
         await showResultDialog(result["responseMessage"], ctx);
      }

    
    } catch (err) {
      // throw Exception(err);
      // print("error view fr bill $err");
    }
  }

  Future<dynamic> cancelBill({
    required String billNo,
    required String status,
    required String remark,
    required BuildContext ctx,
  }) async {
    try {
      String? token = await secureStorage.read("token");
      final uri =
          Uri.parse("$baseUrl/finance/logistic/freightBill/changeBillStatus");
      var response = await http.post(
        uri,
        body:
            jsonEncode({"billNo": billNo, "status": status, "remark": remark}),
        headers: {
          "Authorization": "Bearer $token",
          "username": (sp?.getString("email")).toString(),
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );
      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
      await  showResultDialog(result["responseMessage"], ctx);
      } else {
      await  showResultDialog(result["responseMessage"], ctx);
      }

      // final result = jsonDecode(response.body);
      // print(result);
    } catch (err) {
      // throw Exception(err);
      // print("error view fr bill $err");
    }
  }

  Future<dynamic> resubmitBillLogisticsApi(
      {required String billNo, required BuildContext ctx}) async {
        String? token = await secureStorage.read("token");
    final queryParameters = {"billNo": billNo};
    final uri = Uri.https(domain,
        "app/finance/logistic/freightBill/reSubmitBill", queryParameters);
    try {
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);

     await showResultDialog(result["responseMessage"], ctx);
      // print(result);
    

      // showResultDialog(result["responseMessage"], ctx);
    } catch (e) {
      // print("error in resubmit api $e");
    }
  }
}
