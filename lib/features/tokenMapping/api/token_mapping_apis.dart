// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shreecement/features/tokenMapping/models/token_didetails.dart';
import 'package:shreecement/features/tokenMapping/models/token_list.dart';
import 'package:shreecement/features/tokenMapping/models/token_mapping_action_model.dart';
import 'package:shreecement/features/tokenMapping/models/token_mapping_link_model.dart';
import 'package:shreecement/features/tokenMapping/models/token_mapping_model.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';
import 'package:http/http.dart' as http;

import '../../common/screens/token_expire.dart';

class TokenMappingApi {
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

  Future<dynamic> getTokenMapingDiList({required BuildContext ctx}) async {
    try {
      final queryParameters;
      if (sp?.getString("roleName") == "TRANSPORTER_STAFF") {
        queryParameters = {
          "transporterCode": sp?.getString("employeeCode") ?? "",
          "staffCode": sp?.getString("staffCode") ?? ""
        };
      } else {
        queryParameters = {
          "transporterCode": sp?.getString("employeeCode") ?? ""
        };
      }
      String? token = await secureStorage.read("token");
      final uri = Uri.https(
          domain, "/app/bidding/trans/getTransBidWinDICount", queryParameters);
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
      return TokenMappingModel.fromJson(result);
    } catch (e) {
      // print("error in tokenmap api $e");
    }
  }

  //method to fetch the DI token mapping list in TokenMappingLogistic screen
  Future<dynamic> getTokenMapingDiListLogistics({required BuildContext ctx, required String transporterCode }) async {
    try {
      final queryParameters;
      queryParameters = {
        "transporterCode": transporterCode
      };
      String? token = await secureStorage.read("token");
      final uri = Uri.https(
          domain, "/app/bidding/trans/getTransBidWinDICount", queryParameters);
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
      return TokenMappingModel.fromJson(result);
    } catch (e) {
      // print("error in tokenmap api $e");
    }
  }


  Future<dynamic> getTokenMapingActionList({
    required String transporterId,
    required int plantId,
    String stateName = "",
    String stateCode = "",
    String districtName = "",
    String districtCode = "",
    String cityName = "",
    String cityCode = "",
  }) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.parse('$baseUrl/bidding/trans/getWinDiDetails');
      var res = await http.post(uri,
          headers: {
            "Authorization": "Bearer $token",
            "username": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({
            "transporterId": transporterId,
            "plantId": plantId,
            "stateName": stateName,
            "stateCode": stateCode,
            "district": districtCode,
            "districtName": districtName,
            "city": cityCode,
            "cityName": cityName,
          }));

      final result = jsonDecode(res.body);
      // // print(res.body);
      return TokenMappingActionModel.fromJson(result);
    } catch (e) {
      // print("error in tokenmap action api $e");
    }
  }

  Future<dynamic> getTokenMapingActionListLogistic({
    required String transporterId,
    required int plantId,
    String stateName = "",
    String stateCode = "",
    String districtName = "",
    String districtCode = "",
    String cityName = "",
    String cityCode = "",
  }) async {
    try {
      String? token = await secureStorage.read("token");
      final uri = Uri.parse('$baseUrl/bidding/trans/getWinDiDetails');
      var res = await http.post(uri,
          headers: {
            "Authorization": "Bearer $token",
            "username": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({
            "transporterId": transporterId,
            "plantId": plantId,
            "stateName": stateName,
            "stateCode": stateCode,
            "district": districtCode,
            "districtName": districtName,
            "city": cityCode,
            "cityName": cityName,
          }));

      final result = jsonDecode(res.body);
      // // print(res.body);
      return TokenMappingActionModel.fromJson(result);
    } catch (e) {
      // print("error in tokenmap action api $e");
    }
  }

  Future<dynamic> getTokenMapingLinkingFirst({String? diNumber}) async {
    try {
      final uri = Uri.parse(
        "$baseUrl/bidding/di-detail/$diNumber",
      );
      String? token = await secureStorage.read("token");

      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });

      final result = jsonDecode(res.body);
      // // print(result);
      return TokenMappingLinkListModel.fromJson(result);
    } catch (e) {
      // print("error in tokenmap linking api $e");
    }
  }

  Future<dynamic> getTokenNumberList(
      {String? transporterId, required BuildContext context}) async {
    // print("called token list");

    try {
      final queryParameters = {
        'transporterId': transporterId,
        "plantId": sp!.getString("plantId")!
      };
      String? token = await secureStorage.read("token");
      final uri =
          Uri.https(domain, "/app/bidding/token/all-tokens", queryParameters);
      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
        "roleName" :(sp?.getString("roleName")).toString(),
      });

      final result = jsonDecode(res.body);

      // // print(result);
      return TokenList.fromJson(result);
    } catch (e) {
      showResultDialog("Something Went Wrong", context);
      // print("error in token list api call $e");
    }
  }

  Future<dynamic> getTokenDiDetails({String? tokenNumber}) async {
    String? token = await secureStorage.read("token");
    try {
      final uri = Uri.parse("$baseUrl/bidding/token/$tokenNumber");

      var res = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });

      final result = jsonDecode(res.body);
      // // print("token di detail $result");
      return TokenDetailsResponseList.fromJson(result);
    } catch (e) {
      // print("error in tokenmap linking api $e");
    }
  }

  Future<dynamic> submitTokenForm(
      {required String transporterId,
      required String tokenNumber,
      required String diNumber,
      required BuildContext context,
      String? ownerName,
      String? driverName,
      String? driverMobileNumber1,
      String? licenceNo,
      String? transporterMobileNumber,
      required bool smartPhone
      // bool? smartPhone,
      }) async {
    try {
      String? token = await secureStorage.read("token");
      String url = "$baseUrl/bidding/direct-diAllotted";
      var res = await http.put(Uri.parse(url),
          headers: {
            "Authorization": "Bearer $token",
            "userName": (sp?.getString("email")).toString(),
            "Content-Type": "application/json",
            "Accept": "*/*",
          },
          body: jsonEncode({
            "transporterId": transporterId,
            "tokenNumber": tokenNumber,
            "diNumber": diNumber,
            "ownerName": ownerName ?? "",
            "driverName": driverName ?? "",
            "driverMobileNumber": driverMobileNumber1 ?? "",
            "licenceNo": licenceNo ?? "",
            "transporterMobileNumber": transporterMobileNumber ?? "",
            "smartPhone": smartPhone,
            "roleName" :(sp?.getString("roleName")).toString()
            // "smartPhone":smartPhone
          }));
      final result = jsonDecode(res.body);
      if (result["statusCode"] == "201" || result["statusCode"] == "500") {
        // print("aaaaaaeeeee");
        // ignore: use_build_context_synchronously
        showResultDialog(result["statusMsg"], context);
      } else {
        // ignore: use_build_context_synchronously
        showResultDialog(result["errorMessage"], context);
      }

      // // print("submit api call  $result");
      // return TransporterBid2Model.fromJson(result);
    } catch (err) {
      // print("error in submit $err");
    }
  }
}
