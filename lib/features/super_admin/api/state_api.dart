// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/common/screens/token_expire.dart';
import 'package:shreecement/features/preBidding/apiModels/district.dart';
import 'package:shreecement/features/preBidding/apiModels/states.dart';
import 'package:shreecement/features/super_admin/model/delete_state.dart';
import 'package:shreecement/features/super_admin/model/get_role_master_details_list.dart';
import 'package:shreecement/features/super_admin/model/state_district_response_list.dart';
import 'package:shreecement/features/super_admin/model/transporter_list.dart';
import 'package:shreecement/global.dart';

import 'package:shreecement/main.dart';

class StateApi {
  Future<TransporterListResponse> getTransporterList(
      BuildContext context) async {
    try {
      String? token = await secureStorage.read("token");
      String url = "$baseUrl/master/all-transporter-list";
      var res = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TokenExpire()),
        );
      }
      // log("Pre Bid 2 data: $result");
      return TransporterListResponse.fromJson(result);
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<RoleMasterDetailsResponse> getRoleMasterDetails(
      BuildContext context) async {
    try {
      String? token = await secureStorage.read("token");
      String url = "$baseUrl/master/getRoleMasterDetails";
      var res = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      // if (res.statusCode == 403) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const TokenExpire()),
      //   );
      // }
      // // log("Pre Bid 2 data: $result");
      return RoleMasterDetailsResponse.fromJson(result);
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<StateDistrictResponse> getTableStateList(
      BuildContext context, String transporterId) async {
    try {
      String? token = await secureStorage.read("token");
      //transporterId= 13000522;
      String url =
          "$baseUrl/master/getStateDistrictDetails?transporterCode=$transporterId";
      var res = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TokenExpire()),
        );
      }
      // log("Pre Bid 2 data: $result");
      return StateDistrictResponse.fromJson(result);
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<States> getStatesListFromAPI(BuildContext context) async {
    try {
      String? token = await secureStorage.read("token");
      String url = "$baseUrl/master/states";
      var res = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });
      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TokenExpire()),
        );
      }
      return States.fromJson(result);
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<dynamic> getDistrictsListFromAPI(
      {BuildContext? context, String? stateName, String? stateCode}) async {
    try {
      String? token = await secureStorage.read("token");
      String url =
          "$baseUrl/master/districts?stateName=$stateName&stateCode=$stateCode";
      var res = await http.get(Uri.parse(url), headers: {
        "Authorization":"Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      });

      final result = jsonDecode(res.body);
      if (res.statusCode == 403) {
        Navigator.pushReplacement(
          context!,
          MaterialPageRoute(builder: (context) => const TokenExpire()),
        );
      }
      return District.fromJson(result);
    } catch (e) {
      //  print("error dist api $e");
    }
  }

  Future<dynamic> deleteStateApi(
      {BuildContext? context,
      String? transporterCode,
      String? stateCode}) async {
    try {

      final queryParameters = {
        'transporterCode': transporterCode,
        'stateCode': stateCode,
      };
      String? token = await secureStorage.read("token");
      String url =
          "$baseUrl/master/deleteStateMappingForTransporter";
      // Create a URI with query parameters
      final uri = Uri.parse(url).replace(queryParameters: queryParameters);

      var res = await http.post(uri, headers: {
        "Authorization": "Bearer $token",
        "username": (sp?.getString("email")).toString(),
        "Content-Type": "application/json",
        "Accept": "*/*",
      },);

      final result = jsonDecode(res.body);

      return DeleteApiResponse.fromJson(result);
    } catch (e) {
      //  print("error dist api $e");
    }
  }
}
