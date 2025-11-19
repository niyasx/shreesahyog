import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../global.dart';
import '../../../main.dart';
import '../models/business_rules.dart';
import '../screens/token_expire.dart';

class BusinessLogic {
  Future<dynamic> getbusinesslogiclist(
      {required String plantCode, required BuildContext ctx}) async {
    String url = "$baseUrl/master/getPlantDetails?plantCode=$plantCode";

    try {
      String? token = await secureStorage.read("token");
      var res = await http.get(Uri.parse(url), headers: {
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
      final result = json.decode(res.body);
      return BusinessRules.fromJson(result);
    } catch (e) {
      // print("error in unlink delivery list $e");
    }
  }
}
