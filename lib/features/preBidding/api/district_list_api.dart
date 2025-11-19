import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/preBidding/apiModels/district.dart';
import 'package:shreecement/global.dart';

import 'package:shreecement/main.dart';

class DistrictListAPI {
  Future<District> getDistrictsListFromAPI(
      String stateName, String stateCode) async {
        String? token = await secureStorage.read("token");
    String url =
        "$baseUrl/master/districts?stateName=$stateName&stateCode=$stateCode";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });

    final result = jsonDecode(res.body);

    return District.fromJson(result);
  }
}
