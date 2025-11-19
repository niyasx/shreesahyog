import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/preBidding/apiModels/states.dart';
import 'package:shreecement/global.dart';

import 'package:shreecement/main.dart';

class StatesListAPI {
  Future<States> getStatesListFromAPI() async {
    String? token = await secureStorage.read("token");
    String url = "$baseUrl/master/states";
    var res = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    final result = jsonDecode(res.body);
    // // print(result);
    return States.fromJson(result);
  }
}
