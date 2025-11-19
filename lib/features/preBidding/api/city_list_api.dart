import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shreecement/features/preBidding/apiModels/city.dart';
import 'package:shreecement/global.dart';
import 'package:shreecement/main.dart';

class CityListAPi {
  Future<citymodel> getCityNameList(
      {required String districtName, required String districtCode}) async {
    final queryParameters = {
      'districtName': districtName,
      'districtCode': districtCode,
    };
    String? token = await secureStorage.read("token");
    final uri = Uri.https(domain, "/app/master/city", queryParameters);
    var res = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "username": (sp?.getString("email")).toString(),
      "Content-Type": "application/json",
      "Accept": "*/*",
    });
    // // print(res.body);
    final result = jsonDecode(res.body);
    return citymodel.fromJson(result);
  }
}
